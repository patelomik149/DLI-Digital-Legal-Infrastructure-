import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Soft decorative waves used at the bottom of the screen / security panel.
class WavePainter extends CustomPainter {
  const WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final back = Path()
      ..moveTo(0, size.height * 0.55)
      ..cubicTo(size.width * 0.25, size.height * 0.15, size.width * 0.55,
          size.height * 0.85, size.width, size.height * 0.30)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(back, Paint()..color = AppColors.wave.withValues(alpha: .7));

    final front = Path()
      ..moveTo(0, size.height * 0.75)
      ..cubicTo(size.width * 0.30, size.height * 0.45, size.width * 0.65,
          size.height * 1.0, size.width, size.height * 0.60)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(front, Paint()..color = AppColors.wave);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
