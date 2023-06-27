import 'package:flify/types/network_info_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../providers/network_info.dart';

class CurrentNetworkInfo extends ConsumerWidget {
  CurrentNetworkInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkInfo = ref.watch(networkInfoProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.wifi),
        ),
        networkInfo.when(
            data: (data) => Text("${data.networkName} (ip: ${data.selfIp})"),
            error: (_, __) => const Text("error getting data"),
            loading: () => const Text("- (ip: ?)")),
      ],
    );
  }
}
