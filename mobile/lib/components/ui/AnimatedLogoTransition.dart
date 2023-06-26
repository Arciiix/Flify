import 'package:flutter/material.dart';

import 'AnimatedLogo.dart';

const HERO_LOGO_TAG = "Flify_logo_animated";

class AnimatedLogoTransition extends StatelessWidget {
  const AnimatedLogoTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: HERO_LOGO_TAG,
        child: Material(
          child: AnimatedLogo(
            width: MediaQuery.of(context).size.width * 0.8,
            isFullSize: true,
          ),
        ));
  }
}
