import 'dart:io';

import 'package:flify/providers/notifications.dart';
import 'package:flify/router.dart';
import 'package:flify/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flify/types/recent_device.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final db = await Isar.open([RecentDeviceSchema], directory: dir.path);

  print("DB init");

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  print("Notifications init");

  runApp(ProviderScope(overrides: [
    isarProvider.overrideWithValue(db),
    flutterLocalNotificationsProvider
        .overrideWithValue(flutterLocalNotificationsPlugin),
  ], child: const Flify()));
}

const flifyColor = Color(0xFF206AC4);

class Flify extends StatelessWidget {
  const Flify({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flify',
      theme: ThemeData(
          colorScheme: const ColorScheme.dark(primary: flifyColor),
          useMaterial3: true,
          sliderTheme:
              SliderThemeData(overlayShape: SliderComponentShape.noOverlay)),
      routerConfig: router,
    );
  }
}
