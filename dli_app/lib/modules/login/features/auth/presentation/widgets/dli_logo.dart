import 'package:flutter/material.dart';

/// Shows the official DLI logo exactly as supplied.
/// Never recolor, stretch or redraw this asset - only scale it.
///
/// [trimmed] hides only the empty white margin around the artwork (layout
/// clipping at draw time; the image file itself is not changed). Use it in
/// tight spaces such as app bars and footers.
class DliLogo extends StatelessWidget {
  const DliLogo({super.key, this.height = 150, this.trimmed = false});

  /// Visible height of the logo.
  final double height;
  final bool trimmed;

  static const _asset = 'assets/images/primary_logo.png';
  static const _aspect = 1280 / 853; // width / height of the asset
  static const _widthFactor = 0.65; // share of the image width that has artwork
  static const _heightFactor = 0.54; // share of the image height that has artwork

  @override
  Widget build(BuildContext context) {
    if (!trimmed) {
      return Image.asset(
        _asset,
        height: height,
        fit: BoxFit.contain,
        semanticLabel: 'DLI - Digital Legal Infrastructure',
      );
    }

    final imageHeight = height / _heightFactor;
    return SizedBox(
      height: height,
      width: imageHeight * _aspect * _widthFactor,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Image.asset(
            _asset,
            height: imageHeight,
            fit: BoxFit.contain,
            semanticLabel: 'DLI - Digital Legal Infrastructure',
          ),
        ),
      ),
    );
  }
}
