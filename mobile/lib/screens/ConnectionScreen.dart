import 'package:flify/components/ui/AnimatedLogoTransition.dart';
import 'package:flify/components/ui/Loading.dart';
import 'package:flify/services/form_validation.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:isar/isar.dart';

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
  bool _isConnecting = true;

  void validateIPAndPort() {
    // Check if ip and port are valid
    if (!isIPv4Valid(widget.ip) || !isPortValid(widget.port)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wrong IP or port provided!")));
      context.go("/");
    }
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

    // TODO: Add connection logic

    setState(() {
      _isConnecting = false;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initConnection());
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnecting) {
      return Loading();
    } else {
      return Scaffold(body: Column(children: [AnimatedLogoTransition()]));
    }
  }
}
