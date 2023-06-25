import 'package:flutter/material.dart';

Future<void> showOverridenSnackbar(BuildContext context, Widget content) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: content))
      .closed;
}
