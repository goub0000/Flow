import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Notes & Study Tools Widgets
///
/// Comprehensive note-taking and study tools UI components including:
/// - Note cards with preview and actions
/// - Category and tag chips
/// - Note editor components
/// - Search and filter widgets
/// - Study mode components (flashcards, highlights)
///
/// Backend Integration TODO:
/// ```dart
/// // Option 1: Firebase Firestore for real-time sync
/// import 'package:cloud_firestore/cloud_firestore.dart';
///
/// class NotesRepository {
///   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
///   final String userId;
///
///   CollectionReference get _notesCollection =>
///       _firestore.collection('users').doc(userId).collection('notes');
///
///   Stream<List<NoteModel>> watchNotes({String? categoryId}) {
///     Query query = _notesCollection.orderBy('updatedAt', descending: true);
///
///     if (categoryId != null) {
///       query = query.where('categoryId', isEqualTo: categoryId);
///     }
///
///     return query.snapshots().map((snapshot) {
///       return snapshot.docs
///           .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
///           .toList();
///     });
///   }
///
///   Future<void> createNote(NoteModel note) async {
///     await _notesCollection.doc(note.id).set(note.toJson());
///   }
///
///   Future<void> updateNote(NoteModel note) async {
///     await _notesCollection.doc(note.id).update({
///       ...note.toJson(),
///       'updatedAt': FieldValue.serverTimestamp(),
///     });
///   }
///
///   Future<void> deleteNote(String noteId) async {
///     await _notesCollection.doc(noteId).delete();
///   }
///
///   Future<List<NoteModel>> searchNotes(String query) async {
///     // Note: Firestore doesn't support full-text search natively
///     // Consider using Algolia or ElasticSearch for better search
///     final snapshot = await _notesCollection
///         .where('title', isGreaterThanOrEqualTo: query)
///         .where('title', isLessThanOrEqualTo: '$query\uf8ff')
///         .get();
///
///     return snapshot.docs
///         .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>))
///         .toList();
///   }
/// }
///
/// // Option 2: REST API with offline support
/// import 'package:dio/dio.dart';
/// import 'package:hive/hive.dart';
///
/// class NotesService {
///   final Dio _dio;
///   final Box<NoteModel> _notesCache;
///
///   Future<List<NoteModel>> getNotes({
///     String? categoryId,
///     List<String>? tags,
///     String? searchQuery,
///   }) async {
///     try {
///       final response = await _dio.get('/api/notes', queryParameters: {
///         'categoryId': categoryId,
///         'tags': tags?.join(','),
///         'q': searchQuery,
///       });
///
///       final notes = (response.data['notes'] as List)
///           .map((json) => NoteModel.fromJson(json))
///           .toList();
///
///       // Cache for offline access
///       for (final note in notes) {
///         await _notesCache.put(note.id, note);
///       }
///
///       return notes;
///     } catch (e) {
///       // Return cached data if offline
///       return _notesCache.values.toList();
///     }
///   }
///
///   Future<NoteModel> createNote(NoteModel note) async {
///     final response = await _dio.post('/api/notes', data: note.toJson());
///     final createdNote = NoteModel.fromJson(response.data);
///     await _notesCache.put(createdNote.id, createdNote);
///     return createdNote;
///   }
///
///   Future<void> updateNote(NoteModel note) async {
///     await _dio.put('/api/notes/${note.id}', data: note.toJson());
///     await _notesCache.put(note.id, note);
///   }
///
///   Future<void> deleteNote(String noteId) async {
///     await _dio.delete('/api/notes/$noteId');
///     await _notesCache.delete(noteId);
///   }
///
///   Future<void> syncNotes() async {
///     // Implement offline changes sync
///     final pendingChanges = await _getPendingChanges();
///     for (final change in pendingChanges) {
///       await _syncChange(change);
///     }
///   }
/// }
///
/// // Rich text editor integration
/// import 'package:flutter_quill/flutter_quill.dart';
///
/// class RichTextNote {
///   Document document;
///
///   String toJson() {
///     return jsonEncode(document.toDelta().toJson());
///   }
///
///   factory RichTextNote.fromJson(String json) {
///     final delta = Delta.fromJson(jsonDecode(json));
///     return RichTextNote(document: Document.fromDelta(delta));
///   }
/// }
/// ```

