import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Achievements and Gamification Widgets
///
/// Comprehensive widget library for achievements system:
/// - Achievement models and types
/// - Badge displays
/// - Leaderboard components
/// - Progress trackers
/// - Milestone displays
/// - Reward animations
///
/// Backend Integration TODO:
/// - Fetch achievements from backend
/// - Track progress updates
/// - Unlock achievements
/// - Sync leaderboard data
/// - Award notifications

// Enums
enum AchievementCategory {
  learning,
  social,
  practice,
  streak,
  mastery,
  special
}

enum AchievementRarity { common, rare, epic, legendary }

enum BadgeTier { bronze, silver, gold, platinum, diamond }

// Models
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final int currentValue;
  final int targetValue;
  final String? rewardDescription;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    this.rarity = AchievementRarity.common,
    required this.points,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.currentValue = 0,
    required this.targetValue,
    this.rewardDescription,
  });

  String get categoryLabel {
    switch (category) {
      case AchievementCategory.learning:
        return 'Learning';
      case AchievementCategory.social:
        return 'Social';
      case AchievementCategory.practice:
        return 'Practice';
      case AchievementCategory.streak:
        return 'Streak';
      case AchievementCategory.mastery:
        return 'Mastery';
      case AchievementCategory.special:
        return 'Special';
    }
  }

  String get rarityLabel {
    switch (rarity) {
      case AchievementRarity.common:
        return 'Common';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.legendary:
        return 'Legendary';
    }
  }

  Color get rarityColor {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  String get progressText {
    return '$currentValue / $targetValue';
  }
}

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final int rank;
  final int points;
  final int coursesCompleted;
  final int achievementsUnlocked;
  final double averageScore;
  final bool isCurrentUser;
  final BadgeTier? tier;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.rank,
    required this.points,
    this.coursesCompleted = 0,
    this.achievementsUnlocked = 0,
    this.averageScore = 0.0,
    this.isCurrentUser = false,
    this.tier,
  });

  String get tierLabel {
    if (tier == null) return '';
    switch (tier!) {
      case BadgeTier.bronze:
        return 'Bronze';
      case BadgeTier.silver:
        return 'Silver';
      case BadgeTier.gold:
        return 'Gold';
      case BadgeTier.platinum:
        return 'Platinum';
      case BadgeTier.diamond:
        return 'Diamond';
    }
  }

  Color get tierColor {
    if (tier == null) return Colors.grey;
    switch (tier!) {
      case BadgeTier.bronze:
        return const Color(0xFFCD7F32);
      case BadgeTier.silver:
        return const Color(0xFFC0C0C0);
      case BadgeTier.gold:
        return const Color(0xFFFFD700);
      case BadgeTier.platinum:
        return const Color(0xFFE5E4E2);
      case BadgeTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  IconData get tierIcon {
    if (tier == null) return Icons.workspace_premium_outlined;
    switch (tier!) {
      case BadgeTier.bronze:
        return Icons.workspace_premium;
      case BadgeTier.silver:
        return Icons.workspace_premium;
      case BadgeTier.gold:
        return Icons.workspace_premium;
      case BadgeTier.platinum:
        return Icons.workspace_premium;
      case BadgeTier.diamond:
        return Icons.diamond;
    }
  }
}

class Milestone {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime date;
  final MilestoneType type;
  final String? relatedCourse;
  final int? pointsEarned;

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.date,
    required this.type,
    this.relatedCourse,
    this.pointsEarned,
  });

  String get typeLabel {
    switch (type) {
      case MilestoneType.courseCompleted:
        return 'Course Completed';
      case MilestoneType.achievementUnlocked:
        return 'Achievement Unlocked';
      case MilestoneType.levelUp:
        return 'Level Up';
      case MilestoneType.streakMilestone:
        return 'Streak Milestone';
      case MilestoneType.examPassed:
        return 'Exam Passed';
      case MilestoneType.certificateEarned:
        return 'Certificate Earned';
    }
  }

  Color get typeColor {
    switch (type) {
      case MilestoneType.courseCompleted:
        return AppColors.success;
      case MilestoneType.achievementUnlocked:
        return Colors.purple;
      case MilestoneType.levelUp:
        return Colors.orange;
      case MilestoneType.streakMilestone:
        return Colors.blue;
      case MilestoneType.examPassed:
        return AppColors.primary;
      case MilestoneType.certificateEarned:
        return Colors.amber;
    }
  }
}

