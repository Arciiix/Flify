import 'package:flify/services/form_validation.dart';
import 'package:flify/types/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:go_router/go_router.dart";

class ManualConnect extends StatefulWidget {
  final String? ip;
  final String? port;
  const ManualConnect({super.key, this.ip, this.port});

  @override
  State<ManualConnect> createState() => _ManualConnectState();
}

class _ManualConnectState extends State<ManualConnect> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController =
      TextEditingController(text: "3400");

  Future<void> scanQrCode() async {
    List<String>? data = await context.push("/scanQR");
    if (data != null) {
      var [ip, port] = data;
      _ipController.text = ip;
      _portController.text = port;

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("QR code scanned!"),
      ));
    }
  }

  Future<void> tryToConnect() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    print("TODO: Connect to device");
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      if (widget.ip != null) {
        _ipController.text = widget.ip!;
      }
      if (widget.port != null) {
        _portController.text = widget.port!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(labelText: "IP address"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  return isIPv4Valid(value) ? null : "Invalid IP address.";
                },
              ),
              TextFormField(
                controller: _portController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "Port",
                    helperText:
                        "Default is 3400. 80 for HTTP and 443 for HTTPS.",
                    suffix: IconButton(
                        onPressed: () {
                          _portController.text = "3400";
                        },
                        icon: const Icon(Icons.refresh))),
                validator: (value) {
                  return isPortValid(value) ? null : "Invalid port.";
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: scanQrCode,
                        icon: const Icon(Icons.qr_code),
                        label: const Text("Scan QR code")),
                    ElevatedButton.icon(
                        onPressed: tryToConnect,
                        icon: const Icon(Icons.wifi_tethering),
                        label: const Text("Connect"))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
