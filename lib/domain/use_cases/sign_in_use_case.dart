import '../entities/auth_result.dart';
import '../entities/sign_in_params.dart';
import '../repositories/auth_repository.dart';

/// Use case - Encapsulates business logic for signing in
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<AuthResult> execute(SignInParams params) async {
    return await _authRepository.signIn(params);
  }
}

