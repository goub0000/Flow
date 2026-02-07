import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/notes_widgets.dart';

/// Categories Management Screen
///
/// Allows users to:
/// - View all note categories
/// - Create new categories
/// - Edit existing categories
/// - Delete categories
/// - Set category icons and colors
///
/// Backend Integration TODO:
/// ```dart
/// // Categories API
/// import 'package:dio/dio.dart';
///
/// class CategoriesRepository {
///   final Dio _dio;
///
///   Future<List<NoteCategory>> getCategories() async {
///     final response = await _dio.get('/api/notes/categories');
///     return (response.data['categories'] as List)
///         .map((json) => NoteCategory.fromJson(json))
///         .toList();
///   }
///
///   Future<NoteCategory> createCategory(NoteCategory category) async {
///     final response = await _dio.post(
///       '/api/notes/categories',
///       data: category.toJson(),
///     );
///     return NoteCategory.fromJson(response.data);
///   }
///
///   Future<void> updateCategory(NoteCategory category) async {
///     await _dio.put(
///       '/api/notes/categories/${category.id}',
///       data: category.toJson(),
///     );
///   }
///
///   Future<void> deleteCategory(String categoryId) async {
///     await _dio.delete('/api/notes/categories/$categoryId');
///   }
/// }
/// ```

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<NoteCategory> _categories;

  @override
  void initState() {
    super.initState();
    _generateMockCategories();
  }

  void _generateMockCategories() {
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
      const NoteCategory(
        id: '5',
        name: 'Projects',
        icon: Icons.folder,
        color: Colors.purple,
        noteCount: 6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Categories'),
      ),
      body: _categories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Categories',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create categories to organize your notes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${category.noteCount} ${category.noteCount == 1 ? 'note' : 'notes'}',
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showEditCategoryDialog(category);
                            break;
                          case 'delete':
                            _deleteCategory(category);
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
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: AppColors.error),
                              SizedBox(width: 12),
                              Text(
                                'Delete',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Show notes in this category
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening ${category.name} notes'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCategoryDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Category'),
      ),
    );
  }

  void _showCreateCategoryDialog() {
    _showCategoryDialog();
  }

  void _showEditCategoryDialog(NoteCategory category) {
    _showCategoryDialog(existingCategory: category);
  }

  void _showCategoryDialog({NoteCategory? existingCategory}) {
    final isEditing = existingCategory != null;
    final nameController = TextEditingController(
      text: existingCategory?.name ?? '',
    );
    IconData selectedIcon = existingCategory?.icon ?? Icons.folder;
    Color selectedColor = existingCategory?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'New Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 20),

                // Icon selection
                const Text(
                  'Icon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categoryIcons.map((icon) {
                    final isSelected = icon == selectedIcon;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor.withValues(alpha: 0.2)
                              : AppColors.surface,
                          border: Border.all(
                            color: isSelected
                                ? selectedColor
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? selectedColor
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Color selection
                const Text(
                  'Color',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categoryColors.map((color) {
                    final isSelected = color == selectedColor;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.textPrimary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                final newCategory = NoteCategory(
                  id: existingCategory?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  icon: selectedIcon,
                  color: selectedColor,
                  noteCount: existingCategory?.noteCount ?? 0,
                );

                setState(() {
                  if (isEditing) {
                    final index = _categories
                        .indexWhere((c) => c.id == existingCategory.id);
                    _categories[index] = newCategory;
                  } else {
                    _categories.add(newCategory);
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Category updated'
                          : 'Category created',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(NoteCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          category.noteCount > 0
              ? 'This category contains ${category.noteCount} notes. Deleting it will not delete the notes, but they will become uncategorized.'
              : 'Are you sure you want to delete this category?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeWhere((c) => c.id == category.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category deleted'),
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
}

// Predefined icons for categories
const List<IconData> _categoryIcons = [
  Icons.folder,
  Icons.person,
  Icons.work,
  Icons.school,
  Icons.lightbulb,
  Icons.favorite,
  Icons.star,
  Icons.home,
  Icons.shopping_cart,
  Icons.fitness_center,
  Icons.restaurant,
  Icons.flight,
  Icons.code,
  Icons.palette,
  Icons.music_note,
  Icons.sports_soccer,
];

// Predefined colors for categories
const List<Color> _categoryColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
];
