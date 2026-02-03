import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Resource Categories Screen
///
/// Manages resource categories with:
/// - Category CRUD operations
/// - Icon and color customization
/// - Resource count tracking
/// - Category-based filtering
///
/// Backend Integration TODO:
/// - Fetch categories from backend
/// - Create/update/delete categories
/// - Sync category changes across devices
/// - Track resource counts per category

class ResourceCategoriesScreen extends StatefulWidget {
  const ResourceCategoriesScreen({super.key});

  @override
  State<ResourceCategoriesScreen> createState() =>
      _ResourceCategoriesScreenState();
}

class _ResourceCategoriesScreenState extends State<ResourceCategoriesScreen> {
  late List<CategoryModel> _categories;

  @override
  void initState() {
    super.initState();
    _generateMockCategories();
  }

  void _generateMockCategories() {
    _categories = [
      CategoryModel(
        id: '1',
        name: 'Lecture Notes',
        icon: Icons.note_alt,
        color: AppColors.primary,
        resourceCount: 23,
      ),
      CategoryModel(
        id: '2',
        name: 'Assignments',
        icon: Icons.assignment,
        color: AppColors.error,
        resourceCount: 12,
      ),
      CategoryModel(
        id: '3',
        name: 'Reading Materials',
        icon: Icons.menu_book,
        color: AppColors.success,
        resourceCount: 18,
      ),
      CategoryModel(
        id: '4',
        name: 'Code Examples',
        icon: Icons.code,
        color: const Color(0xFF9C27B0),
        resourceCount: 8,
      ),
      CategoryModel(
        id: '5',
        name: 'Practice Problems',
        icon: Icons.fitness_center,
        color: AppColors.warning,
        resourceCount: 15,
      ),
      CategoryModel(
        id: '6',
        name: 'Video Tutorials',
        icon: Icons.video_library,
        color: AppColors.info,
        resourceCount: 6,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: _categories.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return _buildCategoryCard(category);
              },
            ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewCategoryResources(category),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Category Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.resourceCount} ${category.resourceCount == 1 ? 'resource' : 'resources'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _showEditCategoryDialog(category),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteCategory(category),
                    tooltip: 'Delete',
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Categories',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add categories to organize your resources',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _showAddCategoryDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  void _viewCategoryResources(CategoryModel category) {
    // TODO: Navigate to resources filtered by category
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing resources in ${category.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAddCategoryDialog() {
    _showCategoryDialog(
      title: 'Add Category',
      onSave: (name, icon, color) {
        setState(() {
          _categories.add(CategoryModel(
            id: DateTime.now().toString(),
            name: name,
            icon: icon,
            color: color,
            resourceCount: 0,
          ));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category added successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _showEditCategoryDialog(CategoryModel category) {
    _showCategoryDialog(
      title: 'Edit Category',
      initialName: category.name,
      initialIcon: category.icon,
      initialColor: category.color,
      onSave: (name, icon, color) {
        setState(() {
          final index = _categories.indexWhere((c) => c.id == category.id);
          if (index != -1) {
            _categories[index] = CategoryModel(
              id: category.id,
              name: name,
              icon: icon,
              color: color,
              resourceCount: category.resourceCount,
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      },
    );
  }

  void _showCategoryDialog({
    required String title,
    String? initialName,
    IconData? initialIcon,
    Color? initialColor,
    required Function(String name, IconData icon, Color color) onSave,
  }) {
    final nameController = TextEditingController(text: initialName);
    IconData selectedIcon = initialIcon ?? Icons.folder;
    Color selectedColor = initialColor ?? AppColors.primary;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Input
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 20),

                  // Icon Selection
                  Text(
                    'Icon',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final icon = await _showIconPicker(selectedIcon);
                        if (icon != null) {
                          setDialogState(() {
                            selectedIcon = icon;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(selectedIcon, color: selectedColor),
                            const SizedBox(width: 12),
                            const Text('Tap to change icon'),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Color Selection
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _predefinedColors.map((color) {
                      final isSelected = color == selectedColor;
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
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
                  Navigator.pop(context);
                  onSave(name, selectedIcon, selectedColor);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<IconData?> _showIconPicker(IconData currentIcon) async {
    return showDialog<IconData>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _predefinedIcons.map((icon) {
              final isSelected = icon == currentIcon;
              return InkWell(
                onTap: () => Navigator.pop(context, icon),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text(
          'Are you sure you want to delete "${category.name}"? '
          'This will not delete the resources, but they will be uncategorized.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(category);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(CategoryModel category) {
    setState(() {
      _categories.removeWhere((c) => c.id == category.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category deleted'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // Predefined icons for categories
  final List<IconData> _predefinedIcons = [
    Icons.folder,
    Icons.note_alt,
    Icons.assignment,
    Icons.menu_book,
    Icons.code,
    Icons.video_library,
    Icons.image,
    Icons.music_note,
    Icons.article,
    Icons.description,
    Icons.picture_as_pdf,
    Icons.language,
    Icons.fitness_center,
    Icons.science,
    Icons.calculate,
    Icons.school,
    Icons.history_edu,
    Icons.library_books,
    Icons.auto_stories,
    Icons.quiz,
  ];

  // Predefined colors for categories
  final List<Color> _predefinedColors = [
    AppColors.primary,
    AppColors.success,
    AppColors.error,
    AppColors.warning,
    AppColors.info,
    const Color(0xFF9C27B0), // Purple
    const Color(0xFF673AB7), // Deep Purple
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF009688), // Teal
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFF9800), // Orange
    const Color(0xFF795548), // Brown
    const Color(0xFF607D8B), // Blue Grey
  ];
}

/// Category Model
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int resourceCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.resourceCount,
  });
}
