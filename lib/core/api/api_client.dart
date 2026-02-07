/// API Client
/// Main HTTP client with authentication and error handling
library;

import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  final _logger = Logger('ApiClient');
  late final Dio _dio;
  final SharedPreferences _prefs;
  String? _accessToken;

  ApiClient(this._prefs) {
    _initializeDio();
    _loadToken();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging interceptor in debug mode
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => _logger.fine('[API] $obj'),
      ),
    );
  }

  /// Load token from storage
  Future<void> _loadToken() async {
    _accessToken = _prefs.getString(ApiConfig.accessTokenKey);
  }

  /// Set authentication token
  Future<void> setToken(String token) async {
    _accessToken = token;
    await _prefs.setString(ApiConfig.accessTokenKey, token);
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    _accessToken = null;
    await _prefs.remove(ApiConfig.accessTokenKey);
    await _prefs.remove(ApiConfig.refreshTokenKey);
  }

  /// Get current token
  String? get token => _accessToken;

  /// Check if user is authenticated
  bool get isAuthenticated => _accessToken != null;

  // Request interceptor - Add auth header
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    handler.next(options);
  }

  // Response interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  // Error interceptor - Handle errors uniformly
  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    final exception = _handleError(error);

    // If unauthorized, clear token
    if (exception is UnauthorizedException) {
      await clearToken();
    }

    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        type: error.type,
        error: exception,
      ),
    );
  }

  /// Handle Dio errors and convert to custom exceptions
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);

      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');

      default:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
        );
    }
  }

  /// Handle HTTP status codes
  ApiException _handleStatusCode(Response? response) {
    if (response == null) {
      return ServerException();
    }

    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    // Extract error message from response
    String message = 'An error occurred';
    Map<String, dynamic>? errorData;

    if (data is Map<String, dynamic>) {
      errorData = data['error'] as Map<String, dynamic>?;
      message = errorData?['message'] ?? data['message'] ?? message;
    }

    switch (statusCode) {
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 404:
        return NotFoundException(message: message);
      case 422:
        return ValidationException(
          message: message,
          errors: errorData,
        );
      case 429:
        return RateLimitException(message: message);
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message: message, statusCode: statusCode);
      default:
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: errorData,
        );
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// Upload file using cross-platform compatible byte data
  /// [fileBytes] - The file content as Uint8List
  /// [fileName] - The name of the file including extension
  /// [mimeType] - Optional MIME type (e.g., 'application/pdf', 'image/png')
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    Uint8List fileBytes, {
    required String fileName,
    String fieldName = 'file',
    String? mimeType,
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: mimeType != null ? DioMediaType.parse(mimeType) : null,
        ),
        ...?data,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return _processResponse(response, fromJson);
    } on DioException catch (e) {
      return _processError(e);
    }
  }

  /// Process successful response
  ApiResponse<T> _processResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // Check if it's an error response
      if (data.containsKey('error')) {
        final error = data['error'];
        return ApiResponse.error(
          message: error['message'] ?? 'Unknown error',
          statusCode: error['code'],
          error: error is Map<String, dynamic> ? error : null,
        );
      }

      // Success response
      final responseData = data['data'] ?? data;
      return ApiResponse.success(
        data: fromJson != null ? fromJson(responseData) : responseData as T,
        message: data['message'],
        statusCode: response.statusCode,
      );
    }

    // Direct data response
    return ApiResponse.success(
      data: fromJson != null ? fromJson(data) : data as T,
      statusCode: response.statusCode,
    );
  }

  /// Process error response
  ApiResponse<T> _processError<T>(DioException error) {
    final exception = error.error;

    if (exception is ApiException) {
      return ApiResponse.error(
        message: exception.message,
        statusCode: exception.statusCode,
        error: exception.data is Map<String, dynamic>
            ? exception.data
            : {'message': exception.message},
      );
    }

    return ApiResponse.error(
      message: error.message ?? 'Unknown error occurred',
      statusCode: error.response?.statusCode,
    );
  }
}
