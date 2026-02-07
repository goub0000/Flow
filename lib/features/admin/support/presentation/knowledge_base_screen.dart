// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_knowledge_base_provider.dart';
import '../../chatbot/services/faq_api_service.dart';

/// Knowledge Base Screen - Manage FAQ articles
class KnowledgeBaseScreen extends ConsumerStatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  ConsumerState<KnowledgeBaseScreen> createState() =>
      _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends ConsumerState<KnowledgeBaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FAQ> _getFilteredFAQs(List<FAQ> faqs) {
    var filtered = faqs;

    if (_selectedCategory != 'all') {
      filtered = filtered.where((f) => f.category == _selectedCategory).toList();
    }
    if (_selectedStatus != 'all') {
      final isActive = _selectedStatus == 'active';
      filtered = filtered.where((f) => f.isActive == isActive).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((f) =>
        f.question.toLowerCase().contains(query) ||
        f.answer.toLowerCase().contains(query) ||
        f.keywords.any((k) => k.toLowerCase().contains(query))
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final kbState = ref.watch(adminKnowledgeBaseProvider);
    final filteredFAQs = _getFilteredFAQs(kbState.faqs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(kbState),
        const SizedBox(height: 24),
        if (kbState.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      kbState.error!,
                      style: TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 18),
                    onPressed: () => ref.read(adminKnowledgeBaseProvider.notifier).fetchFAQs(),
                    tooltip: context.l10n.adminKbRetry,
                  ),
                ],
              ),
            ),
          ),
        if (kbState.error != null) const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(filteredFAQs, kbState.isLoading),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminSupportKnowledgeBase,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminSupportKnowledgeBaseSubtitle,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: Text(context.l10n.adminSupportCreateFaq),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => ref.read(adminKnowledgeBaseProvider.notifier).fetchFAQs(),
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminSupportRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AdminKnowledgeBaseState kbState) {
    final mostHelpful = kbState.faqs.isNotEmpty
        ? kbState.faqs.reduce((a, b) => a.helpfulCount > b.helpfulCount ? a : b).helpfulCount
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context.l10n.adminSupportTotalArticles, '${kbState.totalCount}', context.l10n.adminSupportFaqEntries, Icons.article, AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminSupportActive, '${kbState.activeCount}', context.l10n.adminSupportPublishedArticles, Icons.check_circle, AppColors.success)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminSupportInactive, '${kbState.inactiveCount}', context.l10n.adminSupportDraftArticles, Icons.pause_circle, AppColors.warning)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminSupportMostHelpful, '$mostHelpful', context.l10n.adminSupportHighestHelpfulVotes, Icons.thumb_up, AppColors.info)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.adminSupportSearchFaqHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: context.l10n.adminSupportCategory,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminSupportAllCategories)),
                DropdownMenuItem(value: 'general', child: Text(context.l10n.adminSupportGeneral)),
                DropdownMenuItem(value: 'academic', child: Text(context.l10n.adminSupportAcademic)),
                DropdownMenuItem(value: 'technical', child: Text(context.l10n.adminSupportTechnical)),
                DropdownMenuItem(value: 'billing', child: Text(context.l10n.adminSupportBilling)),
                DropdownMenuItem(value: 'account', child: Text(context.l10n.adminSupportAccount)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: context.l10n.adminSupportStatus,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminSupportAllStatus)),
                DropdownMenuItem(value: 'active', child: Text(context.l10n.adminSupportActive)),
                DropdownMenuItem(value: 'inactive', child: Text(context.l10n.adminSupportInactive)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedStatus = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<FAQ> faqs, bool isLoading) {
    return AdminDataTable<FAQ>(
      columns: [
        DataTableColumn(
          label: context.l10n.adminSupportQuestion,
          cellBuilder: (faq) => SizedBox(
            width: 250,
            child: Text(
              faq.question,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportCategory,
          cellBuilder: (faq) => _buildCategoryBadge(faq.category),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportPriority,
          cellBuilder: (faq) => Text('${faq.priority}', style: const TextStyle(fontSize: 13)),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminSupportStatus,
          cellBuilder: (faq) => _buildStatusBadge(faq.isActive),
        ),
        DataTableColumn(
          label: context.l10n.adminSupportUses,
          cellBuilder: (faq) => Text('${faq.usageCount}', style: const TextStyle(fontSize: 13)),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminSupportHelpful,
          cellBuilder: (faq) => Text('${faq.helpfulCount}', style: TextStyle(fontSize: 13, color: AppColors.success)),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminSupportNotHelpful,
          cellBuilder: (faq) => Text('${faq.notHelpfulCount}', style: TextStyle(fontSize: 13, color: AppColors.error)),
          sortable: true,
        ),
      ],
      data: faqs,
      isLoading: isLoading,
      onRowTap: (faq) => _showEditDialog(faq),
      rowActions: [
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminSupportEdit,
          onPressed: (faq) => _showEditDialog(faq),
        ),
        DataTableAction(
          icon: Icons.toggle_on,
          tooltip: context.l10n.adminSupportToggleActive,
          color: AppColors.primary,
          onPressed: (faq) {
            ref.read(adminKnowledgeBaseProvider.notifier).toggleActive(faq.id, !faq.isActive);
          },
        ),
        DataTableAction(
          icon: Icons.delete,
          tooltip: context.l10n.adminSupportDelete,
          color: AppColors.error,
          onPressed: (faq) => _showDeleteConfirm(faq),
        ),
      ],
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category[0].toUpperCase() + category.substring(1),
        style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? context.l10n.adminSupportActive : context.l10n.adminSupportInactive,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? AppColors.success : AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showCreateDialog() {
    _showFAQDialog(null);
  }

  void _showEditDialog(FAQ faq) {
    _showFAQDialog(faq);
  }

  void _showFAQDialog(FAQ? faq) {
    final questionController = TextEditingController(text: faq?.question ?? '');
    final answerController = TextEditingController(text: faq?.answer ?? '');
    final keywordsController = TextEditingController(text: faq?.keywords.join(', ') ?? '');
    String selectedCategory = faq?.category ?? 'general';
    int selectedPriority = faq?.priority ?? 0;
    final isEditing = faq != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? context.l10n.adminSupportEditFaq : context.l10n.adminSupportCreateFaq),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminSupportQuestion,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminSupportAnswer,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: keywordsController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminSupportKeywords,
                      border: OutlineInputBorder(),
                      hintText: context.l10n.adminKbKeywordsHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminSupportCategory,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'general', child: Text(context.l10n.adminSupportGeneral)),
                      DropdownMenuItem(value: 'academic', child: Text(context.l10n.adminSupportAcademic)),
                      DropdownMenuItem(value: 'technical', child: Text(context.l10n.adminSupportTechnical)),
                      DropdownMenuItem(value: 'billing', child: Text(context.l10n.adminSupportBilling)),
                      DropdownMenuItem(value: 'account', child: Text(context.l10n.adminSupportAccount)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedPriority,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminSupportPriority,
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 0, child: Text(context.l10n.adminKbPriorityLow)),
                      DropdownMenuItem(value: 1, child: Text(context.l10n.adminKbPriorityMedium)),
                      DropdownMenuItem(value: 2, child: Text(context.l10n.adminKbPriorityHigh)),
                      DropdownMenuItem(value: 3, child: Text(context.l10n.adminKbPriorityCritical)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedPriority = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.l10n.adminSupportCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final keywords = keywordsController.text
                    .split(',')
                    .map((k) => k.trim())
                    .where((k) => k.isNotEmpty)
                    .toList();

                bool success;
                if (isEditing) {
                  success = await ref.read(adminKnowledgeBaseProvider.notifier).updateFAQ(
                    faq.id,
                    FAQUpdateRequest(
                      question: questionController.text,
                      answer: answerController.text,
                      keywords: keywords,
                      category: selectedCategory,
                      priority: selectedPriority,
                    ),
                  );
                } else {
                  success = await ref.read(adminKnowledgeBaseProvider.notifier).createFAQ(
                    FAQCreateRequest(
                      question: questionController.text,
                      answer: answerController.text,
                      keywords: keywords,
                      category: selectedCategory,
                      priority: selectedPriority,
                    ),
                  );
                }

                if (success && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? context.l10n.adminSupportFaqUpdated : context.l10n.adminSupportFaqCreated)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: Text(isEditing ? context.l10n.adminSupportUpdate : context.l10n.adminSupportCreateAction),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(FAQ faq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminSupportDeleteFaq),
        content: Text(context.l10n.adminKbDeleteConfirmMessage(faq.question)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.adminSupportCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ref.read(adminKnowledgeBaseProvider.notifier).deleteFAQ(faq.id);
              if (success && context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.adminSupportFaqDeleted)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: Text(context.l10n.adminSupportDelete),
          ),
        ],
      ),
    );
  }
}
