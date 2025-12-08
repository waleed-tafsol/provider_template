# Exception Handling Guide

This document describes the exception handling strategy implemented in this application.

## Overview

The application uses a structured exception handling approach with:
- **Custom exception classes** for different error types
- **Centralized error handler** for consistent error processing
- **Proper HTTP status code handling**
- **User-friendly error messages**

## Architecture

### 1. Exception Classes (`lib/exceptions/app_exception.dart`)

All exceptions extend `AppException`, which provides:
- `message`: User-friendly error message
- `code`: Error code for programmatic handling
- `originalError`: Original exception for debugging

#### Available Exception Types:

- **`NetworkException`**: Network connectivity issues
- **`ApiHttpException`**: HTTP request failures with status codes
- **`TimeoutException`**: Request timeout errors
- **`FormatException`**: Data parsing/format errors
- **`UnauthorizedException`**: Authentication failures
- **`ServerException`**: Server-side errors
- **`UnknownException`**: Unexpected errors

### 2. Error Handler (`lib/utills/error_handler.dart`)

The `ErrorHandler` class provides:

#### `handleException(dynamic exception, {bool showToast = true})`
- Converts various exception types to `AppException`
- Shows user-friendly error messages via EasyLoading
- Logs errors for debugging
- Returns error message string

#### `handleHttpResponse(int statusCode, {String? responseBody})`
- Converts HTTP status codes to appropriate exceptions
- Handles common status codes (400, 401, 403, 404, 422, 429, 500, 502, 503)

#### `getErrorMessage(dynamic exception)`
- Extracts user-friendly error message without showing toast

## Usage Patterns

### In API Layer (`ApiBaseHelper`)

```dart
try {
  // Make HTTP request
  final response = await http.get(...);
  
  // Check status code
  if (response.statusCode >= 400) {
    throw ErrorHandler.handleHttpResponse(
      response.statusCode,
      responseBody: response.body,
    );
  }
  
  return response;
} on io.SocketException catch (e) {
  throw NetworkException(originalError: e);
} on AppException {
  rethrow; // Let service layer handle it
} catch (e) {
  throw UnknownException(originalError: e);
}
```

### In Service Layer (`AuthService`)

```dart
try {
  final response = await _apiClient.httpRequest(...);
  // Process successful response
  return authResponse;
} on AppException catch (e) {
  // Handle known exceptions - convert to error message (NO UI display)
  final errorMessage = ErrorHandler.handleException(e);
  return AuthResponse(
    isSuccess: false,
    message: errorMessage,
  );
} catch (e) {
  // Handle unknown exceptions - convert to error message (NO UI display)
  final errorMessage = ErrorHandler.handleException(e);
  return AuthResponse(
    isSuccess: false,
    message: errorMessage,
  );
}
```

**Important**: Services should NOT display UI elements. They only convert exceptions to error messages and return error responses.

### In ViewModel Layer

ViewModels expose error responses but do NOT display UI:

```dart
final AuthResponse response = await _authRepository.signInApi(...);
setAuthResponse(response); // Expose response to UI
return response.isSuccess == true;
```

### In UI Layer (Screens)

The UI layer is responsible for displaying errors:

```dart
final success = await authViewModel.callSignInApi();

if (success && context.mounted) {
  // Handle success
  EasyLoading.showSuccess('Login successful!');
} else if (context.mounted) {
  // Display error in UI layer
  final errorMessage = authViewModel.authResponse.message ?? 
      'An error occurred. Please try again.';
  EasyLoading.showError(errorMessage);
}
```

## HTTP Status Code Handling

The system automatically handles common HTTP status codes:

| Status Code | Exception Type | User Message |
|------------|---------------|--------------|
| 400 | `ApiHttpException` | "Bad request. Please check your input." |
| 401 | `ApiHttpException` | "Authentication failed. Please login again." |
| 403 | `ApiHttpException` | "Access forbidden..." |
| 404 | `ApiHttpException` | "Resource not found." |
| 422 | `ApiHttpException` | "Validation error..." |
| 429 | `ApiHttpException` | "Too many requests..." |
| 500 | `ApiHttpException` | "Internal server error..." |
| 502 | `ApiHttpException` | "Bad gateway..." |
| 503 | `ApiHttpException` | "Service unavailable..." |

## Best Practices

1. **UI display only in UI layer**: Errors should ONLY be displayed in the UI layer (screens/widgets), never in service or view model layers
2. **Use specific exceptions**: Prefer specific exception types over generic ones
3. **Preserve original errors**: Always include `originalError` for debugging
4. **Handle at the right layer**:
   - **API layer**: Convert to AppException, throw exceptions
   - **Service layer**: Handle AppException, convert to error messages, return error responses (NO UI)
   - **ViewModel layer**: Expose responses, return success boolean (NO UI)
   - **UI layer**: Display errors to users via toasts, dialogs, or inline messages
5. **Log errors**: ErrorHandler logs errors automatically (extend for production logging)
6. **Separation of concerns**: Keep business logic (services/viewmodels) free from UI dependencies

## Error Flow

```
HTTP Request
    ↓
ApiBaseHelper (catches network/system exceptions, converts to AppException)
    ↓
Service Layer (catches AppException, converts to error message, returns error response)
    ↓
ViewModel (exposes response, returns success boolean)
    ↓
UI Layer (displays error message to user via EasyLoading/dialogs)
```

**Key Principle**: Only the UI layer displays errors to users. All other layers handle exceptions but do not show UI elements.

## Future Improvements

1. **Logging Framework**: Integrate with `logger` package for production logging
2. **Error Reporting**: Add crash reporting (e.g., Firebase Crashlytics)
3. **Retry Logic**: Implement automatic retry for network failures
4. **Offline Handling**: Better handling of offline scenarios
5. **Error Analytics**: Track error patterns for monitoring

