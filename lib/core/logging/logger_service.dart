import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging service for the application
/// Provides different log levels and automatically handles debug/release modes
class AppLogger {
  static Logger? _logger;

  /// Initialize logger with appropriate configuration
  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Show timestamp
      ),
      level: kDebugMode ? Level.debug : Level.warning, // Only warnings and above in release
    );
  }

  /// Get logger instance
  static Logger get logger {
    _logger ??= Logger(
      printer: PrettyPrinter(),
      level: kDebugMode ? Level.debug : Level.warning,
    );
    return _logger!;
  }

  /// Log debug messages (only in debug mode)
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info messages
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal errors
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log network requests/responses
  static void network(String message, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      logger.d('🌐 NETWORK: $message', error: data);
    }
  }

  /// Log authentication events
  static void auth(String message, [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      logger.d('🔐 AUTH: $message', error: data);
    }
  }
}

