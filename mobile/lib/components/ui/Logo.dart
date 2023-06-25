import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool isFullSize;
  final double width;
  const Logo({super.key, required this.width, this.isFullSize = false});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
          "assets/logo/${isFullSize ? "Flify-full.png" : "Flify.png"}"),
      width: width,
    );
  }
}
