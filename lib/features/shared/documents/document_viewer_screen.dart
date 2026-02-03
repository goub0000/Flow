import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/document_model.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/custom_card.dart';
import '../widgets/enhanced_document_viewer.dart';
import '../widgets/cached_image.dart';

class DocumentViewerScreen extends StatelessWidget {
  final Document document;

  const DocumentViewerScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.sharedDocumentsBack,
        ),
        title: Text(
          document.name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.sharedDocumentsDownloading(document.name))),
              );
            },
            tooltip: context.l10n.sharedDocumentsDownload,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.sharedDocumentsShareComingSoon)),
              );
            },
            tooltip: context.l10n.sharedDocumentsShare,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 12),
                    Text(context.l10n.sharedDocumentsDocumentInfo),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 20, color: AppColors.error),
                    const SizedBox(width: 12),
                    Text(context.l10n.sharedDocumentsDelete, style: const TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'info') {
                _showDocumentInfo(context);
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Document Preview Area
          Expanded(
            child: _buildDocumentPreview(context),
          ),

          // Document Info Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getFileColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getFileIcon(),
                      color: _getFileColor(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                document.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (document.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.verified,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${document.formattedSize} • ${document.categoryDisplayName}',
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

  Widget _buildDocumentPreview(BuildContext context) {
    // Use enhanced document viewer for images and PDFs
    if ((document.isImage || document.isPDF) && document.url != null) {
      return EnhancedDocumentViewer(
        document: document,
        showControls: true,
      );
    }

    // Fallback for unsupported types
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CustomCard(
          child: _buildPreviewPlaceholder(
            icon: _getFileIcon(),
            message: context.l10n.sharedDocumentsPreviewNotAvailable,
            subtitle: context.l10n.sharedDocumentsPreviewNotAvailableSubtitle(document.fileExtension),
            color: _getFileColor(),
            action: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement download
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.sharedDocumentsDownloading(document.name))),
                );
              },
              icon: const Icon(Icons.download),
              label: Text(context.l10n.sharedDocumentsDownloadFile),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getFileColor(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewPlaceholder({
    required IconData icon,
    required String message,
    String? subtitle,
    Color? color,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: (color ?? AppColors.textSecondary).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 24),
            action,
          ],
        ],
      ),
    );
  }

  void _showDocumentInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.sharedDocumentsDocumentInformation,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 24),
                        _InfoRow(label: context.l10n.sharedDocumentsName, value: document.name),
                        const Divider(height: 24),
                        _InfoRow(label: context.l10n.sharedDocumentsType, value: document.fileExtension),
                        const Divider(height: 24),
                        _InfoRow(label: context.l10n.sharedDocumentsSize, value: document.formattedSize),
                        const Divider(height: 24),
                        _InfoRow(
                            label: context.l10n.sharedDocumentsCategory,
                            value: document.categoryDisplayName),
                        const Divider(height: 24),
                        _InfoRow(
                            label: context.l10n.sharedDocumentsUploadedBy,
                            value: document.uploadedByName ?? context.l10n.sharedDocumentsUnknown),
                        const Divider(height: 24),
                        _InfoRow(
                          label: context.l10n.sharedDocumentsUploadDate,
                          value: _formatFullDate(document.uploadedAt),
                        ),
                        if (document.description != null) ...[
                          const Divider(height: 24),
                          _InfoRow(
                              label: context.l10n.sharedDocumentsDescription,
                              value: document.description!),
                        ],
                        const Divider(height: 24),
                        _InfoRow(
                          label: context.l10n.sharedDocumentsVerificationStatus,
                          value: document.isVerified ? context.l10n.sharedDocumentsVerified : context.l10n.sharedDocumentsPending,
                          valueColor: document.isVerified
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.sharedDocumentsDeleteDocumentTitle),
        content: Text(context.l10n.sharedDocumentsDeleteDocumentConfirm(document.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.sharedDocumentsCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close viewer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.sharedDocumentsDocumentDeleted),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.sharedDocumentsDelete),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    if (document.isPDF) return Icons.picture_as_pdf;
    if (document.isImage) return Icons.image;
    if (document.isDocument) return Icons.description;
    return Icons.insert_drive_file;
  }

  Color _getFileColor() {
    if (document.isPDF) return AppColors.error;
    if (document.isImage) return AppColors.success;
    if (document.isDocument) return AppColors.info;
    return AppColors.textSecondary;
  }

  String _formatFullDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
