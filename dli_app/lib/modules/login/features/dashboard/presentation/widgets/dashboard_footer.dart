import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/widgets/dli_logo.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key, required this.items, required this.wide});

  final List<String> items;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted);
    final links = Wrap(
      spacing: 20,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [for (final i in items) Text(i, style: small)],
    );
    final copyright = Text('© ${DateTime.now().year} DLI. All rights reserved.', style: small);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: wide ? 32 : 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: wide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const DliLogo(height: 34, trimmed: true), links, copyright],
                )
              : Column(
                  children: [
                    const DliLogo(height: 40, trimmed: true),
                    const SizedBox(height: 16),
                    links,
                    const SizedBox(height: 12),
                    copyright,
                  ],
                ),
        ),
      ),
    );
  }
}
