import 'package:flify/types/navigation_state.dart';
import 'package:flify/utils/form_validation.dart';
import 'package:flify/utils/override_snackbar.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  MobileScannerController cameraController = MobileScannerController();

  bool _isSnackbarActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Flify's QR code"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.white);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.white);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');

            String? rawValue = barcode.rawValue;
            if (rawValue == null) {
              // No value
              if (!_isSnackbarActive) {
                _isSnackbarActive = true;
                showOverridenSnackbar(
                        context, const Text("Empty QR code scanned!"))
                    .then((value) => _isSnackbarActive = false);
              }
              return;
            }
            // Format: Flify/<ip>:<port>/<hostname>
            if (rawValue.startsWith("Flify/")) {
              String ip, port, name;
              List<String> strings =
                  rawValue.replaceFirst("Flify/", "").split("/");
              [ip, port] = strings[0].split(":");
              name = strings.length > 1 ? strings[1] : "My Flify device";

              if (isIPv4Valid(ip) && isPortValid(port)) {
                // Success - navigate back with the data
                // context.pop([ip, port, name]);
                context.go("/",
                    extra: HomeScreenState(ip: ip, port: port, name: name));
              } else {
                // Wrong format
                if (!_isSnackbarActive) {
                  _isSnackbarActive = true;
                  showOverridenSnackbar(context,
                          const Text("The scanned Flify QR code is invalid!"))
                      .then((value) => _isSnackbarActive = true);
                }
                return;
              }
            } else {
              // It's not Flify
              if (!_isSnackbarActive) {
                _isSnackbarActive = true;
                showOverridenSnackbar(context,
                        const Text("The scanned QR code is not for Flify"))
                    .then((value) => _isSnackbarActive = false);
              }
              return;
            }
          }
        },
      ),
    );
  }
}
