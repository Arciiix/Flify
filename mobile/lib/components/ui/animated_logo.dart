import 'package:flify/components/ui/logo.dart';
import 'package:flutter/material.dart';
import "dart:math";

class AnimatedLogo extends StatefulWidget {
  final double width;
  final bool isFullSize;

  const AnimatedLogo({super.key, required this.width, this.isFullSize = false});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.isFullSize
          ? [
              FlifyStyleText("Fl", width: widget.width),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AnimatedLogoCircle(width: widget.width),
              ),
              FlifyStyleText("fy", width: widget.width),
            ]
          : [AnimatedLogoCircle(width: widget.width)],
    );
  }
}

class FlifyStyleText extends StatelessWidget {
  final String content;
  final double width;

  const FlifyStyleText(this.content, {super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "Arial Rounded MT Bold",
          fontSize: width * 0.3),
    );
  }
}

class AnimatedLogoCircle extends StatefulWidget {
  final double width;

  const AnimatedLogoCircle({super.key, required this.width});

  @override
  State<AnimatedLogoCircle> createState() => _AnimatedLogoCircleState();
}

class _AnimatedLogoCircleState extends State<AnimatedLogoCircle>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  late final CurvedAnimation _curvedAnimation =
      CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: (_curvedAnimation.value * 2 * pi) -
              pi, // in radians, pi = 180 deg, 2 * pi = 360 deg. We want it to start from upside down, so we subtract pi (= 180 deg)

          child: child,
        );
      },
      child: Logo(width: widget.width * 0.3, isFullSize: false),
    );
  }
}
