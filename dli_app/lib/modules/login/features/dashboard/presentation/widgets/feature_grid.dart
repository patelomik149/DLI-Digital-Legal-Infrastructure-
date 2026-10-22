import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class _Feature {
  const _Feature(this.icon, this.title, this.body, this.tile, this.color);

  final IconData icon;
  final String title;
  final String body;
  final Color tile;
  final Color color;
}

const _features = [
  _Feature(Icons.description_outlined, 'Legal Documents',
      'Manage and access your legal documents securely.', AppColors.blueTile, AppColors.primary),
  _Feature(Icons.verified_user_outlined, 'Secure & Trusted',
      'Your data is protected with advanced security measures.', AppColors.greenTile, AppColors.success),
  _Feature(Icons.bolt, 'Faster Processing', 'Reduce time with smart automation.',
      AppColors.purpleTile, AppColors.purple),
  _Feature(Icons.groups_outlined, 'Transparent Process',
      'Track your legal journey in real-time.', AppColors.indigoTile, AppColors.indigo),
];

/// 4 columns on desktop, 2 on tablet, 1 on phone.
class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key, required this.onTap});

  final void Function(String title) onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const gap = 16.0;
        final cols = c.maxWidth >= 1000 ? 4 : (c.maxWidth >= 560 ? 2 : 1);
        final width = (c.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final f in _features)
              SizedBox(width: width, child: _FeatureCard(feature: f, onTap: () => onTap(f.title))),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.onTap});

  final _Feature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: feature.tile,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(feature.icon, color: feature.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: text.titleSmall?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      feature.body,
                      style: text.bodySmall?.copyWith(color: AppColors.textMuted, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    const Icon(Icons.arrow_forward, size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
