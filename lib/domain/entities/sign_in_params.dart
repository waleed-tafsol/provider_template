/// Domain entity for sign-in parameters
class SignInParams {
  final String email;
  final String password;
  final String deviceToken;
  final String deviceType;

  SignInParams({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
  });
}

