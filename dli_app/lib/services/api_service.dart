// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class ApiException implements Exception {
//   ApiException(this.message, {this.statusCode});

//   final String message;
//   final int? statusCode;

//   @override
//   String toString() => message;
// }

// class RegistrationStartResult {
//   const RegistrationStartResult({
//     required this.verificationId,
//     required this.email,
//     required this.phone,
//     required this.message,
//   });

//   final String verificationId;
//   final String email;
//   final String phone;
//   final String message;
// }

// class ApiService {
//   ApiService._();

//   // Flutter Web on the same PC as Flask.
//   // Android emulator: change to http://10.0.2.2:5000/api
//   // Physical phone: change to http://YOUR-PC-LAN-IP:5000/api
//   static const String baseUrl = 'http://127.0.0.1:5000/api';

//   static Future<Map<String, dynamic>> _post(
//     String path,
//     Map<String, dynamic> body,
//   ) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('$baseUrl$path'),
//             headers: const {'Content-Type': 'application/json'},
//             body: jsonEncode(body),
//           )
//           .timeout(const Duration(seconds: 40));

//       Map<String, dynamic> data = {};
//       if (response.body.isNotEmpty) {
//         final decoded = jsonDecode(response.body);
//         if (decoded is Map<String, dynamic>) data = decoded;
//       }

//       if (response.statusCode < 200 || response.statusCode >= 300) {
//         throw ApiException(
//           data['message']?.toString() ??
//               'Server error (${response.statusCode}).',
//           statusCode: response.statusCode,
//         );
//       }

//       return data;
//     } catch (e) {
//       if (e is ApiException) rethrow;
//       throw ApiException(
//         'Unable to connect to the Flask server. Make sure the backend is running on port 5000.',
//       );
//     }
//   }

//   static Future<RegistrationStartResult> startRegistration({
//     required String email,
//     required String phone,
//     required bool termsAccepted,
//   }) async {
//     final data = await _post('/register/start', {
//       'email': email,
//       'phone': phone,
//       'termsAccepted': termsAccepted,
//     });

//     return RegistrationStartResult(
//       verificationId: data['verificationId'].toString(),
//       email: data['email'].toString(),
//       phone: data['phone'].toString(),
//       message: data['message']?.toString() ?? 'OTP sent successfully.',
//     );
//   }

//   static Future<String> verifyRegistration({
//     required String verificationId,
//     required String emailOtp,
//     required String phoneOtp,
//   }) async {
//     final data = await _post('/register/verify', {
//       'verificationId': verificationId,
//       'emailOtp': emailOtp,
//       'phoneOtp': phoneOtp,
//     });

//     return data['message']?.toString() ?? 'Verification successful.';
//   }

//   static Future<String> resendRegistrationOtp({
//     required String verificationId,
//   }) async {
//     final data = await _post('/register/resend', {
//       'verificationId': verificationId,
//     });

//     return data['message']?.toString() ?? 'OTP resent successfully.';
//   }
// }




import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class RegistrationStartResult {
  const RegistrationStartResult({
    required this.verificationId,
    required this.email,
    required this.phone,
    required this.message,
  });

  final String verificationId;
  final String email;
  final String phone;
  final String message;
}

class ApiService {
  ApiService._();

  // Flutter Web on the same PC as Flask.
  // Android emulator: change to http://10.0.2.2:5000/api
  // Physical phone: change to http://YOUR-PC-LAN-IP:5000/api
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));

      Map<String, dynamic> data = {};

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          data['message']?.toString() ??
              'Server error (${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }

      return data;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        'Unable to connect to the Flask server. '
        'Make sure the backend is running on port 5000.',
      );
    }
  }

  // ============================================================
  // REGISTRATION APIs
  // ============================================================

  static Future<RegistrationStartResult> startRegistration({
    required String email,
    required String phone,
    required bool termsAccepted,
  }) async {
    final data = await _post('/register/start', {
      'email': email,
      'phone': phone,
      'termsAccepted': termsAccepted,
    });

    return RegistrationStartResult(
      verificationId: data['verificationId'].toString(),
      email: data['email'].toString(),
      phone: data['phone'].toString(),
      message: data['message']?.toString() ?? 'OTP sent successfully.',
    );
  }

  static Future<String> verifyRegistration({
    required String verificationId,
    required String emailOtp,
    required String phoneOtp,
  }) async {
    final data = await _post('/register/verify', {
      'verificationId': verificationId,
      'emailOtp': emailOtp,
      'phoneOtp': phoneOtp,
    });

    return data['message']?.toString() ?? 'Verification successful.';
  }

  static Future<String> resendRegistrationOtp({
    required String verificationId,
  }) async {
    final data = await _post('/register/resend', {
      'verificationId': verificationId,
    });

    return data['message']?.toString() ?? 'OTP resent successfully.';
  }

  // ============================================================
  // LOGIN APIs
  // ============================================================

  // Send OTP to Email or WhatsApp
  static Future<Map<String, dynamic>> startLogin({
    required String identifier,
  }) async {
    return await _post('/login/start', {
      'identifier': identifier,
    });
  }

  // Verify Login OTP
  static Future<String> verifyLogin({
    required String verificationId,
    required String otp,
  }) async {
    final data = await _post('/login/verify', {
      'verificationId': verificationId,
      'otp': otp,
    });

    return data['message']?.toString() ?? 'Login successful.';
  }

  // Resend Login OTP
  static Future<String> resendLoginOtp({
    required String verificationId,
  }) async {
    final data = await _post('/login/resend', {
      'verificationId': verificationId,
    });

    return data['message']?.toString() ?? 'OTP resent successfully.';
  }
}