import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/ui/animated_logo_transition.dart';
import '../types/navigation_state.dart';

class ReconnectScreen extends StatefulWidget {
  String ip;
  String port;
  String name;
  int currentReconnectIndex =
      0; // If not 0, it will connect to the current data after a delay. Number of reconnections that already happened to the given device. Starts from 1 (0 = don't reconnect)

  ReconnectScreen(
      {super.key,
      required this.ip,
      required this.port,
      required this.name,
      required this.currentReconnectIndex});

  @override
  State<ReconnectScreen> createState() => _ReconnectScreenState();
}

class _ReconnectScreenState extends State<ReconnectScreen> {
  Timer? reconnectTimer;
  Timer?
      reconnectTextPeriodicTimer; // A timer to update the text of time until the reconnection

  String _timeLeft = '';

  @override
  void initState() {
    super.initState();

    if (widget.currentReconnectIndex != 0) {
      Duration duration = Duration(
          // Exponential backoff duration - to not spam the server like crazy, but instead wait for some time
          // Max waiting time is 1 minute (which is log2 60000 ~ 16 retries)
          milliseconds: min(
              ((pow(2, (widget.currentReconnectIndex - 1))) * 1000).floor(),
              60000));

      reconnectTimer = Timer(duration, reconnect);

      DateTime targetDate = DateTime.now().add(duration);
      reconnectTextPeriodicTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        Duration timeLeft = targetDate.difference(DateTime.now());

        if (timeLeft.isNegative) {
          setState(() {
            _timeLeft = 'Connecting...';
          });
          timer.cancel();
          return;
        }

        // Format the remaining time as a string
        // Show seconds because the time is max 1 minute

        setState(() {
          _timeLeft =
              'in ${timeLeft.inSeconds} second${timeLeft.inSeconds == 1 ? '' : 's'}';
        });
      });
    } else {
      context.replace("/",
          extra: HomeScreenNavigationState(
              ip: widget.ip, port: widget.port, name: widget.name));
    }
  }

  void reconnect() {
    if (mounted) {
      reconnectTimer?.cancel();
      reconnectTextPeriodicTimer?.cancel();

      context.replace("/connection",
          extra: ConnectionScreenNavigationState(
              ip: widget.ip,
              port: widget.port,
              name: widget.name,
              currentReconnectIndex: widget.currentReconnectIndex));
    }
  }

  void cancelReconnection() {
    reconnectTimer?.cancel();
    reconnectTextPeriodicTimer?.cancel();
    context.replace("/",
        extra: HomeScreenNavigationState(
            ip: widget.ip, port: widget.port, name: widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Reconnecting..."),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: cancelReconnection,
            )
          ]),
      body: Center(
        child: Column(children: [
          const AnimatedLogoTransition(),
          const Text("Reconnecting...", style: TextStyle(fontSize: 32)),
          Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(widget.name),
                    subtitle: Text("${widget.ip}:${widget.port}"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: reconnect,
                        child: const Text('RECONNECT NOW'),
                      ),
                    ],
                  ),
                ],
              )),
          Text("Reconnect try no.: ${widget.currentReconnectIndex}"),
          Text(_timeLeft),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    reconnectTimer?.cancel();
    reconnectTextPeriodicTimer?.cancel();
  }
}
