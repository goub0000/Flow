import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../models/bulk_message_model.dart';

/// Bulk Messaging Screen - Send messages to multiple users
class BulkMessagingScreen extends ConsumerStatefulWidget {
  const BulkMessagingScreen({super.key});

  @override
  ConsumerState<BulkMessagingScreen> createState() =>
      _BulkMessagingScreenState();
}

class _BulkMessagingScreenState extends ConsumerState<BulkMessagingScreen> {
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  MessageRecipientGroup _selectedGroup = MessageRecipientGroup.allUsers;
  MessagePriority _selectedPriority = MessagePriority.normal;
  MessageChannel _selectedChannel = MessageChannel.inApp;
  DateTime? _scheduledFor;
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Main Content - Message Composer
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildMessageComposer(),
                ],
              ),
            ),
          ),

          // Sidebar - Templates and History
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                left: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              children: [
                _buildTemplatesSection(),
                Divider(height: 1, color: AppColors.border),
                Expanded(
                  child: _buildMessageHistory(),
                ),
              ],
            ),
          ),
        ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adminMessagingTitle,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.adminMessagingSubtitle,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Recipient Selection
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminMessagingNewMessage,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildRecipientSelector(),
                const SizedBox(height: 16),
                _buildChannelSelector(),
              ],
            ),
          ),

          // Message Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminMessagingSubjectLabel,
                    hintText: context.l10n.adminMessagingSubjectHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.subject),
                  ),
                ),
                const SizedBox(height: 20),

                // Content
                TextField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: context.l10n.adminMessagingMessageLabel,
                    hintText: context.l10n.adminMessagingMessageHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Priority and Scheduling
                Row(
                  children: [
                    Expanded(child: _buildPrioritySelector()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildScheduleButton()),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _handleSaveDraft,
                      icon: const Icon(Icons.save, size: 20),
                      label: Text(context.l10n.adminMessagingSaveDraft),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _handlePreview,
                      icon: const Icon(Icons.preview, size: 20),
                      label: Text(context.l10n.adminMessagingPreview),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isSending ? null : _handleSend,
                      icon: _isSending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send, size: 20),
                      label: Text(_isSending ? context.l10n.adminMessagingSending : context.l10n.adminMessagingSendMessage),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adminMessagingRecipients,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: MessageRecipientGroup.values.map((group) {
            final isSelected = _selectedGroup == group;
            return InkWell(
              onTap: () {
                setState(() => _selectedGroup = group);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      group.icon,
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      group.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChannelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adminMessagingDeliveryChannel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: MessageChannel.values.map((channel) {
            final isSelected = _selectedChannel == channel;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(channel.icon, size: 16),
                  const SizedBox(width: 6),
                  Text(channel.label),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedChannel = channel);
                }
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundColor: AppColors.background,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.priority_high,
            size: 20,
            color: _selectedPriority.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<MessagePriority>(
              value: _selectedPriority,
              isExpanded: true,
              underline: const SizedBox(),
              items: MessagePriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPriority = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return OutlinedButton.icon(
      onPressed: _handleSchedule,
      icon: const Icon(Icons.schedule, size: 20),
      label: Text(
        _scheduledFor == null
            ? context.l10n.adminMessagingSchedule
            : DateFormat('MMM d, HH:mm').format(_scheduledFor!),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTemplatesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminMessagingTemplates,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._getMessageTemplates().map((template) {
            return _buildTemplateItem(template);
          }),
        ],
      ),
    );
  }

  Widget _buildTemplateItem(MessageTemplate template) {
    return InkWell(
      onTap: () => _applyTemplate(template),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                template.icon,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    template.category.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageHistory() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          context.l10n.adminMessagingRecentMessages,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ..._getRecentMessages().map((message) {
          return _buildHistoryItem(message);
        }),
      ],
    );
  }

  Widget _buildHistoryItem(BulkMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  message.subject,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: message.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  message.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: message.status.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                message.recipientGroup.icon,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                message.recipientGroup.label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                context.l10n.adminMessagingSentCount(message.sentCount),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyTemplate(MessageTemplate template) {
    setState(() {
      _subjectController.text = template.subject;
      _contentController.text = template.content;
    });
  }

  Future<void> _handleSchedule() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _scheduledFor = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _handleSend() async {
    if (_subjectController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminMessagingFillAllFields),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminMessagingSendMessageTitle),
        content: Text(
          context.l10n.adminMessagingSendConfirmation(_selectedGroup.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.adminMessagingCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(context.l10n.adminMessagingSend),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSending = true);

    // Simulate sending
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminMessagingSentSuccess),
          backgroundColor: AppColors.success,
        ),
      );

      // Clear form
      _subjectController.clear();
      _contentController.clear();
      _scheduledFor = null;
    }
  }

  void _handleSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.adminMessagingDraftSaved),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handlePreview() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminMessagingPreviewTitle),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.adminMessagingPreviewSubject(_subjectController.text),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(_contentController.text),
              const SizedBox(height: 16),
              Divider(color: AppColors.border),
              const SizedBox(height: 8),
              Text(
                context.l10n.adminMessagingPreviewTo(_selectedGroup.label),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                context.l10n.adminMessagingPreviewVia(_selectedChannel.label),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.adminMessagingClose),
          ),
        ],
      ),
    );
  }

  List<MessageTemplate> _getMessageTemplates() {
    return [
      MessageTemplate(
        id: '1',
        name: context.l10n.adminMessagingTemplateWelcomeName,
        subject: context.l10n.adminMessagingTemplateWelcomeSubject,
        content: context.l10n.adminMessagingTemplateWelcomeContent,
        category: MessageCategory.announcement,
        icon: Icons.waving_hand,
      ),
      MessageTemplate(
        id: '2',
        name: context.l10n.adminMessagingTemplatePaymentName,
        subject: context.l10n.adminMessagingTemplatePaymentSubject,
        content: context.l10n.adminMessagingTemplatePaymentContent,
        category: MessageCategory.reminder,
        icon: Icons.payment,
      ),
      MessageTemplate(
        id: '3',
        name: context.l10n.adminMessagingTemplateSystemName,
        subject: context.l10n.adminMessagingTemplateSystemSubject,
        content: context.l10n.adminMessagingTemplateSystemContent,
        category: MessageCategory.update,
        icon: Icons.build,
      ),
    ];
  }

  List<BulkMessage> _getRecentMessages() {
    return [
      BulkMessage(
        id: '1',
        subject: context.l10n.adminMessagingRecentWelcomeSubject,
        content: context.l10n.adminMessagingRecentWelcomeContent,
        recipientGroup: MessageRecipientGroup.students,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        sentCount: 1234,
      ),
      BulkMessage(
        id: '2',
        subject: context.l10n.adminMessagingRecentPaymentSubject,
        content: context.l10n.adminMessagingRecentPaymentContent,
        recipientGroup: MessageRecipientGroup.allUsers,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        sentCount: 2456,
      ),
      BulkMessage(
        id: '3',
        subject: context.l10n.adminMessagingRecentFeaturesSubject,
        content: context.l10n.adminMessagingRecentFeaturesContent,
        recipientGroup: MessageRecipientGroup.institutions,
        status: MessageStatus.scheduled,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        sentCount: 0,
      ),
    ];
  }
}
