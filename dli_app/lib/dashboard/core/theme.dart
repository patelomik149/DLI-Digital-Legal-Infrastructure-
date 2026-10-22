import 'package:flutter/material.dart';

/// Colors sampled from the DLI dashboard design.
class DashColors {
  static const navy = Color(0xFF00264F);
  static const navActive = Color(0xFF0B6BA6);
  static const heading = Color(0xFF0B2C5C);
  static const accent = Color(0xFF0A5483);
  static const primary = Color(0xFF05619D);
  static const bg = Color(0xFFF6FAFE);
  static const soft = Color(0xFFE8F6FD);
  static const softBorder = Color(0xFFD3E9F7);
  static const border = Color(0xFFE5EDF5);
  static const muted = Color(0xFF5E6E82);
  static const green = Color(0xFF16A34A);
  static const greenSoft = Color(0xFFD9F7E8);
  static const orange = Color(0xFFF08A0B);
  static const orangeSoft = Color(0xFFFDEBC8);
  static const purple = Color(0xFF8B5CF6);
  static const purpleSoft = Color(0xFFEDE4FE);
  static const blueSoft = Color(0xFFD6EBFC);
  static const red = Color(0xFFEF4444);
}

/// Screen width from which the sidebar is shown permanently (web / tablet / desktop).
const double kWideBreakpoint = 900;

ThemeData buildDashTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: DashColors.primary),
    scaffoldBackgroundColor: DashColors.bg,
    splashFactory: InkRipple.splashFactory,
  );
}

void showSoon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what - coming soon')));
}
