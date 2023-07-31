import 'dart:async';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final batteryProvider = Provider.autoDispose<Stream<int>>((ref) {
  final battery = BehaviorSubject<int>();

  final androidListener =
      BatteryInfoPlugin().androidBatteryInfoStream.listen((event) {
    battery.sink.add(event?.batteryLevel ?? 0);
  });
  final iosListener = BatteryInfoPlugin().iosBatteryInfoStream.listen((event) {
    battery.sink.add(event?.batteryLevel ?? 0);
  });

  ref.onDispose(() {
    androidListener.cancel();
    iosListener.cancel();
  });
  ref.keepAlive();

  return battery.stream;
});
