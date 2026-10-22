
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import '../../../app/app_routes.dart';
import '../widgets/dli_page_title.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mobileController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;

  // ============================================================
  // DLI COLORS
  // ============================================================

  static const Color navy = Color(0xFF092B52);
  static const Color darkNavy = Color(0xFF08284A);
  static const Color blue = Color(0xFF1478E8);
  static const Color lightBlue = Color(0xFFEAF5FF);
  static const Color borderColor = Color(0xFFD9E3ED);
  static const Color textGrey = Color(0xFF6C7D90);
  static const Color hintGrey = Color(0xFF9AAABD);

  // ============================================================
  // MOBILE NUMBER HELPERS
  // ============================================================

  String _nationalDigits(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length == 12 && digits.startsWith('91')) {
      digits = digits.substring(2);
    } else if (digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    return digits.length == 10 ? digits : '';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // REGISTER
  // ============================================================
  void _showTopSuccessPopup(BuildContext context, String message) {
  final overlay = Overlay.of(context, rootOverlay: true);

  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 24,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 21,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please agree to the Terms & Conditions.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.startRegistration(
        email: _emailController.text.trim(),
        phone: _nationalDigits(_mobileController.text),
        termsAccepted: _agreeToTerms,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      _showTopSuccessPopup(context, result.message);

      Navigator.of(context).pushNamed(
        AppRoutes.registerOtp,
        arguments: RegisterOtpArgs(
          verificationId: result.verificationId,
          email: result.email,
          phone: result.phone,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          content: Text(e.message),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  void _openLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return DliPageTitle(
      title: 'DLI | REGISTER',
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FAFE),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              if (constraints.maxWidth < 700) {
                return _buildMobileLayout();
              }

              return _buildWebLayout();
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // WEB LAYOUT
  // ============================================================

  Widget _buildWebLayout() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 35,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1180,
          ),
          child: SizedBox(
            height: 740,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  // =================================================
                  // LEFT - REGISTER SIDE
                  //
                  // ONLY THIS SIDE SCROLLS
                  // =================================================

                  Expanded(
                    flex: 5,
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        physics:
                            const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        child: _buildFormPanel(
                          isMobile: false,
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // RIGHT - INFORMATION PANEL
                  //
                  // THIS SIDE REMAINS FIXED
                  // =================================================

                  Expanded(
                    flex: 5,
                    child: _buildRightPanel(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE LAYOUT
  // ============================================================

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 480,
          ),
          child: _buildFormPanel(
            isMobile: true,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FORM PANEL
  // ============================================================

  Widget _buildFormPanel({
    required bool isMobile,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 22 : 55,
        isMobile ? 18 : 38,
        isMobile ? 22 : 55,
        isMobile ? 22 : 35,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ======================================================
            // DLI LOGO
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/primary_logo.png',
                width: isMobile ? 160 : 230,
                height: isMobile ? 80 : 100,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),

            SizedBox(
              height: isMobile ? 24 : 20,
            ),

            // ======================================================
            // TITLE
            // ======================================================

            Text(
              'Create Account',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 27 : 32,
                fontWeight: FontWeight.w700,
                color: darkNavy,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Fill in your details to get started',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 12.5 : 14,
                fontWeight: FontWeight.w400,
                color: textGrey,
              ),
            ),

            SizedBox(
              height: isMobile ? 28 : 40,
            ),

            // ======================================================
            // MOBILE NUMBER
            // ======================================================

            _buildInputField(
              controller: _mobileController,
              label: 'Mobile Number',
              hint: '+91 98765 43210',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isMobile: isMobile,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Mobile number is required';
                }

                if (_nationalDigits(value).isEmpty) {
                  return 'Enter a valid 10-digit mobile number';
                }

                return null;
              },
            ),

            SizedBox(
              height: isMobile ? 17 : 20,
            ),

            // ======================================================
            // EMAIL
            // ======================================================

            _buildInputField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType:
                  TextInputType.emailAddress,
              isMobile: isMobile,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Email address is required';
                }

                final emailRegex = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                );

                if (!emailRegex.hasMatch(
                  value.trim(),
                )) {
                  return 'Enter a valid email address';
                }

                return null;
              },
            ),

            SizedBox(
              height: isMobile ? 16 : 18,
            ),

            // ======================================================
            // TERMS & CONDITIONS
            // ======================================================

            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                setState(() {
                  _agreeToTerms = !_agreeToTerms;
                });
              },
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 23,
                    height: 23,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms =
                              value ?? false;
                        });
                      },
                      activeColor: blue,
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFB9C9D8),
                        width: 1,
                      ),
                      materialTapTargetSize:
                          MaterialTapTargetSize
                              .shrinkWrap,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize:
                              isMobile ? 10.5 : 11.5,
                          color: textGrey,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'I agree to the ',
                          ),
                          TextSpan(
                            text:
                                'Terms & Conditions',
                            style:
                                GoogleFonts.poppins(
                              fontSize: isMobile
                                  ? 10.5
                                  : 11.5,
                              color: blue,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: isMobile ? 22 : 25,
            ),

            // ======================================================
            // REGISTER BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: isMobile ? 50 : 56,
              child: ElevatedButton(
                onPressed:
                    _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF8BBDF2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style:
                                GoogleFonts.poppins(
                              fontSize: isMobile
                                  ? 13.5
                                  : 15,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.arrow_forward,
                            size: 19,
                          ),
                        ],
                      ),
              ),
            ),

            SizedBox(
              height: isMobile ? 20 : 22,
            ),

            // ======================================================
            // LOGIN DIVIDER
            // ======================================================

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color:
                        const Color(0xFFE2E8EF),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    'Already have an account?',
                    style: GoogleFonts.poppins(
                      fontSize:
                          isMobile ? 9.5 : 10.5,
                      color:
                          const Color(0xFF78899A),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 1,
                    color:
                        const Color(0xFFE2E8EF),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ======================================================
            // LOGIN BUTTON
            // ======================================================

            SizedBox(
              width: double.infinity,
              height: isMobile ? 45 : 48,
              child: OutlinedButton(
                onPressed: _openLogin,
                style: OutlinedButton.styleFrom(
                  foregroundColor: blue,
                  side: const BorderSide(
                    color: blue,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize:
                            isMobile ? 12.5 : 13.5,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 27),

            // ======================================================
            // BOTTOM TEXT
            //
            // IMPORTANT:
            // This is INSIDE the form's scroll area.
            // So on Web it scrolls with the form.
            // ======================================================

            Center(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  _bottomText(
                    'Secure',
                    isMobile,
                  ),
                  _bottomDot(),
                  _bottomText(
                    'Transparent',
                    isMobile,
                  ),
                  _bottomDot(),
                  _bottomText(
                    'Efficient',
                    isMobile,
                  ),
                ],
              ),
            ),

            // Extra bottom space for scrolling
            if (!isMobile)
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required bool isMobile,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: blue,
      style: GoogleFonts.poppins(
        fontSize: isMobile ? 13.5 : 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF34495E),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior:
            FloatingLabelBehavior.always,

        labelStyle: GoogleFonts.poppins(
          fontSize: isMobile ? 11.5 : 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF52677D),
        ),

        floatingLabelStyle:
            GoogleFonts.poppins(
          fontSize: isMobile ? 11.5 : 13,
          fontWeight: FontWeight.w500,
          color: blue,
        ),

        hintStyle: GoogleFonts.poppins(
          fontSize: isMobile ? 12 : 13,
          fontWeight: FontWeight.w400,
          color: hintGrey,
        ),

        prefixIcon: Icon(
          icon,
          size: isMobile ? 20 : 22,
          color: navy,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 15 : 18,
          vertical: isMobile ? 18 : 22,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: blue,
            width: 1.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.4,
          ),
        ),

        errorStyle: GoogleFonts.poppins(
          fontSize: 10.5,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  // ============================================================
  // RIGHT INFORMATION PANEL
  // ============================================================

  Widget _buildRightPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: lightBlue,
      ),
      child: Stack(
        children: [
          // ------------------------------------------------------
          // TOP DECORATION
          // ------------------------------------------------------

          Positioned(
            top: -100,
            right: -90,
            child: Container(
              width: 300,
              height: 230,
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.45),
                borderRadius:
                    const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(150),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------
          // BOTTOM DECORATION
          // ------------------------------------------------------

          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 320,
              height: 210,
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.48),
                borderRadius:
                    const BorderRadius.only(
                  topRight:
                      Radius.circular(170),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------
          // INFORMATION
          // ------------------------------------------------------

          Padding(
            padding: const EdgeInsets.fromLTRB(
              55,
              70,
              40,
              35,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Legal\nJourney Starts\nHere',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    height: 1.17,
                    fontWeight:
                        FontWeight.w700,
                    color: darkNavy,
                  ),
                ),

                const SizedBox(height: 17),

                Text(
                  'Register today and experience\na smarter, faster and more\ntransparent way to manage\nlegal processes.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.65,
                    fontWeight:
                        FontWeight.w400,
                    color: textGrey,
                  ),
                ),

                const Spacer(),

                Center(
                  child:
                      _buildLegalIllustration(),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEGAL ILLUSTRATION
  // ============================================================

  Widget _buildLegalIllustration() {
    return SizedBox(
      width: 330,
      height: 270,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 42,
            top: 100,
            child: Container(
              width: 225,
              height: 1,
              color:
                  const Color(0xFFA8CDED),
            ),
          ),

          Positioned(
            left: 140,
            top: 60,
            child: Container(
              width: 1,
              height: 125,
              color:
                  const Color(0xFFA8CDED),
            ),
          ),

          // LAPTOP SCREEN

          Positioned(
            left: 58,
            top: 48,
            child: Container(
              width: 215,
              height: 142,
              padding:
                  const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF173F6A),
                borderRadius:
                    BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(0xFF5B83A8)
                            .withOpacity(0.30),
                    blurRadius: 18,
                    offset:
                        const Offset(0, 9),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 18,
                      child: Container(
                        width: 110,
                        height: 8,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFDDEBFA,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(4),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 34,
                      left: 18,
                      child: Container(
                        width: 140,
                        height: 7,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFE7F0F8,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(4),
                        ),
                      ),
                    ),

                    const Center(
                      child: Icon(
                        Icons.verified_user,
                        size: 67,
                        color: blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // LAPTOP BASE

          Positioned(
            left: 35,
            bottom: 22,
            child: Container(
              width: 260,
              height: 18,
              decoration: BoxDecoration(
                color:
                    const Color(0xFF214B75),
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ),

          // USER ICON

          Positioned(
            left: 5,
            top: 87,
            child: _illustrationIcon(
              Icons.person_outline,
            ),
          ),

          // SHIELD ICON

          Positioned(
            right: 0,
            top: 40,
            child: _illustrationIcon(
              Icons.shield_outlined,
            ),
          ),

          // DOCUMENT ICON

          Positioned(
            right: 8,
            bottom: 72,
            child: _illustrationIcon(
              Icons.description_outlined,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ILLUSTRATION ICON
  // ============================================================

  Widget _illustrationIcon(
    IconData icon,
  ) {
    return Container(
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color:
              const Color(0xFFB7D8F5),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: blue,
        size: 24,
      ),
    );
  }

  // ============================================================
  // BOTTOM TEXT
  // ============================================================

  Widget _bottomText(
    String text,
    bool isMobile,
  ) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: isMobile ? 8.5 : 9.5,
        fontWeight: FontWeight.w400,
        color:
            const Color(0xFF78899A),
      ),
    );
  }

  // ============================================================
  // BOTTOM DOT
  // ============================================================

  Widget _bottomDot() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      child: Text(
        '•',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight:
              FontWeight.w600,
          color: blue,
        ),
      ),
    );
  }
}