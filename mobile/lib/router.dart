import 'package:flify/components/connect/scan_qr_code.dart';
import 'package:flify/screens/connection_screen.dart';
import 'package:flify/screens/home_screen.dart';
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
      builder: (context, state) {
        HomeScreenNavigationState? params =
            state.extra as HomeScreenNavigationState?;
        return HomeScreen(
            ip: params?.ip, port: params?.port, name: params?.name);
      },
    ),
    GoRoute(
      path: "/scanQR",
      builder: (context, state) => const ScanQrCode(),
    ),
    GoRoute(
        path: "/connection",
        redirect: (context, state) {
          ConnectionScreenNavigationState? params =
              state.extra as ConnectionScreenNavigationState?;
          if (params == null) {
            return "/";
          }
          return null;
        },
        builder: (context, state) {
          ConnectionScreenNavigationState? params =
              state.extra as ConnectionScreenNavigationState?;
          if (params == null) {
            context.replace("/");
          }
          return ConnectionScreen(
              ip: params!.ip!,
              port: params.port!,
              name: params.name!,
              currentReconnectIndex: params.currentReconnectIndex);
        }),
  ],
);
