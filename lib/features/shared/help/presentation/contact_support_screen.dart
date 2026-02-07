// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Contact Support Screen
///
/// Allows users to submit support requests.
/// Features:
/// - Support request form
/// - Category and priority selection
/// - File attachments
/// - Contact information display
/// - Business hours
///
/// Backend Integration TODO:
/// - Submit support requests to API
/// - Upload attachments
/// - Send confirmation email
/// - Create support ticket

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'general';
  String _priority = 'medium';
  String _contactMethod = 'email';
  final List<AttachmentFile> _attachments = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.helpBack,
        ),
        title: Text(context.l10n.helpContactSupport),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Info Card
          Card(
            color: AppColors.info.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: AppColors.info,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.helpWeAreHereToHelp,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.helpSupportResponseTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Support Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject
                Text(
                  context.l10n.helpSubject,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    hintText: context.l10n.helpSubjectHint,
                    prefixIcon: const Icon(Icons.subject),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.helpSubjectRequired;
                    }
                    if (value.length < 5) {
                      return context.l10n.helpSubjectMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                Text(
                  context.l10n.helpCategory,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'general',
                      child: Text(context.l10n.helpCategoryGeneral),
                    ),
                    DropdownMenuItem(
                      value: 'technical',
                      child: Text(context.l10n.helpCategoryTechnical),
                    ),
                    DropdownMenuItem(
                      value: 'billing',
                      child: Text(context.l10n.helpCategoryBilling),
                    ),
                    DropdownMenuItem(
                      value: 'account',
                      child: Text(context.l10n.helpCategoryAccount),
                    ),
                    DropdownMenuItem(
                      value: 'course',
                      child: Text(context.l10n.helpCategoryCourse),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Text(context.l10n.helpCategoryOther),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _category = value!);
                  },
                ),
                const SizedBox(height: 20),

                // Priority
                Text(
                  context.l10n.helpPriority,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'low',
                      label: Text(context.l10n.helpPriorityLow),
                      icon: const Icon(Icons.arrow_downward, size: 16),
                    ),
                    ButtonSegment(
                      value: 'medium',
                      label: Text(context.l10n.helpPriorityMedium),
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                    ButtonSegment(
                      value: 'high',
                      label: Text(context.l10n.helpPriorityHigh),
                      icon: const Icon(Icons.arrow_upward, size: 16),
                    ),
                    ButtonSegment(
                      value: 'urgent',
                      label: Text(context.l10n.helpPriorityUrgent),
                      icon: const Icon(Icons.priority_high, size: 16),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (Set<String> selection) {
                    setState(() => _priority = selection.first);
                  },
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  context.l10n.helpDescription,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: context.l10n.helpDescriptionHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.helpDescriptionRequired;
                    }
                    if (value.length < 20) {
                      return context.l10n.helpDescriptionMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Attachments
                Text(
                  context.l10n.helpAttachments,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      if (_attachments.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.l10n.helpNoFilesAttached,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _attachments.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final attachment = _attachments[index];
                            return ListTile(
                              leading: Icon(
                                _getFileIcon(attachment.name),
                                color: AppColors.primary,
                              ),
                              title: Text(attachment.name),
                              subtitle: Text(_formatFileSize(attachment.size)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, color: AppColors.error),
                                onPressed: () {
                                  setState(() => _attachments.removeAt(index));
                                },
                              ),
                            );
                          },
                        ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.add, color: AppColors.primary),
                        title: Text(context.l10n.helpAddAttachment),
                        subtitle: Text(context.l10n.helpAttachmentTypes),
                        onTap: _pickFile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Preferred Contact Method
                Text(
                  context.l10n.helpPreferredContactMethod,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(context.l10n.helpEmail),
                        subtitle: Text(context.l10n.helpRespondViaEmail),
                        value: 'email',
                        groupValue: _contactMethod,
                        onChanged: (value) {
                          setState(() => _contactMethod = value!);
                        },
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        title: Text(context.l10n.helpPhone),
                        subtitle: Text(context.l10n.helpCallYouBack),
                        value: 'phone',
                        groupValue: _contactMethod,
                        onChanged: (value) {
                          setState(() => _contactMethod = value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitRequest,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(_isSubmitting ? context.l10n.helpSubmitting : context.l10n.helpSubmitRequest),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Contact Information
          Text(
            context.l10n.helpOtherWaysToReachUs,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.email, color: AppColors.primary),
              ),
              title: Text(context.l10n.helpEmail),
              subtitle: const Text('support@flow-edu.com'),
              trailing: const Icon(Icons.content_copy, size: 20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.helpEmailCopied)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Phone
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.phone, color: AppColors.success),
              ),
              title: Text(context.l10n.helpPhone),
              subtitle: const Text('+1 (555) 123-4567'),
              trailing: const Icon(Icons.content_copy, size: 20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.helpPhoneCopied)),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Business Hours
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.access_time, color: AppColors.info),
              ),
              title: Text(context.l10n.helpBusinessHours),
              subtitle: Text(context.l10n.helpBusinessHoursDetails),
              isThreeLine: true,
            ),
          ),
          const SizedBox(height: 8),

          // Response Time
          Card(
            color: AppColors.success.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.helpAverageResponseTime,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.helpTypicallyRespond24h,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (!mounted) return;
      if (result != null) {
        for (final file in result.files) {
          if (file.bytes != null) {
            // Check file size (10MB max)
            if (file.size > 10 * 1024 * 1024) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${file.name} is too large. Max size is 10MB.'),
                  backgroundColor: AppColors.error,
                ),
              );
              continue;
            }

            setState(() {
              _attachments.add(AttachmentFile(
                name: file.name,
                bytes: file.bytes!,
                size: file.size,
              ));
            });
          }
        }

        if (result.files.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.files.length} file(s) attached'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking files: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // TODO: Submit to backend API
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (!mounted) return;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success),
              ),
              const SizedBox(width: 12),
              Text(context.l10n.helpRequestSubmitted),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.helpRequestSubmittedSuccess,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ticket #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.helpTrackRequestInfo,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.pop(); // Go back to previous screen
              },
              child: Text(context.l10n.helpOk),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.pop(); // Go back
                // TODO: Navigate to support tickets screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.helpViewTicketInSupport),
                  ),
                );
              },
              child: Text(context.l10n.helpViewTickets),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting request: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class AttachmentFile {
  final String name;
  final Uint8List bytes;
  final int size;

  AttachmentFile({
    required this.name,
    required this.bytes,
    required this.size,
  });
}
