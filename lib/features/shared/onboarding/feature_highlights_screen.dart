import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/onboarding_widgets.dart';

/// Feature Highlights Screen
///
/// Showcases all major features of the app in an interactive grid.
/// Can be accessed from settings or help menu.
///
/// Backend Integration TODO:
/// - Track which features users interact with
/// - Personalize feature recommendations
/// - Show feature usage statistics

class FeatureHighlightsScreen extends StatefulWidget {
  const FeatureHighlightsScreen({super.key});

  @override
  State<FeatureHighlightsScreen> createState() =>
      _FeatureHighlightsScreenState();
}

class _FeatureHighlightsScreenState extends State<FeatureHighlightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<FeatureCategory> _categories = [
    FeatureCategory(
      name: 'Core Features',
      features: [
        FeatureData(
          icon: Icons.search,
          title: 'Course Discovery',
          description:
              'Browse and search thousands of courses from top institutions worldwide',
          color: Colors.blue,
        ),
        FeatureData(
          icon: Icons.description,
          title: 'Application Tracking',
          description:
              'Manage all your course applications and track their status in real-time',
          color: Colors.green,
        ),
        FeatureData(
          icon: Icons.school,
          title: 'Learning Dashboard',
          description:
              'Track your progress, view enrolled courses, and access learning materials',
          color: Colors.purple,
        ),
        FeatureData(
          icon: Icons.chat,
          title: 'Messaging',
          description:
              'Communicate directly with institutions and counselors',
          color: Colors.orange,
        ),
      ],
    ),
    FeatureCategory(
      name: 'Study Tools',
      features: [
        FeatureData(
          icon: Icons.note,
          title: 'Notes',
          description:
              'Take, organize, and sync notes across all your devices',
          color: Colors.amber,
        ),
        FeatureData(
          icon: Icons.bookmark,
          title: 'Bookmarks',
          description: 'Save courses and resources for quick access later',
          color: Colors.red,
        ),
        FeatureData(
          icon: Icons.emoji_events,
          title: 'Achievements',
          description:
              'Earn badges and track milestones as you progress',
          color: Colors.yellow,
        ),
        FeatureData(
          icon: Icons.assessment,
          title: 'Progress Analytics',
          description: 'Visualize your learning journey with detailed statistics',
          color: Colors.teal,
        ),
      ],
    ),
    FeatureCategory(
      name: 'Productivity',
      features: [
        FeatureData(
          icon: Icons.calendar_today,
          title: 'Calendar',
          description:
              'Track deadlines, events, and important dates',
          color: Colors.indigo,
        ),
        FeatureData(
          icon: Icons.notifications,
          title: 'Smart Notifications',
          description:
              'Get timely reminders and updates about your applications',
          color: Colors.pink,
        ),
        FeatureData(
          icon: Icons.schedule,
          title: 'Study Scheduler',
          description: 'Plan and optimize your study time',
          color: Colors.cyan,
        ),
        FeatureData(
          icon: Icons.flag,
          title: 'Goals & Milestones',
          description: 'Set and track your learning goals',
          color: Colors.deepOrange,
        ),
      ],
    ),
    FeatureCategory(
      name: 'Collaboration',
      features: [
        FeatureData(
          icon: Icons.people,
          title: 'Study Groups',
          description: 'Connect and collaborate with fellow learners',
          color: Colors.lightBlue,
        ),
        FeatureData(
          icon: Icons.forum,
          title: 'Discussion Forums',
          description: 'Participate in course discussions and Q&A',
          color: Colors.deepPurple,
        ),
        FeatureData(
          icon: Icons.share,
          title: 'Resource Sharing',
          description: 'Share notes, links, and study materials',
          color: Colors.lime,
        ),
        FeatureData(
          icon: Icons.video_call,
          title: 'Live Sessions',
          description: 'Join virtual classes and webinars',
          color: Colors.brown,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Features'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) {
            return Tab(text: category.name);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          return _buildFeatureGrid(category.features);
        }).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Got It!'),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(List<FeatureData> features) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return FeatureCard(
          icon: feature.icon,
          title: feature.title,
          description: feature.description,
          iconColor: feature.color,
          onTap: () => _showFeatureDetail(feature),
        );
      },
    );
  }

  void _showFeatureDetail(FeatureData feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: feature.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                feature.icon,
                color: feature.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(feature.title),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feature.description),
            const SizedBox(height: 16),
            const Text(
              'How to use:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getFeatureInstructions(feature.title),
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToFeature(feature);
            },
            child: const Text('Try It'),
          ),
        ],
      ),
    );
  }

  String _getFeatureInstructions(String featureTitle) {
    final instructions = {
      'Course Discovery':
          'Navigate to the Explore tab and use the search bar or browse categories.',
      'Application Tracking':
          'Go to Applications tab to view and manage all your applications.',
      'Learning Dashboard':
          'Access your dashboard from the Home tab to see your progress.',
      'Messaging':
          'Open the Messages tab to chat with institutions and counselors.',
      'Notes': 'Tap the Notes icon to create and organize your study notes.',
      'Bookmarks':
          'Save items by tapping the bookmark icon on courses or resources.',
      'Achievements':
          'View your achievements in the Profile section under Progress.',
      'Progress Analytics':
          'Check detailed analytics in your Profile > Progress section.',
      'Calendar':
          'Access the Calendar from the bottom navigation or menu.',
      'Smart Notifications':
          'Enable notifications in Settings > Notifications.',
      'Study Scheduler':
          'Create study schedules in Tools > Study Planner.',
      'Goals & Milestones':
          'Set goals in Profile > Progress > Goals.',
      'Study Groups':
          'Join or create study groups from Community > Groups.',
      'Discussion Forums':
          'Participate in forums from Community > Discussions.',
      'Resource Sharing':
          'Share resources using the share button on any content.',
      'Live Sessions':
          'Join live sessions from the Schedule or Courses section.',
    };

    return instructions[featureTitle] ??
        'Explore the app to discover this feature!';
  }

  void _navigateToFeature(FeatureData feature) {
    // TODO: Navigate to the relevant screen based on feature
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${feature.title}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Feature Category Model
class FeatureCategory {
  final String name;
  final List<FeatureData> features;

  FeatureCategory({
    required this.name,
    required this.features,
  });
}

/// Feature Data Model
class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
