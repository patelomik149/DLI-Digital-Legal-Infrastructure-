import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "Secure • Transparent • Efficient" footer line.
class FooterTagline extends StatelessWidget {
  const FooterTagline({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 12.5, color: AppColors.primary);
    const dot = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text('•', style: style),
    );
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Secure', style: style),
        dot,
        Text('Transparent', style: style),
        dot,
        Text('Efficient', style: style),
      ],
    );
  }
}
