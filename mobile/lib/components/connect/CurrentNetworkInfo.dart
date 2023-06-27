import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../services/network_info.dart';

class CurrentNetworkInfo extends StatefulWidget {
  CurrentNetworkInfo({super.key});

  @override
  State<CurrentNetworkInfo> createState() => _CurrentNetworkInfoState();
}

class _CurrentNetworkInfoState extends State<CurrentNetworkInfo> {
  final info = NetworkInfo();
  String networkName = "-";
  String selfIp = "?";

  @override
  void initState() {
    super.initState();
    getWifiName().then((value) {
      setState(() {
        networkName = value?['networkName'] ?? "-";
        selfIp = value?['selfIp'] ?? "?";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.wifi),
        ),
        Text("${networkName} (ip: ${selfIp})"),
      ],
    );
  }
}
