/// API Response Models
/// Generic response wrapper for API calls

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.error,
  });

  /// Create a successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode ?? 200,
    );
  }

  /// Create an error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? error,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  /// Create from JSON response
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    // Check if response has error field
    if (json.containsKey('error')) {
      final errorData = json['error'];
      return ApiResponse.error(
        message: errorData['message'] ?? 'Unknown error',
        statusCode: errorData['code'],
        error: errorData is Map<String, dynamic> ? errorData : null,
      );
    }

    // Success response
    final data = json['data'];
    return ApiResponse.success(
      data: fromJsonT != null ? fromJsonT(data) : data as T,
      message: json['message'],
      statusCode: json['status_code'],
    );
  }

  /// Check if response has data
  bool get hasData => data != null;

  /// Get data or throw exception
  T get dataOrThrow {
    if (data != null) {
      return data!;
    }
    throw Exception(message ?? 'No data available');
  }
}

/// Paginated response model
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    // Support multiple field names for the list items
    // Backend may return 'items', 'conversations', 'messages', 'data', etc.
    final itemsList = (json['items'] ??
                       json['conversations'] ??
                       json['messages'] ??
                       json['data'] ??
                       []) as List;
    return PaginatedResponse(
      items: itemsList.map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? itemsList.length,
      totalPages: json['total_pages'] ?? 1,
      hasNext: json['has_next'] ?? json['has_more'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}
