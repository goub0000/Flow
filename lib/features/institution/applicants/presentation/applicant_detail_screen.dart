// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/applicant_model.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/institution_applicants_provider.dart';

class ApplicantDetailScreen extends ConsumerStatefulWidget {
  final Applicant applicant;

  const ApplicantDetailScreen({
    super.key,
    required this.applicant,
  });

  @override
  ConsumerState<ApplicantDetailScreen> createState() => _ApplicantDetailScreenState();
}

class _ApplicantDetailScreenState extends ConsumerState<ApplicantDetailScreen> {
  late Applicant _applicant;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _applicant = widget.applicant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.instApplicantDetails),
        actions: [
          if (_applicant.isPending || _applicant.isUnderReview)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'accept') {
                  _showReviewDialog(true);
                } else if (value == 'reject') {
                  _showReviewDialog(false);
                } else if (value == 'mark_reviewing') {
                  _markAsUnderReview();
                }
              },
              itemBuilder: (context) => [
                if (_applicant.isPending)
                  PopupMenuItem(
                    value: 'mark_reviewing',
                    child: Row(
                      children: [
                        Icon(Icons.rate_review, size: 20),
                        SizedBox(width: 8),
                        Text(context.l10n.instApplicantMarkUnderReview),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'accept',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(context.l10n.instApplicantAcceptApplication),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'reject',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, size: 20, color: AppColors.error),
                      SizedBox(width: 8),
                      Text(context.l10n.instApplicantRejectApplication),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            CustomCard(
              color: _getStatusColor().withValues(alpha: 0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.instApplicantApplicationStatus,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusLabel(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Student Information
            Text(
              context.l10n.instApplicantStudentInfo,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person,
                    label: context.l10n.instApplicantFullName,
                    value: _applicant.studentName,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.email,
                    label: context.l10n.instApplicantEmail,
                    value: _applicant.studentEmail,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.phone,
                    label: context.l10n.instApplicantPhone,
                    value: _applicant.studentPhone,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.school,
                    label: context.l10n.instApplicantPreviousSchool,
                    value: _applicant.previousSchool,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.grade,
                    label: context.l10n.instApplicantGpa,
                    value: _applicant.gpa.toString(),
                    valueColor: _applicant.gpa >= 3.5
                        ? AppColors.success
                        : _applicant.gpa >= 3.0
                            ? AppColors.warning
                            : AppColors.error,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Program Applied For
            Text(
              context.l10n.instApplicantProgramApplied,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _applicant.programName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: context.l10n.instApplicantSubmitted,
                    value: _formatDate(_applicant.submittedAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statement of Purpose
            Text(
              context.l10n.instApplicantStatementOfPurpose,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Text(
                _applicant.statementOfPurpose,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Recommendation Letters Section
            _buildRecommendationLettersSection(),
            const SizedBox(height: 24),

            // Other Documents
            Text(
              context.l10n.instApplicantDocuments,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: _applicant.documents.where((doc) => doc.type != 'recommendation').map((doc) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getDocumentIcon(doc.type),
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(doc.name),
                        subtitle: Text(
                          _getDocumentTypeLabel(doc.type),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              onPressed: () {
                                // TODO: View document
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.l10n.instApplicantDocViewerComingSoon),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                // TODO: Download document
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.l10n.instApplicantDownloading(doc.name)),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (doc != _applicant.documents.where((d) => d.type != 'recommendation').last)
                        const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Review Information (if reviewed)
            if (_applicant.reviewedAt != null) ...[
              const SizedBox(height: 24),
              Text(
                context.l10n.instApplicantReviewInfo,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: context.l10n.instApplicantReviewedBy,
                      value: _applicant.reviewedBy ?? context.l10n.instApplicantUnknown,
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: context.l10n.instApplicantReviewDate,
                      value: _formatDate(_applicant.reviewedAt!),
                    ),
                    if (_applicant.reviewNotes != null) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.instApplicantReviewNotes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _applicant.reviewNotes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            if (_applicant.isPending || _applicant.isUnderReview) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : () => _showReviewDialog(false),
                      icon: const Icon(Icons.cancel, color: AppColors.error),
                      label: Text(context.l10n.instApplicantReject),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : () => _showReviewDialog(true),
                      icon: const Icon(Icons.check_circle),
                      label: Text(context.l10n.instApplicantAccept),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_applicant.status) {
      case 'pending':
        return AppColors.warning;
      case 'under_review':
        return AppColors.info;
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (_applicant.status) {
      case 'pending':
        return Icons.pending;
      case 'under_review':
        return Icons.rate_review;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusLabel() {
    switch (_applicant.status) {
      case 'pending':
        return context.l10n.instApplicantStatusPending;
      case 'under_review':
        return context.l10n.instApplicantStatusUnderReview;
      case 'accepted':
        return context.l10n.instApplicantStatusAccepted;
      case 'rejected':
        return context.l10n.instApplicantStatusRejected;
      default:
        return _applicant.status;
    }
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'transcript':
        return Icons.description;
      case 'id':
        return Icons.badge;
      case 'photo':
        return Icons.photo;
      case 'recommendation':
        return Icons.recommend;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getDocumentTypeLabel(String type) {
    switch (type) {
      case 'transcript':
        return context.l10n.instApplicantDocTranscript;
      case 'id':
        return context.l10n.instApplicantDocId;
      case 'photo':
        return context.l10n.instApplicantDocPhoto;
      case 'recommendation':
        return context.l10n.instApplicantDocRecommendation;
      default:
        return context.l10n.instApplicantDocGeneric;
    }
  }

  Widget _buildRecommendationLettersSection() {
    // Get recommendation documents
    final recommendationDocs = _applicant.documents
        .where((doc) => doc.type == 'recommendation')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.instApplicantRecommendationLetters,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: recommendationDocs.isEmpty
                    ? AppColors.warning.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                context.l10n.instApplicantReceivedCount(recommendationDocs.length),
                style: TextStyle(
                  color: recommendationDocs.isEmpty
                      ? AppColors.warning
                      : AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recommendationDocs.isEmpty)
          CustomCard(
            color: AppColors.warning.withValues(alpha: 0.05),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.instApplicantNoRecommendations,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.instApplicantNoRecommendationsDesc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          CustomCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: recommendationDocs.asMap().entries.map((entry) {
                final index = entry.key;
                final doc = entry.value;
                return Column(
                  children: [
                    _RecommendationLetterTile(
                      document: doc,
                      onView: () => _viewRecommendationLetter(doc),
                      onDownload: () => _downloadRecommendationLetter(doc),
                    ),
                    if (index < recommendationDocs.length - 1)
                      const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _viewRecommendationLetter(dynamic doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.recommend, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(doc.name)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RecommendationDetailRow(
                label: context.l10n.instApplicantType,
                value: context.l10n.instApplicantDocRecommendation,
              ),
              _RecommendationDetailRow(
                label: context.l10n.instApplicantSubmitted,
                value: doc.uploadedAt != null
                    ? _formatDate(doc.uploadedAt)
                    : context.l10n.instApplicantUnknown,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.article, size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.instApplicantLetterPreview,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (doc.url != null && doc.url.isNotEmpty)
                      Text(
                        context.l10n.instApplicantClickViewFull,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      Text(
                        context.l10n.instApplicantLetterPreviewUnavailable,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
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
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.instApplicantClose),
          ),
          if (doc.url != null && doc.url.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _openLetterUrl(doc.url);
              },
              icon: const Icon(Icons.open_in_new),
              label: Text(context.l10n.instApplicantViewFull),
            ),
        ],
      ),
    );
  }

  void _downloadRecommendationLetter(dynamic doc) {
    if (doc.url != null && doc.url.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.instApplicantDownloading(doc.name)),
          backgroundColor: AppColors.info,
        ),
      );
      // TODO: Implement actual download
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.instApplicantDownloadNotAvailable),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _openLetterUrl(String url) {
    // TODO: Implement URL launcher or in-app viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.instApplicantOpeningLetter(url)),
        backgroundColor: AppColors.info,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _markAsUnderReview() async {
    setState(() => _isProcessing = true);

    try {
      await ref.read(institutionApplicantsProvider.notifier).updateApplicantStatus(
        _applicant.id,
        'under_review',
      );

      if (mounted) {
        // Update local applicant state
        final updatedApplicant = ref.read(institutionApplicantsProvider.notifier).getApplicantById(_applicant.id);
        if (updatedApplicant != null) {
          setState(() {
            _applicant = updatedApplicant;
            _isProcessing = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instApplicantMarkedUnderReview),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instApplicantFailedUpdateStatus),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instApplicantErrorUpdatingStatus(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showReviewDialog(bool isAccept) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAccept ? context.l10n.instApplicantAcceptApplication : context.l10n.instApplicantRejectApplication),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAccept
                  ? context.l10n.instApplicantConfirmAccept
                  : context.l10n.instApplicantConfirmReject,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: isAccept ? context.l10n.instApplicantReviewNotesOptional : context.l10n.instApplicantReviewNotesRequired,
                hintText: context.l10n.instApplicantAddComments,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.instApplicantCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (!isAccept && notesController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.instApplicantNotesRequiredRejection),
                  ),
                );
                return;
              }

              context.pop();
              _processReview(isAccept, notesController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccept ? AppColors.success : AppColors.error,
            ),
            child: Text(isAccept ? context.l10n.instApplicantAccept : context.l10n.instApplicantReject),
          ),
        ],
      ),
    );
  }

  Future<void> _processReview(bool isAccept, String notes) async {
    setState(() => _isProcessing = true);

    try {
      final newStatus = isAccept ? 'accepted' : 'rejected';

      // Update applicant status
      await ref.read(institutionApplicantsProvider.notifier).updateApplicantStatus(
        _applicant.id,
        newStatus,
      );

      // Notes functionality will be added in a future update

      if (mounted) {
        // Update local applicant state
        final updatedApplicant = ref.read(institutionApplicantsProvider.notifier).getApplicantById(_applicant.id);
        if (updatedApplicant != null) {
          setState(() {
            _applicant = updatedApplicant;
            _isProcessing = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAccept
                  ? context.l10n.instApplicantAcceptedSuccess
                  : context.l10n.instApplicantRejectedSuccess,
            ),
            backgroundColor: isAccept ? AppColors.success : AppColors.error,
          ),
        );

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instApplicantErrorProcessingReview(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationLetterTile extends StatelessWidget {
  final dynamic document;
  final VoidCallback onView;
  final VoidCallback onDownload;

  const _RecommendationLetterTile({
    required this.document,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.recommend,
          color: AppColors.success,
        ),
      ),
      title: Text(
        document.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  context.l10n.instApplicantReceived,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.instApplicantDocRecommendation,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: onView,
            tooltip: context.l10n.instApplicantViewLetter,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: onDownload,
            tooltip: context.l10n.instApplicantDownload,
          ),
        ],
      ),
    );
  }
}

class _RecommendationDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _RecommendationDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
