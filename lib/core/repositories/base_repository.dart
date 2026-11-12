import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:power_saving/my_widget/sharable.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../utils/result.dart';
import 'package:power_saving/core/auth/session_manager.dart';
/// Base Repository class providing safe remote operations and unified exception to failure mappings
abstract class BaseRepository {
  /// Safely executes remote block mapping any caught AppExceptions into failures
  Future<Result<T>> safeRemoteCall<T>(Future<T> Function() call, {bool Function()? isCurrent}) async {
    try {
      final result = await call();
      return Result.success(result);
    } on NetworkException catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      showCustomErrorDialog(errorMessage: e.toString());
      return Result.failure(
        NetworkFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on AuthenticationException catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      await SessionManager.logout(message: SessionManager.invalidMessage);
      return Result.failure(
        AuthenticationFailure(
          e.message,
          statusCode: e.statusCode,
          exception: e,
        ),
      );
    } on ValidationException catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      showCustomErrorDialog(errorMessage: e.toString());
      return Result.failure(
        ValidationFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on ServerException catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      showCustomErrorDialog(errorMessage: e.toString());
      return Result.failure(
        ServerFailure(e.message, statusCode: e.statusCode, exception: e),
      );
    } on ParsingException catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      showCustomErrorDialog(errorMessage: e.toString());
      return Result.failure(ParsingFailure(e.message, exception: e));
    } catch (e) {
      if (isCurrent != null && !isCurrent()) return Result.failure(Failure('Obsolete request'));
      showCustomErrorDialog(errorMessage: e.toString());
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
      showCustomErrorDialog(errorMessage: e.toString());
      if (e is ParsingException) rethrow;
      throw ParsingException(
        'فشل في تحليل بيانات الاستجابة من الخادم.',
        originalError: e,
      );
    }
  }
}
