import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider_sample_app/exceptions/app_exception.dart';
import 'package:provider_sample_app/utils/error_handler.dart';

void main() {
  group('ErrorHandler.handleException', () {
    test('should return originalError when exception is ApiHttpException', () {
      // Arrange
      const originalError = 'Custom API error message';
      const exception = ApiHttpException(
        message: 'Default message',
        statusCode: 400,
        originalError: originalError,
      );

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, equals(originalError));
    });

    test('should return message when exception is NetworkException', () {
      // Arrange
      const exception = NetworkException();

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(
        result,
        equals('No internet connection. Please check your network settings.'),
      );
    });

    test(
      'should return message when exception is TimeoutException (AppException)',
      () {
        // Arrange
        const exception = TimeoutException();

        // Act
        final result = ErrorHandler.handleException(exception);

        // Assert
        expect(
          result,
          equals(
            'Request timeout. Please check your connection and try again.',
          ),
        );
      },
    );

    test(
      'should return message when exception is FormatException (AppException)',
      () {
        // Arrange
        const exception = FormatException();

        // Act
        final result = ErrorHandler.handleException(exception);

        // Assert
        expect(result, equals('Invalid data format. Please try again.'));
      },
    );

    test('should return message when exception is UnauthorizedException', () {
      // Arrange
      const exception = UnauthorizedException();

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, equals('Authentication failed. Please login again.'));
    });

    test('should return message when exception is ServerException', () {
      // Arrange
      const exception = ServerException();

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, equals('Server error. Please try again later.'));
    });

    test('should return message when exception is UnknownException', () {
      // Arrange
      const exception = UnknownException();

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, equals('An unexpected error occurred. Please try again.'));
    });

    test('should convert SocketException to NetworkException', () {
      // Arrange
      final exception = SocketException('Connection failed');

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(
        result,
        equals('No internet connection. Please check your network settings.'),
      );
    });

    test(
      'should convert HttpException to NetworkException with custom message',
      () {
        // Arrange
        final exception = HttpException('Network error');

        // Act
        final result = ErrorHandler.handleException(exception);

        // Assert
        expect(result, equals('Network error occurred. Please try again.'));
      },
    );

    // Note: FormatException and TimeoutException from dart:io/dart:async
    // are difficult to construct directly in unit tests. The conversion logic
    // for these exceptions is tested indirectly through integration tests
    // in the API layer (api_base_helper.dart). The AppException versions
    // of these exceptions are tested above.

    test('should convert unknown exception to UnknownException', () {
      // Arrange
      final exception = ArgumentError('Some argument error');

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, contains('Some argument error'));
    });

    test('should handle null originalError in ApiHttpException', () {
      // Arrange
      const exception = ApiHttpException(
        message: 'Default message',
        statusCode: 500,
        originalError: null,
      );

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, isNull);
    });

    test('should handle ApiHttpException with non-string originalError', () {
      // Arrange
      final originalError = {'error': 'Custom error', 'code': 123};
      final exception = ApiHttpException(
        message: 'Default message',
        statusCode: 400,
        originalError: originalError,
      );

      // Act
      final result = ErrorHandler.handleException(exception);

      // Assert
      expect(result, equals(originalError));
    });
  });

  group('ErrorHandler.handleHttpResponse', () {
    test('should throw ArgumentError for success status codes (200-299)', () {
      // Act & Assert
      expect(
        () => ErrorHandler.handleHttpResponse(200),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => ErrorHandler.handleHttpResponse(201),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => ErrorHandler.handleHttpResponse(299),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should create ApiHttpException for status code 400', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(400) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(result.message, equals('Bad request. Please check your input.'));
      expect(result.statusCode, equals(400));
      expect(result.code, equals('BAD_REQUEST'));
    });

    test('should create ApiHttpException for status code 401', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(401) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Authentication failed. Please login again.'),
      );
      expect(result.statusCode, equals(401));
      expect(result.code, equals('UNAUTHORIZED'));
    });

    test('should create ApiHttpException for status code 403', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(403) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals(
          'Access forbidden. You don\'t have permission to perform this action.',
        ),
      );
      expect(result.statusCode, equals(403));
      expect(result.code, equals('FORBIDDEN'));
    });

    test('should create ApiHttpException for status code 404', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(404) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(result.message, equals('Resource not found.'));
      expect(result.statusCode, equals(404));
      expect(result.code, equals('NOT_FOUND'));
    });

    test('should create ApiHttpException for status code 422', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(422) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Validation error. Please check your input.'),
      );
      expect(result.statusCode, equals(422));
      expect(result.code, equals('VALIDATION_ERROR'));
    });

    test('should create ApiHttpException for status code 429', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(429) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Too many requests. Please try again later.'),
      );
      expect(result.statusCode, equals(429));
      expect(result.code, equals('RATE_LIMIT_EXCEEDED'));
    });

    test('should create ApiHttpException for status code 500', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(500) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Internal server error. Please try again later.'),
      );
      expect(result.statusCode, equals(500));
      expect(result.code, equals('INTERNAL_SERVER_ERROR'));
    });

    test('should create ApiHttpException for status code 502', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(502) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Bad gateway. The server is temporarily unavailable.'),
      );
      expect(result.statusCode, equals(502));
      expect(result.code, equals('BAD_GATEWAY'));
    });

    test('should create ApiHttpException for status code 503', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(503) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(
        result.message,
        equals('Service unavailable. Please try again later.'),
      );
      expect(result.statusCode, equals(503));
      expect(result.code, equals('SERVICE_UNAVAILABLE'));
    });

    test('should create ApiHttpException for unknown status codes', () {
      // Act
      final result = ErrorHandler.handleHttpResponse(418) as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(result.message, equals('An error occurred. Please try again.'));
      expect(result.statusCode, equals(418));
      expect(result.code, equals('HTTP_ERROR'));
    });

    test('should include responseBody when provided', () {
      // Arrange
      const responseBody = '{"error": "Custom error message"}';

      // Act
      final result =
          ErrorHandler.handleHttpResponse(400, responseBody: responseBody)
              as ApiHttpException;

      // Assert
      expect(result, isA<ApiHttpException>());
      expect(result.responseBody, equals(responseBody));
    });
  });

  group('ErrorHandler.getErrorMessage', () {
    test('should return message directly for AppException', () {
      // Arrange
      const exception = NetworkException();

      // Act
      final result = ErrorHandler.getErrorMessage(exception);

      // Assert
      expect(
        result,
        equals('No internet connection. Please check your network settings.'),
      );
    });

    test('should call handleException for non-AppException', () {
      // Arrange
      final exception = SocketException('Connection failed');

      // Act
      final result = ErrorHandler.getErrorMessage(exception);

      // Assert
      expect(
        result,
        equals('No internet connection. Please check your network settings.'),
      );
    });

    test('should return originalError for ApiHttpException', () {
      // Arrange
      const originalError = 'API specific error';
      const exception = ApiHttpException(
        message: 'Default message',
        originalError: originalError,
      );

      // Act
      final result = ErrorHandler.getErrorMessage(exception);

      // Assert
      expect(result, equals(originalError));
    });
  });
}
