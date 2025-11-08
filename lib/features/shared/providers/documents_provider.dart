import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/document_model.dart';

const _uuid = Uuid();

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
  DocumentsNotifier() : super(const DocumentsState()) {
    fetchDocuments();
  }

  /// Fetch all documents and folders for current user
  /// TODO: Connect to backend API (Firebase Firestore & Storage)
  Future<void> fetchDocuments() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Fetch both documents and folders

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockFolders = [
        DocumentFolder(
          id: 'folder_1',
          name: 'Transcripts',
          documentCount: 3,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        DocumentFolder(
          id: 'folder_2',
          name: 'Certificates',
          documentCount: 5,
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        DocumentFolder(
          id: 'folder_3',
          name: 'Recommendations',
          documentCount: 2,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];

      final mockDocuments = List<Document>.generate(
        10,
        (index) => Document.mockDocument(index),
      );

      state = state.copyWith(
        documents: mockDocuments,
        folders: mockFolders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch documents: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Upload a document
  /// TODO: Connect to backend API (Firebase Storage & Firestore)
  Future<bool> uploadDocument(Document document) async {
    try {
      // TODO: Upload file to Firebase Storage
      // TODO: Save metadata to Firestore

      await Future.delayed(const Duration(seconds: 2));

      final updatedDocuments = [...state.documents, document];
      state = state.copyWith(documents: updatedDocuments);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to upload document: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete a document
  /// TODO: Connect to backend API (Firebase Storage & Firestore)
  Future<bool> deleteDocument(String documentId) async {
    try {
      // TODO: Delete file from Firebase Storage
      // TODO: Delete metadata from Firestore

      await Future.delayed(const Duration(milliseconds: 500));

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

  /// Create a folder
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> createFolder(String folderName) async {
    try {
      // TODO: Create folder in Firestore

      await Future.delayed(const Duration(milliseconds: 300));

      final newFolder = DocumentFolder(
        id: _uuid.v4(),
        name: folderName,
        documentCount: 0,
        createdAt: DateTime.now(),
      );

      final updatedFolders = [...state.folders, newFolder];
      state = state.copyWith(folders: updatedFolders);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create folder: ${e.toString()}',
      );
      return false;
    }
  }

  /// Move document to folder
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> moveToFolder(String documentId, String folderId) async {
    try {
      // TODO: Update document category/folder in Firestore

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedDocuments = state.documents.map((doc) {
        if (doc.id == documentId) {
          return doc.copyWith(category: folderId);
        }
        return doc;
      }).toList().cast<Document>();

      state = state.copyWith(documents: updatedDocuments);

      return true;
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
  return DocumentsNotifier();
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
