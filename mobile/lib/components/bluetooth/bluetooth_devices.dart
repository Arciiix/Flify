import "package:flify/providers/bluetooth_service.dart";
import "package:flutter/material.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class BluetoothDevices extends ConsumerStatefulWidget {
  const BluetoothDevices({super.key});

  @override
  BluetoothDevicesState createState() => BluetoothDevicesState();
}

class BluetoothDevicesState extends ConsumerState<BluetoothDevices> {
  late final FlutterBluePlus bluetooth;

  Future<void> initBluetooth() async {
    print(await bluetooth.isOn);
  }

  @override
  void initState() {
    super.initState();

    bluetooth = ref.read(bluetoothServiceProvider);

    initBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
