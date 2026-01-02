import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/providers/service_providers.dart';

/// FAQ API Service for admin management
class FAQApiService {
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final AuthService? _authService;

  FAQApiService({
    http.Client? client,
    AuthService? authService,
  })  : _client = client ?? http.Client(),
        _authService = authService;

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_authService != null) {
      final token = _authService.accessToken;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// List FAQs with pagination and filters
  Future<FAQListResponse> listFAQs({
    int page = 1,
    int pageSize = 20,
    String? category,
    String? search,
    bool activeOnly = false,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        'active_only': activeOnly.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('$baseUrl/chatbot/faqs')
          .replace(queryParameters: queryParams);

      final headers = _buildHeaders();
      final response = await _client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return FAQListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load FAQs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching FAQs: $e');
    }
  }

  /// Create new FAQ
  Future<FAQ> createFAQ(FAQCreateRequest request) async {
    try {
      final headers = _buildHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/chatbot/admin/faqs'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return FAQ.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Admin access required');
      } else {
        throw Exception('Failed to create FAQ: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating FAQ: $e');
    }
  }

  /// Update existing FAQ
  Future<FAQ> updateFAQ(String faqId, FAQUpdateRequest request) async {
    try {
      final headers = _buildHeaders();
      final response = await _client.put(
        Uri.parse('$baseUrl/chatbot/admin/faqs/$faqId'),
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return FAQ.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('FAQ not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to update FAQ: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating FAQ: $e');
    }
  }

  /// Delete FAQ
  Future<void> deleteFAQ(String faqId) async {
    try {
      final headers = _buildHeaders();
      final response = await _client.delete(
        Uri.parse('$baseUrl/chatbot/admin/faqs/$faqId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete FAQ: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting FAQ: $e');
    }
  }

  /// Toggle FAQ active status
  Future<FAQ> toggleFAQActive(String faqId, bool isActive) async {
    return updateFAQ(faqId, FAQUpdateRequest(isActive: isActive));
  }
}

/// Riverpod provider for FAQ API service
final faqApiServiceProvider = Provider<FAQApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return FAQApiService(authService: authService);
});

/// FAQ Model
class FAQ {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final String category;
  final int priority;
  final bool isActive;
  final int usageCount;
  final int helpfulCount;
  final int notHelpfulCount;
  final List<Map<String, dynamic>>? quickActions;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.category,
    required this.priority,
    required this.isActive,
    required this.usageCount,
    required this.helpfulCount,
    required this.notHelpfulCount,
    this.quickActions,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  double get helpfulPercentage {
    final total = helpfulCount + notHelpfulCount;
    if (total == 0) return 0;
    return helpfulCount / total * 100;
  }

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      keywords: (json['keywords'] as List?)?.cast<String>() ?? [],
      category: json['category'] as String? ?? 'general',
      priority: json['priority'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      usageCount: json['usage_count'] as int? ?? 0,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      notHelpfulCount: json['not_helpful_count'] as int? ?? 0,
      quickActions: (json['quick_actions'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// FAQ List Response
class FAQListResponse {
  final List<FAQ> faqs;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  FAQListResponse({
    required this.faqs,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory FAQListResponse.fromJson(Map<String, dynamic> json) {
    return FAQListResponse(
      faqs: (json['faqs'] as List).map((e) => FAQ.fromJson(e)).toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      hasMore: json['has_more'] as bool,
    );
  }
}

/// FAQ Create Request
class FAQCreateRequest {
  final String question;
  final String answer;
  final List<String> keywords;
  final String category;
  final int priority;
  final List<Map<String, dynamic>>? quickActions;

  FAQCreateRequest({
    required this.question,
    required this.answer,
    required this.keywords,
    required this.category,
    this.priority = 0,
    this.quickActions,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'keywords': keywords,
      'category': category,
      'priority': priority,
      if (quickActions != null) 'quick_actions': quickActions,
    };
  }
}

/// FAQ Update Request
class FAQUpdateRequest {
  final String? question;
  final String? answer;
  final List<String>? keywords;
  final String? category;
  final int? priority;
  final bool? isActive;
  final List<Map<String, dynamic>>? quickActions;

  FAQUpdateRequest({
    this.question,
    this.answer,
    this.keywords,
    this.category,
    this.priority,
    this.isActive,
    this.quickActions,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (question != null) json['question'] = question;
    if (answer != null) json['answer'] = answer;
    if (keywords != null) json['keywords'] = keywords;
    if (category != null) json['category'] = category;
    if (priority != null) json['priority'] = priority;
    if (isActive != null) json['is_active'] = isActive;
    if (quickActions != null) json['quick_actions'] = quickActions;
    return json;
  }
}
