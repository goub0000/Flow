import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/achievements_widgets.dart';

/// Achievements Gallery Screen
///
/// Main interface for achievements display:
/// - Browse all achievements
/// - Filter by category and status
/// - View achievement details
/// - Track progress
/// - Display total points and level
///
/// Backend Integration TODO:
/// - Fetch achievements from backend
/// - Real-time progress updates
/// - Push notifications for unlocks
/// - Achievement sharing

class AchievementsGalleryScreen extends ConsumerStatefulWidget {
  const AchievementsGalleryScreen({super.key});

  @override
  ConsumerState<AchievementsGalleryScreen> createState() =>
      _AchievementsGalleryScreenState();
}

class _AchievementsGalleryScreenState extends ConsumerState<AchievementsGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AchievementCategory? _selectedCategory;
  late List<Achievement> _achievements;
  int _totalPoints = 0;
  int _currentLevel = 0;
  int _pointsToNextLevel = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockAchievements();
    _calculateStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockAchievements() {
    final now = DateTime.now();

    _achievements = [
      Achievement(
        id: '1',
        title: 'First Steps',
        description: 'Complete your first lesson',
        icon: Icons.directions_walk,
        color: Colors.green,
        category: AchievementCategory.learning,
        rarity: AchievementRarity.common,
        points: 10,
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 30)),
        progress: 1.0,
        currentValue: 1,
        targetValue: 1,
      ),
      Achievement(
        id: '2',
        title: 'Knowledge Seeker',
        description: 'Complete 10 lessons',
        icon: Icons.school,
        color: Colors.blue,
        category: AchievementCategory.learning,
        rarity: AchievementRarity.common,
        points: 25,
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 20)),
        progress: 1.0,
        currentValue: 10,
        targetValue: 10,
      ),
      Achievement(
        id: '3',
        title: 'Course Master',
        description: 'Complete your first course',
        icon: Icons.workspace_premium,
        color: Colors.purple,
        category: AchievementCategory.mastery,
        rarity: AchievementRarity.rare,
        points: 50,
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 15)),
        progress: 1.0,
        currentValue: 1,
        targetValue: 1,
      ),
      Achievement(
        id: '4',
        title: 'Perfect Score',
        description: 'Score 100% on any exam',
        icon: Icons.grade,
        color: Colors.amber,
        category: AchievementCategory.practice,
        rarity: AchievementRarity.epic,
        points: 100,
        isUnlocked: false,
        progress: 0.85,
        currentValue: 85,
        targetValue: 100,
      ),
      Achievement(
        id: '5',
        title: 'Week Warrior',
        description: 'Maintain a 7-day study streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        category: AchievementCategory.streak,
        rarity: AchievementRarity.rare,
        points: 75,
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 5)),
        progress: 1.0,
        currentValue: 7,
        targetValue: 7,
      ),
      Achievement(
        id: '6',
        title: 'Social Butterfly',
        description: 'Join 5 study groups',
        icon: Icons.groups,
        color: Colors.pink,
        category: AchievementCategory.social,
        rarity: AchievementRarity.common,
        points: 30,
        isUnlocked: false,
        progress: 0.6,
        currentValue: 3,
        targetValue: 5,
      ),
      Achievement(
        id: '7',
        title: 'Quiz Champion',
        description: 'Pass 50 quizzes',
        icon: Icons.quiz,
        color: Colors.teal,
        category: AchievementCategory.practice,
        rarity: AchievementRarity.rare,
        points: 60,
        isUnlocked: false,
        progress: 0.42,
        currentValue: 21,
        targetValue: 50,
      ),
      Achievement(
        id: '8',
        title: 'Early Bird',
        description: 'Study before 8 AM for 5 days',
        icon: Icons.wb_sunny,
        color: Colors.yellow,
        category: AchievementCategory.special,
        rarity: AchievementRarity.rare,
        points: 40,
        isUnlocked: false,
        progress: 0.4,
        currentValue: 2,
        targetValue: 5,
      ),
      Achievement(
        id: '9',
        title: 'Legendary Learner',
        description: 'Complete 100 lessons',
        icon: Icons.auto_awesome,
        color: Colors.deepPurple,
        category: AchievementCategory.mastery,
        rarity: AchievementRarity.legendary,
        points: 200,
        isUnlocked: false,
        progress: 0.35,
        currentValue: 35,
        targetValue: 100,
      ),
      Achievement(
        id: '10',
        title: 'Month Marathon',
        description: 'Maintain a 30-day study streak',
        icon: Icons.emoji_events,
        color: Colors.red,
        category: AchievementCategory.streak,
        rarity: AchievementRarity.legendary,
        points: 250,
        isUnlocked: false,
        progress: 0.23,
        currentValue: 7,
        targetValue: 30,
      ),
      Achievement(
        id: '11',
        title: 'Helpful Hand',
        description: 'Help 10 students in study groups',
        icon: Icons.volunteer_activism,
        color: Colors.green,
        category: AchievementCategory.social,
        rarity: AchievementRarity.rare,
        points: 50,
        isUnlocked: false,
        progress: 0.3,
        currentValue: 3,
        targetValue: 10,
      ),
      Achievement(
        id: '12',
        title: 'Speed Learner',
        description: 'Complete a course in under 7 days',
        icon: Icons.speed,
        color: Colors.cyan,
        category: AchievementCategory.special,
        rarity: AchievementRarity.epic,
        points: 150,
        isUnlocked: false,
        progress: 0.0,
        currentValue: 0,
        targetValue: 1,
      ),
    ];
  }

  void _calculateStats() {
    _totalPoints = _achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) => sum + a.points);

    // Calculate level (every 100 points = 1 level)
    _currentLevel = (_totalPoints / 100).floor() + 1;
    _pointsToNextLevel = 100 - (_totalPoints % 100);
  }

  List<Achievement> get _unlockedAchievements {
    return _achievements
        .where((a) => a.isUnlocked)
        .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));
  }

  List<Achievement> get _lockedAchievements {
    return _achievements
        .where((a) => !a.isUnlocked)
        .toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
  }

  List<Achievement> get _filteredAchievements {
    var filtered = _achievements;

    if (_selectedCategory != null) {
      filtered = filtered
          .where((a) => a.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filter',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${_filteredAchievements.length})'),
            Tab(text: 'Unlocked (${_unlockedAchievements.length})'),
            Tab(text: 'Locked (${_lockedAchievements.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Header
          _buildStatsHeader(),

          // Active filter
          if (_selectedCategory != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Chip(
                    label: Text(_getCategoryLabel(_selectedCategory!)),
                    onDeleted: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Achievements Grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementsGrid(_filteredAchievements),
                _buildAchievementsGrid(_unlockedAchievements),
                _buildAchievementsGrid(_lockedAchievements),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final levelProgress = (_totalPoints % 100) / 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Level',
                '$_currentLevel',
                Icons.emoji_events,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white30,
              ),
              _buildStatItem(
                'Points',
                '$_totalPoints',
                Icons.stars,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white30,
              ),
              _buildStatItem(
                'Unlocked',
                '${_unlockedAchievements.length}/${_achievements.length}',
                Icons.lock_open,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $_currentLevel',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$_pointsToNextLevel points to Level ${_currentLevel + 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: levelProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsGrid(List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return EmptyAchievementsState(
        message: _selectedCategory != null
            ? 'No achievements in this category'
            : 'No achievements found',
        subtitle: _selectedCategory != null
            ? 'Try a different category'
            : 'Start learning to unlock achievements',
        onAction: _selectedCategory != null
            ? () {
                setState(() {
                  _selectedCategory = null;
                });
              }
            : null,
        actionLabel: 'Clear Filter',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh achievements from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return AchievementCard(
            achievement: achievement,
            onTap: () => _showAchievementDetails(achievement),
          );
        },
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: achievement.isUnlocked
                      ? LinearGradient(
                          colors: [
                            achievement.color,
                            achievement.color.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                  color: achievement.isUnlocked
                      ? null
                      : Colors.grey.shade300,
                  border: Border.all(
                    color: achievement.rarityColor,
                    width: 4,
                  ),
                ),
                child: Icon(
                  achievement.icon,
                  size: 50,
                  color:
                      achievement.isUnlocked ? Colors.white : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                achievement.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Rarity and category
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: achievement.rarityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      achievement.rarityLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: achievement.rarityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      achievement.categoryLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Progress or unlock info
              if (achievement.isUnlocked) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unlocked!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      if (achievement.unlockedAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatFullDate(achievement.unlockedAt!),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: achievement.progress,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          AlwaysStoppedAnimation<Color>(achievement.color),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${achievement.progressText} - ${(achievement.progress * 100).toStringAsFixed(0)}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

              // Points reward
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      '${achievement.points} Points',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Achievements',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        setSheetState(() {
                          _selectedCategory = null;
                        });
                        setState(() {
                          _selectedCategory = null;
                        });
                      },
                    ),
                    ...AchievementCategory.values.map((category) {
                      return FilterChip(
                        label: Text(_getCategoryLabel(category)),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setSheetState(() {
                            _selectedCategory = selected ? category : null;
                          });
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCategoryLabel(AchievementCategory category) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