enum MilestoneType {
  courseCompleted,
  achievementUnlocked,
  levelUp,
  streakMilestone,
  examPassed,
  certificateEarned
}

// Widgets
class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: achievement.isUnlocked ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: achievement.isUnlocked
              ? achievement.rarityColor
              : Colors.grey.shade300,
          width: achievement.isUnlocked ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with rarity border
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: achievement.isUnlocked
                          ? LinearGradient(
                              colors: [
                                achievement.color,
                                achievement.color.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: achievement.isUnlocked
                          ? null
                          : Colors.grey.shade300,
                      border: Border.all(
                        color: achievement.rarityColor,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      achievement.icon,
                      size: 40,
                      color: achievement.isUnlocked
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (!achievement.isUnlocked)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? Colors.black87
                      : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Progress or unlock date
              if (achievement.isUnlocked && achievement.unlockedAt != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(context, achievement.unlockedAt!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                LinearProgressIndicator(
                  value: achievement.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.progressText,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],

              const SizedBox(height: 8),

              // Points and rarity
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: achievement.rarityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      achievement.rarityLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: achievement.rarityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars,
                          size: 12,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${achievement.points}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return context.l10n.swAchievementToday;
    } else if (difference.inDays == 1) {
      return context.l10n.swAchievementYesterday;
    } else if (difference.inDays < 7) {
      return context.l10n.swAchievementDaysAgo(difference.inDays);
    } else if (difference.inDays < 30) {
      return context.l10n.swAchievementWeeksAgo((difference.inDays / 7).floor());
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final VoidCallback? onTap;

  const LeaderboardCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: entry.isCurrentUser ? 3 : 1,
      color: entry.isCurrentUser
          ? AppColors.primary.withValues(alpha: 0.05)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: entry.isCurrentUser
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getRankColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getRankColor(),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: entry.rank <= 3
                      ? Icon(
                          _getRankIcon(),
                          color: _getRankColor(),
                          size: 24,
                        )
                      : Text(
                          '${entry.rank}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getRankColor(),
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: entry.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          entry.avatarUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person);
                          },
                        ),
                      )
                    : Text(
                        entry.userName[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
              ),
              const SizedBox(width: 16),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            entry.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (entry.isCurrentUser) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              context.l10n.swAchievementYou,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (entry.tier != null) ...[
                          Icon(
                            entry.tierIcon,
                            size: 14,
                            color: entry.tierColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.tierLabel,
                            style: TextStyle(
                              fontSize: 12,
                              color: entry.tierColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.emoji_events,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${entry.achievementsUnlocked}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 20,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.points}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    context.l10n.swAchievementPoints,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor() {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.primary;
    }
  }

  IconData _getRankIcon() {
    switch (entry.rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events_outlined;
      case 3:
        return Icons.emoji_events_outlined;
      default:
        return Icons.workspace_premium;
    }
  }
}

class MilestoneTimelineItem extends StatelessWidget {
  final Milestone milestone;
  final bool isLast;

  const MilestoneTimelineItem({
    super.key,
    required this.milestone,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: milestone.typeColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: milestone.typeColor,
                  width: 3,
                ),
              ),
              child: Icon(
                milestone.icon,
                size: 20,
                color: milestone.typeColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            milestone.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (milestone.pointsEarned != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.stars,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '+${milestone.pointsEarned}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      milestone.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: milestone.typeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            milestone.typeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: milestone.typeColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(milestone.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class EmptyAchievementsState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyAchievementsState({
    super.key,
    required this.message,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.explore),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
