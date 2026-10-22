import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'wave_painter.dart';

/// Right-hand panel for the email OTP screen (envelope illustration).
class EmailSecurityPanel extends StatelessWidget {
  const EmailSecurityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.panelStart, AppColors.panelEnd],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 170,
            child: CustomPaint(painter: WavePainter()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 64, 48, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your Security\nOur Priority',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'We use OTP verification to ensure\nyour account is safe and secure.',
                  style: TextStyle(
                      fontSize: 14.5, height: 1.6, color: AppColors.textBody),
                ),
                Expanded(child: Center(child: _EmailIllustration())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailIllustration extends StatelessWidget {
  const _EmailIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 340,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: CustomPaint(painter: _RingsPainter())),
          // Paper plane
          Positioned(
            top: 14,
            right: 10,
            child: Transform.rotate(
              angle: -0.6,
              child: Icon(Icons.send_rounded,
                  size: 32,
                  color: AppColors.primaryLight.withValues(alpha: .55)),
            ),
          ),
          // Envelope
          Positioned(
            left: 55,
            top: 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .30),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const CustomPaint(
                size: Size(230, 165),
                painter: _EnvelopePainter(),
              ),
            ),
          ),
          // Shield bubble
          const Positioned(
            left: 128,
            top: 70,
            child: _Bubble(
              child: Icon(Icons.verified_user_rounded,
                  size: 40, color: AppColors.primary),
            ),
          ),
          // Password card
          Positioned(
            left: 88,
            top: 232,
            child: Transform.rotate(
              angle: -0.10,
              child: _Bubble(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.mail_rounded,
                        size: 18, color: AppColors.primary),
                    SizedBox(width: 10),
                    Text(
                      '* * * * *',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  const _EnvelopePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(18)),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, AppColors.primary],
        ).createShader(rect),
    );

    final flap = Path()
      ..moveTo(10, 12)
      ..lineTo(size.width / 2, size.height * 0.58)
      ..lineTo(size.width - 10, 12)
      ..close();
    canvas.drawPath(
        flap, Paint()..color = AppColors.white.withValues(alpha: .18));

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.white.withValues(alpha: .35);
    canvas.drawLine(Offset(12, size.height - 12),
        Offset(size.width * 0.40, size.height * 0.52), line);
    canvas.drawLine(Offset(size.width - 12, size.height - 12),
        Offset(size.width * 0.60, size.height * 0.52), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height * 0.55);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.primaryLight.withValues(alpha: .25);
    canvas.drawCircle(c, size.width * 0.46, p);
    canvas.drawCircle(c, size.width * 0.36, p);

    final dot = Paint()..color = AppColors.primaryLight.withValues(alpha: .6);
    for (final o in const [
      Offset(0.22, 0.30),
      Offset(0.72, 0.18),
      Offset(0.94, 0.50),
      Offset(0.10, 0.80),
      Offset(0.90, 0.88),
    ]) {
      canvas.drawCircle(Offset(o.dx * size.width, o.dy * size.height), 4, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
