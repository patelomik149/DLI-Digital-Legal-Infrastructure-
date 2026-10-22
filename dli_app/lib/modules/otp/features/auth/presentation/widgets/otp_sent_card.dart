// import 'package:flutter/material.dart';

// import '../../../../core/theme/app_colors.dart';

// /// "OTP sent to +91 ...  Change" card. Tap Change to edit the number inline.
// class OtpSentCard extends StatefulWidget {
//   const OtpSentCard({super.key, required this.destination, this.onChanged});

//   final String destination;
//   final ValueChanged<String>? onChanged; // called after a valid save

//   @override
//   State<OtpSentCard> createState() => _OtpSentCardState();
// }

// class _OtpSentCardState extends State<OtpSentCard> {
//   late final TextEditingController _controller;
//   late String _value;
//   bool _editing = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _value = widget.destination;
//     _controller = TextEditingController(text: _value);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _startEdit() => setState(() {
//         _editing = true;
//         _error = null;
//         _controller.text = _value;
//         _controller.selection =
//             TextSelection(baseOffset: 0, extentOffset: _value.length);
//       });

//   void _save() {
//     final v = _controller.text.trim();
//     final isPhone = RegExp(r'^\+?[0-9 ]{10,15}$').hasMatch(v);
//     final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);

//     if (!isPhone && !isEmail) {
//       setState(() => _error = 'Enter a valid phone number or email');
//       return;
//     }
//     setState(() {
//       _value = v;
//       _editing = false;
//       _error = null;
//     });
//     widget.onChanged?.call(v);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: AppColors.card,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: AppColors.primary,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.smartphone_rounded,
//                 color: AppColors.white, size: 20),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('OTP sent to',
//                     style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
//                 const SizedBox(height: 2),
//                 if (_editing)
//                   TextField(
//                     controller: _controller,
//                     autofocus: true,
//                     keyboardType: TextInputType.emailAddress,
//                     onSubmitted: (_) => _save(),
//                     cursorColor: AppColors.navy,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.navy,
//                     ),
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(vertical: 6),
//                       hintText: 'Phone number or email',
//                       border: UnderlineInputBorder(
//                         borderSide: BorderSide(color: AppColors.primary),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide:
//                             BorderSide(color: AppColors.primary, width: 1.5),
//                       ),
//                     ),
//                   )
//                 else
//                   Text(
//                     _value,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.navy,
//                     ),
//                   ),
//                 if (_error != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(_error!,
//                         style: const TextStyle(
//                             fontSize: 12, color: AppColors.error)),
//                   ),
//               ],
//             ),
//           ),
//           TextButton(
//   onPressed: _save,
//   style: TextButton.styleFrom(
//     foregroundColor: AppColors.primary,
//     padding: EdgeInsets.zero,
//     minimumSize: const Size(48, 32),
//   ),
//   child: const Text('Update',
//       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
// ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// "OTP sent to" card with an always-editable phone number field.
class OtpSentCard extends StatefulWidget {
  const OtpSentCard({super.key, required this.destination, this.onChanged});

  final String destination;
  final ValueChanged<String>? onChanged; // called after a valid update

  @override
  State<OtpSentCard> createState() => _OtpSentCardState();
}

class _OtpSentCardState extends State<OtpSentCard> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final v = _controller.text.trim();
    final isPhone = RegExp(r'^\+?[0-9 ]{10,15}$').hasMatch(v);

    if (!isPhone) {
      setState(() => _error = 'Enter a valid phone number');
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
            child: const Icon(Icons.smartphone_rounded,
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
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                  ],
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
                    hintText: 'Enter phone number',
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
                    child: Text(
                      _error!,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.error),
                    ),
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
            child: const Text(
              'Update',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}