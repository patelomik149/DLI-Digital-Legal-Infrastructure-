import 'package:flutter/material.dart';

import '../../../../../app/app_routes.dart';
import '../../../../../services/api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/dli_page_title.dart';
import 'widgets/dli_logo.dart';
import 'widgets/footer_tagline.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/resend_timer.dart';
import 'widgets/security_panel.dart';
import 'widgets/wave_painter.dart';

class VerifyRegistrationOtpScreen extends StatefulWidget {
  const VerifyRegistrationOtpScreen({
    super.key,
    required this.verificationId,
    required this.email,
    required this.phone,
  });

  final String verificationId;
  final String email;
  final String phone;

  @override
  State<VerifyRegistrationOtpScreen> createState() =>
      _VerifyRegistrationOtpScreenState();
}

class _VerifyRegistrationOtpScreenState
    extends State<VerifyRegistrationOtpScreen> {
  // ---- Easy settings ----
  static const Color _mobileBg = Color(0xFFFFFFFF);
  static const bool _showWave = false;
  static const double _webCardHeight = 820;

  String _emailOtp = '';
  String _phoneOtp = '';
  bool _loading = false;
  String? _error;
  String? _success;

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _error = null;
      _success = null;
    });

    if (!RegExp(r'^\d{6}$').hasMatch(_emailOtp)) {
      setState(() => _error = 'Please enter the 6-digit email OTP.');
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(_phoneOtp)) {
      setState(() => _error = 'Please enter the 6-digit WhatsApp OTP.');
      return;
    }

    setState(() => _loading = true);

    try {
      final message = await ApiService.verifyRegistration(
        verificationId: widget.verificationId,
        emailOtp: _emailOtp,
        phoneOtp: _phoneOtp,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _success = message;
      });

      await Future<void>.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Verification failed. Please try again.';
      });
    }
  }

  Future<void> _resend() async {
    setState(() {
      _error = null;
      _success = null;
      _loading = true;
    });

    try {
      final message = await ApiService.resendRegistrationOtp(
        verificationId: widget.verificationId,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _success = message;
        _emailOtp = '';
        _phoneOtp = '';
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not resend OTP. Please try again.';
      });
    }
  }

  void _back() {
    if (!_loading) {
      Navigator.maybePop(context);
    }
  }

  Widget _statusMessage() {
    if (_error != null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.error.withValues(alpha: .25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_success != null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFFAF1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.green.withValues(alpha: .25),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                _success!,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _destinationCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
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
            child: Icon(
              icon,
              color: AppColors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SHARED FORM
  // ============================================================

  Widget _form({required bool wide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment:
              wide ? Alignment.centerLeft : Alignment.center,
          child: DliLogo(
            width: wide ? 240 : 220,
          ),
        ),

        SizedBox(
          height: wide ? 4 : 8,
        ),

        Text(
          'Verify Registration',
          style: TextStyle(
            fontSize: wide ? 32 : 28,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Enter both 6-digit OTPs sent to your email and WhatsApp number.',
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.textBody,
          ),
        ),

        const SizedBox(height: 18),

        _statusMessage(),

        _destinationCard(
          icon: Icons.mail_rounded,
          label: 'Email OTP sent to',
          value: widget.email,
        ),

        const SizedBox(height: 12),

        const Text(
          'Email OTP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 9),

        OtpInputField(
          boxHeight: wide ? 64 : 56,
          hasError: _error != null,
          onChanged: (value) {
            setState(() {
              _emailOtp = value;
              _error = null;
            });
          },
        ),

        const SizedBox(height: 20),

        _destinationCard(
          icon: Icons.phone_rounded,
          label: 'WhatsApp OTP sent to',
          value: '+${widget.phone}',
        ),

        const SizedBox(height: 12),

        const Text(
          'WhatsApp OTP',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 9),

        OtpInputField(
          boxHeight: wide ? 64 : 56,
          hasError: _error != null,
          onChanged: (value) {
            setState(() {
              _phoneOtp = value;
              _error = null;
            });
          },
        ),

        const SizedBox(height: 12),

        // Resend
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _loading ? null : _resend,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 30),
            ),
            child: const Text(
              'Resend Both OTPs',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

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
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Text('Verify Both OTPs'),
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
              padding: EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: ResendTimer(seconds: 60),
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

        // Back button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: _loading
                ? null
                : () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 20,
            ),
            label: const Text(
              'Back to Registration',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color:
                    AppColors.primaryLight.withValues(alpha: .6),
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

        // Extra bottom space for desktop scrolling
        if (wide)
          const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DliPageTitle(
      title: 'DLI | VERIFY REGISTRATION',
      child: LayoutBuilder(
        builder: (context, c) {
          return Responsive.isDesktop(c.maxWidth)
              ? _buildWeb()
              : _buildMobile();
        },
      ),
    );
  }

  // ============================================================
  // MOBILE / TABLET
  // ============================================================

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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _back,
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

  // ============================================================
  // WEB / DESKTOP
  // ============================================================

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
              height: _webCardHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(
                        alpha: .10,
                      ),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,

                // IMPORTANT:
                // Right panel stays fixed.
                // Only left side scrolls.
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    // ==================================================
                    // LEFT FORM - SCROLLABLE
                    // ==================================================
                    Expanded(
                      flex: 11,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          physics:
                              const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 20,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(
                                maxWidth: 520,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .stretch,
                                children: [
                                  _form(wide: true),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // Footer is INSIDE
                                  // the scrollable area.
                                  const FooterTagline(),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ==================================================
                    // RIGHT SECURITY PANEL - FIXED
                    // ==================================================
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