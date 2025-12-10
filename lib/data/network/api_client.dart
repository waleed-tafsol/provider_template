import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/exceptions/app_exception.dart';
import '../../core/constants/enums.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/errors/error_handler.dart';

/// API Client - Handles HTTP requests
class ApiClient {
  final SecureStorage _secureStorage;

  ApiClient({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  Future<Map<String, dynamic>> get({
    required EndPoints endpoint,
    Map<String, String>? queryParameters,
  }) async {
    return _handleRequest(
      method: 'GET',
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> post({
    required EndPoints endpoint,
    Map<String, dynamic>? body,
  }) async {
    return _handleRequest(
      method: 'POST',
      endpoint: endpoint,
      body: body,
    );
  }

  Future<Map<String, dynamic>> put({
    required EndPoints endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    return _handleRequest(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> delete({
    required EndPoints endpoint,
    Map<String, String>? queryParameters,
  }) async {
    return _handleRequest(
      method: 'DELETE',
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> _handleRequest({
    required String method,
    required EndPoints endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final token = _secureStorage.cachedAuthToken;
      final uri = Uri.parse('${BaseUrls.api.url}${endpoint.url}');

      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(
            queryParameters != null
                ? uri.replace(queryParameters: queryParameters)
                : uri,
            headers: _getHeaders(token),
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const TimeoutException(),
          );
          break;

        case 'POST':
          response = await http.post(
            uri,
            headers: _getHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const TimeoutException(),
          );
          break;

        case 'PUT':
          response = await http.put(
            queryParameters != null
                ? uri.replace(queryParameters: queryParameters)
                : uri,
            headers: _getHeaders(token),
            body: body != null ? jsonEncode(body) : null,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const TimeoutException(),
          );
          break;

        case 'DELETE':
          response = await http.delete(
            queryParameters != null
                ? uri.replace(queryParameters: queryParameters)
                : uri,
            headers: _getHeaders(token),
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw const TimeoutException(),
          );
          break;

        default:
          throw UnknownException(
            message: 'Unsupported request type: $method',
            code: 'UNSUPPORTED_REQUEST_TYPE',
          );
      }

      // Check HTTP status code
      if (response.statusCode >= 400) {
        throw ErrorHandler.handleHttpResponse(
          response.statusCode,
          responseBody: response.body,
        );
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on SocketException catch (e) {
      throw NetworkException(originalError: e);
    } on HttpException catch (e) {
      throw NetworkException(
        message: 'Network error occurred. Please try again.',
        originalError: e,
      );
    } on FormatException catch (e) {
      throw FormatException(originalError: e);
    } on TimeoutException catch (e) {
      throw TimeoutException(originalError: e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
