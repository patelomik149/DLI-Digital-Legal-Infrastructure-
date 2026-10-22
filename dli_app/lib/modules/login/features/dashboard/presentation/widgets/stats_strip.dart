import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Overview numbers. TODO: replace the sample values with data from the backend.
class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back to your DLI account.',
            style: text.titleSmall?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 640 ? 4 : 2;
              final width = c.maxWidth / cols;
              return Wrap(
                runSpacing: 20,
                children: [
                  for (final s in _stats) SizedBox(width: width, child: _Stat(stat: s)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.value, this.label, this.color);

  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

const _stats = [
  _StatData(Icons.description_outlined, '12', 'Total Requests', AppColors.navy),
  _StatData(Icons.schedule, '5', 'In Progress', AppColors.warning),
  _StatData(Icons.verified_outlined, '7', 'Completed', AppColors.success),
  _StatData(Icons.shield_outlined, '100%', 'Secure', AppColors.purple),
];

class _Stat extends StatelessWidget {
  const _Stat({required this.stat});

  final _StatData stat;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(stat.icon, color: stat.color, size: 26),
        const SizedBox(height: 6),
        Text(
          stat.value,
          style: text.headlineSmall?.copyWith(color: stat.color, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(stat.label, style: text.bodySmall?.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}
