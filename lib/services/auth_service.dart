import 'dart:convert';

import 'package:provider_sample_app/repositories/auth_repository.dart';
import 'package:provider_sample_app/utils/secure_storage_service.dart';

import '../exceptions/app_exception.dart';
import '../models/requests/sign_in_request.dart';
import '../models/responses/auth_response.dart';
import '../utils/enums.dart';
import '../utils/error_handler.dart';
import 'api_base_helper.dart';

class AuthService implements AuthRepository {
  final ApiBaseHelper _apiClient;
  final SecureStorage _secureStorage;

  AuthService({
    required ApiBaseHelper apiClient,
    required SecureStorage secureStorage,
  }) : _apiClient = apiClient,
       _secureStorage = secureStorage;

  @override
  Future<AuthResponse> signInApi({required SignInRequest signInRequest}) async {
    try {
      final response = await _apiClient.httpRequest(
        endPoint: EndPoints.signIn,
        requestType: 'POST',
        requestBody: signInRequest,
        params: '',
      );

      // Parse response
      final parsed = json.decode(response.body);
      final AuthResponse authResponse = AuthResponse.fromJson(parsed);

      // Save token if successful
      if (authResponse.isSuccess == true &&
          authResponse.data?.clientToken != null) {
        await _secureStorage.saveAuthToken(authResponse.data!.clientToken!);
      }

      return authResponse;
    } on AppException catch (e) {
      // Handle known exceptions - convert to error message (no UI display here)
      final errorMessage = ErrorHandler.handleException(e);
      return AuthResponse(isSuccess: false, message: errorMessage);
    } catch (e) {
      // Handle unknown exceptions - convert to error message (no UI display here)
      final errorMessage = ErrorHandler.handleException(e);
      return AuthResponse(isSuccess: false, message: errorMessage);
    }
  }
}
