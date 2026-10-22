import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Row of single-digit OTP boxes with auto-advance, backspace and paste support.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    this.length = 6,
    this.boxHeight = 56,
    this.hasError = false,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final double boxHeight;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) {
      final node = FocusNode();
      node.addListener(() => setState(() {}));
      return node;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _notify() {
    final v = _value;
    widget.onChanged?.call(v);
    if (v.length == widget.length) {
      widget.onCompleted?.call(v);
      FocusScope.of(context).unfocus();
    }
  }

  void _onChanged(int i, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _controllers[i].clear();
    } else if (digits.length <= 2 && _controllers[i].text.isNotEmpty ||
        digits.length == 1) {
      // Typing over an existing digit keeps the newest one.
      _controllers[i].text = digits[digits.length - 1];
      if (i < widget.length - 1) _nodes[i + 1].requestFocus();
    } else {
      // Pasted code: spread across the boxes.
      var last = i;
      for (var j = 0; j < digits.length && i + j < widget.length; j++) {
        _controllers[i + j].text = digits[j];
        last = i + j;
      }
      if (last < widget.length - 1) _nodes[last + 1].requestFocus();
    }
    _notify();
  }

  KeyEventResult _onKey(int i, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[i].text.isEmpty &&
        i > 0) {
      _controllers[i - 1].clear();
      _nodes[i - 1].requestFocus();
      _notify();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (i) {
        final focused = _nodes[i].hasFocus;
        final borderColor = widget.hasError
            ? AppColors.error
            : focused
                ? AppColors.primary
                : AppColors.border;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == widget.length - 1 ? 0 : 10),
            child: SizedBox(
              height: widget.boxHeight,
              child: Focus(
                onKeyEvent: (_, event) => _onKey(i, event),
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  autofocus: i == 0,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  cursorColor: AppColors.navy,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTap: () => _controllers[i].selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controllers[i].text.length,
                  ),
                  onChanged: (v) => _onChanged(i, v),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: AppColors.inputFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: borderColor, width: 1.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
