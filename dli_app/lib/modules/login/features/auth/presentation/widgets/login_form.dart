// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../../../core/theme/app_colors.dart';
// import '../../../../../../app/app_routes.dart';
// import '../../login_method.dart';
// import 'dli_logo.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({
//     super.key,
//     this.logoAlignment = Alignment.center,
//     this.logoHeight = 84,
//   });

//   final Alignment logoAlignment;
//   final double logoHeight;

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _input = TextEditingController();

//   LoginMethod _method = LoginMethod.mobile;
//   bool _remember = true;
//   bool _loading = false;

//   bool get _isMobile => _method == LoginMethod.mobile;

//   @override
//   void dispose() {
//     _input.dispose();
//     super.dispose();
//   }

//   void _switchMethod(LoginMethod method) {
//     if (method == _method) return;
//     setState(() {
//       _method = method;
//       _input.clear();
//     });
//     _formKey.currentState?.reset();
//   }

//   String? _validate(String? value) {
//     final text = (value ?? '').trim();
//     if (_isMobile) {
//       if (!RegExp(r'^[6-9]\d{9}$').hasMatch(text)) {
//         return 'Enter a valid 10-digit mobile number';
//       }
//     } else {
//       if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
//         return 'Enter a valid email address';
//       }
//     }
//     return null;
//   }

//   Future<void> _sendOtp() async {
//     if (!_formKey.currentState!.validate()) return;
//     FocusScope.of(context).unfocus();
//     setState(() => _loading = true);

//     final raw = _input.text.trim();
//     final isMobile = _isMobile; // fixed now, in case the tab is switched while sending

//     // TODO: call the backend "send OTP" API here, then open the OTP screen.
//     await Future<void>.delayed(const Duration(milliseconds: 800));

//     if (!mounted) return;
//     setState(() => _loading = false);

//     // One OTP URL for both. Mobile shows the number, email shows the address.
//     // 9876543210 -> "+91 98765 43210" (format used by the OTP screen)
//     final destination =
//         isMobile ? '+91 ${raw.substring(0, 5)} ${raw.substring(5)}' : raw;

//     Navigator.of(context).pushNamed(
//       AppRoutes.verifyOtp,
//       arguments: VerifyOtpArgs(
//         method: isMobile ? OtpMethod.mobile : OtpMethod.email,
//         destination: destination,
//       ),
//     );
//   }

//   void _openRegister() {
//     Navigator.of(context).pushNamed(AppRoutes.register);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final text = Theme.of(context).textTheme;

//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Align(
//             alignment: widget.logoAlignment,
//             child: DliLogo(height: widget.logoHeight, trimmed: true),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'Welcome Back',
//             style: text.headlineMedium?.copyWith(
//               color: AppColors.navy,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Sign in to your account to continue',
//             style: text.bodyLarge?.copyWith(color: AppColors.label),
//           ),
//           const SizedBox(height: 24),

//           _MethodToggle(method: _method, onChanged: _switchMethod),
//           const SizedBox(height: 22),

//           Text(
//             _isMobile ? 'Mobile Number' : 'Email Address',
//             style: text.bodyMedium?.copyWith(
//               color: AppColors.label,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: _input,
//             validator: _validate,
//             keyboardType:
//                 _isMobile ? TextInputType.phone : TextInputType.emailAddress,
//             textInputAction: TextInputAction.done,
//             autofillHints:
//                 _isMobile ? const [AutofillHints.telephoneNumberNational] : const [AutofillHints.email],
//             inputFormatters: _isMobile
//                 ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]
//                 : [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
//             onFieldSubmitted: (_) => _sendOtp(),
//             style: text.bodyLarge?.copyWith(color: AppColors.navy),
//             decoration: InputDecoration(
//               hintText: _isMobile ? '98765 43210' : 'name@company.com',
//               hintStyle: text.bodyLarge?.copyWith(color: AppColors.hint),
//               prefixIcon: Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 12),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       _isMobile ? Icons.phone : Icons.mail_outline,
//                       color: AppColors.navy,
//                       size: 22,
//                     ),
//                     if (_isMobile) ...[
//                       const SizedBox(width: 10),
//                       Text('+91', style: text.bodyLarge?.copyWith(color: AppColors.navy)),
//                     ],
//                   ],
//                 ),
//               ),
//               prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               filled: true,
//               fillColor: Colors.white,
//               enabledBorder: _border(AppColors.border),
//               focusedBorder: _border(AppColors.primary, width: 1.6),
//               errorBorder: _border(AppColors.error),
//               focusedErrorBorder: _border(AppColors.error, width: 1.6),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _isMobile
//                 ? "We'll send a one-time password to your mobile number."
//                 : "We'll send a one-time password to your email address.",
//             style: text.bodySmall?.copyWith(color: AppColors.textMuted),
//           ),
//           const SizedBox(height: 14),

