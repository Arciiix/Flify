import 'dart:async';

import 'package:flify/components/connect/current_network_info.dart';
import 'package:flify/components/connect/recent_devices.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/connect/manual_connect.dart';
import '../components/ui/animated_logo_transition.dart';

class HomeScreen extends StatefulWidget {
  final String? ip;
  final String? port;
  final String? name;
  final bool?
      reconnect; // If true, it will connect to the current data after a delay

  const HomeScreen({super.key, this.ip, this.port, this.name, this.reconnect});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? reconnectTimer;

  @override
  void initState() {
    super.initState();

    if (widget.reconnect == true) {
      reconnectTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          context.replace(
              "/connection?ip=${widget.ip}&port=${widget.port}&name=${widget.name}");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo(
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   isFullSize: true,
            // ),
            const AnimatedLogoTransition(),
            Text("Connect",
                style: TextStyle(fontSize: 48, color: primaryColor)),
            const CurrentNetworkInfo(),
            Text("Recent",
                style: TextStyle(
                    color: primaryColor.withOpacity(0.6), fontSize: 19)),
            const RecentDevices(),
            ManualConnect(ip: widget.ip, port: widget.port, name: widget.name),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();

    reconnectTimer?.cancel();
  }
}
