import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.userName,
    required this.wide,
    required this.onGetStarted,
  });

  final String userName;
  final bool wide;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final headingSize = wide ? 50.0 : 34.0;

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to DLI',
          style: text.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            style: text.displaySmall?.copyWith(
              fontSize: headingSize,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
            children: [
              TextSpan(text: 'Hello $userName,\nYour Legal Journey\n'),
              const TextSpan(text: 'Starts Here', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Digital Legal Infrastructure simplifies legal processes with '
            'technology, making them faster, safer and more transparent for everyone.',
            style: text.bodyLarge?.copyWith(color: AppColors.textMuted, height: 1.6),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: onGetStarted,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Get Started'),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ],
    );

    if (!wide) return copy;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: copy),
        const SizedBox(width: 32),
        const Expanded(flex: 5, child: _HeroArt()),
      ],
    );
  }
}

/// Simple illustration built from icons (no extra image files needed).
class _HeroArt extends StatelessWidget {
  const _HeroArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Color(0xFFD4E5FC), Color(0x00E6EFFD)]),
            ),
          ),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 30, offset: Offset(0, 14)),
              ],
            ),
            child: const Icon(Icons.balance, size: 110, color: AppColors.navy),
          ),
          const Align(alignment: Alignment(0.05, -0.95), child: _Tile(Icons.lock_outline)),
          const Align(alignment: Alignment(-0.85, -0.3), child: _Tile(Icons.description_outlined)),
          const Align(alignment: Alignment(0.9, -0.25), child: _Tile(Icons.person_outline)),
          const Align(alignment: Alignment(0.75, 0.75), child: _Tile(Icons.account_balance_outlined)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: Icon(icon, color: AppColors.primaryLight, size: 30),
    );
  }
}
