/// API Exception Classes
/// Handles different types of API errors

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network connection error
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Network connection error. Please check your internet connection.',
          statusCode: null,
        );
}

/// Authentication error (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Unauthorized. Please login again.',
          statusCode: 401,
        );
}

/// Forbidden error (403)
class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'Access forbidden. You do not have permission.',
          statusCode: 403,
        );
}

/// Not found error (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found.',
          statusCode: 404,
        );
}

/// Validation error (422)
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException({
    String? message,
    this.errors,
  }) : super(
          message: message ?? 'Validation error. Please check your input.',
          statusCode: 422,
          data: errors,
        );

  String getFieldError(String field) {
    if (errors == null) return '';
    final error = errors![field];
    if (error is List && error.isNotEmpty) {
      return error.first.toString();
    }
    return error?.toString() ?? '';
  }
}

/// Rate limit error (429)
class RateLimitException extends ApiException {
  RateLimitException({String? message})
      : super(
          message: message ?? 'Too many requests. Please try again later.',
          statusCode: 429,
        );
}

/// Server error (500+)
class ServerException extends ApiException {
  ServerException({String? message, int? statusCode})
      : super(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode ?? 500,
        );
}

/// Timeout error
class TimeoutException extends ApiException {
  TimeoutException({String? message})
      : super(
          message: message ?? 'Request timeout. Please try again.',
          statusCode: null,
        );
}

/// Parse error
class ParseException extends ApiException {
  ParseException({String? message})
      : super(
          message: message ?? 'Failed to parse response data.',
          statusCode: null,
        );
}
