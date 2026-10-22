import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shared shell for all auth screens.
///  - width >= 900 -> web layout (form on the left, [hero] on the right)
///  - width <  900 -> mobile layout (single column)
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.formBuilder, required this.hero});

  static const double webBreakpoint = 900;

  /// Builds the form. [isWide] is true for the web layout.
  final Widget Function(BuildContext context, bool isWide) formBuilder;
  final Widget hero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= webBreakpoint;
          return isWide ? _web(context) : _mobile(context);
        },
      ),
    );
  }

  Widget _mobile(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, AppColors.pageBg],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: formBuilder(context, false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _web(BuildContext context) {
    return Container(
      color: AppColors.pageBg,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 900),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 32, offset: Offset(0, 12)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 11,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: formBuilder(context, true),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 10, child: hero),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
