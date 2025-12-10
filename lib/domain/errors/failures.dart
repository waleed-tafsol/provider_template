/// Base class for all failures in the domain layer
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}

