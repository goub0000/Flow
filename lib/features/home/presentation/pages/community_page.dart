import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Community page with forums and user groups
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Community'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.groups, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        'Join Our Community',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect with students, counselors, and educators',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Community Stats
                Row(
                  children: [
                    Expanded(child: _buildStatCard(theme, '50K+', 'Members')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(theme, '200+', 'Groups')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(theme, '5K+', 'Discussions')),
                  ],
                ),

                const SizedBox(height: 40),

                // Featured Groups
                Text(
                  'Featured Groups',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildGroupCard(
                  theme,
                  icon: Icons.school,
                  title: 'University Applicants 2026',
                  members: '12,450 members',
                  description: 'Connect with fellow students applying to universities this year.',
                ),
                _buildGroupCard(
                  theme,
                  icon: Icons.engineering,
                  title: 'STEM Students Africa',
                  members: '8,230 members',
                  description: 'A community for students pursuing science, technology, engineering, and math.',
                ),
                _buildGroupCard(
                  theme,
                  icon: Icons.medical_services,
                  title: 'Medical School Aspirants',
                  members: '5,890 members',
                  description: 'Resources and support for future medical professionals.',
                ),
                _buildGroupCard(
                  theme,
                  icon: Icons.business,
                  title: 'Business & Economics',
                  members: '7,120 members',
                  description: 'For students interested in business, economics, and finance.',
                ),

                const SizedBox(height: 40),

                // Discussion Topics
                Text(
                  'Popular Discussions',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDiscussionCard(
                  theme,
                  title: 'Tips for writing a compelling personal statement',
                  author: 'Sarah M.',
                  replies: 145,
                  likes: 320,
                ),
                _buildDiscussionCard(
                  theme,
                  title: 'Best universities for Computer Science in West Africa?',
                  author: 'Kwame A.',
                  replies: 89,
                  likes: 210,
                ),
                _buildDiscussionCard(
                  theme,
                  title: 'Scholarship opportunities for 2026 intake',
                  author: 'Amina O.',
                  replies: 234,
                  likes: 450,
                ),
                _buildDiscussionCard(
                  theme,
                  title: 'How to prepare for university entrance exams',
                  author: 'David K.',
                  replies: 112,
                  likes: 280,
                ),

                const SizedBox(height: 40),

                // Events
                Text(
                  'Upcoming Events',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildEventCard(
                  theme,
                  title: 'Virtual University Fair 2026',
                  date: 'Feb 15, 2026',
                  time: '10:00 AM GMT',
                  attendees: 2500,
                ),
                _buildEventCard(
                  theme,
                  title: 'Scholarship Application Workshop',
                  date: 'Feb 20, 2026',
                  time: '2:00 PM GMT',
                  attendees: 850,
                ),
                _buildEventCard(
                  theme,
                  title: 'Career Guidance Webinar',
                  date: 'Feb 25, 2026',
                  time: '4:00 PM GMT',
                  attendees: 1200,
                ),

                const SizedBox(height: 40),

                // CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to Join?',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create an account to join the community',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Sign Up Free'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String members,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  members,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionCard(
    ThemeData theme, {
    required String title,
    required String author,
    required int replies,
    required int likes,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'by $author',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '$replies',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.thumb_up_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    ThemeData theme, {
    required String title,
    required String date,
    required String time,
    required int attendees,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event, color: AppColors.accent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date • $time',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$attendees',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'attending',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
