import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/notes_widgets.dart';
import '../../authentication/providers/auth_provider.dart';
import 'note_editor_screen.dart';

/// Notes List Screen
///
/// Displays user's notes with:
/// - Search and filter functionality
/// - Category organization
/// - Sorting options (date, priority, title)
/// - Pin and favorite management
/// - Swipe actions
///
/// Backend Integration TODO:
/// - Fetch notes from backend/local storage
/// - Implement real-time sync
/// - Handle offline mode
/// - Implement search indexing

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

enum ViewMode { list, grid }

class _NotesListScreenState extends State<NotesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<NoteModel> _allNotes;
  late List<NoteModel> _displayedNotes;
  late List<NoteCategory> _categories;
  String? _selectedCategoryId;
  String _searchQuery = '';
  SortOption _sortOption = SortOption.dateModified;
  ViewMode _viewMode = ViewMode.list;
  Set<NotePriority> _selectedPriorities = {};
  bool _onlyWithAttachments = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockData();
    _applyFilters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    _categories = [
      const NoteCategory(
        id: '1',
        name: 'Personal',
        icon: Icons.person,
        color: Colors.blue,
        noteCount: 5,
      ),
      const NoteCategory(
        id: '2',
        name: 'Study',
        icon: Icons.school,
        color: Colors.green,
        noteCount: 8,
      ),
      const NoteCategory(
        id: '3',
        name: 'Work',
        icon: Icons.work,
        color: Colors.orange,
        noteCount: 3,
      ),
      const NoteCategory(
        id: '4',
        name: 'Ideas',
        icon: Icons.lightbulb,
        color: Colors.amber,
        noteCount: 4,
      ),
    ];

    _allNotes = [
      NoteModel(
        id: '1',
        title: 'Flutter State Management',
        content:
            'Riverpod is a powerful state management solution for Flutter. Key concepts include Providers, StateNotifier, and Consumer widgets. Remember to always dispose of controllers properly.',
        categoryId: '2',
        tags: ['flutter', 'riverpod', 'coding'],
        priority: NotePriority.high,
        isPinned: true,
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        courseId: 'course-123',
      ),
      NoteModel(
        id: '2',
        title: 'Meeting Notes - Project Review',
        content:
            'Discussed Q4 goals and deliverables. Action items: 1. Update documentation, 2. Schedule team sync, 3. Review code standards.',
        categoryId: '3',
        tags: ['meeting', 'work'],
        priority: NotePriority.medium,
        isPinned: false,
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
        attachments: ['meeting-notes.pdf', 'slides.pptx'],
      ),
      NoteModel(
        id: '3',
        title: 'App Feature Ideas',
        content:
            'New features to consider: Dark mode toggle, offline sync, push notifications, in-app messaging, social sharing.',
        categoryId: '4',
        tags: ['ideas', 'features'],
        priority: NotePriority.low,
        isPinned: false,
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NoteModel(
        id: '4',
        title: 'Data Structures Cheat Sheet',
        content:
            'Arrays: O(1) access, O(n) search. Linked Lists: O(n) access, O(1) insert/delete. Hash Tables: O(1) average case for insert/search/delete.',
        categoryId: '2',
        tags: ['study', 'algorithms', 'computer-science'],
        priority: NotePriority.high,
        isPinned: true,
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NoteModel(
        id: '5',
        title: 'Shopping List',
        content: 'Groceries: milk, eggs, bread, vegetables. Household: paper towels, soap, laundry detergent.',
        categoryId: '1',
        tags: ['personal', 'shopping'],
        priority: NotePriority.low,
        isPinned: false,
        isFavorite: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      NoteModel(
        id: '6',
        title: 'Book Recommendations',
        content:
            'To Read: Clean Code by Robert Martin, Design Patterns by Gang of Four, The Pragmatic Programmer.',
        categoryId: '1',
        tags: ['books', 'reading'],
        priority: NotePriority.medium,
        isPinned: false,
        isFavorite: true,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void _applyFilters() {
    _displayedNotes = _allNotes.where((note) {
      // Category filter
      if (_selectedCategoryId != null && note.categoryId != _selectedCategoryId) {
        return false;
      }

      // Priority filter
      if (_selectedPriorities.isNotEmpty &&
          !_selectedPriorities.contains(note.priority)) {
        return false;
      }

      // Attachments filter
      if (_onlyWithAttachments && note.attachments.isEmpty) {
        return false;
      }

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query) ||
            note.tags.any((tag) => tag.toLowerCase().contains(query));
      }

      return true;
    }).toList();

    // Apply sorting
    _sortNotes();
  }

  void _sortNotes() {
    switch (_sortOption) {
      case SortOption.dateModified:
        _displayedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOption.dateCreated:
        _displayedNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.title:
        _displayedNotes.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.priority:
        _displayedNotes.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
    }

    // Pinned notes always on top
    _displayedNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
  }

  List<NoteModel> _getNotesForTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // All
        return _displayedNotes;
      case 1: // Favorites
        return _displayedNotes.where((note) => note.isFavorite).toList();
      case 2: // Recent
        return _displayedNotes.take(10).toList();
      default:
        return _displayedNotes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(_viewMode == ViewMode.list ? Icons.grid_view : Icons.view_list),
            tooltip: _viewMode == ViewMode.list ? 'Grid view' : 'List view',
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${_displayedNotes.length})'),
            Tab(
              text: 'Favorites (${_displayedNotes.where((n) => n.isFavorite).length})',
            ),
            const Tab(text: 'Recent'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          NoteSearchBar(
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
                _applyFilters();
              });
            },
            onFilterTap: () => _showFilterDialog(),
            onSortTap: () => _showSortDialog(),
          ),

          // Categories
          if (_categories.isNotEmpty) ...[
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CategoryChip(
                        category: const NoteCategory(
                          id: 'all',
                          name: 'All',
                          icon: Icons.all_inclusive,
                          color: AppColors.primary,
                        ),
                        isSelected: _selectedCategoryId == null,
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = null;
                            _applyFilters();
                          });
                        },
                      ),
                    );
                  }

                  final category = _categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CategoryChip(
                      category: category,
                      isSelected: _selectedCategoryId == category.id,
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = category.id;
                          _applyFilters();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
          ],

          // Notes List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotesList(0),
                _buildNotesList(1),
                _buildNotesList(2),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<NoteModel>(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              _allNotes.add(result);
              _applyFilters();
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }

  Widget _buildNotesList(int tabIndex) {
    final notes = _getNotesForTab(tabIndex);

    if (notes.isEmpty) {
      return EmptyNotesState(
        message: _searchQuery.isNotEmpty
            ? 'No notes found'
            : tabIndex == 1
                ? 'No favorite notes'
                : 'No notes yet',
        subtitle: _searchQuery.isNotEmpty
            ? 'Try a different search query'
            : 'Create your first note to get started',
        onCreateNote: () async {
          final result = await Navigator.push<NoteModel>(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              _allNotes.add(result);
              _applyFilters();
            });
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh notes from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: _viewMode == ViewMode.list
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final category = _categories.firstWhere(
                  (c) => c.id == note.categoryId,
                  orElse: () => const NoteCategory(
                    id: '',
                    name: 'Uncategorized',
                    icon: Icons.note,
                    color: AppColors.textSecondary,
                  ),
                );

                return NoteCard(
                  note: note,
                  category: category,
                  onTap: () async {
                    final result = await Navigator.push<NoteModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        final index = _allNotes.indexWhere((n) => n.id == result.id);
                        if (index != -1) {
                          _allNotes[index] = result;
                          _applyFilters();
                        }
                      });
                    }
                  },
                  onEdit: () async {
                    final result = await Navigator.push<NoteModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        final index = _allNotes.indexWhere((n) => n.id == result.id);
                        if (index != -1) {
                          _allNotes[index] = result;
                          _applyFilters();
                        }
                      });
                    }
                  },
                  onDelete: () => _deleteNote(note),
                  onToggleFavorite: () => _toggleFavorite(note),
                  onTogglePin: () => _togglePin(note),
                );
              },
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final category = _categories.firstWhere(
                  (c) => c.id == note.categoryId,
                  orElse: () => const NoteCategory(
                    id: '',
                    name: 'Uncategorized',
                    icon: Icons.note,
                    color: AppColors.textSecondary,
                  ),
                );

                return NoteCard(
                  note: note,
                  category: category,
                  onTap: () async {
                    final result = await Navigator.push<NoteModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        final index = _allNotes.indexWhere((n) => n.id == result.id);
                        if (index != -1) {
                          _allNotes[index] = result;
                          _applyFilters();
                        }
                      });
                    }
                  },
                  onEdit: () async {
                    final result = await Navigator.push<NoteModel>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        final index = _allNotes.indexWhere((n) => n.id == result.id);
                        if (index != -1) {
                          _allNotes[index] = result;
                          _applyFilters();
                        }
                      });
                    }
                  },
                  onDelete: () => _deleteNote(note),
                  onToggleFavorite: () => _toggleFavorite(note),
                  onTogglePin: () => _togglePin(note),
                );
              },
            ),
    );
  }

  void _showFilterDialog() {
    // Create local copies to track changes in dialog
    Set<NotePriority> tempPriorities = Set.from(_selectedPriorities);
    bool tempAttachments = _onlyWithAttachments;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Notes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: NotePriority.values.map((priority) {
                    final isSelected = tempPriorities.contains(priority);
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(priority.icon, size: 14),
                          const SizedBox(width: 4),
                          Text(priority.displayName),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: priority.color.withValues(alpha: 0.2),
                      checkmarkColor: priority.color,
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            tempPriorities.add(priority);
                          } else {
                            tempPriorities.remove(priority);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Attachments', style: TextStyle(fontWeight: FontWeight.bold)),
                SwitchListTile(
                  title: const Text('Only notes with attachments'),
                  value: tempAttachments,
                  onChanged: (value) {
                    setDialogState(() {
                      tempAttachments = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                if (tempPriorities.isNotEmpty || tempAttachments)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.info),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${tempPriorities.length > 0 ? "${tempPriorities.length} priority filter(s)" : ""}${tempPriorities.isNotEmpty && tempAttachments ? " + " : ""}${tempAttachments ? "attachments filter" : ""}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedPriorities.clear();
                  _onlyWithAttachments = false;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedPriorities = tempPriorities;
                  _onlyWithAttachments = tempAttachments;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SortOption.values.map((option) {
            return RadioListTile<SortOption>(
              title: Text(option.displayName),
              value: option,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() {
                  _sortOption = value!;
                  _applyFilters();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _deleteNote(NoteModel note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allNotes.removeWhere((n) => n.id == note.id);
                _applyFilters();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(NoteModel note) {
    setState(() {
      final index = _allNotes.indexWhere((n) => n.id == note.id);
      _allNotes[index] = note.copyWith(isFavorite: !note.isFavorite);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          note.isFavorite
              ? 'Removed from favorites'
              : 'Added to favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _togglePin(NoteModel note) {
    setState(() {
      final index = _allNotes.indexWhere((n) => n.id == note.id);
      _allNotes[index] = note.copyWith(isPinned: !note.isPinned);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note.isPinned ? 'Note unpinned' : 'Note pinned'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

enum SortOption {
  dateModified,
  dateCreated,
  title,
  priority,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.dateModified:
        return 'Date Modified';
      case SortOption.dateCreated:
        return 'Date Created';
      case SortOption.title:
        return 'Title';
      case SortOption.priority:
        return 'Priority';
    }
  }
}
