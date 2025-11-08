import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/progress_analytics_widgets.dart';

/// Achievements Screen
///
/// Displays earned and locked achievements/badges.

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Achievement> _achievements;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateMockAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockAchievements() {
    _achievements = [
      Achievement(
        id: '1',
        title: 'First Steps',
        description: 'Complete your first lesson',
        icon: Icons.star,
        color: Colors.amber,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 30)),
        progress: 1,
        target: 1,
      ),
      Achievement(
        id: '2',
        title: 'Course Completed',
        description: 'Finish your first course',
        icon: Icons.school,
        color: AppColors.success,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 15)),
        progress: 1,
        target: 1,
      ),
      Achievement(
        id: '3',
        title: 'Week Warrior',
        description: 'Maintain a 7-day learning streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        progress: 7,
        target: 7,
      ),
      Achievement(
        id: '4',
        title: 'Perfect Score',
        description: 'Get 100% on any quiz',
        icon: Icons.grade,
        color: Colors.purple,
        isUnlocked: false,
        progress: 95,
        target: 100,
      ),
      Achievement(
        id: '5',
        title: 'Marathon Learner',
        description: 'Study for 100 hours',
        icon: Icons.timer,
        color: AppColors.info,
        isUnlocked: false,
        progress: 87,
        target: 100,
      ),
      Achievement(
        id: '6',
        title: 'Social Butterfly',
        description: 'Connect with 10 learners',
        icon: Icons.people,
        color: Colors.pink,
        isUnlocked: false,
        progress: 4,
        target: 10,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('Achievements'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Unlocked ($unlockedCount)'),
            Tab(text: 'Locked (${_achievements.length - unlockedCount})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  '$unlockedCount of ${_achievements.length} achievements unlocked',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Achievements Grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementGrid(
                  _achievements.where((a) => a.isUnlocked).toList(),
                ),
                _buildAchievementGrid(
                  _achievements.where((a) => !a.isUnlocked).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGrid(List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return Center(
        child: Text(
          'No achievements yet',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return AchievementBadge(
          achievement: achievements[index],
          onTap: () => _showAchievementDetail(achievements[index]),
        );
      },
    );
  }

  void _showAchievementDetail(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(achievement.icon, size: 64, color: achievement.color),
            const SizedBox(height: 16),
            Text(achievement.description, textAlign: TextAlign.center),
            if (!achievement.isUnlocked) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: achievement.progressPercentage / 100,
                color: achievement.color,
              ),
              const SizedBox(height: 8),
              Text('${achievement.progress}/${achievement.target}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
