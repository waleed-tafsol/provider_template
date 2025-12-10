import '../entities/auth_result.dart';
import '../entities/sign_in_params.dart';

/// Repository interface - Domain layer (no implementation details)
abstract class AuthRepository {
  Future<AuthResult> signIn(SignInParams params);
}

