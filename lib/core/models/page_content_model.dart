/// Page Content Model
/// Represents CMS content for footer pages

class PageContentModel {
  final String id;
  final String pageSlug;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> content;
  final String? metaDescription;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;

  const PageContentModel({
    required this.id,
    required this.pageSlug,
    required this.title,
    this.subtitle,
    required this.content,
    this.metaDescription,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  /// Create from JSON (from backend API)
  factory PageContentModel.fromJson(Map<String, dynamic> json) {
    return PageContentModel(
      id: json['id']?.toString() ?? '',
      pageSlug: json['page_slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      content: json['content'] is Map<String, dynamic>
          ? json['content'] as Map<String, dynamic>
          : {},
      metaDescription: json['meta_description']?.toString(),
      status: json['status']?.toString() ?? 'draft',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      createdBy: json['created_by']?.toString(),
      updatedBy: json['updated_by']?.toString(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'page_slug': pageSlug,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'meta_description': metaDescription,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  /// Create a copy with updated fields
  PageContentModel copyWith({
    String? id,
    String? pageSlug,
    String? title,
    String? subtitle,
    Map<String, dynamic>? content,
    String? metaDescription,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return PageContentModel(
      id: id ?? this.id,
      pageSlug: pageSlug ?? this.pageSlug,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      metaDescription: metaDescription ?? this.metaDescription,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  /// Check if page is published
  bool get isPublished => status == 'published';

  /// Check if page is draft
  bool get isDraft => status == 'draft';

  /// Check if page is archived
  bool get isArchived => status == 'archived';

  @override
  String toString() {
    return 'PageContentModel(pageSlug: $pageSlug, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageContentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Simplified public page content (for frontend display)
class PublicPageContent {
  final String pageSlug;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> content;
  final String? metaDescription;

  const PublicPageContent({
    required this.pageSlug,
    required this.title,
    this.subtitle,
    required this.content,
    this.metaDescription,
  });

  factory PublicPageContent.fromJson(Map<String, dynamic> json) {
    return PublicPageContent(
      pageSlug: json['page_slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      content: json['content'] is Map<String, dynamic>
          ? json['content'] as Map<String, dynamic>
          : {},
      metaDescription: json['meta_description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_slug': pageSlug,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'meta_description': metaDescription,
    };
  }

  // Helper methods to get typed content

  /// Get string content value
  String getString(String key, {String defaultValue = ''}) {
    return content[key]?.toString() ?? defaultValue;
  }

  /// Get list content value
  List<dynamic> getList(String key) {
    final value = content[key];
    if (value is List) return value;
    return [];
  }

  /// Get map content value
  Map<String, dynamic> getMap(String key) {
    final value = content[key];
    if (value is Map<String, dynamic>) return value;
    return {};
  }

  /// Get sections for legal/policy pages
  List<ContentSection> getSections() {
    final sections = getList('sections');
    return sections
        .map((s) => ContentSection.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  /// Get FAQ items
  List<FaqItem> getFaqs() {
    final faqs = getList('faqs');
    return faqs.map((f) => FaqItem.fromJson(f as Map<String, dynamic>)).toList();
  }

  /// Get team members
  List<TeamMember> getTeam() {
    final team = getList('team');
    return team
        .map((t) => TeamMember.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  /// Get values
  List<ValueItem> getValues() {
    final values = getList('values');
    return values
        .map((v) => ValueItem.fromJson(v as Map<String, dynamic>))
        .toList();
  }

  /// Get benefits (for careers)
  List<BenefitItem> getBenefits() {
    final benefits = getList('benefits');
    return benefits
        .map((b) => BenefitItem.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  /// Get positions (for careers)
  List<PositionItem> getPositions() {
    final positions = getList('positions');
    return positions
        .map((p) => PositionItem.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Get press releases
  List<PressRelease> getPressReleases() {
    final releases = getList('releases');
    return releases
        .map((r) => PressRelease.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Get blog posts
  List<BlogPost> getBlogPosts() {
    final posts = getList('featured_posts');
    return posts
        .map((p) => BlogPost.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Get app features (for mobile apps page)
  List<FeatureItem> getFeatures() {
    final features = getList('features');
    return features
        .map((f) => FeatureItem.fromJson(f as Map<String, dynamic>))
        .toList();
  }
}

/// Section content for policy/legal pages
class ContentSection {
  final String title;
  final String content;

  const ContentSection({required this.title, required this.content});

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}

/// FAQ item
class FaqItem {
  final String question;
  final String answer;
  final String? category;

  const FaqItem({required this.question, required this.answer, this.category});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      category: json['category']?.toString(),
    );
  }
}

/// Team member
class TeamMember {
  final String name;
  final String? role;
  final String? description;
  final String? imageUrl;

  const TeamMember({
    required this.name,
    this.role,
    this.description,
    this.imageUrl,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

/// Value item
class ValueItem {
  final String title;
  final String description;

  const ValueItem({required this.title, required this.description});

  factory ValueItem.fromJson(Map<String, dynamic> json) {
    return ValueItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

/// Benefit item (for careers)
class BenefitItem {
  final String title;
  final String description;

  const BenefitItem({required this.title, required this.description});

  factory BenefitItem.fromJson(Map<String, dynamic> json) {
    return BenefitItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

/// Position item (for careers)
class PositionItem {
  final String title;
  final String? department;
  final String? location;
  final String? type;

  const PositionItem({
    required this.title,
    this.department,
    this.location,
    this.type,
  });

  factory PositionItem.fromJson(Map<String, dynamic> json) {
    return PositionItem(
      title: json['title']?.toString() ?? '',
      department: json['department']?.toString(),
      location: json['location']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

/// Press release
class PressRelease {
  final String title;
  final String? date;
  final String? excerpt;

  const PressRelease({required this.title, this.date, this.excerpt});

  factory PressRelease.fromJson(Map<String, dynamic> json) {
    return PressRelease(
      title: json['title']?.toString() ?? '',
      date: json['date']?.toString(),
      excerpt: json['excerpt']?.toString(),
    );
  }
}

/// Blog post
class BlogPost {
  final String title;
  final String? excerpt;
  final String? author;
  final String? date;
  final String? category;
  final String? slug;

  const BlogPost({
    required this.title,
    this.excerpt,
    this.author,
    this.date,
    this.category,
    this.slug,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      title: json['title']?.toString() ?? '',
      excerpt: json['excerpt']?.toString(),
      author: json['author']?.toString(),
      date: json['date']?.toString(),
      category: json['category']?.toString(),
      slug: json['slug']?.toString(),
    );
  }
}

/// Feature item (for mobile apps)
class FeatureItem {
  final String title;
  final String description;

  const FeatureItem({required this.title, required this.description});

  factory FeatureItem.fromJson(Map<String, dynamic> json) {
    return FeatureItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}
