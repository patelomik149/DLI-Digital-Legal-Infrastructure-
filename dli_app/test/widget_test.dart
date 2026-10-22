// import 'package:flutter_test/flutter_test.dart';

// import 'package:dli_app/app/app_routes.dart';

// void main() {
//   test('route names are unique', () {
//     final names = <String>{
//       AppRoutes.loader,
//       AppRoutes.login,
//       AppRoutes.register,
//       AppRoutes.verifyOtp,
//       AppRoutes.home,
//     };
//     expect(names.length, 6);
//   });

//   test('mobile and email share one OTP route', () {
//     const mobile = VerifyOtpArgs(
//       method: OtpMethod.mobile,
//       destination: '+91 98765 43210',
//     );
//     const email = VerifyOtpArgs(
//       method: OtpMethod.email,
//       destination: 'you@example.com',
//     );

//     expect(mobile.method, isNot(email.method));
//     expect(AppRoutes.verifyOtp, '/auth/verify-otp');
//   });

//   test('loader continues to the login screen', () {
//     expect(AppRoutes.afterLoader, AppRoutes.login);
//   });
// }




import 'package:flutter_test/flutter_test.dart';

import 'package:dli_app/app/app_routes.dart';

void main() {
  test('route names are unique', () {
    final names = <String>{
      AppRoutes.loader,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.verifyOtp,
      AppRoutes.registerOtp,
      AppRoutes.home,
    };

    expect(names.length, 6);
  });

  test('mobile and email share one OTP route', () {
    const mobile = VerifyOtpArgs(
      method: OtpMethod.mobile,
      destination: '+91 98765 43210',
      verificationId: 'test-verification-id',
    );

    const email = VerifyOtpArgs(
      method: OtpMethod.email,
      destination: 'you@example.com',
      verificationId: 'test-verification-id',
    );

    expect(mobile.method, isNot(email.method));
    expect(AppRoutes.verifyOtp, '/auth/verify-otp');
  });

  test('loader continues to the login screen', () {
    expect(AppRoutes.afterLoader, AppRoutes.login);
  });
}
