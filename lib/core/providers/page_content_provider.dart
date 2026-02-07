/// Page Content Providers
/// Riverpod providers for CMS page content
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/page_content_model.dart';
import '../services/page_content_service.dart';
import 'service_providers.dart';

/// Page Content Service Provider
final pageContentServiceProvider = Provider<PageContentService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PageContentService(apiClient);
});

/// Provider for a single public page by slug
/// Usage: ref.watch(publicPageProvider('about'))
final publicPageProvider = FutureProvider.family<PublicPageContent?, String>((ref, slug) async {
  final service = ref.watch(pageContentServiceProvider);
  final response = await service.getPublicPage(slug);

  if (response.success && response.data != null) {
    return response.data;
  }
  return null;
});

/// Provider for all public pages
final allPublicPagesProvider = FutureProvider<List<PublicPageContent>>((ref) async {
  final service = ref.watch(pageContentServiceProvider);
  final response = await service.getAllPublicPages();

  if (response.success && response.data != null) {
    return response.data!;
  }
  return [];
});

/// Provider for refreshing a specific page
final refreshPageProvider = Provider.family<Future<void> Function(), String>((ref, slug) {
  return () async {
    ref.invalidate(publicPageProvider(slug));
  };
});

// ============================================
// ADMIN PROVIDERS
// ============================================

/// State class for admin page list
class AdminPagesState {
  final List<PageContentModel> pages;
  final bool isLoading;
  final String? error;

  const AdminPagesState({
    this.pages = const [],
    this.isLoading = false,
    this.error,
  });

  AdminPagesState copyWith({
    List<PageContentModel>? pages,
    bool? isLoading,
    String? error,
  }) {
    return AdminPagesState(
      pages: pages ?? this.pages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for admin pages management
class AdminPagesNotifier extends StateNotifier<AdminPagesState> {
  final PageContentService _service;
  final Ref _ref;

  AdminPagesNotifier(this._service, this._ref) : super(const AdminPagesState());

  /// Load all pages for admin
  Future<void> loadPages() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _service.listAllPages();

    if (response.success && response.data != null) {
      state = state.copyWith(pages: response.data!, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.message ?? 'Failed to load pages',
      );
    }
  }

  /// Update a page
  Future<bool> updatePage(
    String slug, {
    String? title,
    String? subtitle,
    Map<String, dynamic>? content,
    String? metaDescription,
    String? status,
  }) async {
    final response = await _service.updatePage(
      slug,
      title: title,
      subtitle: subtitle,
      content: content,
      metaDescription: metaDescription,
      status: status,
    );

    if (response.success) {
      await loadPages(); // Refresh list
      // Also invalidate public page cache
      _ref.invalidate(publicPageProvider(slug));
      return true;
    }
    return false;
  }

  /// Publish a page
  Future<bool> publishPage(String slug) async {
    final response = await _service.publishPage(slug);

    if (response.success) {
      await loadPages();
      _ref.invalidate(publicPageProvider(slug));
      return true;
    }
    return false;
  }

  /// Unpublish a page
  Future<bool> unpublishPage(String slug) async {
    final response = await _service.unpublishPage(slug);

    if (response.success) {
      await loadPages();
      _ref.invalidate(publicPageProvider(slug));
      return true;
    }
    return false;
  }
}

/// Provider for admin pages state and actions
final adminPagesProvider = StateNotifierProvider<AdminPagesNotifier, AdminPagesState>((ref) {
  final service = ref.watch(pageContentServiceProvider);
  return AdminPagesNotifier(service, ref);
});

/// Provider for a single page being edited (admin)
final adminEditPageProvider = FutureProvider.family<PageContentModel?, String>((ref, slug) async {
  final service = ref.watch(pageContentServiceProvider);
  final response = await service.getPageForAdmin(slug);

  if (response.success && response.data != null) {
    return response.data;
  }
  return null;
});

/// Provider for valid page slugs
final validPageSlugsProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(pageContentServiceProvider);
  final response = await service.getValidSlugs();

  if (response.success && response.data != null) {
    return response.data!;
  }
  return [];
});

/// Provider for content template
final pageContentTemplateProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, slug) async {
  final service = ref.watch(pageContentServiceProvider);
  final response = await service.getContentTemplate(slug);

  if (response.success && response.data != null) {
    return response.data!;
  }
  return {};
});

// ============================================
// HELPER PROVIDERS FOR SPECIFIC PAGE TYPES
// ============================================

/// About page content
final aboutPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('about').future);
});

/// Contact page content
final contactPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('contact').future);
});

/// Privacy page content
final privacyPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('privacy').future);
});

/// Terms page content
final termsPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('terms').future);
});

/// Careers page content
final careersPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('careers').future);
});

/// Help center content
final helpPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('help').future);
});

/// Blog page content
final blogPageContentProvider = FutureProvider<PublicPageContent?>((ref) async {
  return ref.watch(publicPageProvider('blog').future);
});
