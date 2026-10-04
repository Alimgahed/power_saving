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
  NetworkException(super.message, {super.statusCode, super.originalError});
}

/// Thrown when local parameter or response payload schema validation fails
class ValidationException extends AppException {
  ValidationException(super.message, {super.statusCode});
}

/// Thrown on token expiry, missing authorization credentials, or invalid permissions (401/403)
class AuthenticationException extends AppException {
  AuthenticationException(super.message, {super.statusCode});
}

/// Thrown when response parsing fails due to type mismatches or corrupted payload structure
class ParsingException extends AppException {
  ParsingException(super.message, {super.originalError});
}

/// Thrown on unexpected server failures (5xx status codes)
class ServerException extends AppException {
  ServerException(super.message, {super.statusCode, super.originalError});
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
