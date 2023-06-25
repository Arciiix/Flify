import 'package:flify/components/connect/ScanQrCode.dart';
import 'package:flify/screens/HomeScreen.dart';
import 'package:flify/types/navigation_state.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(
          ip: (state.extra as HomeScreenState?)?.ip,
          port: (state.extra as HomeScreenState?)?.port),
    ),
    GoRoute(
      path: "/scanQR",
      builder: (context, state) => ScanQrCode(),
    )
  ],
);
