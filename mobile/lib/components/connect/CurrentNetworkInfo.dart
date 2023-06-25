import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CurrentNetworkInfo extends StatefulWidget {
  CurrentNetworkInfo({super.key});

  @override
  State<CurrentNetworkInfo> createState() => _CurrentNetworkInfoState();
}

class _CurrentNetworkInfoState extends State<CurrentNetworkInfo> {
  final info = NetworkInfo();
  String networkName = "-";
  String selfIp = "?";

  void getWifiName() async {
    try {
      String? name = await info.getWifiName() ?? "-";
      String? ip = await info.getWifiIP() ?? "?";
      print("name: ${name}, ip: ${ip}");
      setState(() {
        selfIp = ip;
        networkName = name;
      });
    } catch (e) {
      print("Error while getting Wi-Fi name");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getWifiName();
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
