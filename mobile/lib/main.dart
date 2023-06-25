import 'package:flify/router.dart';
import 'package:flify/services/isar_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.openDB();

  runApp(const Flify());
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
