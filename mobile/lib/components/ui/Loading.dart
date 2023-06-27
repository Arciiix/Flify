import 'package:flify/components/ui/AnimatedLogoTransition.dart';
import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";

class Loading extends StatelessWidget {
  String loadingText;
  bool showGoHomeButton;
  Loading(
      {super.key,
      this.loadingText = "Loading...",
      this.showGoHomeButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedLogoTransition(),
              Text(
                loadingText,
                style: const TextStyle(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              if (showGoHomeButton)
                ElevatedButton.icon(
                    onPressed: () => context.go("/"),
                    icon: const Icon(Icons.home),
                    label: const Text("Go home")),
            ],
          ),
        ),
      ),
    );
  }
}
