import 'package:flify/types/network_info_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';

final networkInfoProvider = FutureProvider<NetworkInfoResponse>((ref) async {
  final info = NetworkInfo();

  String? name = await info.getWifiName() ?? "-";
  String? ip = await info.getWifiIP() ?? "?";
  print("name: ${name}, ip: ${ip}");
  return NetworkInfoResponse(selfIp: ip, networkName: name);
});
