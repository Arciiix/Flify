import 'package:flify/providers/isar_service.dart';
import 'package:flify/types/recent_device.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final recentDevicesProvider = FutureProvider<List<RecentDevice>>((ref) async {
  final db = ref.read(isarProvider);

  List<RecentDevice> allDevices = await db.recentDevices.where().findAll();

  // Sort them from the most recent one
  allDevices
      .sort((a, b) => b.lastConnectionDate.compareTo(a.lastConnectionDate));

  return allDevices;
});
