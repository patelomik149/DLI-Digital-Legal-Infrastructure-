import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Right-hand panel of the web login: heading, text, three icon tiles and the
/// gavel / books / laptop photo (assets/images/login_hero.jpg) at the bottom.
class HeroPanel extends StatelessWidget {
  const HeroPanel({super.key});

  static const _photoAspect = 1392 / 918; // width / height of login_hero.jpg

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final photoH = w / _photoAspect;
        final photoTop = h - photoH;
        // Only show the floating tiles when there is room above the photo.
        final showTiles = photoTop - 72 >= 296;

        return Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.heroTop, AppColors.heroBottom],
                ),
              ),
            ),

            // Photo, faded into the gradient along its top edge.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FFFFFF), Colors.white],
                  stops: [0.0, 0.22],
                ).createShader(rect),
                child: Image.asset(
                  'assets/images/login_hero.jpg',
                  width: w,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => SizedBox(height: photoH),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(56, 56, 56, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Legal\nJourney Starts\nHere',
                    style: text.headlineMedium?.copyWith(
                      fontSize: 34,
                      color: AppColors.navy,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      'Register today and experience a smarter, faster and more '
                      'transparent way to manage legal processes.',
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.label,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (showTiles) ...[
              Positioned(
                left: w * 0.20,
                top: photoTop - 44,
                child: const _IconTile(Icons.description_outlined),
              ),
              Positioned(
                left: w * 0.44,
                top: photoTop - 72,
                child: const _IconTile(Icons.verified_user_outlined),
              ),
              Positioned(
                left: w * 0.60,
                top: photoTop - 16,
                child: const _IconTile(Icons.balance),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: Icon(icon, color: AppColors.primaryLight, size: 28),
    );
  }
}
