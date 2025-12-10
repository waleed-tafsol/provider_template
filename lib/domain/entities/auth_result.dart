import 'user.dart';

/// Domain entity representing authentication result
class AuthResult {
  final bool isSuccess;
  final String? message;
  final User? user;

  AuthResult({
    required this.isSuccess,
    this.message,
    this.user,
  });

  factory AuthResult.success({required User user, String? message}) {
    return AuthResult(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.failure({required String message}) {
    return AuthResult(
      isSuccess: false,
      message: message,
    );
  }
}

