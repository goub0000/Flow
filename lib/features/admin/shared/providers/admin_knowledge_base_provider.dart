import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chatbot/services/faq_api_service.dart';

/// State class for Knowledge Base admin
class AdminKnowledgeBaseState {
  final List<FAQ> faqs;
  final bool isLoading;
  final String? error;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  const AdminKnowledgeBaseState({
    this.faqs = const [],
    this.isLoading = false,
    this.error,
    this.totalCount = 0,
    this.activeCount = 0,
    this.inactiveCount = 0,
  });

  AdminKnowledgeBaseState copyWith({
    List<FAQ>? faqs,
    bool? isLoading,
    String? error,
    int? totalCount,
    int? activeCount,
    int? inactiveCount,
  }) {
    return AdminKnowledgeBaseState(
      faqs: faqs ?? this.faqs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalCount: totalCount ?? this.totalCount,
      activeCount: activeCount ?? this.activeCount,
      inactiveCount: inactiveCount ?? this.inactiveCount,
    );
  }
}

/// StateNotifier for Knowledge Base admin
class AdminKnowledgeBaseNotifier extends StateNotifier<AdminKnowledgeBaseState> {
  final FAQApiService _faqService;

  AdminKnowledgeBaseNotifier(this._faqService) : super(const AdminKnowledgeBaseState()) {
    fetchFAQs();
  }

  /// Fetch all FAQs
  Future<void> fetchFAQs({String? category, String? search}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _faqService.listFAQs(
        pageSize: 200,
        category: category,
        search: search,
      );

      final faqs = response.faqs;
      final activeCount = faqs.where((f) => f.isActive).length;
      final inactiveCount = faqs.where((f) => !f.isActive).length;

      state = state.copyWith(
        faqs: faqs,
        isLoading: false,
        totalCount: faqs.length,
        activeCount: activeCount,
        inactiveCount: inactiveCount,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch FAQs: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new FAQ
  Future<bool> createFAQ(FAQCreateRequest request) async {
    try {
      await _faqService.createFAQ(request);
      await fetchFAQs();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create FAQ: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update an existing FAQ
  Future<bool> updateFAQ(String faqId, FAQUpdateRequest request) async {
    try {
      await _faqService.updateFAQ(faqId, request);
      await fetchFAQs();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update FAQ: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete a FAQ
  Future<bool> deleteFAQ(String faqId) async {
    try {
      await _faqService.deleteFAQ(faqId);
      await fetchFAQs();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete FAQ: ${e.toString()}',
      );
      return false;
    }
  }

  /// Toggle FAQ active status
  Future<bool> toggleActive(String faqId, bool isActive) async {
    try {
      await _faqService.toggleFAQActive(faqId, isActive);
      await fetchFAQs();
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to toggle FAQ status: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider for Knowledge Base admin state
final adminKnowledgeBaseProvider =
    StateNotifierProvider<AdminKnowledgeBaseNotifier, AdminKnowledgeBaseState>((ref) {
  final faqService = ref.watch(faqApiServiceProvider);
  return AdminKnowledgeBaseNotifier(faqService);
});
