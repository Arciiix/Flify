import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final bluetoothServiceProvider = Provider<FlutterBluePlus?>((ref) {
  try {
    final instance = FlutterBluePlus.instance;
    return instance;
  } on PlatformException catch (e) {
    print("Couldn't init Bluetooth!");
    print(e);
    return null;
  }
});
