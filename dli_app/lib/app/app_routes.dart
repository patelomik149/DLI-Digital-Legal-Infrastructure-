class AppRoutes {
  AppRoutes._();

  static const loader = '/';
  static const login = '/auth/login';
  static const register = '/auth/register';

  /// One OTP screen for both mobile and email (see [VerifyOtpArgs.method]).
  static const verifyOtp = '/auth/verify-otp';
  static const registerOtp = '/auth/register/verify-otp';
  static const home = '/home';

  /// The screen shown after the start-up loader finishes.
  /// Change this one line to `register` to start on the Register page instead.
  static const afterLoader = login;
}

/// What the user entered on the login screen.
enum OtpMethod { mobile, email }

/// Arguments for [AppRoutes.verifyOtp].
class VerifyOtpArgs {
  const VerifyOtpArgs({
    required this.method,
    required this.destination,
    required this.verificationId,
  });

  final OtpMethod method;

  /// Mobile: "+91 98765 43210"   |   Email: "you@example.com"
  final String destination;

  /// Verification ID returned by the Flask login API.
  final String verificationId;
}

/// Arguments for the registration email + WhatsApp OTP screen.
class RegisterOtpArgs {
  const RegisterOtpArgs({
    required this.verificationId,
    required this.email,
    required this.phone,
  });

  final String verificationId;
  final String email;
  final String phone;
}
