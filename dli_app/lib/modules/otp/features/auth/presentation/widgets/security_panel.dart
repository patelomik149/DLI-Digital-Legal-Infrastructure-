import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'wave_painter.dart';

/// Right-hand "Your Security, Our Priority" panel (web layout only).
class SecurityPanel extends StatelessWidget {
  const SecurityPanel({super.key});

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
              children:  [
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
                    fontSize: 14.5,
                    height: 1.6,
                    color: AppColors.textBody,
                  ),
                ),

                // NEW IMAGE
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 500,
                      height: 500,
                      child: Image.asset(
                        'assets/images/registration_otp.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}