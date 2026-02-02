import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Help Screen for students
/// Provides FAQs, contact support, and helpful resources
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String _searchQuery = '';
  HelpCategory? _expandedCategory;

  // FAQ categories and questions
  final List<HelpCategoryData> _categories = [
    HelpCategoryData(
      category: HelpCategory.gettingStarted,
      icon: Icons.rocket_launch,
      color: Colors.blue,
      questions: [
        FAQItem(
          question: 'How do I complete my student profile?',
          answer: 'Go to the Profile tab and click "Edit Profile". Fill in your personal information, academic details, and preferences. A complete profile helps us provide better recommendations.',
        ),
        FAQItem(
          question: 'How do I link my parent/guardian account?',
          answer: 'Navigate to Quick Actions > Parent Link. You can either generate a link code to share with your parent, or accept a pending link request if your parent has already initiated the connection.',
        ),
        FAQItem(
          question: 'What is the "Find Your Path" feature?',
          answer: 'Find Your Path is our AI-powered recommendation system that analyzes your profile, interests, and goals to suggest universities and programs that match your preferences. Access it from the home dashboard.',
        ),
      ],
    ),
    HelpCategoryData(
      category: HelpCategory.applications,
      icon: Icons.description,
      color: Colors.green,
      questions: [
        FAQItem(
          question: 'How do I start a new application?',
          answer: 'Go to the Applications tab and tap the "+" button or "Create Application". Select the program you want to apply to, fill in the required information, and submit when ready.',
        ),
        FAQItem(
          question: 'What do the application statuses mean?',
          answer: '''
• Draft: Application started but not submitted
• Submitted: Application sent for review
• Under Review: Being evaluated by admissions
• Interview: You've been invited for an interview
• Accepted: Congratulations! You've been admitted
• Rejected: Unfortunately not selected
• Withdrawn: You chose to withdraw the application''',
        ),
        FAQItem(
          question: 'Can I edit a submitted application?',
          answer: 'Once an application is submitted, you cannot edit it directly. If you need to make changes, contact the admissions office of the institution or reach out to your counselor for guidance.',
        ),
        FAQItem(
          question: 'How do I request a recommendation letter?',
          answer: 'Go to Quick Actions > Letters. You can create a new request, select a teacher or counselor, provide context about what you need, and track the status of your requests.',
        ),
      ],
    ),
    HelpCategoryData(
      category: HelpCategory.counseling,
      icon: Icons.psychology,
      color: Colors.teal,
      questions: [
        FAQItem(
          question: 'How do I book a counseling session?',
          answer: 'Go to Quick Actions > Counseling. You\'ll see your assigned counselor and can book a session by selecting an available time slot from the calendar.',
        ),
        FAQItem(
          question: 'What types of counseling sessions are available?',
          answer: '''
• General: Overall guidance and questions
• Academic: Help with courses, GPA, study strategies
• Career: Career exploration, job preparation
• College: College search, applications, essays
• Personal: Personal challenges affecting academics''',
        ),
        FAQItem(
          question: 'Can I change my assigned counselor?',
          answer: 'Counselor assignments are managed by your institution. If you need to change counselors, please contact your school\'s administration or reach out through the Help & Support section.',
        ),
      ],
    ),
    HelpCategoryData(
      category: HelpCategory.courses,
      icon: Icons.menu_book,
      color: Colors.orange,
      questions: [
        FAQItem(
          question: 'How do I enroll in a course?',
          answer: 'Go to the Courses tab, browse available courses, and tap on one to view details. Click "Enroll" to add it to your courses. Some courses may require prerequisites or approval.',
        ),
        FAQItem(
          question: 'Where can I find my enrolled courses?',
          answer: 'Your enrolled courses appear in the Courses tab under "My Courses". You can also access them directly from the Quick Actions on your home dashboard.',
        ),
        FAQItem(
          question: 'How do I track my course progress?',
          answer: 'Open any enrolled course and you\'ll see your progress percentage, completed lessons, and upcoming assignments. The Progress tab also shows an overview of all your academic progress.',
        ),
      ],
    ),
    HelpCategoryData(
      category: HelpCategory.account,
      icon: Icons.person,
      color: Colors.purple,
      questions: [
        FAQItem(
          question: 'How do I change my password?',
          answer: 'Go to Profile > Settings > Security. You can change your password by entering your current password and setting a new one.',
        ),
        FAQItem(
          question: 'How do I update my email address?',
          answer: 'Go to Profile > Edit Profile. Update your email address and verify it through the confirmation email sent to your new address.',
        ),
        FAQItem(
          question: 'How do I enable notifications?',
          answer: 'Go to Profile > Settings > Notifications. You can customize which notifications you receive for applications, messages, counseling appointments, and more.',
        ),
      ],
    ),
    HelpCategoryData(
      category: HelpCategory.technical,
      icon: Icons.build,
      color: Colors.grey,
      questions: [
        FAQItem(
          question: 'The app is running slowly. What can I do?',
          answer: 'Try these steps:\n1. Close and reopen the app\n2. Check your internet connection\n3. Clear the app cache in Settings\n4. Make sure you\'re using the latest version',
        ),
        FAQItem(
          question: 'I\'m not receiving notifications. How do I fix this?',
          answer: 'Ensure notifications are enabled both in the app (Profile > Settings > Notifications) and in your device settings. Also check that Do Not Disturb is not enabled.',
        ),
        FAQItem(
          question: 'How do I report a bug or issue?',
          answer: 'Use the "Contact Support" button at the bottom of this Help screen. Describe the issue in detail, including what you were doing when it occurred. Screenshots are helpful if possible.',
        ),
      ],
    ),
  ];

  List<HelpCategoryData> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;

    final query = _searchQuery.toLowerCase();
    return _categories.map((category) {
      final filteredQuestions = category.questions.where((q) {
        return q.question.toLowerCase().contains(query) ||
            q.answer.toLowerCase().contains(query);
      }).toList();

      if (filteredQuestions.isEmpty) return null;

      return HelpCategoryData(
        category: category.category,
        icon: category.icon,
        color: category.color,
        questions: filteredQuestions,
      );
    }).whereType<HelpCategoryData>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studentHelpTitle),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.studentHelpSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick help cards
                  if (_searchQuery.isEmpty) ...[
                    Text(
                      context.l10n.studentHelpQuickHelp,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickHelpCard(
                            icon: Icons.chat_bubble_outline,
                            title: context.l10n.studentHelpLiveChat,
                            subtitle: context.l10n.studentHelpChatWithSupport,
                            color: AppColors.primary,
                            onTap: () => _showComingSoon('Live Chat'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickHelpCard(
                            icon: Icons.email_outlined,
                            title: context.l10n.studentHelpEmailUs,
                            subtitle: context.l10n.studentHelpEmailAddress,
                            color: Colors.green,
                            onTap: () => _showContactDialog(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickHelpCard(
                            icon: Icons.video_library_outlined,
                            title: context.l10n.studentHelpTutorials,
                            subtitle: context.l10n.studentHelpVideoGuides,
                            color: Colors.red,
                            onTap: () => _showComingSoon('Video Tutorials'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickHelpCard(
                            icon: Icons.school_outlined,
                            title: context.l10n.studentHelpUserGuide,
                            subtitle: context.l10n.studentHelpFullDocumentation,
                            color: Colors.orange,
                            onTap: () => _showComingSoon('User Guide'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // FAQ sections
                  Text(
                    _searchQuery.isEmpty
                        ? context.l10n.studentHelpFaq
                        : context.l10n.studentHelpSearchResults,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_filteredCategories.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.l10n.studentHelpNoResults,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.l10n.studentHelpTryDifferentKeywords,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._filteredCategories.map((category) {
                      return _buildFAQCategory(category);
                    }),

                  const SizedBox(height: 32),

                  // Contact support button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showContactDialog,
                      icon: const Icon(Icons.support_agent),
                      label: Text(context.l10n.studentHelpContactSupport),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App version
                  Center(
                    child: Text(
                      'Flow App v1.0.0',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
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

  Widget _buildQuickHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCategory(HelpCategoryData category) {
    final isExpanded = _expandedCategory == category.category ||
        _searchQuery.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Category header
          InkWell(
            onTap: _searchQuery.isNotEmpty
                ? null
                : () {
                    setState(() {
                      _expandedCategory = isExpanded ? null : category.category;
                    });
                  },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.category.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          context.l10n.studentHelpQuestionsCount(category.questions.length),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_searchQuery.isEmpty)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                ],
              ),
            ),
          ),

          // Questions list
          if (isExpanded) ...[
            const Divider(height: 1),
            ...category.questions.map((faq) => _buildFAQItem(faq)),
          ],
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Text(
        faq.question,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            faq.answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.studentHelpComingSoon(feature)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.support_agent, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(context.l10n.studentHelpContactSupport),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.studentHelpReachOut,
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              Icons.email,
              context.l10n.studentHelpEmail,
              'support@flow.edu',
            ),
            const SizedBox(height: 12),
            _buildContactOption(
              Icons.phone,
              context.l10n.studentHelpPhone,
              '+1 (800) FLOW-APP',
            ),
            const SizedBox(height: 12),
            _buildContactOption(
              Icons.access_time,
              context.l10n.studentHelpHours,
              context.l10n.studentHelpBusinessHours,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.studentHelpClose),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.studentHelpOpeningEmail),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.studentHelpSendEmail),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Help categories
enum HelpCategory {
  gettingStarted,
  applications,
  counseling,
  courses,
  account,
  technical;

  String get label {
    switch (this) {
      case HelpCategory.gettingStarted:
        return 'Getting Started';
      case HelpCategory.applications:
        return 'Applications';
      case HelpCategory.counseling:
        return 'Counseling';
      case HelpCategory.courses:
        return 'Courses';
      case HelpCategory.account:
        return 'Account & Settings';
      case HelpCategory.technical:
        return 'Technical Support';
    }
  }
}

/// FAQ item model
class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}

/// Help category data model
class HelpCategoryData {
  final HelpCategory category;
  final IconData icon;
  final Color color;
  final List<FAQItem> questions;

  HelpCategoryData({
    required this.category,
    required this.icon,
    required this.color,
    required this.questions,
  });
}
