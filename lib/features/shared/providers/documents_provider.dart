import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/document_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing documents
class DocumentsState {
  final List<Document> documents;
  final List<DocumentFolder> folders;
  final String? selectedFolderId;
  final bool isLoading;
  final String? error;

  const DocumentsState({
    this.documents = const [],
    this.folders = const [],
    this.selectedFolderId,
    this.isLoading = false,
    this.error,
  });

  DocumentsState copyWith({
    List<Document>? documents,
    List<DocumentFolder>? folders,
    String? selectedFolderId,
    bool? isLoading,
    String? error,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      folders: folders ?? this.folders,
      selectedFolderId: selectedFolderId ?? this.selectedFolderId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing documents
class DocumentsNotifier extends StateNotifier<DocumentsState> {
  final ApiClient _apiClient;

  DocumentsNotifier(this._apiClient) : super(const DocumentsState()) {
    fetchDocuments();
  }

  /// Fetch all documents for current user from backend API
  Future<void> fetchDocuments() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.documents}',
        fromJson: (data) {
          if (data is List) {
            return data.map((docJson) => Document.fromJson(docJson)).toList();
          }
          return <Document>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          documents: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch documents',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch documents: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Upload a document via backend API
  /// Note: File upload should be handled separately, this creates document metadata
  Future<bool> uploadDocument({
    required String fileName,
    required String fileType,
    required int fileSize,
    required String filePath,
    String? folderId,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.documents,
        data: {
          'file_name': fileName,
          'file_type': fileType,
          'file_size': fileSize,
          'file_path': filePath,
          if (folderId != null) 'folder_id': folderId,
          if (description != null) 'description': description,
        },
        fromJson: (data) => Document.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedDocuments = [...state.documents, response.data!];
        state = state.copyWith(documents: updatedDocuments);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to upload document',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to upload document: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete a document via backend API
  Future<bool> deleteDocument(String documentId) async {
    try {
      await _apiClient.delete('${ApiConfig.documents}/$documentId');

      final updatedDocuments = state.documents
          .where((doc) => doc.id != documentId)
          .toList();

      state = state.copyWith(documents: updatedDocuments);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete document: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update document metadata via backend API
  Future<bool> updateDocument(String documentId, {
    String? fileName,
    String? description,
    String? category,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.documents}/$documentId',
        data: {
          if (fileName != null) 'file_name': fileName,
          if (description != null) 'description': description,
          if (category != null) 'category': category,
        },
        fromJson: (data) => Document.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedDocuments = state.documents.map((doc) {
          return doc.id == documentId ? response.data! : doc;
        }).toList();

        state = state.copyWith(documents: updatedDocuments);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update document: ${e.toString()}',
      );
      return false;
    }
  }

  /// Move document to folder (update category)
  Future<bool> moveToFolder(String documentId, String category) async {
    try {
      return await updateDocument(documentId, category: category);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to move document: ${e.toString()}',
      );
      return false;
    }
  }

  /// Select folder
  void selectFolder(String? folderId) {
    state = state.copyWith(selectedFolderId: folderId);
  }

  /// Get documents in selected folder
  List<Document> getDocumentsInFolder(String? folderId) {
    if (folderId == null) return state.documents;

    return state.documents.where((doc) => doc.category == folderId).toList();
  }

  /// Filter documents by type
  List<Document> filterByType(String type) {
    if (type == 'all') return state.documents;

    return state.documents.where((doc) => doc.type == type).toList();
  }

  /// Filter documents by category
  List<Document> filterByCategory(String category) {
    if (category == 'all') return state.documents;

    return state.documents.where((doc) => doc.category == category).toList();
  }

  /// Search documents
  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return state.documents;

    final lowerQuery = query.toLowerCase();
    return state.documents.where((doc) {
      return doc.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get document statistics
  Map<String, dynamic> getDocumentStatistics() {
    final Map<String, int> typeCounts = {};
    int totalSize = 0;
    int verifiedCount = 0;

    for (final doc in state.documents) {
      typeCounts[doc.type] = (typeCounts[doc.type] ?? 0) + 1;
      totalSize += doc.size;
      if (doc.isVerified) verifiedCount++;
    }

    return {
      'total': state.documents.length,
      'verified': verifiedCount,
      'unverified': state.documents.length - verifiedCount,
      'totalSize': totalSize,
      'typeCounts': typeCounts,
      'folderCount': state.folders.length,
    };
  }
}

/// Provider for documents state
final documentsProvider = StateNotifierProvider<DocumentsNotifier, DocumentsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DocumentsNotifier(apiClient);
});

/// Provider for documents list
final documentsListProvider = Provider<List<Document>>((ref) {
  final documentsState = ref.watch(documentsProvider);
  return documentsState.documents;
});

/// Provider for folders list
final foldersListProvider = Provider<List<DocumentFolder>>((ref) {
  final documentsState = ref.watch(documentsProvider);
  return documentsState.folders;
});

/// Provider for document statistics
final documentStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(documentsProvider.notifier);
  return notifier.getDocumentStatistics();
});

/// Provider for checking if documents are loading
final documentsLoadingProvider = Provider<bool>((ref) {
  final documentsState = ref.watch(documentsProvider);
  return documentsState.isLoading;
});

/// Provider for documents error
final documentsErrorProvider = Provider<String?>((ref) {
  final documentsState = ref.watch(documentsProvider);
  return documentsState.error;
});

/// Provider for document folders list
final documentFoldersListProvider = Provider<List<DocumentFolder>>((ref) {
  final documentsState = ref.watch(documentsProvider);
  return documentsState.folders;
});
