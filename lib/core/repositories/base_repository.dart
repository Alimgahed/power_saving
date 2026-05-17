import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../utils/result.dart';

/// Base Repository class providing safe remote operations and unified exception to failure mappings
abstract class BaseRepository {
  /// Safely executes remote block mapping any caught AppExceptions into failures
  Future<Result<T>> safeRemoteCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Result.success(result);
    } on NetworkException catch (e) {
      return Result.failure(
        NetworkFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on AuthenticationException catch (e) {
      return Result.failure(
        AuthenticationFailure(
          e.message,
          statusCode: e.statusCode,
          exception: e,
        ),
      );
    } on ValidationException catch (e) {
      return Result.failure(
        ValidationFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on ParsingException catch (e) {
      return Result.failure(ParsingFailure(e.message, exception: e));
    } catch (e) {
      return Result.failure(Failure('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  /// Helper to safely decode raw http string body into a parsed object structure
  T safeDecode<T>(
    http.Response response,
    T Function(Map<String, dynamic> json) parser,
  ) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return parser(decoded);
      } else {
        throw ParsingException('تنسيق البيانات المستلمة غير صالح.');
      }
    } catch (e) {
      if (e is ParsingException) rethrow;
      throw ParsingException(
        'فشل في تحليل بيانات الاستجابة من الخادم.',
        originalError: e,
      );
    }
  }
}
