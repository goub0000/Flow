import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Rich card message for displaying structured content
class CardMessage extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final String? description;
  final List<CardAction>? actions;
  final VoidCallback? onTap;

  const CardMessage({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.description,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            if (imageUrl != null) _buildImage(),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Subtitle
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  // Description
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty) _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 140,
          color: AppColors.border,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 140,
          color: AppColors.border,
          child: Icon(
            Icons.image_not_supported,
            color: AppColors.textSecondary,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions!.map((action) {
          if (action.isPrimary) {
            return ElevatedButton(
              onPressed: action.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(0, 36),
              ),
              child: Text(action.label, style: const TextStyle(fontSize: 13)),
            );
          }
          return TextButton(
            onPressed: action.onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: Text(action.label, style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
      ),
    );
  }
}

/// Action button for card message
class CardAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const CardAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.icon,
  });
}

/// Factory to create common card types
class CardMessageFactory {
  /// Create a university card
  static CardMessage university({
    required BuildContext context,
    required String name,
    required String location,
    String? logoUrl,
    int? rank,
    double? acceptanceRate,
    VoidCallback? onViewDetails,
    VoidCallback? onApply,
  }) {
    return CardMessage(
      imageUrl: logoUrl,
      title: name,
      subtitle: location,
      description: [
        if (rank != null) context.l10n.chatRankLabel(rank),
        if (acceptanceRate != null) context.l10n.chatAcceptanceLabel(acceptanceRate.toStringAsFixed(1)),
      ].join(' | '),
      actions: [
        if (onViewDetails != null)
          CardAction(
            label: context.l10n.chatViewDetails,
            onPressed: onViewDetails,
          ),
        if (onApply != null)
          CardAction(
            label: context.l10n.chatApply,
            onPressed: onApply,
            isPrimary: true,
          ),
      ],
    );
  }

  /// Create a course card
  static CardMessage course({
    required BuildContext context,
    required String name,
    required String university,
    String? thumbnailUrl,
    String? duration,
    String? level,
    VoidCallback? onViewDetails,
    VoidCallback? onEnroll,
  }) {
    return CardMessage(
      imageUrl: thumbnailUrl,
      title: name,
      subtitle: university,
      description: [
        if (duration != null) duration,
        if (level != null) level,
      ].join(' | '),
      actions: [
        if (onViewDetails != null)
          CardAction(
            label: context.l10n.chatLearnMore,
            onPressed: onViewDetails,
          ),
        if (onEnroll != null)
          CardAction(
            label: context.l10n.chatEnroll,
            onPressed: onEnroll,
            isPrimary: true,
          ),
      ],
    );
  }

  /// Create an application status card
  static CardMessage applicationStatus({
    required BuildContext context,
    required String universityName,
    required String status,
    String? deadline,
    String? logoUrl,
    VoidCallback? onViewApplication,
    VoidCallback? onContinue,
  }) {
    return CardMessage(
      imageUrl: logoUrl,
      title: universityName,
      subtitle: status.toUpperCase(),
      description: deadline != null ? context.l10n.chatDeadlineLabel(deadline) : null,
      actions: [
        if (onViewApplication != null)
          CardAction(
            label: context.l10n.chatViewDetails,
            onPressed: onViewApplication,
          ),
        if (onContinue != null && status.toLowerCase() == 'in_progress')
          CardAction(
            label: context.l10n.chatContinue,
            onPressed: onContinue,
            isPrimary: true,
          ),
      ],
    );
  }
}
