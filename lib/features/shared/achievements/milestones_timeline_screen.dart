import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/achievements_widgets.dart';

/// Milestones Timeline Screen
///
/// Visual timeline of user achievements:
/// - Chronological milestone display
/// - Filter by milestone type
/// - Monthly/yearly grouping
/// - Celebration animations
/// - Export timeline
///
/// Backend Integration TODO:
/// - Fetch milestones from backend
/// - Real-time milestone additions
/// - Share milestones
/// - Generate achievement reports

class MilestonesTimelineScreen extends StatefulWidget {
  const MilestonesTimelineScreen({super.key});

  @override
  State<MilestonesTimelineScreen> createState() =>
      _MilestonesTimelineScreenState();
}

class _MilestonesTimelineScreenState extends State<MilestonesTimelineScreen> {
  MilestoneType? _selectedType;
  late List<Milestone> _milestones;
  int _totalMilestones = 0;
  int _thisMonthCount = 0;

  @override
  void initState() {
    super.initState();
    _generateMockMilestones();
    _calculateStats();
  }

  void _generateMockMilestones() {
    final now = DateTime.now();

    _milestones = [
      Milestone(
        id: '1',
        title: 'Welcome to Flow!',
        description: 'Started your learning journey',
        icon: Icons.celebration,
        date: now.subtract(const Duration(days: 45)),
        type: MilestoneType.levelUp,
        pointsEarned: 10,
      ),
      Milestone(
        id: '2',
        title: 'First Lesson Completed',
        description: 'Completed Introduction to Programming',
        icon: Icons.school,
        date: now.subtract(const Duration(days: 44)),
        type: MilestoneType.courseCompleted,
        relatedCourse: 'Introduction to Programming',
        pointsEarned: 25,
      ),
      Milestone(
        id: '3',
        title: 'First Achievement Unlocked',
        description: 'Unlocked "First Steps" achievement',
        icon: Icons.emoji_events,
        date: now.subtract(const Duration(days: 44)),
        type: MilestoneType.achievementUnlocked,
        pointsEarned: 10,
      ),
      Milestone(
        id: '4',
        title: 'Quiz Master',
        description: 'Passed first quiz with 85%',
        icon: Icons.quiz,
        date: now.subtract(const Duration(days: 40)),
        type: MilestoneType.examPassed,
        relatedCourse: 'Introduction to Programming',
        pointsEarned: 30,
      ),
      Milestone(
        id: '5',
        title: '7-Day Streak!',
        description: 'Studied for 7 consecutive days',
        icon: Icons.local_fire_department,
        date: now.subtract(const Duration(days: 35)),
        type: MilestoneType.streakMilestone,
        pointsEarned: 75,
      ),
      Milestone(
        id: '6',
        title: 'Level Up!',
        description: 'Reached Level 2',
        icon: Icons.arrow_upward,
        date: now.subtract(const Duration(days: 32)),
        type: MilestoneType.levelUp,
        pointsEarned: 50,
      ),
      Milestone(
        id: '7',
        title: 'Course Completed',
        description: 'Finished Mobile App Development',
        icon: Icons.workspace_premium,
        date: now.subtract(const Duration(days: 25)),
        type: MilestoneType.courseCompleted,
        relatedCourse: 'Mobile App Development',
        pointsEarned: 100,
      ),
      Milestone(
        id: '8',
        title: 'Certificate Earned',
        description: 'Earned certificate in Mobile Development',
        icon: Icons.card_membership,
        date: now.subtract(const Duration(days: 25)),
        type: MilestoneType.certificateEarned,
        relatedCourse: 'Mobile App Development',
        pointsEarned: 150,
      ),
      Milestone(
        id: '9',
        title: 'Perfect Score',
        description: 'Scored 100% on Data Structures Midterm',
        icon: Icons.grade,
        date: now.subtract(const Duration(days: 20)),
        type: MilestoneType.examPassed,
        relatedCourse: 'Data Structures',
        pointsEarned: 100,
      ),
      Milestone(
        id: '10',
        title: 'Knowledge Seeker',
        description: 'Unlocked "Knowledge Seeker" achievement',
        icon: Icons.auto_awesome,
        date: now.subtract(const Duration(days: 18)),
        type: MilestoneType.achievementUnlocked,
        pointsEarned: 25,
      ),
      Milestone(
        id: '11',
        title: 'Level 3 Reached',
        description: 'Advanced to Level 3',
        icon: Icons.trending_up,
        date: now.subtract(const Duration(days: 15)),
        type: MilestoneType.levelUp,
        pointsEarned: 50,
      ),
      Milestone(
        id: '12',
        title: 'Course Master',
        description: 'Unlocked "Course Master" achievement',
        icon: Icons.military_tech,
        date: now.subtract(const Duration(days: 12)),
        type: MilestoneType.achievementUnlocked,
        pointsEarned: 50,
      ),
      Milestone(
        id: '13',
        title: 'Exam Champion',
        description: 'Passed Web Development Final Exam',
        icon: Icons.check_circle,
        date: now.subtract(const Duration(days: 8)),
        type: MilestoneType.examPassed,
        relatedCourse: 'Web Technologies',
        pointsEarned: 80,
      ),
      Milestone(
        id: '14',
        title: 'Certified Professional',
        description: 'Earned Web Development Certificate',
        icon: Icons.verified,
        date: now.subtract(const Duration(days: 7)),
        type: MilestoneType.certificateEarned,
        relatedCourse: 'Web Technologies',
        pointsEarned: 150,
      ),
      Milestone(
        id: '15',
        title: 'Week Warrior',
        description: 'Maintained 7-day study streak',
        icon: Icons.whatshot,
        date: now.subtract(const Duration(days: 5)),
        type: MilestoneType.achievementUnlocked,
        pointsEarned: 75,
      ),
      Milestone(
        id: '16',
        title: 'Quiz Champion',
        description: 'Passed AI Fundamentals Quiz',
        icon: Icons.psychology,
        date: now.subtract(const Duration(days: 2)),
        type: MilestoneType.examPassed,
        relatedCourse: 'Artificial Intelligence',
        pointsEarned: 60,
      ),
    ];

    // Sort by date descending (most recent first)
    _milestones.sort((a, b) => b.date.compareTo(a.date));
  }

