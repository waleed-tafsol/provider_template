import '../../domain/entities/auth_result.dart';
import '../../domain/entities/sign_in_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/app_exception.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../models/sign_in_request_dto.dart';
import '../mappers/auth_mapper.dart';

/// Repository implementation - Data layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResult> signIn(SignInParams params) async {
    try {
      final requestDto = SignInRequestDto(
        email: params.email,
        password: params.password,
        deviceToken: params.deviceToken,
        deviceType: params.deviceType,
      );

      final responseDto = await _remoteDataSource.signIn(requestDto);
      return AuthMapper.toAuthResult(responseDto);
    } on AppException catch (e) {
      return AuthResult.failure(message: e.message);
    } catch (e) {
      return AuthResult.failure(
        message: 'An unexpected error occurred',
      );
    }
  }
}

