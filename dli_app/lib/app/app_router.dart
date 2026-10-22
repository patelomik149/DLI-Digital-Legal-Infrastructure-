import 'package:flutter/material.dart';

import '../modules/login/core/theme/app_theme.dart' as login_theme;
import '../modules/login/features/auth/presentation/login_page.dart';
import '../dashboard/dli_dashboard.dart';
import '../modules/otp/core/theme/app_theme.dart' as otp_theme;
import '../modules/otp/features/auth/presentation/verify_email_otp_screen.dart';
import '../modules/otp/features/auth/presentation/verify_otp_screen.dart';
import '../modules/otp/features/auth/presentation/verify_registration_otp_screen.dart';
import '../modules/register/pages/loader_page.dart';
import '../modules/register/pages/register_page.dart';
import 'app_routes.dart';

/// Central route table.
///
/// The login, OTP and register/loader screens were designed with three
/// different themes (fonts / palettes). To keep every screen looking exactly
/// as designed, each page is wrapped in the theme of the module it came from.
class AppRouter {
  AppRouter._();

  // Theme of the original register + loader project.
  static final ThemeData _registerTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF8FBFF),
  );

  // Themes of the login and OTP projects (created once, on first use).
  static final ThemeData _loginTheme = login_theme.AppTheme.light;
  static final ThemeData _otpTheme = otp_theme.AppTheme.light;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (_normalize(settings.name)) {
      case AppRoutes.loader:
        return _route(settings, _registerTheme, const LoaderPage());

      case AppRoutes.login:
        return _route(settings, _loginTheme, const LoginPage());

      case AppRoutes.register:
        return _route(settings, _registerTheme, const RegisterPage());

      case AppRoutes.registerOtp:
        if (args is! RegisterOtpArgs) return _fallbackToLogin();
        return _route(
          settings,
          _otpTheme,
          VerifyRegistrationOtpScreen(
            verificationId: args.verificationId,
            email: args.email,
            phone: args.phone,
          ),
        );

      case AppRoutes.verifyOtp:
        // Opened directly (e.g. browser refresh) without a number/email -> login.
        if (args is! VerifyOtpArgs) return _fallbackToLogin();

        // Same URL for both; the login choice decides what is shown.
        final Widget page = args.method == OtpMethod.mobile
            ? VerifyOtpScreen(destination: args.destination, verificationId: args.verificationId,)
            : VerifyEmailOtpScreen(email: args.destination, verificationId: args.verificationId,);
        return _route(settings, _otpTheme, page);

      case AppRoutes.home:
        return _route(settings, _loginTheme, const DliDashboard());

      default:
        return _fallbackToLogin();
    }
  }

  /// "/auth/login/?x=1" -> "/auth/login"  (web URLs may carry both)
  static String _normalize(String? name) {
    var path = Uri.tryParse(name ?? '/')?.path ?? '/';
    if (path.isEmpty) path = '/';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  static Route<dynamic> _fallbackToLogin() => _route(
        const RouteSettings(name: AppRoutes.login),
        _loginTheme,
        const LoginPage(),
      );

  static MaterialPageRoute<dynamic> _route(
    RouteSettings settings,
    ThemeData theme,
    Widget page,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => Theme(data: theme, child: page),
    );
  }
}
