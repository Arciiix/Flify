import 'package:flify/services/isar_service.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flutter/material.dart';

import 'package:isar/isar.dart';

class RecentDevices extends StatefulWidget {
  const RecentDevices({super.key});

  @override
  State<RecentDevices> createState() => _RecentDevicesState();
}

class _RecentDevicesState extends State<RecentDevices> {
  List<RecentDevice> devices = [];

  Future<List<RecentDevice>> getRecentDevices() async {
    List<RecentDevice> allDevices =
        await IsarService.db.recentDevices.where().findAll();

    // Sort them from the most recent one
    allDevices
        .sort((a, b) => b.lastConnectionDate.compareTo(a.lastConnectionDate));

    setState(() {
      devices = allDevices;
    });

    return allDevices;
  }

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
      await IsarService.db.writeTxn(() async {
        await IsarService.db.recentDevices.delete(device.id);
      });
      await getRecentDevices();
    }
  }

  @override
  void initState() {
    super.initState();

    getRecentDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: devices.isNotEmpty
              ? devices
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RawChip(
                          label: Text("${e.name} (${e.ip.toString()})"),
                          onDeleted: () => deleteDevice(e),
                          onPressed: () {
                            print("TODO: Connect to device");
                          },
                        ),
                      ))
                  .toList()
              : [Text("No recent devices! 👀")],
        ),
      ),
    );
  }
}
