import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/common.dart';

/// Simple "coming soon" page for sidebar items that are built later.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: title,
      children: [
        SoftCard(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Icon(icon, size: 56, color: DashColors.primary),
                const SizedBox(height: 14),
                Text(
                  '$title is coming soon',
                  style: const TextStyle(
                    color: DashColors.heading,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
