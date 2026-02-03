import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import 'logo_avatar.dart';

/// User Profile Widgets Library
///
/// Comprehensive widget collection for user profiles:
/// - User models and types
/// - Profile cards and info displays
/// - Statistics widgets
/// - Achievement badges
/// - Activity tracking
///
/// Backend Integration TODO:
/// - Fetch user data from backend
/// - Update profile information
/// - Track user activity
/// - Sync achievements and badges

// ============================================================================
// MODELS
// ============================================================================

/// User Role Enum
enum UserRole {
  student,
  instructor,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.admin:
        return 'Admin';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school;
      case UserRole.instructor:
        return Icons.person;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  Color get color {
    switch (this) {
      case UserRole.student:
        return AppColors.primary;
      case UserRole.instructor:
        return AppColors.success;
      case UserRole.admin:
        return AppColors.error;
    }
  }
}

/// Achievement Model
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime earnedAt;
  final bool isUnlocked;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.earnedAt,
    this.isUnlocked = true,
  });
}

/// User Statistics Model
class UserStatistics {
  final int coursesEnrolled;
  final int coursesCompleted;
  final int totalLessons;
  final int lessonsCompleted;
  final int quizzesTaken;
  final double averageScore;
  final int totalStudyHours;
  final int currentStreak;
  final int longestStreak;
  final int tasksCompleted;
  final int notesCreated;
  final List<AchievementModel> achievements;

  UserStatistics({
    required this.coursesEnrolled,
    required this.coursesCompleted,
    required this.totalLessons,
    required this.lessonsCompleted,
    required this.quizzesTaken,
    required this.averageScore,
    required this.totalStudyHours,
    required this.currentStreak,
    required this.longestStreak,
    required this.tasksCompleted,
    required this.notesCreated,
    required this.achievements,
  });

  double get courseCompletionRate {
    if (coursesEnrolled == 0) return 0;
    return (coursesCompleted / coursesEnrolled) * 100;
  }

  double get lessonCompletionRate {
    if (totalLessons == 0) return 0;
    return (lessonsCompleted / totalLessons) * 100;
  }
}

/// User Model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserRole role;
  final String? bio;
  final DateTime joinedDate;
  final String? location;
  final String? website;
  final List<String> interests;
  final UserStatistics statistics;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    this.bio,
    required this.joinedDate,
    this.location,
    this.website,
    this.interests = const [],
    required this.statistics,
    this.isVerified = false,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Profile Header Widget
class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEditProfile;
  final VoidCallback? onSettings;

  const ProfileHeader({
    super.key,
    required this.user,
    this.onEditProfile,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: LogoAvatar.user(
                    photoUrl: user.avatarUrl,
                    initials: user.initials,
                    size: 100,
                    backgroundColor: Colors.white,
                  ),
                ),
                if (user.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: AppColors.success,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Name and Role
            Text(
              user.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    user.role.icon,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.role.displayName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Bio
            if (user.bio != null) ...[
              const SizedBox(height: 16),
              Text(
                user.bio!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Action Buttons
            if (onEditProfile != null || onSettings != null) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onEditProfile != null)
                    FilledButton.icon(
                      onPressed: onEditProfile,
                      icon: const Icon(Icons.edit),
                      label: Text(context.l10n.swUserProfileEditProfile),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  if (onEditProfile != null && onSettings != null)
                    const SizedBox(width: 12),
                  if (onSettings != null)
                    OutlinedButton.icon(
                      onPressed: onSettings,
                      icon: const Icon(Icons.settings),
                      label: Text(context.l10n.swUserProfileSettings),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
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
}

/// Statistics Card Widget
class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Achievement Badge Widget
class AchievementBadge extends StatelessWidget {
  final AchievementModel achievement;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withValues(alpha: 0.1)
                      : AppColors.textSecondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement.icon,
                  size: 30,
                  color: achievement.isUnlocked
                      ? achievement.color
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: achievement.isUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile Info Row Widget
class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Progress Ring Widget
class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;
  final Widget? child;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.color = AppColors.primary,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Interest Tag Widget
class InterestTag extends StatelessWidget {
  final String interest;
  final VoidCallback? onDelete;

  const InterestTag({
    super.key,
    required this.interest,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            interest,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Activity Timeline Item Widget
class ActivityTimelineItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isLast;

  const ActivityTimelineItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(timestamp, context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
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

  String _formatTimestamp(DateTime timestamp, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return context.l10n.swUserProfileJustNow;
    if (difference.inMinutes < 60) return context.l10n.swUserProfileMinutesAgo(difference.inMinutes.toString());
    if (difference.inHours < 24) return context.l10n.swUserProfileHoursAgo(difference.inHours.toString());
    if (difference.inDays < 7) return context.l10n.swUserProfileDaysAgo(difference.inDays.toString());

    final months = [
      context.l10n.swUserProfileMonthJan,
      context.l10n.swUserProfileMonthFeb,
      context.l10n.swUserProfileMonthMar,
      context.l10n.swUserProfileMonthApr,
      context.l10n.swUserProfileMonthMay,
      context.l10n.swUserProfileMonthJun,
      context.l10n.swUserProfileMonthJul,
      context.l10n.swUserProfileMonthAug,
      context.l10n.swUserProfileMonthSep,
      context.l10n.swUserProfileMonthOct,
      context.l10n.swUserProfileMonthNov,
      context.l10n.swUserProfileMonthDec
    ];
    return '${months[timestamp.month - 1]} ${timestamp.day}';
  }
}

/// Empty Profile State
class EmptyProfileState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyProfileState({
    super.key,
    required this.message,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel ?? context.l10n.swUserProfileGetStarted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
