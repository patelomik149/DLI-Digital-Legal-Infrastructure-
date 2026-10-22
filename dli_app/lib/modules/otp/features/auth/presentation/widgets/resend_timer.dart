import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "Resend OTP in 00:45" countdown that turns into a Resend button.
class ResendTimer extends StatefulWidget {
  const ResendTimer({super.key, this.seconds = 45, this.onResend});

  final int seconds;
  final VoidCallback? onResend;

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  Timer? _timer;
  late int _left;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _left = widget.seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) {
        t.cancel();
      }
      setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _label {
    final m = (_left ~/ 60).toString().padLeft(2, '0');
    final s = (_left % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_left > 0) {
      return Text('Resend OTP in $_label',
          style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted));
    }
    return TextButton(
      onPressed: () {
        widget.onResend?.call();
        setState(_start);
      },
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      child: const Text('Resend OTP',
          style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
