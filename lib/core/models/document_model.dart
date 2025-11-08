class Document {
  final String id;
  final String name;
  final String type; // pdf, doc, docx, image, etc.
  final int size; // in bytes
  final String? url;
  final String uploadedBy;
  final String? uploadedByName;
  final DateTime uploadedAt;
  final String category; // transcript, certificate, id, essay, recommendation, etc.
  final String? description;
  final bool isVerified;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    this.url,
    required this.uploadedBy,
    this.uploadedByName,
    required this.uploadedAt,
    required this.category,
    this.description,
    this.isVerified = false,
  });

  String get formattedSize {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get fileExtension {
    final parts = name.split('.');
    return parts.isNotEmpty ? parts.last.toUpperCase() : type.toUpperCase();
  }

  String get categoryDisplayName {
    switch (category) {
      case 'transcript':
        return 'Transcript';
      case 'certificate':
        return 'Certificate';
      case 'id':
        return 'ID Document';
      case 'essay':
        return 'Essay';
      case 'recommendation':
        return 'Recommendation Letter';
      case 'resume':
        return 'Resume/CV';
      case 'portfolio':
        return 'Portfolio';
      default:
        return category;
    }
  }

  bool get isPDF => type.toLowerCase() == 'pdf';
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'webp']
      .contains(type.toLowerCase());
  bool get isDocument => ['doc', 'docx', 'txt', 'rtf']
      .contains(type.toLowerCase());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'size': size,
      'url': url,
      'uploadedBy': uploadedBy,
      'uploadedByName': uploadedByName,
      'uploadedAt': uploadedAt.toIso8601String(),
      'category': category,
      'description': description,
      'isVerified': isVerified,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
      url: json['url'] as String?,
      uploadedBy: json['uploadedBy'] as String,
      uploadedByName: json['uploadedByName'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      category: json['category'] as String,
      description: json['description'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Document copyWith({
    String? id,
    String? name,
    String? type,
    int? size,
    String? url,
    String? uploadedBy,
    String? uploadedByName,
    DateTime? uploadedAt,
    String? category,
    String? description,
    bool? isVerified,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      url: url ?? this.url,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedByName: uploadedByName ?? this.uploadedByName,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      category: category ?? this.category,
      description: description ?? this.description,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  /// Single mock document for development
  static Document mockDocument([int index = 0]) {
    final categories = ['transcript', 'certificate', 'id', 'essay', 'recommendation'];
    final types = ['pdf', 'pdf', 'pdf', 'docx', 'pdf'];
    final names = [
      'Transcript.pdf',
      'Certificate.pdf',
      'ID_Document.pdf',
      'Essay.docx',
      'Recommendation.pdf',
    ];
    final sizes = [2457600, 1048576, 524288, 786432, 614400];

    return Document(
      id: 'doc${index + 1}',
      name: names[index % names.length],
      type: types[index % types.length],
      size: sizes[index % sizes.length],
      url: 'https://example.com/docs/${names[index % names.length]}',
      uploadedBy: 'user${(index % 3) + 1}',
      uploadedByName: 'User ${(index % 3) + 1}',
      uploadedAt: DateTime.now().subtract(Duration(days: index + 1)),
      category: categories[index % categories.length],
      description: 'Mock document ${index + 1}',
      isVerified: index % 2 == 0,
    );
  }

  static List<Document> mockDocuments({String? userId}) {
    return [
      Document(
        id: 'doc1',
        name: 'High_School_Transcript.pdf',
        type: 'pdf',
        size: 2457600, // 2.4 MB
        url: 'https://example.com/docs/transcript.pdf',
        uploadedBy: userId ?? 'user1',
        uploadedByName: 'John Doe',
        uploadedAt: DateTime.now().subtract(const Duration(days: 15)),
        category: 'transcript',
        description: 'Official high school transcript for 2020-2024',
        isVerified: true,
      ),
      Document(
        id: 'doc2',
        name: 'Birth_Certificate.pdf',
        type: 'pdf',
        size: 1048576, // 1 MB
        url: 'https://example.com/docs/birth_cert.pdf',
        uploadedBy: userId ?? 'user1',
        uploadedByName: 'John Doe',
        uploadedAt: DateTime.now().subtract(const Duration(days: 12)),
        category: 'id',
        description: 'Certified copy of birth certificate',
        isVerified: true,
      ),
      Document(
        id: 'doc3',
        name: 'Personal_Statement.docx',
        type: 'docx',
        size: 524288, // 512 KB
        url: 'https://example.com/docs/statement.docx',
        uploadedBy: userId ?? 'user1',
        uploadedByName: 'John Doe',
        uploadedAt: DateTime.now().subtract(const Duration(days: 8)),
        category: 'essay',
        description: 'Personal statement for university application',
        isVerified: false,
      ),
      Document(
        id: 'doc4',
        name: 'Recommendation_Letter_Prof_Smith.pdf',
        type: 'pdf',
        size: 786432, // 768 KB
        url: 'https://example.com/docs/recommendation.pdf',
        uploadedBy: 'recommender1',
        uploadedByName: 'Prof. Michael Smith',
        uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'recommendation',
        description: 'Recommendation from Mathematics Professor',
        isVerified: true,
      ),
      Document(
        id: 'doc5',
        name: 'Resume_2024.pdf',
        type: 'pdf',
        size: 614400, // 600 KB
        url: 'https://example.com/docs/resume.pdf',
        uploadedBy: userId ?? 'user1',
        uploadedByName: 'John Doe',
        uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: 'resume',
        description: 'Updated resume with recent achievements',
        isVerified: false,
      ),
      Document(
        id: 'doc6',
        name: 'Achievement_Certificate.jpg',
        type: 'jpg',
        size: 1572864, // 1.5 MB
        url: 'https://example.com/docs/cert.jpg',
        uploadedBy: userId ?? 'user1',
        uploadedByName: 'John Doe',
        uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'certificate',
        description: 'Mathematics competition first place certificate',
        isVerified: false,
      ),
    ];
  }
}

class DocumentFolder {
  final String id;
  final String name;
  final String? description;
  final int documentCount;
  final DateTime createdAt;
  final String? category;

  DocumentFolder({
    required this.id,
    required this.name,
    this.description,
    required this.documentCount,
    required this.createdAt,
    this.category,
  });

  static List<DocumentFolder> mockFolders() {
    return [
      DocumentFolder(
        id: 'folder1',
        name: 'Academic Records',
        description: 'Transcripts, certificates, and diplomas',
        documentCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        category: 'transcript',
      ),
      DocumentFolder(
        id: 'folder2',
        name: 'Application Documents',
        description: 'Essays, statements, and resumes',
        documentCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        category: 'essay',
      ),
      DocumentFolder(
        id: 'folder3',
        name: 'Recommendations',
        description: 'Letters of recommendation',
        documentCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        category: 'recommendation',
      ),
      DocumentFolder(
        id: 'folder4',
        name: 'Identification',
        description: 'ID cards, passports, birth certificates',
        documentCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'id',
      ),
    ];
  }
}
