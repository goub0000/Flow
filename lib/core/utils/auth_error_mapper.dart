/// Authentication Error Mapper
/// Maps technical error messages from Supabase/backend to user-friendly messages
library;

class AuthErrorMapper {
  /// Common error patterns and their user-friendly messages
  static final Map<String, AuthErrorInfo> _errorPatterns = {
    // Login errors
    'invalid login credentials': AuthErrorInfo(
      message: 'Incorrect email or password. Please check your credentials and try again.',
      suggestion: 'If you forgot your password, use the "Forgot Password?" link below.',
      errorType: AuthErrorType.invalidCredentials,
    ),
    'invalid credentials': AuthErrorInfo(
      message: 'Incorrect email or password. Please check your credentials and try again.',
      suggestion: 'If you forgot your password, use the "Forgot Password?" link below.',
      errorType: AuthErrorType.invalidCredentials,
    ),
    'email not confirmed': AuthErrorInfo(
      message: 'Please verify your email address before logging in.',
      suggestion: 'Check your inbox for a verification email. You can request a new one if needed.',
      errorType: AuthErrorType.emailNotVerified,
    ),
    'email not verified': AuthErrorInfo(
      message: 'Please verify your email address before logging in.',
      suggestion: 'Check your inbox for a verification email. You can request a new one if needed.',
      errorType: AuthErrorType.emailNotVerified,
    ),
    'user not found': AuthErrorInfo(
      message: 'No account found with this email address.',
      suggestion: 'Please check the email or create a new account.',
      errorType: AuthErrorType.userNotFound,
    ),
    'user has been banned': AuthErrorInfo(
      message: 'Your account has been suspended.',
      suggestion: 'Please contact support for assistance.',
      errorType: AuthErrorType.accountSuspended,
    ),
    'too many requests': AuthErrorInfo(
      message: 'Too many login attempts. Please wait a moment before trying again.',
      suggestion: 'For security, we limit login attempts. Try again in a few minutes.',
      errorType: AuthErrorType.rateLimited,
    ),
    'rate limit': AuthErrorInfo(
      message: 'Too many requests. Please wait a moment before trying again.',
      suggestion: 'Try again in a few minutes.',
      errorType: AuthErrorType.rateLimited,
    ),

    // Registration errors
    'already registered': AuthErrorInfo(
      message: 'An account with this email already exists.',
      suggestion: 'Try logging in instead, or use "Forgot Password?" to reset your password.',
      errorType: AuthErrorType.emailAlreadyExists,
    ),
    'already exists': AuthErrorInfo(
      message: 'An account with this email already exists.',
      suggestion: 'Try logging in instead, or use "Forgot Password?" to reset your password.',
      errorType: AuthErrorType.emailAlreadyExists,
    ),
    'email address is already registered': AuthErrorInfo(
      message: 'An account with this email already exists.',
      suggestion: 'Try logging in instead, or use "Forgot Password?" to reset your password.',
      errorType: AuthErrorType.emailAlreadyExists,
    ),
    'duplicate': AuthErrorInfo(
      message: 'An account with this email already exists.',
      suggestion: 'Try logging in instead, or use "Forgot Password?" to reset your password.',
      errorType: AuthErrorType.emailAlreadyExists,
    ),
    'password should be at least': AuthErrorInfo(
      message: 'Your password is too short.',
      suggestion: 'Please use a password with at least 8 characters.',
      errorType: AuthErrorType.weakPassword,
    ),
    'weak password': AuthErrorInfo(
      message: 'Your password is too weak.',
      suggestion: 'Please use a stronger password with letters, numbers, and symbols.',
      errorType: AuthErrorType.weakPassword,
    ),
    'invalid email': AuthErrorInfo(
      message: 'Please enter a valid email address.',
      suggestion: 'Make sure your email is in the correct format (e.g., name@example.com).',
      errorType: AuthErrorType.invalidEmail,
    ),

    // Network/Server errors
    'network error': AuthErrorInfo(
      message: 'Unable to connect to the server.',
      suggestion: 'Please check your internet connection and try again.',
      errorType: AuthErrorType.networkError,
    ),
    'connection refused': AuthErrorInfo(
      message: 'Unable to connect to the server.',
      suggestion: 'Please check your internet connection and try again.',
      errorType: AuthErrorType.networkError,
    ),
    'timeout': AuthErrorInfo(
      message: 'The request timed out.',
      suggestion: 'Please check your internet connection and try again.',
      errorType: AuthErrorType.networkError,
    ),
    'server error': AuthErrorInfo(
      message: 'Something went wrong on our end.',
      suggestion: 'Please try again later. If the problem persists, contact support.',
      errorType: AuthErrorType.serverError,
    ),
    '500': AuthErrorInfo(
      message: 'Something went wrong on our end.',
      suggestion: 'Please try again later. If the problem persists, contact support.',
      errorType: AuthErrorType.serverError,
    ),
    '503': AuthErrorInfo(
      message: 'The service is temporarily unavailable.',
      suggestion: 'Please try again in a few minutes.',
      errorType: AuthErrorType.serverError,
    ),

    // Session errors
    'session expired': AuthErrorInfo(
      message: 'Your session has expired.',
      suggestion: 'Please log in again to continue.',
      errorType: AuthErrorType.sessionExpired,
    ),
    'token expired': AuthErrorInfo(
      message: 'Your session has expired.',
      suggestion: 'Please log in again to continue.',
      errorType: AuthErrorType.sessionExpired,
    ),
    'refresh token': AuthErrorInfo(
      message: 'Your session has expired.',
      suggestion: 'Please log in again to continue.',
      errorType: AuthErrorType.sessionExpired,
    ),
  };

