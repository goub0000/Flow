import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/application_model.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../providers/student_applications_provider.dart';

class ApplicationDetailScreen extends ConsumerWidget {
  final Application application;

  const ApplicationDetailScreen({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.appBack,
        ),
        title: Text(context.l10n.appDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            CustomCard(
              color: _getStatusColor().withValues(alpha: 0.1),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    size: 48,
                    color: _getStatusColor(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.appDetailStatus,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(context),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _getStatusBadge(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Institution & Program Info
            Text(
              context.l10n.appDetailInfo,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: context.l10n.appDetailInstitution,
                    value: application.institutionName,
                  ),
                  const Divider(),
                  _DetailRow(
                    label: context.l10n.appDetailProgram,
                    value: application.programName,
                  ),
                  const Divider(),
                  _DetailRow(
                    label: context.l10n.appDetailSubmitted,
                    value:
                        '${application.submittedAt.day}/${application.submittedAt.month}/${application.submittedAt.year}',
                  ),
                  if (application.reviewedAt != null) ...[
                    const Divider(),
                    _DetailRow(
                      label: context.l10n.appDetailReviewed,
                      value:
                          '${application.reviewedAt!.day}/${application.reviewedAt!.month}/${application.reviewedAt!.year}',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Info
            if (application.applicationFee != null) ...[
              Text(
                context.l10n.appDetailPaymentInfo,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  children: [
                    _DetailRow(
                      label: context.l10n.appDetailApplicationFee,
                      value: '\$${application.applicationFee!.toStringAsFixed(2)}',
                    ),
                    const Divider(),
                    _DetailRow(
                      label: context.l10n.appDetailPaymentStatus,
                      value: application.feePaid ? context.l10n.appDetailPaid : context.l10n.appDetailPendingPayment,
                      valueColor:
                          application.feePaid ? AppColors.success : AppColors.warning,
                    ),
                  ],
                ),
              ),
              if (!application.feePaid) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    _showPaymentDialog(context, ref);
                  },
                  icon: const Icon(Icons.payment),
                  label: Text(context.l10n.appDetailPayFee),
                ),
              ],
              const SizedBox(height: 24),
            ],

            // Review Notes
            if (application.reviewNotes != null &&
                application.reviewNotes!.isNotEmpty) ...[
              Text(
                context.l10n.appDetailReviewNotes,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              CustomCard(
                color: _getStatusColor().withValues(alpha: 0.05),
                child: Text(
                  application.reviewNotes!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Documents
            Text(
              context.l10n.appDetailDocuments,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _DocumentItem(
                    name: context.l10n.appDetailTranscript,
                    status: context.l10n.appDetailUploaded,
                    icon: Icons.description,
                  ),
                  const Divider(),
                  _DocumentItem(
                    name: context.l10n.appDetailIdDocument,
                    status: context.l10n.appDetailUploaded,
                    icon: Icons.badge,
                  ),
                  const Divider(),
                  _DocumentItem(
                    name: context.l10n.appDetailPersonalStatement,
                    status: context.l10n.appDetailUploaded,
                    icon: Icons.article,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            if (application.isPending) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showWithdrawDialog(context, ref);
                      },
                      icon: const Icon(Icons.cancel),
                      label: Text(context.l10n.appDetailWithdraw),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to edit
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(context.l10n.appDetailEdit),
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

  StatusBadge _getStatusBadge() {
    switch (application.status) {
      case 'pending':
        return StatusBadge.pending();
      case 'under_review':
        return StatusBadge.inProgress();
      case 'accepted':
        return StatusBadge.approved();
      case 'rejected':
        return StatusBadge.rejected();
      default:
        return StatusBadge.pending();
    }
  }

  Color _getStatusColor() {
    switch (application.status) {
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
    switch (application.status) {
      case 'pending':
        return Icons.pending;
      case 'under_review':
        return Icons.hourglass_empty;
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(BuildContext context) {
    switch (application.status) {
      case 'pending':
        return context.l10n.appStatusPendingReview;
      case 'under_review':
        return context.l10n.appStatusUnderReview;
      case 'accepted':
        return context.l10n.appStatusAccepted;
      case 'rejected':
        return context.l10n.appStatusRejected;
      default:
        return context.l10n.appStatusUnknown;
    }
  }

  Future<void> _showPaymentDialog(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.appPaymentDialogTitle),
        content: Text(
          context.l10n.appPaymentDialogContent(application.applicationFee!.toStringAsFixed(2)),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.appCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();

              try {
                // Process payment via provider
                final success = await ref.read(applicationsProvider.notifier).payApplicationFee(
                  application.id,
                  application.applicationFee!,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? context.l10n.appPaymentSuccess
                            : context.l10n.appPaymentFailed,
                      ),
                      backgroundColor: success ? AppColors.success : AppColors.error,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.appErrorPayment(e.toString())),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(context.l10n.appPayNow),
          ),
        ],
      ),
    );
  }

  Future<void> _showWithdrawDialog(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.appWithdrawTitle),
        content: Text(
          context.l10n.appWithdrawConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.appCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();

              try {
                // Withdraw application via provider
                final success = await ref.read(applicationsProvider.notifier).withdrawApplication(
                  application.id,
                );

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.appWithdrawSuccess),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.pop(); // Navigate back to applications list
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.appWithdrawFailed),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.appErrorWithdraw(e.toString())),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.appDetailWithdraw),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;

  const _DocumentItem({
    required this.name,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  status,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              // TODO: View document
            },
          ),
        ],
      ),
    );
  }
}
