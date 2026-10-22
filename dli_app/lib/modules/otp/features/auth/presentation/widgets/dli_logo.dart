import 'package:flutter/material.dart';

/// Company logo, shown exactly as provided (never recolored or redrawn).
class DliLogo extends StatelessWidget {
  const DliLogo({super.key, this.width = 220});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/primary_logo.png',
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'DLI Digital Legal Infrastructure',
    );
  }
}