  /// Maps a raw error message to a user-friendly AuthErrorInfo
  static AuthErrorInfo mapError(String? rawError) {
    if (rawError == null || rawError.isEmpty) {
      return AuthErrorInfo(
        message: 'An unexpected error occurred.',
        suggestion: 'Please try again.',
        errorType: AuthErrorType.unknown,
      );
    }

    final lowerError = rawError.toLowerCase();

    // Check each pattern
    for (final entry in _errorPatterns.entries) {
      if (lowerError.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default fallback - return a cleaned-up version of the original error
    return AuthErrorInfo(
      message: _cleanErrorMessage(rawError),
      suggestion: 'Please try again or contact support if the problem persists.',
      errorType: AuthErrorType.unknown,
    );
  }

  /// Cleans up raw error messages for display
  static String _cleanErrorMessage(String rawError) {
    // Remove common prefixes
    String cleaned = rawError
        .replaceAll(RegExp(r'^(Exception:|Error:|Sign in failed:|Sign up failed:|Login failed:|Registration failed:)\s*', caseSensitive: false), '')
        .trim();

    // Capitalize first letter
    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    // Ensure it ends with a period
    if (cleaned.isNotEmpty && !cleaned.endsWith('.') && !cleaned.endsWith('!') && !cleaned.endsWith('?')) {
      cleaned = '$cleaned.';
    }

    return cleaned;
  }

  /// Maps a raw error to just the user-friendly message string
  static String mapErrorMessage(String? rawError) {
    return mapError(rawError).message;
  }

  /// Gets the error type from a raw error
  static AuthErrorType getErrorType(String? rawError) {
    return mapError(rawError).errorType;
  }
}

/// Types of authentication errors for programmatic handling
enum AuthErrorType {
  invalidCredentials,
  emailNotVerified,
  userNotFound,
  accountSuspended,
  rateLimited,
  emailAlreadyExists,
  weakPassword,
  invalidEmail,
  networkError,
  serverError,
  sessionExpired,
  unknown,
}

/// Contains user-friendly error information
class AuthErrorInfo {
  final String message;
  final String suggestion;
  final AuthErrorType errorType;

  const AuthErrorInfo({
    required this.message,
    required this.suggestion,
    required this.errorType,
  });

  /// Returns the full error message with suggestion
  String get fullMessage => '$message $suggestion';

  /// Returns whether this error suggests trying to log in instead
  bool get shouldSuggestLogin => errorType == AuthErrorType.emailAlreadyExists;

  /// Returns whether this error suggests using forgot password
  bool get shouldSuggestForgotPassword =>
      errorType == AuthErrorType.invalidCredentials ||
      errorType == AuthErrorType.emailAlreadyExists;

  /// Returns whether this error suggests checking email
  bool get shouldSuggestCheckEmail => errorType == AuthErrorType.emailNotVerified;
}
