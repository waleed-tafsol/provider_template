import 'dart:io';

import '../../domain/exceptions/app_exception.dart';
import '../logging/logger_service.dart';

/// Centralized error handler for the application
/// Note: This handler does NOT display UI elements. Errors should be displayed in the UI layer.
class ErrorHandler {
  /// Handles exceptions and converts them to user-friendly error messages
  /// Returns a user-friendly error message (does NOT show UI)
  static String handleException(dynamic exception) {
    // If it's ApiHttpException, return its original message directly
    if (exception is ApiHttpException) {
      _logError(exception);
      return exception.originalError;
    }

    AppException appException;

    // Convert various exception types to AppException
    if (exception is AppException) {
      appException = exception;
    } else if (exception is SocketException) {
      appException = const NetworkException();
    } else if (exception is HttpException) {
      appException = NetworkException(
        message: 'Network error occurred. Please try again.',
        originalError: exception,
      );
    } else if (exception is FormatException) {
      appException = const FormatException();
    } else if (exception is TimeoutException) {
      appException = const TimeoutException();
    } else {
      appException = UnknownException(
        message: exception.toString(),
        originalError: exception,
      );
    }

    // Log error using centralized logging service
    _logError(appException);

    return appException.message;
  }

  /// Handles HTTP response and converts to appropriate exception
  static AppException handleHttpResponse(
    int statusCode, {
    String? responseBody,
  }) {
    if (statusCode >= 200 && statusCode < 300) {
      throw ArgumentError('Status code $statusCode is not an error');
    }

    return ApiHttpException.fromStatusCode(
      statusCode,
      responseBody: responseBody,
    );
  }

  /// Logs error for debugging purposes
  static void _logError(AppException exception) {
    final errorData = <String, dynamic>{
      'type': exception.runtimeType.toString(),
      'message': exception.message,
      'code': exception.code,
    };

    if (exception.originalError != null) {
      errorData['originalError'] = exception.originalError.toString();
    }

    if (exception is ApiHttpException) {
      errorData['statusCode'] = exception.statusCode;
      if (exception.responseBody != null) {
        errorData['responseBody'] = exception.responseBody;
      }
    }

    AppLogger.e(
      '❌ Error: ${exception.runtimeType}',
      errorData,
    );
  }

  /// Gets a user-friendly error message from an exception
  /// This is an alias for handleException for clarity
  static String getErrorMessage(dynamic exception) {
    if (exception is AppException) {
      return exception.message;
    }
    return handleException(exception);
  }
}
