import 'package:flify/components/ui/AnimatedLogoTransition.dart';
import 'package:flutter/material.dart';

import '../../screens/HomeScreen.dart';
import 'AnimatedLogo.dart';

class Loading extends StatelessWidget {
  String loadingText;
  Loading({super.key, this.loadingText = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedLogoTransition(),
              Text(loadingText, style: const TextStyle(fontSize: 32))
            ],
          ),
        ),
      ),
    );
  }
}
