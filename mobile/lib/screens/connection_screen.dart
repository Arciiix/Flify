import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flify/components/player/player_ui.dart';
import 'package:flify/components/ui/animated_logo_transition.dart';
import 'package:flify/components/ui/loading.dart';
import 'package:flify/providers/battery.dart';
import 'package:flify/providers/network_info.dart';
import 'package:flify/providers/notifications.dart';
import 'package:flify/providers/recent_devices.dart';
import 'package:flify/providers/self_volume.dart';
import 'package:flify/providers/socket.dart';
import 'package:flify/types/current_info.dart';
import 'package:flify/types/navigation_state.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flify/types/socket.dart';
import 'package:flify/utils/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import "package:go_router/go_router.dart";
import 'package:isar/isar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:volume_controller/volume_controller.dart';

import '../providers/current_info.dart';
import '../providers/isar_service.dart';

const NOTIFICATION_ID = 0;

class ConnectionScreen extends ConsumerStatefulWidget {
  final String ip;
  final String port;
  final String name;
  final int?
      currentReconnectIndex; // If not 0, it will connect to the current data after a delay. Number of reconnections that already happened to the given device. Starts from 1 (0 = don't reconnect)

  const ConnectionScreen(
      {super.key,
      required this.ip,
      required this.port,
      required this.name,
      this.currentReconnectIndex});

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  late final Isar db;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _loadingState = "Loading...";
  late IO.Socket socket;
  Timer? reconnectTimer;
  Timer?
      reconnectTextPeriodicTimer; // A timer to update the text of time until the reconnection

  late String remoteDeviceName;
  late String displayedName;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Session? _currentSession;
  FlutterSoundPlayer? player;

  bool _isError = false;

  late StreamSubscription selfVolumeSubscription;
  late StreamSubscription batteryLevelSubscription;

  int currentReconnectIndex = 0;

  DateTime lastHeartbeat = DateTime.fromMillisecondsSinceEpoch(0);

  late final FlutterLocalNotificationsPlugin localNotifications;

  void validateIPAndPort() {
    // Check if ip and port are valid
    if (!isIPv4Valid(widget.ip) || !isPortValid(widget.port)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong IP or port provided!")));
      context.go("/");
    }
  }

  Future<Metadata> gatherMetadata() async {
    // Get own ip
    var networkInfo = await ref.watch(networkInfoProvider.future);
    String? selfIp = networkInfo.selfIp;

    // Get device name
    final generalInfo = (await deviceInfo.deviceInfo).data;

    String name;
    if (generalInfo.containsKey("name")) {
      name = generalInfo["name"];
    } else if (generalInfo.containsKey("brand") ||
        generalInfo.containsKey("model")) {
      // "<brand> <model>" or "<brand>" or "<model>"
      name =
          '${generalInfo['brand'] ?? ''} ${generalInfo['model'] ?? ''}'.trim();
    } else {
      name = "Flify device";
    }

    // Get os
    String os = Platform.operatingSystem;

    return Metadata(selfIp: selfIp, deviceName: name, os: os);
  }

  Future<void> updateName(String newName) async {
    // RecentDevice recentDevice = (await db.recentDevices
    //     .filter()
    //     .ipEqualTo(widget.ip)
    //     .and()
    //     .portEqualTo(int.parse(widget.port))
    //     .findFirst())!;

    RecentDevice recentDevice = (await ref.read(recentDevicesProvider.future))
        .firstWhere((element) =>
            element.ip == widget.ip && element.port == int.parse(widget.port));

    recentDevice.name = newName;

    await db.writeTxn(() async {
      await db.recentDevices.put(recentDevice);
      print("Updated this device's name in the db");
    });
    ref.refresh(recentDevicesProvider);

    setState(() {
      remoteDeviceName = newName;
      displayedName = newName;
      ref.read(currentInfoProvider.notifier).state =
          ref.read(currentInfoProvider).copyWith(hostname: displayedName);
    });
  }

