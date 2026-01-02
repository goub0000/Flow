import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';

/// Base entity card widget
abstract class EntityCard extends StatelessWidget {
  const EntityCard({super.key});
}

/// University card for displaying university information in chat
class UniversityCard extends EntityCard {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final int? rank;
  final double? acceptanceRate;
  final String? matchScore;
  final String? category; // Safety, Match, Reach
  final VoidCallback? onViewDetails;
  final VoidCallback? onApply;
  final VoidCallback? onFavorite;
  final bool isFavorited;

  const UniversityCard({
    super.key,
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    this.rank,
    this.acceptanceRate,
    this.matchScore,
    this.category,
    this.onViewDetails,
    this.onApply,
    this.onFavorite,
    this.isFavorited = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 320),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with logo and info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Logo
                _buildLogo(),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Category badge
                if (category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Stats row
          if (rank != null || acceptanceRate != null || matchScore != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (rank != null)
                    _buildStat('Rank', '#$rank'),
                  if (acceptanceRate != null)
                    _buildStat('Accept', '${acceptanceRate!.toStringAsFixed(0)}%'),
                  if (matchScore != null)
                    _buildStat('Match', matchScore!),
                ],
              ),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Favorite button
                if (onFavorite != null)
                  IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : AppColors.textSecondary,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                const Spacer(),
                // View Details
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Details'),
                  ),
                // Apply button
                if (onApply != null)
                  ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Apply'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    if (logoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: logoUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildLogoPlaceholder(),
          errorWidget: (_, __, ___) => _buildLogoPlaceholder(),
        ),
      );
    }
    return _buildLogoPlaceholder();
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor() {
    switch (category?.toLowerCase()) {
      case 'safety':
        return AppColors.success;
      case 'match':
        return AppColors.primary;
      case 'reach':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Course card for displaying course information in chat
class CourseCard extends EntityCard {
  final String id;
  final String name;
  final String university;
  final String? thumbnailUrl;
  final String? duration;
  final String? level;
  final double? progress;
  final int? lessonsCount;
  final VoidCallback? onViewDetails;
  final VoidCallback? onContinue;
  final VoidCallback? onEnroll;

  const CourseCard({
    super.key,
    required this.id,
    required this.name,
    required this.university,
    this.thumbnailUrl,
    this.duration,
    this.level,
    this.progress,
    this.lessonsCount,
    this.onViewDetails,
    this.onContinue,
    this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 320),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbnail
          if (thumbnailUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 120,
                  color: AppColors.border,
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 120,
                  color: AppColors.border,
                  child: Icon(
                    Icons.school,
                    color: AppColors.textSecondary,
                    size: 40,
                  ),
                ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // University
                Text(
                  university,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),

                // Meta info
                if (duration != null || level != null || lessonsCount != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      if (duration != null)
                        _buildMetaChip(Icons.access_time, duration!),
                      if (level != null)
                        _buildMetaChip(Icons.signal_cellular_alt, level!),
                      if (lessonsCount != null)
                        _buildMetaChip(Icons.play_circle_outline, '$lessonsCount lessons'),
                    ],
                  ),
                ],

                // Progress bar (if enrolled)
                if (progress != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress!,
                            backgroundColor: AppColors.border,
                            color: AppColors.success,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress! * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Details'),
                  ),
                if (onContinue != null)
                  ElevatedButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                if (onEnroll != null && progress == null)
                  ElevatedButton(
                    onPressed: onEnroll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Enroll'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
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
}

/// Application status card for displaying application progress
class ApplicationCard extends EntityCard {
  final String id;
  final String universityName;
  final String status;
  final String? logoUrl;
  final String? deadline;
  final double? completionProgress;
  final List<String>? pendingTasks;
  final VoidCallback? onViewDetails;
  final VoidCallback? onContinue;

  const ApplicationCard({
    super.key,
    required this.id,
    required this.universityName,
    required this.status,
    this.logoUrl,
    this.deadline,
    this.completionProgress,
    this.pendingTasks,
    this.onViewDetails,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusBorderColor(),
          width: _isUrgent() ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Logo
                _buildLogo(),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        universityName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildStatusChip(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress bar
          if (completionProgress != null && status.toLowerCase() != 'submitted') ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(completionProgress! * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completionProgress!,
                      backgroundColor: AppColors.border,
                      color: AppColors.primary,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Deadline warning
          if (deadline != null)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isUrgent()
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: _isUrgent() ? AppColors.error : AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Deadline: $deadline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isUrgent() ? AppColors.error : AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

          // Pending tasks
          if (pendingTasks != null && pendingTasks!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Do:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...pendingTasks!.take(3).map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('View Details'),
                  ),
                if (onContinue != null &&
                    status.toLowerCase() != 'submitted' &&
                    status.toLowerCase() != 'accepted' &&
                    status.toLowerCase() != 'rejected')
                  ElevatedButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    if (logoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: logoUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildLogoPlaceholder(),
          errorWidget: (_, __, ___) => _buildLogoPlaceholder(),
        ),
      );
    }
    return _buildLogoPlaceholder();
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          _getStatusIcon(),
          color: _getStatusColor(),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: 12,
            color: _getStatusColor(),
          ),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'submitted':
      case 'pending':
        return AppColors.info;
      case 'in_progress':
        return AppColors.primary;
      case 'planning':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBorderColor() {
    if (_isUrgent()) return AppColors.error;
    return AppColors.border;
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'submitted':
        return Icons.send;
      case 'pending':
        return Icons.hourglass_empty;
      case 'in_progress':
        return Icons.edit;
      case 'planning':
        return Icons.lightbulb;
      default:
        return Icons.description;
    }
  }

  bool _isUrgent() {
    // Check if deadline is within 7 days
    if (deadline == null) return false;
    // Simple check - in real implementation, parse the date
    return status.toLowerCase() != 'submitted' &&
        status.toLowerCase() != 'accepted' &&
        status.toLowerCase() != 'rejected';
  }
}
