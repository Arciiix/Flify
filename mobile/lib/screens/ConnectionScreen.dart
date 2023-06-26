import 'package:flify/components/ui/AnimatedLogoTransition.dart';
import 'package:flify/components/ui/Loading.dart';
import 'package:flify/services/form_validation.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:isar/isar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/isar_service.dart';

class ConnectionScreen extends StatefulWidget {
  final String ip;
  final String port;
  final String name;
  const ConnectionScreen(
      {super.key, required this.ip, required this.port, required this.name});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String? _loadingState = "Loading...";
  late final IO.Socket socket;

  bool _isError = false;

  void validateIPAndPort() {
    // Check if ip and port are valid
    if (!isIPv4Valid(widget.ip) || !isPortValid(widget.port)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong IP or port provided!")));
      context.go("/");
    }
  }

  void initSocketConnection() {
    // TODO: Think about migrating to HTTPS
    socket = IO.io('http://${widget.ip}:${widget.port}');
    setState(() {
      _loadingState = "Waiting for connection...";
    });
    socket.onConnect((_) {
      if (!mounted) return;

      print("Successfully connnected to the socket!");
      socket.emit("hello");
      setState(() {
        _loadingState = "Waiting for initial message...";
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Disconnected from the server")));
      context.go("/");
    });

    // A reply to "hello" event send onConnect
    // TODO: Receive some metadata
    socket.on("world", (_) {
      setState(() {
        _loadingState = null;
      });
    });
  }

  Future<void> initConnection() async {
    validateIPAndPort();

    // Save to recent devices
    // Try to get the old one saves
    RecentDevice recentDevice = await IsarService.db.recentDevices
            .filter()
            .ipEqualTo(widget.ip)
            .and()
            .portEqualTo(int.parse(widget.port))
            .findFirst() ??
        RecentDevice(
            ip: widget.ip, port: int.parse(widget.port), name: widget.name);

    recentDevice.lastConnectionDate = DateTime.now();

    await IsarService.db.writeTxn(() async {
      await IsarService.db.recentDevices.put(recentDevice);
      print("Updated db with recent device");
    });

    // Try to connect to the server
    initSocketConnection();
  }

  @override
  void initState() {
    super.initState();

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
      return Scaffold(body: Column(children: [AnimatedLogoTransition()]));
    }
  }
}
