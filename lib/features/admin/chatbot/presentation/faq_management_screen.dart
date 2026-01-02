import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../services/faq_api_service.dart';

/// Admin FAQ Management Screen
class FAQManagementScreen extends ConsumerStatefulWidget {
  const FAQManagementScreen({super.key});

  @override
  ConsumerState<FAQManagementScreen> createState() =>
      _FAQManagementScreenState();
}

class _FAQManagementScreenState extends ConsumerState<FAQManagementScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  bool _showInactiveOnly = false;
  bool _isLoading = true;
  String? _error;
  List<FAQ> _faqs = [];
  int _totalFaqs = 0;
  int _currentPage = 1;
  bool _hasMore = false;

  final List<String> _categories = [
    'general',
    'registration',
    'pricing',
    'features',
    'technical',
    'support',
    'billing',
  ];

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFAQs({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(faqApiServiceProvider);
      final response = await service.listFAQs(
        page: _currentPage,
        pageSize: 20,
        category: _selectedCategory,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
        activeOnly: !_showInactiveOnly,
      );

      setState(() {
        if (refresh || _currentPage == 1) {
          _faqs = response.faqs;
        } else {
          _faqs.addAll(response.faqs);
        }
        _totalFaqs = response.total;
        _hasMore = response.hasMore;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFAQ(FAQ faq) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete FAQ'),
        content: Text('Are you sure you want to delete this FAQ?\n\n"${faq.question}"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final service = ref.read(faqApiServiceProvider);
        await service.deleteFAQ(faq.id);
        _loadFAQs(refresh: true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAQ deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete FAQ: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleActive(FAQ faq) async {
    try {
      final service = ref.read(faqApiServiceProvider);
      await service.toggleFAQActive(faq.id, !faq.isActive);
      _loadFAQs(refresh: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update FAQ: $e')),
        );
      }
    }
  }

  void _showFAQDialog({FAQ? faq}) {
    showDialog(
      context: context,
      builder: (context) => _FAQEditDialog(
        faq: faq,
        categories: _categories,
        onSave: (result) {
          _loadFAQs(refresh: true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FAQ Management'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadFAQs(refresh: true),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFAQDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add FAQ', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search FAQs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _loadFAQs(refresh: true);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _loadFAQs(refresh: true),
                ),
                const SizedBox(height: 12),
                // Filters Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ..._categories.map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(_capitalize(cat)),
                              )),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                          _loadFAQs(refresh: true);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Show Inactive Toggle
                    FilterChip(
                      label: const Text('Show Inactive'),
                      selected: _showInactiveOnly,
                      onSelected: (value) {
                        setState(() => _showInactiveOnly = value);
                        _loadFAQs(refresh: true);
                      },
                    ),
                    const SizedBox(width: 16),
                    // Stats
                    Text(
                      '$_totalFaqs FAQs',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: _isLoading && _faqs.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 48, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text(_error!,
                                style: TextStyle(color: AppColors.error)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _loadFAQs(refresh: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _faqs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.question_answer_outlined,
                                    size: 64, color: AppColors.textSecondary),
                                const SizedBox(height: 16),
                                Text(
                                  'No FAQs found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () => _showFAQDialog(),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Create your first FAQ'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => _loadFAQs(refresh: true),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _faqs.length + (_hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _faqs.length) {
                                  // Load more button
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : TextButton(
                                              onPressed: () {
                                                _currentPage++;
                                                _loadFAQs();
                                              },
                                              child: const Text('Load More'),
                                            ),
                                    ),
                                  );
                                }
                                return _buildFAQCard(_faqs[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(FAQ faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: faq.isActive ? AppColors.border : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: faq.isActive
                  ? AppColors.surface
                  : AppColors.error.withOpacity(0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                // Category Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _capitalize(faq.category),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Priority Badge
                if (faq.priority > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          'Priority ${faq.priority}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.amber,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!faq.isActive) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Actions
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showFAQDialog(faq: faq),
                  tooltip: 'Edit',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(
                    faq.isActive
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () => _toggleActive(faq),
                  tooltip: faq.isActive ? 'Deactivate' : 'Activate',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: AppColors.error),
                  onPressed: () => _deleteFAQ(faq),
                  tooltip: 'Delete',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Question & Answer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.help_outline,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        faq.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Answer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        faq.answer,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (faq.keywords.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: faq.keywords.map((keyword) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          keyword,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Stats Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                _buildStatItem(
                    Icons.trending_up, '${faq.usageCount}', 'Uses'),
                const SizedBox(width: 24),
                _buildStatItem(Icons.thumb_up_outlined,
                    '${faq.helpfulCount}', 'Helpful'),
                const SizedBox(width: 24),
                _buildStatItem(Icons.thumb_down_outlined,
                    '${faq.notHelpfulCount}', 'Not Helpful'),
                const Spacer(),
                if (faq.helpfulCount + faq.notHelpfulCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: faq.helpfulPercentage >= 70
                          ? Colors.green.withOpacity(0.1)
                          : faq.helpfulPercentage >= 40
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${faq.helpfulPercentage.toStringAsFixed(0)}% helpful',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: faq.helpfulPercentage >= 70
                            ? Colors.green
                            : faq.helpfulPercentage >= 40
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

/// Dialog for creating/editing FAQs
class _FAQEditDialog extends ConsumerStatefulWidget {
  final FAQ? faq;
  final List<String> categories;
  final Function(FAQ) onSave;

  const _FAQEditDialog({
    this.faq,
    required this.categories,
    required this.onSave,
  });

  @override
  ConsumerState<_FAQEditDialog> createState() => _FAQEditDialogState();
}

class _FAQEditDialogState extends ConsumerState<_FAQEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _keywordsController = TextEditingController();
  String _selectedCategory = 'general';
  int _priority = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.faq != null) {
      _questionController.text = widget.faq!.question;
      _answerController.text = widget.faq!.answer;
      _keywordsController.text = widget.faq!.keywords.join(', ');
      _selectedCategory = widget.faq!.category;
      _priority = widget.faq!.priority;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _keywordsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(faqApiServiceProvider);
      final keywords = _keywordsController.text
          .split(',')
          .map((k) => k.trim())
          .where((k) => k.isNotEmpty)
          .toList();

      FAQ result;
      if (widget.faq != null) {
        // Update
        result = await service.updateFAQ(
          widget.faq!.id,
          FAQUpdateRequest(
            question: _questionController.text,
            answer: _answerController.text,
            keywords: keywords,
            category: _selectedCategory,
            priority: _priority,
          ),
        );
      } else {
        // Create
        result = await service.createFAQ(
          FAQCreateRequest(
            question: _questionController.text,
            answer: _answerController.text,
            keywords: keywords,
            category: _selectedCategory,
            priority: _priority,
          ),
        );
      }

      widget.onSave(result);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                widget.faq != null ? 'FAQ updated' : 'FAQ created'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Icon(
                      widget.faq != null ? Icons.edit : Icons.add_circle,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.faq != null ? 'Edit FAQ' : 'Create FAQ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Question
                TextFormField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    hintText: 'Enter the FAQ question...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Question is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Answer
                TextFormField(
                  controller: _answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Enter the answer...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Answer is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Keywords
                TextFormField(
                  controller: _keywordsController,
                  decoration: const InputDecoration(
                    labelText: 'Keywords',
                    hintText: 'Enter keywords separated by commas...',
                    border: OutlineInputBorder(),
                    helperText: 'Used for matching user questions',
                  ),
                ),
                const SizedBox(height: 16),

                // Category and Priority Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: widget.categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(_capitalize(cat)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedCategory = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(11, (i) => i)
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p == 0 ? 'Normal' : 'Priority $p'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _priority = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _save,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(widget.faq != null ? 'Update' : 'Create'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
