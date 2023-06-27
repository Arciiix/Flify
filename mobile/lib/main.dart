import 'package:flify/router.dart';
import 'package:flify/providers/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flify/types/recent_device.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final db = await Isar.open([RecentDeviceSchema], directory: dir.path);

  print("DB init");

  runApp(ProviderScope(
      overrides: [isarProvider.overrideWithValue(db)], child: const Flify()));
}

class Flify extends StatelessWidget {
  const Flify({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flify',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Color(0xFF206AC4)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
