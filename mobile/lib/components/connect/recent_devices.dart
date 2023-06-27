import 'package:flify/providers/isar_service.dart';
import 'package:flify/providers/recent_devices.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:isar/isar.dart';

class RecentDevices extends ConsumerStatefulWidget {
  const RecentDevices({super.key});

  @override
  RecentDevicesState createState() => RecentDevicesState();
}

class RecentDevicesState extends ConsumerState<RecentDevices> {
  late final Isar db;

  Future<void> deleteDevice(RecentDevice device) async {
    bool answer = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Delete recent device'),
            content: Text(
                'Are you sure you want to remove device ${device.name} (${device.ip}:${device.port}) from the recent devices?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete')),
            ],
          );
        });

    if (answer) {
      await db.writeTxn(() async {
        await db.recentDevices.delete(device.id);
      });
      ref.refresh(recentDevicesProvider);
    }
  }

  void connectToDevice(RecentDevice device) {
    context.push(
        "/connection?ip=${device.ip}&port=${device.port}&name=${device.name}");
  }

  @override
  void initState() {
    super.initState();

    db = ref.read(isarProvider);

    ref.refresh(recentDevicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(recentDevicesProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: devices.when(
              data: (items) => Row(
                    children: items.isNotEmpty
                        ? items
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: RawChip(
                                    label:
                                        Text("${e.name} (${e.ip.toString()})"),
                                    onDeleted: () => deleteDevice(e),
                                    onPressed: () {
                                      connectToDevice(e);
                                    },
                                  ),
                                ))
                            .toList()
                        : [const Text("No recent devices! 👀")],
                  ),
              loading: () => const Text("Please wait... ⌛"),
              error: (_, __) => const Text("Couldn't load... 😢"))),
    );
  }
}
