
import 'package:flutter/material.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/dli_page_title.dart';
import 'widgets/dli_logo.dart';
import 'widgets/footer_tagline.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/otp_sent_card.dart';
import 'widgets/resend_timer.dart';
import 'widgets/security_panel.dart';
import 'widgets/wave_painter.dart';

/// Verify OTP (phone) screen. Mobile below 900px, split card layout on web.
class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({
    super.key,
    required this.destination,
    required this.verificationId,
  });

  final String destination;

  /// Verification ID returned by Flask login API.
  final String verificationId;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // ---- Easy settings ----
  static const Color _mobileBg = Color(0xFFFFFFFF);
  static const bool _showWave = false;

  late String _phone = widget.destination;

  String _otp = '';
  bool _loading = false;
  bool _error = false;
  String _errorMessage = 'Please enter the 6-digit code';

  Future<void> _verify() async {
    // Prevent multiple API calls.
    if (_loading) return;

    // OTP must contain exactly 6 digits.
    if (_otp.length != 6) {
      setState(() {
        _error = true;
        _errorMessage = 'Please enter the 6-digit code';
      });
      return;
    }

    setState(() {
      _error = false;
      _loading = true;
    });

    try {
      // ---------------------------------------------------------
      // Call Flask backend:
      // POST /api/login/verify
      //
      // Sends:
      // {
      //   "verificationId": "...",
      //   "otp": "123456"
      // }
      // ---------------------------------------------------------
      final message = await ApiService.verifyLogin(
        verificationId: widget.verificationId,
        otp: _otp,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

      // OTP verified successfully.
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = true;
        _errorMessage = e is ApiException
            ? e.message
            : 'OTP verification failed. Please try again.';
      });
    }
  }

  void _backToLogin() => Navigator.maybePop(context);

  @override
  Widget build(BuildContext context) {
    return DliPageTitle(
      title: 'DLI | VERIFY OTP',
      child: LayoutBuilder(
        builder: (context, c) =>
            Responsive.isDesktop(c.maxWidth) ? _buildWeb() : _buildMobile(),
      ),
    );
  }

  // ---------------- Shared form ----------------

  Widget _form({required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: wide ? Alignment.centerLeft : Alignment.center,
          child: DliLogo(width: wide ? 240 : 220),
        ),

        SizedBox(height: wide ? 4 : 8),

        Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: wide ? 32 : 28,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "We've sent a 6-digit verification code\nto your mobile number or email.",
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.textBody,
          ),
        ),

        const SizedBox(height: 22),

        OtpSentCard(
          destination: _phone,
          onChanged: (newValue) {
            setState(() => _phone = newValue);

            // Currently we do not send a new OTP here.
            // OTP resend should be handled by the resend API.
          },
        ),

        const SizedBox(height: 22),

        OtpInputField(
          boxHeight: wide ? 64 : 56,
          hasError: _error,
          onChanged: (v) => setState(() {
            _otp = v;
            _error = false;
            _errorMessage = 'Please enter the 6-digit code';
          }),
          onCompleted: (_) => _verify(),
        ),

        if (_error)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.error,
              ),
            ),
          ),

        const SizedBox(height: 26),

        // Verify button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _loading ? null : _verify,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor:
                  AppColors.primary.withValues(alpha: .6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Verify OTP'),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 16),

        // Resend timer
        Row(
          children: const [
            Expanded(
              child: Divider(
                color: AppColors.divider,
                height: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: ResendTimer(seconds: 45),
            ),
            Expanded(
              child: Divider(
                color: AppColors.divider,
                height: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Back to Login
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _backToLogin,
            icon: const Icon(
              Icons.person_rounded,
              size: 20,
            ),
            label: const Text('Back to Login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primaryLight.withValues(alpha: .6),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Mobile / tablet ----------------

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: _mobileBg,
      body: Stack(
        children: [
          if (_showWave)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150,
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    8,
                    24,
                    80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _backToLogin,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.primary,
                        ),
                      ),

                      _form(wide: false),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 14),
                child: FooterTagline(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Web / desktop ----------------

  Widget _buildWeb() {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1180,
            ),
            child: SizedBox(
              height: 740,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .10),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =====================================================
                    // LEFT SIDE
                    // =====================================================
                    Expanded(
                      flex: 11,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 20,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 520,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  _form(wide: true),

                                  const SizedBox(height: 20),

                                  const FooterTagline(),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // =====================================================
                    // RIGHT SIDE
                    // =====================================================
                    const Expanded(
                      flex: 9,
                      child: SecurityPanel(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}