  void reconnect({int? currentReconnectIndexOverride}) {
    setState(() {
      currentReconnectIndex += 1;
      socket.disconnect();
      socket.dispose();
      player?.stopPlayer();

      ref.read(socketProvider.notifier).state = null;

      localNotifications.cancel(NOTIFICATION_ID);
      selfVolumeSubscription.cancel();
      batteryLevelSubscription.cancel();
      reconnectTimer?.cancel();
      reconnectTextPeriodicTimer?.cancel();
      _loadingState = "Reconnecting...";
      _currentSession = null;
      player = null;
    });

    Duration duration = Duration(
        // Exponential backoff duration - to not spam the server like crazy, but instead wait for some time
        // Max waiting time is 1 minute (which is log2 60000 ~ 16 retries)
        milliseconds:
            min(((pow(2, (currentReconnectIndex - 1))) * 1000).floor(), 60000));
    reconnectTimer = Timer(duration, initConnection);
    DateTime targetDate = DateTime.now().add(duration);

    reconnectTextPeriodicTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      Duration timeLeft = targetDate.difference(DateTime.now());

      if (timeLeft.isNegative) {
        setState(() {
          _loadingState = 'Connecting...';
        });
        timer.cancel();
        return;
      }

      // Format the remaining time as a string
      // Show seconds because the time is max 1 minute

      setState(() {
        _loadingState =
            'Reconnecting in ${timeLeft.inSeconds} second${timeLeft.inSeconds == 1 ? '' : 's'}...';
      });
    });
  }

  void initSocketConnection(Metadata metadata) {
    // Create a new info object
    ref.read(currentInfoProvider.notifier).state = CurrentInfo();

    // TODO: Think about migrating to HTTPS
    socket = IO.io('http://${widget.ip}:${widget.port}', <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true
    });

    // Update the provider value
    ref.read(socketProvider.notifier).state = socket;

    setState(() {
      _loadingState = "Waiting for connection...";
    });
    socket.onConnect((_) async {
      if (!mounted) return;

      displayedName = widget.name;

      print("Successfully connnected to the socket!");

      // Listen to volume change
      selfVolumeSubscription = ref.read(selfVolumeProvider).listen((value) {
        socket.emit("update_volume", value);
      });

      // Listen to battery level change
      batteryLevelSubscription =
          ref.read(batteryProvider).listen((batteryLevel) {
        socket.emit("update_battery", batteryLevel);
      });

      socket.emit("hello", metadata);
      setState(() {
        _loadingState = "Waiting for initial message...";
      });
    });

    socket.on("init", (session) async {
      if (_currentSession != null) {
        print(
            "Trying to init ${session['id']} but there's already a session ${_currentSession!.id!}!");
        return;
      }
      setState(() {
        _currentSession = Session()
          ..id = session['id']
          ..params = (AudioParams()
            ..channelCount = session['params']['channelCount']
            ..sampleRate = session['params']['sampleRate'])
          ..audioDeviceName = session?["selectedAudioDevice"]?["name"];
        player = FlutterSoundPlayer();
        currentReconnectIndex = 0;
      });
      print("INIT FINISH  ${_currentSession!.id}!");

      await player!.openPlayer(enableVoiceProcessing: false);

      await player!.startPlayerFromStream(
          codec: Codec.pcm16,
          numChannels: _currentSession!.params!.channelCount!,
          sampleRate: _currentSession!.params!.sampleRate!);

      print("INIT FINISH  ${_currentSession!.id}!");

      ref.read(currentInfoProvider.notifier).state = ref
          .read(currentInfoProvider)
          .copyWith(audioDeviceName: _currentSession?.audioDeviceName);

      showNotification();
    });

    socket.on("data", (payload) {
      if (_currentSession == null ||
          _currentSession?.id != payload['i'] ||
          player == null ||
          !player!.isOpen() ||
          !player!.isPlaying) {
        print("Received data not in the session, return...");
        return;
      }
      // print("DATA!");
      player!.foodSink!.add(FoodData(payload['d']));
      // print("added to player");

      // If the time has come, also send the heartbeat
      if (DateTime.now().difference(lastHeartbeat).inSeconds > 5) {
        socket.emit(
            "data_heartbeat",
            DataHeartbeat(
                    initialDataTimestamp: DateTime.tryParse(payload['t']),
                    timestamp: DateTime.now())
                .toJson());
        lastHeartbeat = DateTime.now();
      }
    });

    socket.on("change_volume", (volume) {
      int newVolume = int.tryParse(volume.toString()) ?? 100;
      print("Change volume to $newVolume");
      VolumeController().setVolume(newVolume / 100);
    });

    socket.on("host_volume_update", (volumeState) {
      ref.read(currentInfoProvider.notifier).state = ref
          .read(currentInfoProvider)
          .copyWith(volume: VolumeState.fromPayload(volumeState));
    });

    socket.on("stop", (session) {
      if (_currentSession?.id != session['id']) return;
      player?.stopPlayer();

      print("Stopped");

      setState(() {
        player = null;
        _currentSession = null;
      });
    });

    socket.on("reconnect", (_) {
      print("Reconnect");

      print("not mounted, do manual reconnect...");
      reconnect();
    });

    socket.on("you_will_disconnect", (_) {
      if (mounted) {
        socket.disconnect();
        context.replace("/",
            extra: HomeScreenNavigationState(
                ip: widget.ip, port: widget.port, name: widget.name));
      }
    });

    socket.onConnectError((data) {
      if (!mounted) return;

      print("Connection error!");
      print(data);
      setState(() {
        _loadingState = "Error: ${data?.toString() ?? "unknown"}";
        _isError = true;
      });

      reconnect();
    });
    socket.onConnectTimeout((data) {
      if (!mounted) return;

      print("Connection timeout!");
      print(data);
      setState(() {
        _loadingState = "Error: connection timeout";
        _isError = true;
      });

      reconnect();
    });
    socket.onDisconnect((data) {
      if (!mounted) return;
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text("Disconnected from the server")));
        // _scaffoldKey.currentContext!.go(
        //   "/",
        // );

        reconnect();
      }
    });

    // A reply to "hello" event send onConnect
    socket.on("world", (data) {
      if (data?['hostname'] != null && data['hostname'] != remoteDeviceName) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Remote host name "${data['hostname']}" is different from the device name "$remoteDeviceName"'),
          action: SnackBarAction(
              label: "Update", onPressed: () => updateName(data['hostname'])),
        ));
      }

      ref.read(currentInfoProvider.notifier).state =
          ref.read(currentInfoProvider).copyWith(hostname: displayedName);

      setState(() {
        _loadingState = null;
      });
    });
  }

  Future<void> initConnection() async {
    validateIPAndPort();

    // Save to recent devices
    // Try to get the old one saves
    RecentDevice recentDevice = (await ref.read(recentDevicesProvider.future))
        .firstWhere(
            (element) =>
                element.ip == widget.ip &&
                element.port == int.parse(widget.port),
            orElse: () => RecentDevice(
                ip: widget.ip,
                port: int.parse(widget.port),
                name: remoteDeviceName));

    recentDevice.lastConnectionDate = DateTime.now();

    await db.writeTxn(() async {
      await db.recentDevices.put(recentDevice);
      print("Updated db with recent device");
    });
    ref.refresh(recentDevicesProvider);

    // Try to connect to the server
    Metadata metadata = await gatherMetadata();
    initSocketConnection(metadata);
  }

  void showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('Flify', 'Flify',
            showWhen: true,
            usesChronometer: true,
            ongoing: true,
            icon: "@mipmap/launcher_icon");

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await localNotifications.show(
      NOTIFICATION_ID,
      'Flify',
      'Connected to: $remoteDeviceName',
      notificationDetails,
    );
  }

  @override
  void initState() {
    super.initState();
    db = ref.read(isarProvider);
    localNotifications = ref.read(flutterLocalNotificationsProvider);

    remoteDeviceName = widget.name;
    currentReconnectIndex = widget.currentReconnectIndex ?? 0;

    WidgetsBinding.instance.addPostFrameCallback((_) => initConnection());
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingState != null) {
      return Loading(
        loadingText: _loadingState ?? "Loading...",
        showGoHomeButton: _isError,
      );
    } else {
      return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const AnimatedLogoTransition(),
                MusicPlayer(
                  hostName: displayedName,
                  ip: widget.ip,
                )
              ]),
            )),
      );
    }
  }

  @override
  void dispose() {
    print("DISPOSE! Disconnect from server");
    socket.disconnect();
    socket.dispose();

    localNotifications.cancel(NOTIFICATION_ID);
    selfVolumeSubscription.cancel();
    batteryLevelSubscription.cancel();
    reconnectTimer?.cancel();
    reconnectTextPeriodicTimer?.cancel();

    super.dispose();
  }
}
