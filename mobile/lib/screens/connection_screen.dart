import 'dart:io';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flify/components/ui/animated_logo_transition.dart';
import 'package:flify/components/ui/loading.dart';
import 'package:flify/providers/network_info.dart';
import 'package:flify/providers/notifications.dart';
import 'package:flify/providers/recent_devices.dart';
import 'package:flify/providers/socket.dart';
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

import '../providers/isar_service.dart';

const NOTIFICATION_ID = 0;

class ConnectionScreen extends ConsumerStatefulWidget {
  final String ip;
  final String port;
  final String name;
  const ConnectionScreen(
      {super.key, required this.ip, required this.port, required this.name});

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  late final Isar db;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _loadingState = "Loading...";
  late final IO.Socket socket;

  late String remoteDeviceName;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Session? _currentSession;
  FlutterSoundPlayer? player;

  bool _isError = false;

  late double selfVolume;
  late int batteryLevel;

  DateTime lastHeartbeat = DateTime.now();

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
    });
  }

  void initSocketConnection(Metadata metadata) {
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

      print("Successfully connnected to the socket!");

      // Listen to volume change
      VolumeController().listener((volume) {
        setState(() => selfVolume = volume);
        socket.emit("update_volume", volume);
      });

      // Listen to battery level change
      BatteryInfoPlugin().androidBatteryInfoStream.listen((event) {
        setState(() {
          batteryLevel = event?.batteryLevel ?? 0;
        });
        socket.emit("update_battery", batteryLevel);
      });
      BatteryInfoPlugin().iosBatteryInfoStream.listen((event) {
        setState(() {
          batteryLevel = event?.batteryLevel ?? 0;
        });
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
            ..sampleRate = session['params']['sampleRate']);
        player = FlutterSoundPlayer();
      });
      print("INIT FINISH  ${_currentSession!.id}!");

      await player!.openPlayer(enableVoiceProcessing: false);

      await player!.startPlayerFromStream(
          codec: Codec.pcm16,
          numChannels: _currentSession!.params!.channelCount!,
          sampleRate: _currentSession!.params!.sampleRate!);

      print("INIT FINISH  ${_currentSession!.id}!");
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
      print("DATA!");
      player!.foodSink!.add(FoodData(payload['d']));
      print("added to player");

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

    socket.on("stop", (session) {
      if (_currentSession?.id != session['id']) return;
      player?.stopPlayer();

      print("Stopped");

      setState(() {
        player = null;
        _currentSession = null;
      });
    });

    socket.onConnectError((data) {
      if (!mounted) return;

      print("Connection error!");
      print(data);
      setState(() {
        _loadingState = "Error: ${data?.toString() ?? "unknown"}";
        _isError = true;
      });
    });
    socket.onConnectTimeout((data) {
      if (!mounted) return;

      print("Connection timeout!");
      print(data);
      setState(() {
        _loadingState = "Error: connection timeout";
        _isError = true;
      });
    });
    socket.onDisconnect((data) {
      if (!mounted) return;
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text("Disconnected from the server")));
        _scaffoldKey.currentContext!.go(
          "/",
        );
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
            body: const Column(children: [AnimatedLogoTransition()])),
      );
    }
  }

  @override
  void dispose() {
    print("DISPOSE! Disconnect from server");
    socket.disconnect();
    socket.dispose();

    localNotifications.cancel(NOTIFICATION_ID);
    VolumeController().removeListener();

    super.dispose();
  }
}