/// Note Priority Enum
enum NotePriority {
  low,
  medium,
  high,
}

extension NotePriorityExtension on NotePriority {
  String get displayName {
    switch (this) {
      case NotePriority.low:
        return 'Low';
      case NotePriority.medium:
        return 'Medium';
      case NotePriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case NotePriority.low:
        return AppColors.info;
      case NotePriority.medium:
        return AppColors.warning;
      case NotePriority.high:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case NotePriority.low:
        return Icons.flag_outlined;
      case NotePriority.medium:
        return Icons.flag;
      case NotePriority.high:
        return Icons.priority_high;
    }
  }
}

/// Note Category Model
class NoteCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int noteCount;

  const NoteCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.noteCount = 0,
  });

  factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
      noteCount: json['noteCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'colorValue': color.toARGB32(),
      'noteCount': noteCount,
    };
  }
}

/// Note Model
class NoteModel {
  final String id;
  final String title;
  final String content;
  final String? categoryId;
  final List<String> tags;
  final NotePriority priority;
  final bool isPinned;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? courseId;
  final String? lessonId;
  final List<String>? attachments;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.tags = const [],
    this.priority = NotePriority.low,
    this.isPinned = false,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
    this.courseId,
    this.lessonId,
    this.attachments,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryId: json['categoryId'],
      tags: List<String>.from(json['tags'] ?? []),
      priority: NotePriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotePriority.low,
      ),
      isPinned: json['isPinned'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      courseId: json['courseId'],
      lessonId: json['lessonId'],
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categoryId': categoryId,
      'tags': tags,
      'priority': priority.name,
      'isPinned': isPinned,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'courseId': courseId,
      'lessonId': lessonId,
      'attachments': attachments,
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    List<String>? tags,
    NotePriority? priority,
    bool? isPinned,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? courseId,
    String? lessonId,
    List<String>? attachments,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      courseId: courseId ?? this.courseId,
      lessonId: lessonId ?? this.lessonId,
      attachments: attachments ?? this.attachments,
    );
  }
}

/// Note Card Widget
class NoteCard extends StatelessWidget {
  final NoteModel note;
  final NoteCategory? category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTogglePin;

  const NoteCard({
    super.key,
    required this.note,
    this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleFavorite,
    this.onTogglePin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: note.isPinned ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: note.isPinned
            ? BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  if (note.isPinned)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.push_pin,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  if (category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: category!.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category!.icon,
                            size: 12,
                            color: category!.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category!.name,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: category!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  if (note.priority != NotePriority.low)
                    Icon(
                      note.priority.icon,
                      size: 18,
                      color: note.priority.color,
                    ),
                  IconButton(
                    icon: Icon(
                      note.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: note.isFavorite ? AppColors.error : null,
                    ),
                    onPressed: onToggleFavorite,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'pin':
                          onTogglePin?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pin',
                        child: Row(
                          children: [
                            Icon(
                              note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(note.isPinned ? 'Unpin' : 'Pin'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: AppColors.error),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                note.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Content preview
              Text(
                note.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Tags
              if (note.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        '#$tag',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (note.attachments != null && note.attachments!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.attach_file,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${note.attachments!.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final NoteCategory category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? category.color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 20,
              color: category.color,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
                Text(
                  '${category.noteCount} notes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tag Chip Widget
class TagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TagChip({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text('#$tag'),
      selected: isSelected,
      onPressed: onTap,
      onDeleted: onDelete,
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      deleteIconColor: AppColors.textSecondary,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
    );
  }
}

/// Empty Notes State
class EmptyNotesState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onCreateNote;

  const EmptyNotesState({
    super.key,
    this.message = 'No Notes Yet',
    this.subtitle,
    this.onCreateNote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.note_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? 'Start taking notes to remember important information',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onCreateNote != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onCreateNote,
                icon: const Icon(Icons.add),
                label: const Text('Create Note'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Note Search Bar Widget
class NoteSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;

  const NoteSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hintText ?? 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onFilterTap,
              icon: const Icon(Icons.filter_list),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.border),
              ),
            ),
          ],
          if (onSortTap != null) ...[
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSortTap,
              icon: const Icon(Icons.sort),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.border),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
