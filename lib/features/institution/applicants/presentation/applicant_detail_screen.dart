import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/applicant_model.dart';
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
        title: const Text('Applicant Details'),
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
                  const PopupMenuItem(
                    value: 'mark_reviewing',
                    child: Row(
                      children: [
                        Icon(Icons.rate_review, size: 20),
                        SizedBox(width: 8),
                        Text('Mark as Under Review'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'accept',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 20, color: AppColors.success),
                      SizedBox(width: 8),
                      Text('Accept Application'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'reject',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, size: 20, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Reject Application'),
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
                          'Application Status',
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
              'Student Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person,
                    label: 'Full Name',
                    value: _applicant.studentName,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: _applicant.studentEmail,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: _applicant.studentPhone,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.school,
                    label: 'Previous School',
                    value: _applicant.previousSchool,
                  ),
                  const Divider(),
                  _InfoRow(
                    icon: Icons.grade,
                    label: 'GPA',
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
              'Program Applied',
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
                    label: 'Submitted',
                    value: _formatDate(_applicant.submittedAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Statement of Purpose
            Text(
              'Statement of Purpose',
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

            // Documents
            Text(
              'Documents',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: _applicant.documents.map((doc) {
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
                                  const SnackBar(
                                    content: Text('Document viewer coming soon'),
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
                                    content: Text('Downloading ${doc.name}...'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (doc != _applicant.documents.last)
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
                'Review Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.person,
                      label: 'Reviewed By',
                      value: _applicant.reviewedBy ?? 'Unknown',
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Review Date',
                      value: _formatDate(_applicant.reviewedAt!),
                    ),
                    if (_applicant.reviewNotes != null) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Review Notes',
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
                      label: const Text('Reject'),
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
                      label: const Text('Accept'),
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
        return 'Pending Review';
      case 'under_review':
        return 'Under Review';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
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
        return 'Academic Transcript';
      case 'id':
        return 'ID Document';
      case 'photo':
        return 'Photo';
      case 'recommendation':
        return 'Recommendation Letter';
      default:
        return 'Document';
    }
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
          const SnackBar(
            content: Text('Marked as Under Review'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
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
        title: Text(isAccept ? 'Accept Application' : 'Reject Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAccept
                  ? 'Are you sure you want to accept this application?'
                  : 'Are you sure you want to reject this application?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Review Notes ${isAccept ? '(Optional)' : '(Required)'}',
                hintText: 'Add comments about your decision...',
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!isAccept && notesController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review notes are required for rejection'),
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
            child: Text(isAccept ? 'Accept' : 'Reject'),
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
                  ? 'Application accepted successfully'
                  : 'Application rejected',
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
            content: Text('Error processing review: $e'),
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
