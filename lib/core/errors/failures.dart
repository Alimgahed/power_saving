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
    super.message, {
    super.statusCode,
    NetworkException? super.exception,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure(
    super.message, {
    super.statusCode,
    ValidationException? super.exception,
  });
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(
    super.message, {
    super.statusCode,
    AuthenticationException? super.exception,
  });
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message, {ParsingException? super.exception});
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.statusCode,
    ServerException? super.exception,
  });
}
