import '../errors/failures.dart';

/// Type-safe monadic functional programming container representing success or failure
abstract class Result<T> {
  const Result();

  /// Creates a success result containing the returned data
  factory Result.success(T data) = Success<T>;

  /// Creates a failure result containing the failure details
  factory Result.failure(Failure failure) = FailureResult<T>;

  /// Checks if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Checks if this is a failure result
  bool get isFailure => this is FailureResult<T>;

  /// Monadic fold operation to handle success and failure values elegantly
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  );
}

/// Success subclass of Result monad
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return onSuccess(data);
  }
}

/// Failure subclass of Result monad
class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return onFailure(failure);
  }
}
