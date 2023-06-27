import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/bluetooth_service.dart';

class BluetoothScan extends ConsumerStatefulWidget {
  const BluetoothScan({super.key});

  @override
  BluetoothScanState createState() => BluetoothScanState();
}

class BluetoothScanState extends ConsumerState<BluetoothScan> {
  late final FlutterBluePlus? bluetooth;

  String currentState = "Init...";

  Future<void> initScan() async {
    setState(() {
      currentState = "Scanning...";
    });
    if (bluetooth!.isScanningNow) {
      // TODO: Handle it
      print("already scanning");
    } else {
      // TODO: Think about duration
      bluetooth!.scan(timeout: const Duration(seconds: 5)).listen((event) {
        if (!mounted) return;
        setState(() {
          print(event);
          // bluetoothDevices.add(event);
          // TODO: Find a way to categorize the devices to those with sound casting support
          // TODO: Set them as a state
          // TODO: Send socket event here or SEE BELOW (here: the stream of the devices). After user connects to one of them, further scanning is not needed
        });
      }, onDone: () {
        if (!mounted) return;
        setState(() {
          currentState = "Done!";
        });
        // TODO: Send socket event here or SEE ABOVE (here: only the list with all devices)
      });
    }
  }

  void prepareScan() async {
    setState(() {
      currentState = "Turning on Bluetooth...";
    });
    await bluetooth!.turnOn();

    late StreamSubscription<BluetoothState> subscription;
    subscription = bluetooth!.state.listen((event) {
      if (event == BluetoothState.on) {
        initScan();
        subscription.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    bluetooth = ref.read(bluetoothServiceProvider);

    prepareScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            // TODO: Better way to display the state
            Text(currentState),
            // TODO: Display the devices list
            // TODO: After clicking on the device, connect to it
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
