import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// "OTP sent to you@example.com" card with an always-editable email field.
class EmailSentCard extends StatefulWidget {
  const EmailSentCard({super.key, required this.email, this.onChanged});

  final String email;
  final ValueChanged<String>? onChanged; // called after a valid update

  @override
  State<EmailSentCard> createState() => _EmailSentCardState();
}

class _EmailSentCardState extends State<EmailSentCard> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final v = _controller.text.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    if (!ok) {
      setState(() => _error = 'Enter a valid email address');
      return;
    }
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    widget.onChanged?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.mail_rounded,
                color: AppColors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('OTP sent to',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _save(),
                  cursorColor: AppColors.navy,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.navy,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    hintText: 'Enter email address',
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_error!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.error)),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: _save,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 32),
            ),
            // Reference design says "Change". Rename here if you prefer.
            child: const Text('Update',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
