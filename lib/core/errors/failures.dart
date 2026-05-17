import 'exceptions.dart';

/// Lightweight logging-safe model holding safe messages to present to the user interface
class Failure {
  final String message;
  final int? statusCode;
  final AppException? exception;

  const Failure(this.message, {this.statusCode, this.exception});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

class NetworkFailure extends Failure {
  const NetworkFailure(
    String message, {
    int? statusCode,
    NetworkException? exception,
  }) : super(message, statusCode: statusCode, exception: exception);
}

class ValidationFailure extends Failure {
  const ValidationFailure(
    String message, {
    int? statusCode,
    ValidationException? exception,
  }) : super(message, statusCode: statusCode, exception: exception);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(
    String message, {
    int? statusCode,
    AuthenticationException? exception,
  }) : super(message, statusCode: statusCode, exception: exception);
}

class ParsingFailure extends Failure {
  const ParsingFailure(String message, {ParsingException? exception})
    : super(message, exception: exception);
}

class ServerFailure extends Failure {
  const ServerFailure(
    String message, {
    int? statusCode,
    ServerException? exception,
  }) : super(message, statusCode: statusCode, exception: exception);
}