//           Row(
//             children: [
//               SizedBox(
//                 height: 24,
//                 width: 24,
//                 child: Checkbox(
//                   value: _remember,
//                   onChanged: (v) => setState(() => _remember = v ?? false),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text('Remember me', style: text.bodySmall?.copyWith(color: AppColors.navy)),
//               const Spacer(),
//               TextButton(
//                 onPressed: () {
//                   // TODO: account recovery flow.
//                 },
//                 style: TextButton.styleFrom(
//                   foregroundColor: AppColors.primary,
//                   padding: EdgeInsets.zero,
//                   minimumSize: const Size(0, 32),
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//                 child: Text(
//                   _isMobile ? 'Forgot mobile number?' : 'Forgot email address?',
//                   style: text.bodySmall?.copyWith(
//                     color: AppColors.primary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),

//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: FilledButton(
//               onPressed: _loading ? null : _sendOtp,
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
//               ),
//               child: _loading
//                   ? const SizedBox(
//                       height: 22,
//                       width: 22,
//                       child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
//                     )
//                   : const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Send OTP'),
//                         SizedBox(width: 10),
//                         Icon(Icons.arrow_forward, size: 20),
//                       ],
//                     ),
//             ),
//           ),
//           const SizedBox(height: 22),

//           Row(
//             children: [
//               const Expanded(child: Divider(color: AppColors.border)),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Text(
//                   "Don't have an account?",
//                   style: text.bodySmall?.copyWith(color: AppColors.textMuted),
//                 ),
//               ),
//               const Expanded(child: Divider(color: AppColors.border)),
//             ],
//           ),
//           const SizedBox(height: 18),

//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: OutlinedButton.icon(
//               onPressed: _openRegister,
//               icon: const Icon(Icons.person, size: 22),
//               label: const Text('Register'),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 side: const BorderSide(color: AppColors.border, width: 1.4),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//           const SizedBox(height: 28),

//           Center(
//             child: Text(
//               'Secure   •   Transparent   •   Efficient',
//               style: text.bodySmall?.copyWith(color: AppColors.textMuted),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   OutlineInputBorder _border(Color color, {double width = 1.2}) =>
//       OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: BorderSide(color: color, width: width),
//       );
// }

// /// Pill-shaped "Mobile Number | Email Address" switch.
// class _MethodToggle extends StatelessWidget {
//   const _MethodToggle({required this.method, required this.onChanged});

//   final LoginMethod method;
//   final ValueChanged<LoginMethod> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         color: AppColors.tabTrack,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         children: [
//           _segment(context, Icons.phone, 'Mobile Number', LoginMethod.mobile),
//           _segment(context, Icons.mail_outline, 'Email Address', LoginMethod.email),
//         ],
//       ),
//     );
//   }

//   Widget _segment(BuildContext context, IconData icon, String label, LoginMethod value) {
//     final active = method == value;
//     final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
//           color: active ? Colors.white : AppColors.navy,
//           fontWeight: active ? FontWeight.w600 : FontWeight.w500,
//         );

