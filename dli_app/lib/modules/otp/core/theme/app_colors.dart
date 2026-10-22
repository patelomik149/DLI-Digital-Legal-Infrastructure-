import 'package:flutter/material.dart';

/// Colors sampled from the DLI logo and the Verify OTP reference design.
class AppColors {
  AppColors._();

  // Brand
  static const navy = Color(0xFF0B2A6B); // headings, logo navy
  static const navyDark = Color(0xFF0A1F4D);
  static const primary = Color(0xFF1566D6); // buttons, links, focus
  static const primaryLight = Color(0xFF2F80ED); // accents, icons

  // Text
  static const textBody = Color(0xFF3D5A8A);
  static const textMuted = Color(0xFF5B7299);

  // Surfaces
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF8FBFF);
  static const card = Color(0xFFFFFFFF); // web card + info card
  static const inputFill = Color(0xFFFFFFFF); // OTP boxes
  static const border = Color(0xFFB4C6E2); // OTP box + info card border
  static const divider = Color(0xFFE3EBF6);

  // Right security panel + waves
  static const panelStart = Color(0xFFEAF2FC);
  static const panelEnd = Color(0xFFD3E4FA);
  static const wave = Color(0xFFDCEAFB);

  static const error = Color(0xFFD64545);

  // Web page background (darker white). Mobile uses its own white setting.
  static const offWhite = Color(0xFFE2E8F1);
}