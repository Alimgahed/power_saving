/// Base Exception for all enterprise application errors
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  AppException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => message;
}

/// Thrown when network connection is absent, times out, or returns a DNS error
class NetworkException extends AppException {
  NetworkException(String message, {int? statusCode, dynamic originalError})
    : super(message, statusCode: statusCode, originalError: originalError);
}

/// Thrown when local parameter or response payload schema validation fails
class ValidationException extends AppException {
  ValidationException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

/// Thrown on token expiry, missing authorization credentials, or invalid permissions (401/403)
class AuthenticationException extends AppException {
  AuthenticationException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

/// Thrown when response parsing fails due to type mismatches or corrupted payload structure
class ParsingException extends AppException {
  ParsingException(String message, {dynamic originalError})
    : super(message, originalError: originalError);
}

/// Thrown on unexpected server failures (5xx status codes)
class ServerException extends AppException {
  ServerException(String message, {int? statusCode, dynamic originalError})
    : super(message, statusCode: statusCode, originalError: originalError);
}

/// Mapping utility to convert status codes into localized Arabic messages
class ExceptionMapper {
  static String getLocalizedMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صالح. يرجى التحقق من البيانات المرسلة.';
      case 401:
        return 'غير مصرح لك بالوصول. يرجى تسجيل الدخول مرة أخرى.';
      case 403:
        return 'غير مسموح لك بالوصول إلى هذا المصدر.';
      case 404:
        return 'المصدر المطلوب غير موجود.';
      case 500:
        return 'حدث خطأ داخلي في الخادم. يرجى المحاولة لاحقاً.';
      case 503:
        return 'الخدمة غير متوفرة حالياً. يرجى المحاولة لاحقاً.';
      default:
        return 'حدث خطأ غير متوقع في النظام.';
    }
  }
}
