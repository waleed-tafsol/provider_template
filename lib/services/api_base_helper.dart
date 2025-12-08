import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;

import '../exceptions/app_exception.dart';
import '../utils/enums.dart';
import '../utils/error_handler.dart';
import '../utils/secure_storage_service.dart';

class ApiBaseHelper {
  String? autToken;
  // final SharedPref _sharedPref = SharedPref();
  final SecureStorage _secureStorage;

  ApiBaseHelper({required SecureStorage secureStorage})
    : _secureStorage = secureStorage;

  Future<dynamic> httpRequest({
    required EndPoints endPoint,
    required String requestType,
    var requestBody,
    required String params,
    String? imagePath,
  }) async {
    autToken = _secureStorage.cachedAuthToken;
    try {
      http.Response? response;
      http.StreamedResponse? streamedResponse;

      switch (requestType) {
        case 'GET':
          response = await http
              .get(
                Uri.parse(BaseUrls.api.url + endPoint.url + params),
                headers: getHeaders(),
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw const TimeoutException();
                },
              );
          break;
        case 'POST':
          response = await http
              .post(
                Uri.parse(BaseUrls.api.url + endPoint.url),
                headers: getHeaders(),
                body: jsonEncode(requestBody),
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw const TimeoutException();
                },
              );
          break;
        case 'PUT':
          response = await http
              .put(
                Uri.parse(BaseUrls.api.url + endPoint.url + params),
                headers: getHeaders(),
                body: requestBody != '' ? jsonEncode(requestBody) : null,
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw const TimeoutException();
                },
              );
          break;
        case 'DEL':
          response = await http
              .delete(
                Uri.parse(BaseUrls.api.url + endPoint.url + params),
                headers: getHeaders(),
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw const TimeoutException();
                },
              );
          break;
        case 'MULTIPART':
          final request = http.MultipartRequest(
            'POST',
            Uri.parse(BaseUrls.api.url + endPoint.url),
          );
          request.fields.addAll(requestBody!.toJson());
          request.files.add(
            await http.MultipartFile.fromPath('image', imagePath!),
          );
          request.headers.addAll(getHeaders());
          streamedResponse = await request.send().timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw const TimeoutException();
            },
          );
          // Convert StreamedResponse to Response for consistency
          response = await http.Response.fromStream(streamedResponse);
          break;
        default:
          throw UnknownException(
            message: 'Unsupported request type: $requestType',
            code: 'UNSUPPORTED_REQUEST_TYPE',
          );
      }

      // Check HTTP status code and throw appropriate exception if error
      if (response.statusCode >= 400) {
        throw ErrorHandler.handleHttpResponse(
          response.statusCode,
          responseBody: response.body,
        );
      }

      return response;
    } on io.SocketException catch (e) {
      throw NetworkException(originalError: e);
    } on io.HttpException catch (e) {
      // This is Dart's built-in HttpException, convert to our NetworkException
      throw NetworkException(
        message: 'Network error occurred. Please try again.',
        originalError: e,
      );
    } on FormatException catch (e) {
      // Dart's built-in FormatException
      throw FormatException(originalError: e);
    } on TimeoutException catch (e) {
      // Dart's built-in TimeoutException
      throw TimeoutException(originalError: e);
    } on AppException {
      // Re-throw AppException as-is (ErrorHandler will handle it in the service layer)
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    headers.putIfAbsent('Content-Type', () => 'application/json');
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent('Authorization', () => 'Bearer ${autToken ?? ''}');
    return headers;
  }
}
