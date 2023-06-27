import 'package:flify/components/connect/ScanQrCode.dart';
import 'package:flify/screens/ConnectionScreen.dart';
import 'package:flify/screens/HomeScreen.dart';
import 'package:flify/types/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeObserverProvider = RouteObserver<ModalRoute<void>>();

// GoRouter configuration
final router = GoRouter(
  observers: [routeObserverProvider],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(
          ip: (state.extra as HomeScreenState?)?.ip,
          port: (state.extra as HomeScreenState?)?.port,
          name: (state.extra as HomeScreenState?)?.name),
    ),
    GoRoute(
      path: "/scanQR",
      builder: (context, state) => const ScanQrCode(),
    ),
    GoRoute(
        path: "/connection",
        redirect: (context, state) {
          if (state.queryParameters["ip"] == null ||
              state.queryParameters['port'] == null ||
              state.queryParameters['name'] == null) {
            return "/";
          }
          return null;
        },
        builder: (context, state) {
          return ConnectionScreen(
            ip: state.queryParameters["ip"]!,
            port: state.queryParameters["port"]!,
            name: state.queryParameters["name"]!,
          );
        })
  ],
);
