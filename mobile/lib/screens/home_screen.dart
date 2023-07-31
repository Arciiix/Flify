import 'package:flify/components/connect/current_network_info.dart';
import 'package:flify/components/connect/recent_devices.dart';
import 'package:flutter/material.dart';

import '../components/connect/manual_connect.dart';
import '../components/ui/animated_logo_transition.dart';

class HomeScreen extends StatefulWidget {
  final String? ip;
  final String? port;
  final String? name;

  const HomeScreen({
    super.key,
    this.ip,
    this.port,
    this.name,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
}