//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(27),
//         onTap: () => onChanged(value),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             color: active ? AppColors.primary : Colors.transparent,
//             borderRadius: BorderRadius.circular(27),
//           ),
//           alignment: Alignment.center,
//           child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 19, color: active ? Colors.white : AppColors.navy),
//                 const SizedBox(width: 8),
//                 Text(label, style: style),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../../../app/app_routes.dart';
import '../../../../../../services/api_service.dart';
import '../../login_method.dart';
import 'dli_logo.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.logoAlignment = Alignment.center,
    this.logoHeight = 84,
  });

  final Alignment logoAlignment;
  final double logoHeight;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _input = TextEditingController();

  LoginMethod _method = LoginMethod.mobile;
  bool _remember = true;
  bool _loading = false;

  bool get _isMobile => _method == LoginMethod.mobile;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _switchMethod(LoginMethod method) {
    if (method == _method) return;

    setState(() {
      _method = method;
      _input.clear();
    });

    _formKey.currentState?.reset();
  }

  String? _validate(String? value) {
    final text = (value ?? '').trim();

    if (_isMobile) {
      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(text)) {
        return 'Enter a valid 10-digit mobile number';
      }
    } else {
      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
        return 'Enter a valid email address';
      }
    }

    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
    });

    final raw = _input.text.trim();
    final isMobile = _isMobile;

    try {
      // Send OTP through Flask backend.
      final result = await ApiService.startLogin(
        identifier: raw,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      final verificationId = result['verificationId']?.toString() ?? '';

      if (verificationId.isEmpty) {
        throw ApiException('Verification ID was not received from server.');
      }

      final destination = isMobile
          ? '+91 ${raw.substring(0, 5)} ${raw.substring(5)}'
          : raw;

      Navigator.of(context).pushNamed(
        AppRoutes.verifyOtp,
        arguments: VerifyOtpArgs(
          method: isMobile ? OtpMethod.mobile : OtpMethod.email,
          destination: destination,
          verificationId: verificationId,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is ApiException
                ? e.message
                : 'Unable to send OTP. Please try again.',
          ),
        ),
      );
    }
  }

  void _openRegister() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: widget.logoAlignment,
            child: DliLogo(
              height: widget.logoHeight,
              trimmed: true,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome Back',
            style: text.headlineMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to your account to continue',
            style: text.bodyLarge?.copyWith(
              color: AppColors.label,
            ),
          ),
          const SizedBox(height: 24),

          _MethodToggle(
            method: _method,
            onChanged: _switchMethod,
          ),
          const SizedBox(height: 22),

          Text(
            _isMobile ? 'Mobile Number' : 'Email Address',
            style: text.bodyMedium?.copyWith(
              color: AppColors.label,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: _input,
            validator: _validate,
            keyboardType:
                _isMobile ? TextInputType.phone : TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: _isMobile
                ? const [AutofillHints.telephoneNumberNational]
                : const [AutofillHints.email],
            inputFormatters: _isMobile
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ]
                : [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'\s'),
                    ),
                  ],
            onFieldSubmitted: (_) => _sendOtp(),
            style: text.bodyLarge?.copyWith(
              color: AppColors.navy,
            ),
            decoration: InputDecoration(
              hintText:
                  _isMobile ? '98765 43210' : 'name@company.com',
              hintStyle: text.bodyLarge?.copyWith(
                color: AppColors.hint,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isMobile
                          ? Icons.phone
                          : Icons.mail_outline,
                      color: AppColors.navy,
                      size: 22,
                    ),
                    if (_isMobile) ...[
                      const SizedBox(width: 10),
                      Text(
                        '+91',
                        style: text.bodyLarge?.copyWith(
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: _border(AppColors.border),
              focusedBorder: _border(
                AppColors.primary,
                width: 1.6,
              ),
              errorBorder: _border(AppColors.error),
              focusedErrorBorder: _border(
                AppColors.error,
                width: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _isMobile
                ? "We'll send a one-time password to your mobile number."
                : "We'll send a one-time password to your email address.",
            style: text.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _remember,
                  onChanged: (v) => setState(
                    () => _remember = v ?? false,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Remember me',
                style: text.bodySmall?.copyWith(
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: account recovery flow.
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _isMobile
                      ? 'Forgot mobile number?'
                      : 'Forgot email address?',
                  style: text.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _loading ? null : _sendOtp,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text('Send OTP'),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              const Expanded(
                child: Divider(
                  color: AppColors.border,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  "Don't have an account?",
                  style: text.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(
                  color: AppColors.border,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _openRegister,
              icon: const Icon(
                Icons.person,
                size: 22,
              ),
              label: const Text('Register'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.border,
                  width: 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          Center(
            child: Text(
              'Secure   •   Transparent   •   Efficient',
              style: text.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(
    Color color, {
    double width = 1.2,
  }) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
}

/// Pill-shaped "Mobile Number | Email Address" switch.
class _MethodToggle extends StatelessWidget {
  const _MethodToggle({
    required this.method,
    required this.onChanged,
  });

  final LoginMethod method;
  final ValueChanged<LoginMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.tabTrack,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _segment(
            context,
            Icons.phone,
            'Mobile Number',
            LoginMethod.mobile,
          ),
          _segment(
            context,
            Icons.mail_outline,
            'Email Address',
            LoginMethod.email,
          ),
        ],
      ),
    );
  }

  Widget _segment(
    BuildContext context,
    IconData icon,
    String label,
    LoginMethod value,
  ) {
    final active = method == value;

    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: active ? Colors.white : AppColors.navy,
          fontWeight:
              active ? FontWeight.w600 : FontWeight.w500,
        );

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(27),
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(27),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: active
                      ? Colors.white
                      : AppColors.navy,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}