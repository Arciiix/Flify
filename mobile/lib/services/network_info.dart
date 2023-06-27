import 'package:network_info_plus/network_info_plus.dart';

Future<Map<String, String>?> getWifiName() async {
  final info = NetworkInfo();
  String networkName = "-";
  String selfIp = "?";
  try {
    String? name = await info.getWifiName() ?? "-";
    String? ip = await info.getWifiIP() ?? "?";
    print("name: ${name}, ip: ${ip}");
    return {
      'selfIp': ip,
      'networkName': name,
    };
  } catch (e) {
    print("Error while getting Wi-Fi name");
    print(e);
    return null;
  }
}
