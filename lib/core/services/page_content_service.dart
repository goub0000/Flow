/// Page Content Service
/// Service for fetching and managing CMS page content
library;

import 'package:logging/logging.dart';
import '../api/api_client.dart';
import '../api/api_response.dart';
import '../models/page_content_model.dart';

class PageContentService {
  final ApiClient _apiClient;
  final _logger = Logger('PageContentService');

  // Cache for public pages
  final Map<String, PublicPageContent> _cache = {};
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(minutes: 5);

  PageContentService(this._apiClient);

  // ============================================
  // PUBLIC ENDPOINTS
  // ============================================

  /// Get published page content by slug (public access)
  Future<ApiResponse<PublicPageContent>> getPublicPage(String slug) async {
    // Check cache first
    if (_isCacheValid && _cache.containsKey(slug)) {
      return ApiResponse.success(data: _cache[slug]!);
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/pages/$slug',
      );

      if (response.success && response.data != null) {
        final content = PublicPageContent.fromJson(response.data!);
        _cache[slug] = content;
        _cacheTime ??= DateTime.now();
        return ApiResponse.success(data: content);
      }

      return ApiResponse.error(
        message: response.message ?? 'Page not found',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error fetching page $slug: $e');
      return ApiResponse.error(message: 'Failed to fetch page: $e');
    }
  }

  /// Get all published pages (public access)
  Future<ApiResponse<List<PublicPageContent>>> getAllPublicPages() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/pages');

      if (response.success && response.data != null) {
        final pages = response.data!
            .map((json) => PublicPageContent.fromJson(json as Map<String, dynamic>))
            .toList();

        // Update cache
        _cacheTime = DateTime.now();
        for (final page in pages) {
          _cache[page.pageSlug] = page;
        }

        return ApiResponse.success(data: pages);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to fetch pages',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error fetching all pages: $e');
      return ApiResponse.error(message: 'Failed to fetch pages: $e');
    }
  }

  // ============================================
  // ADMIN ENDPOINTS
  // ============================================

  /// List all pages for admin dashboard
  Future<ApiResponse<List<PageContentModel>>> listAllPages() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/admin/pages');

      if (response.success && response.data != null) {
        final pages = response.data!
            .map((json) => PageContentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(data: pages);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to fetch pages',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error listing pages: $e');
      return ApiResponse.error(message: 'Failed to list pages: $e');
    }
  }

  /// Get page for admin editing
  Future<ApiResponse<PageContentModel>> getPageForAdmin(String slug) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/pages/$slug',
      );

      if (response.success && response.data != null) {
        final content = PageContentModel.fromJson(response.data!);
        return ApiResponse.success(data: content);
      }

      return ApiResponse.error(
        message: response.message ?? 'Page not found',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error fetching page $slug for admin: $e');
      return ApiResponse.error(message: 'Failed to fetch page: $e');
    }
  }

  /// Update page content
  Future<ApiResponse<PageContentModel>> updatePage(
    String slug, {
    String? title,
    String? subtitle,
    Map<String, dynamic>? content,
    String? metaDescription,
    String? status,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (subtitle != null) updateData['subtitle'] = subtitle;
      if (content != null) updateData['content'] = content;
      if (metaDescription != null) updateData['meta_description'] = metaDescription;
      if (status != null) updateData['status'] = status;

      final response = await _apiClient.put<Map<String, dynamic>>(
        '/admin/pages/$slug',
        data: updateData,
      );

      if (response.success && response.data != null) {
        final updatedContent = PageContentModel.fromJson(response.data!);
        // Invalidate cache
        _cache.remove(slug);
        return ApiResponse.success(data: updatedContent);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to update page',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error updating page $slug: $e');
      return ApiResponse.error(message: 'Failed to update page: $e');
    }
  }

  /// Publish page
  Future<ApiResponse<PageContentModel>> publishPage(String slug) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/admin/pages/$slug/publish',
      );

      if (response.success && response.data != null) {
        final updatedContent = PageContentModel.fromJson(response.data!);
        // Invalidate cache
        _cache.remove(slug);
        return ApiResponse.success(data: updatedContent);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to publish page',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error publishing page $slug: $e');
      return ApiResponse.error(message: 'Failed to publish page: $e');
    }
  }

  /// Unpublish page
  Future<ApiResponse<PageContentModel>> unpublishPage(String slug) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/admin/pages/$slug/unpublish',
      );

      if (response.success && response.data != null) {
        final updatedContent = PageContentModel.fromJson(response.data!);
        // Invalidate cache
        _cache.remove(slug);
        return ApiResponse.success(data: updatedContent);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to unpublish page',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error unpublishing page $slug: $e');
      return ApiResponse.error(message: 'Failed to unpublish page: $e');
    }
  }

  /// Get valid page slugs
  Future<ApiResponse<List<String>>> getValidSlugs() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/admin/pages/slugs');

      if (response.success && response.data != null) {
        final slugs = response.data!.map((s) => s.toString()).toList();
        return ApiResponse.success(data: slugs);
      }

      return ApiResponse.error(
        message: response.message ?? 'Failed to fetch slugs',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error fetching slugs: $e');
      return ApiResponse.error(message: 'Failed to fetch slugs: $e');
    }
  }

  /// Get content template for a page type
  Future<ApiResponse<Map<String, dynamic>>> getContentTemplate(String slug) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/admin/pages/template/$slug',
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(data: response.data!);
      }

      return ApiResponse.error(
        message: response.message ?? 'Template not found',
        statusCode: response.statusCode,
      );
    } catch (e) {
      _logger.warning('Error fetching template for $slug: $e');
      return ApiResponse.error(message: 'Failed to fetch template: $e');
    }
  }

  // ============================================
  // CACHE MANAGEMENT
  // ============================================

  /// Check if cache is valid
  bool get _isCacheValid {
    if (_cacheTime == null) return false;
    return DateTime.now().difference(_cacheTime!) < _cacheDuration;
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
    _cacheTime = null;
  }

  /// Refresh a specific page in cache
  Future<void> refreshPage(String slug) async {
    _cache.remove(slug);
    await getPublicPage(slug);
  }
}
