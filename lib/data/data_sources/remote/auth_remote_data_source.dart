import '../../models/auth_response_dto.dart';
import '../../models/sign_in_request_dto.dart';
import '../../../domain/exceptions/app_exception.dart';
import '../../../core/constants/enums.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../network/api_client.dart';

/// Remote data source - Handles API calls
abstract class AuthRemoteDataSource {
  Future<AuthResponseDto> signIn(SignInRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRemoteDataSourceImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  @override
  Future<AuthResponseDto> signIn(SignInRequestDto request) async {
    try {
      final response = await _apiClient.post(
        endpoint: EndPoints.signIn,
        body: request.toJson(),
      );

      final authResponse = AuthResponseDto.fromJson(response);

      // Save token if successful
      if (authResponse.isSuccess && authResponse.data?.clientToken != null) {
        await _secureStorage.saveAuthToken(
          authResponse.data!.clientToken!,
        );
      }

      return authResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred',
        code: 'UNKNOWN_ERROR',
        originalError: e,
      );
    }
  }
}

