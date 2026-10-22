import 'package:flutter/material.dart';

class DliPageTitle extends StatelessWidget {
  final String title;
  final Widget child;

  const DliPageTitle({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Title(
      title: title,
      color: const Color(0xFF087BEF),
      child: child,
    );
  }
}