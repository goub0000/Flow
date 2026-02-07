// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../services/faq_api_service.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart

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
        title: Text(context.l10n.adminChatFaqDeleteTitle),
        content: Text(context.l10n.adminChatFaqDeleteConfirm(faq.question)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.adminChatCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.adminChatDelete),
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
            SnackBar(content: Text(context.l10n.adminChatFaqDeleted)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.adminChatFaqDeleteFailed(e.toString()))),
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
          SnackBar(content: Text(context.l10n.adminChatFaqUpdateFailed(e.toString()))),
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
    // Content is wrapped by AdminShell via ShellRoute
    return Stack(
      children: [
        Container(
          color: AppColors.background,
          child: Column(
            children: [
              // Page Header
              _buildPageHeader(),
              // Search and Filter Bar
              _buildSearchAndFilterBar(),
              // FAQ List
              Expanded(
                child: _buildFAQList(),
              ),
            ],
          ),
        ),
        // Floating Action Button
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton.extended(
            onPressed: () => _showFAQDialog(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(context.l10n.adminChatFaqAdd, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.adminChatFaqSearch,
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
                    labelText: context.l10n.adminChatFaqCategory,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(context.l10n.adminChatFaqAllCategories),
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
                label: Text(context.l10n.adminChatFaqShowInactive),
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
    );
  }

  Widget _buildFAQList() {
    if (_isLoading && _faqs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadFAQs(refresh: true),
              child: Text(context.l10n.adminChatRetry),
            ),
          ],
        ),
      );
    }
    if (_faqs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.question_answer_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              context.l10n.adminChatFaqNoFaqs,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showFAQDialog(),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.adminChatFaqCreateFirst),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
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
                        child: Text(context.l10n.adminChatFaqLoadMore),
                      ),
              ),
            );
          }
          return _buildFAQCard(_faqs[index]);
        },
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.quiz_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminChatFaqTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  context.l10n.adminChatFaqSubtitle,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadFAQs(refresh: true),
            tooltip: context.l10n.adminChatRefresh,
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
          color: faq.isActive ? AppColors.border : AppColors.error.withValues(alpha: 0.3),
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
                  : AppColors.error.withValues(alpha: 0.05),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
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
                      color: Colors.amber.withValues(alpha: 0.1),
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
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      context.l10n.adminChatFaqInactive,
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
                  tooltip: context.l10n.adminChatFaqEdit,
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
                  tooltip: faq.isActive ? context.l10n.adminChatFaqDeactivate : context.l10n.adminChatFaqActivate,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      size: 20, color: AppColors.error),
                  onPressed: () => _deleteFAQ(faq),
                  tooltip: context.l10n.adminChatDelete,
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
                    Icons.trending_up, '${faq.usageCount}', context.l10n.adminChatFaqUses),
                const SizedBox(width: 24),
                _buildStatItem(Icons.thumb_up_outlined,
                    '${faq.helpfulCount}', context.l10n.adminChatFaqHelpful),
                const SizedBox(width: 24),
                _buildStatItem(Icons.thumb_down_outlined,
                    '${faq.notHelpfulCount}', context.l10n.adminChatFaqNotHelpful),
                const Spacer(),
                if (faq.helpfulCount + faq.notHelpfulCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: faq.helpfulPercentage >= 70
                          ? Colors.green.withValues(alpha: 0.1)
                          : faq.helpfulPercentage >= 40
                              ? Colors.orange.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
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
                widget.faq != null ? context.l10n.adminChatFaqUpdated : context.l10n.adminChatFaqCreated),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adminChatFaqSaveFailed(e.toString()))),
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
                      widget.faq != null ? context.l10n.adminChatFaqEditTitle : context.l10n.adminChatFaqCreateTitle,
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
                  decoration: InputDecoration(
                    labelText: context.l10n.adminChatFaqQuestion,
                    hintText: context.l10n.adminChatFaqQuestionHint,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.adminChatFaqQuestionRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Answer
                TextFormField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminChatFaqAnswer,
                    hintText: context.l10n.adminChatFaqAnswerHint,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.adminChatFaqAnswerRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Keywords
                TextFormField(
                  controller: _keywordsController,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminChatFaqKeywords,
                    hintText: context.l10n.adminChatFaqKeywordsHint,
                    border: const OutlineInputBorder(),
                    helperText: context.l10n.adminChatFaqKeywordsHelper,
                  ),
                ),
                const SizedBox(height: 16),

                // Category and Priority Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminChatFaqCategory,
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
                        decoration: InputDecoration(
                          labelText: context.l10n.adminChatFaqPriority,
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
                      child: Text(context.l10n.adminChatCancel),
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
                      label: Text(widget.faq != null ? context.l10n.adminChatFaqUpdate : context.l10n.adminChatFaqCreate),
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
