import 'package:flify/components/connect/CurrentNetworkInfo.dart';
import 'package:flify/components/connect/RecentDevices.dart';
import 'package:flutter/material.dart';

import '../components/connect/ManualConnect.dart';
import '../components/ui/AnimatedLogoTransition.dart';

class HomeScreen extends StatelessWidget {
  final String? ip;
  final String? port;
  final String? name;

  const HomeScreen({super.key, this.ip, this.port, this.name});

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
            ManualConnect(ip: ip, port: port, name: name),
          ],
        ),
      )),
    );
  }
}
