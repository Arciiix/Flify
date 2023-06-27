import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final bluetoothServiceProvider =
    Provider<FlutterBluePlus>((ref) => FlutterBluePlus.instance);
