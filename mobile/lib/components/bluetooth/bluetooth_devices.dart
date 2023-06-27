import "dart:async";

import "package:flify/providers/bluetooth_service.dart";
import "package:flutter/material.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:permission_handler/permission_handler.dart";

import "bluetooth_scan.dart";

class BluetoothDevices extends ConsumerStatefulWidget {
  const BluetoothDevices({super.key});

  @override
  BluetoothDevicesState createState() => BluetoothDevicesState();
}

class BluetoothDevicesState extends ConsumerState<BluetoothDevices> {
  final primaryColor = Colors.blue;

  late final FlutterBluePlus? bluetooth;
  bool isBluetoothSupported = false;

  List<ScanResult> bluetoothDevices = [];

  Future<void> initBluetooth() async {
    if (bluetooth == null) return;

    Map<Permission, PermissionStatus> status;

    do {
      print("asking for permission...");
      status = await [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request();
      print("Asked!");
    } while (status.containsValue(PermissionStatus.denied));

    if (status.containsValue(PermissionStatus.permanentlyDenied)) {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'One of the permissions was permanently denied. Please change it.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK')),
              ],
            );
          });

      return;
    }

    final isSupported = await bluetooth!.isAvailable;

    setState(() {
      isBluetoothSupported = isSupported;
      bluetoothDevices = [];
    });

    if (!isBluetoothSupported) return;

    bool? answer = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Bluetooth'),
            content: Text(
                'Now the app will turn on Bluetooth and scan for the external devices (speakers, headphones).'),
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
                  icon: const Icon(Icons.bluetooth),
                  label: const Text("Let's do that!")),
            ],
          );
        });

    if (answer == true) {
      prepareScan();
    }
  }

  Future<void> prepareScan() async {
    showModalBottomSheet(
        context: context, builder: (context) => BluetoothScan());
  }

  void stopScanning() => bluetooth!.stopScan();

  @override
  void initState() {
    super.initState();

    bluetooth = ref.read(bluetoothServiceProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bluetooth != null) {
        initBluetooth();
      } else {
        setState(() {
          isBluetoothSupported = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(colorScheme: ColorScheme.dark(primary: primaryColor)),
      child: isBluetoothSupported
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[900],
                  border: Border.all(
                    color: primaryColor,
                    width: 4,
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bluetooth, color: primaryColor, size: 32),
                      Text("Bluetooth",
                          style: TextStyle(color: primaryColor, fontSize: 32))
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.bluetooth_audio),
                      ),
                      Column(
                        children: [
                          // TODO: nice signal indicator
                          Text("signal"),
                          Text("not connected"),
                        ],
                      )
                    ],
                  ),
                  ElevatedButton.icon(
                      onPressed: prepareScan,
                      icon: const Icon(Icons.search),
                      label: const Text("Scan"))
                  // ElevatedButton(
                  //     onPressed: stopScanning, child: const Text("Stop scanning")),
                ],
              ),
            )
          : Container(),
    );
  }
}