  void _calculateStats() {
    _totalMilestones = _milestones.length;

    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);

    _thisMonthCount =
        _milestones.where((m) => m.date.isAfter(thisMonthStart)).length;
  }

  List<Milestone> get _filteredMilestones {
    if (_selectedType == null) return _milestones;
    return _milestones.where((m) => m.type == _selectedType).toList();
  }

  Map<String, List<Milestone>> get _groupedMilestones {
    final Map<String, List<Milestone>> grouped = {};

    for (final milestone in _filteredMilestones) {
      final key = _getMonthYearKey(milestone.date);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(milestone);
    }

    return grouped;
  }

  String _getMonthYearKey(DateTime date) {
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
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final groupedMilestones = _groupedMilestones;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareMilestones,
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          _buildStatsHeader(),

          // Active filter
          if (_selectedType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Chip(
                    label: Text(_getTypeLabel(_selectedType!)),
                    onDeleted: () {
                      setState(() {
                        _selectedType = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Timeline
          Expanded(
            child: _buildTimeline(groupedMilestones),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalPoints = _milestones.fold<int>(
        0, (sum, m) => sum + (m.pointsEarned ?? 0));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Total', '$_totalMilestones', Icons.timeline),
          Container(
            width: 1,
            height: 40,
            color: Colors.white30,
          ),
          _buildStatItem('This Month', '$_thisMonthCount', Icons.calendar_today),
          Container(
            width: 1,
            height: 40,
            color: Colors.white30,
          ),
          _buildStatItem('Points Earned', '$totalPoints', Icons.stars),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimeline(Map<String, List<Milestone>> groupedMilestones) {
    if (groupedMilestones.isEmpty) {
      return EmptyAchievementsState(
        message: _selectedType != null
            ? 'No milestones of this type'
            : 'No milestones yet',
        subtitle: _selectedType != null
            ? 'Try a different filter'
            : 'Start learning to create milestones!',
        onAction: _selectedType != null
            ? () {
                setState(() {
                  _selectedType = null;
                });
              }
            : null,
        actionLabel: 'Clear Filter',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh milestones from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedMilestones.length,
        itemBuilder: (context, groupIndex) {
          final monthYear = groupedMilestones.keys.elementAt(groupIndex);
          final milestones = groupedMilestones[monthYear]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            monthYear,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${milestones.length} milestone${milestones.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Milestones for this month
              ...milestones.asMap().entries.map((entry) {
                final index = entry.key;
                final milestone = entry.value;
                final isLast = index == milestones.length - 1 &&
                    groupIndex == groupedMilestones.length - 1;

                return MilestoneTimelineItem(
                  milestone: milestone,
                  isLast: isLast,
                );
              }),
            ],
          );
        },
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
                  'Filter Milestones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Milestone Type',
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
                      selected: _selectedType == null,
                      onSelected: (selected) {
                        setSheetState(() {
                          _selectedType = null;
                        });
                        setState(() {
                          _selectedType = null;
                        });
                      },
                    ),
                    ...MilestoneType.values.map((type) {
                      return FilterChip(
                        label: Text(_getTypeLabel(type)),
                        selected: _selectedType == type,
                        onSelected: (selected) {
                          setSheetState(() {
                            _selectedType = selected ? type : null;
                          });
                          setState(() {
                            _selectedType = selected ? type : null;
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
                          _selectedType = null;
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

  String _getTypeLabel(MilestoneType type) {
    switch (type) {
      case MilestoneType.courseCompleted:
        return 'Course Completed';
      case MilestoneType.achievementUnlocked:
        return 'Achievement';
      case MilestoneType.levelUp:
        return 'Level Up';
      case MilestoneType.streakMilestone:
        return 'Streak';
      case MilestoneType.examPassed:
        return 'Exam Passed';
      case MilestoneType.certificateEarned:
        return 'Certificate';
    }
  }

  void _shareMilestones() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
      ),
    );
  }
}
