import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/counseling/models/counseling_models.dart';
import '../../../shared/counseling/widgets/counseling_widgets.dart';
import '../../providers/student_counseling_provider.dart';

/// Student counseling tab - shows assigned counselor and sessions
class StudentCounselingTab extends ConsumerStatefulWidget {
  const StudentCounselingTab({super.key});

  @override
  ConsumerState<StudentCounselingTab> createState() => _StudentCounselingTabState();
}

class _StudentCounselingTabState extends ConsumerState<StudentCounselingTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load counseling data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studentCounselingProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentCounselingProvider);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(studentCounselingProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          // Counselor section
          SliverToBoxAdapter(
            child: _buildCounselorSection(state, theme),
          ),

          // Stats cards
          if (state.stats != null)
            SliverToBoxAdapter(
              child: _buildStatsSection(state.stats!, theme),
            ),

          // Sessions tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Upcoming (${state.upcomingSessions.length})'),
                  Tab(text: 'Past (${state.pastSessions.length})'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
              ),
            ),
          ),

          // Sessions list
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSessionsList(state.upcomingSessions, isUpcoming: true),
                _buildSessionsList(state.pastSessions, isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorSection(StudentCounselingState state, ThemeData theme) {
    if (state.isLoading && state.counselor == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.counselor == null) {
      return NoCounselorAssigned(
        onContactAdmin: () {
          // Navigate to support/contact
          context.push('/student/help');
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CounselorCard(
        counselor: state.counselor!,
        onBookSession: () => _navigateToBookSession(state.counselor!),
        onTap: () => _showCounselorDetails(state.counselor!),
      ),
    );
  }

  Widget _buildStatsSection(CounselingStats stats, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildStatCard(
            'Total',
            stats.totalSessions.toString(),
            Icons.calendar_month,
            Colors.blue,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Completed',
            stats.completedSessions.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Upcoming',
            stats.upcomingSessions.toString(),
            Icons.schedule,
            Colors.orange,
          ),
          if (stats.averageRating != null) ...[
            const SizedBox(width: 12),
            _buildStatCard(
              'Rating',
              stats.averageRating!.toStringAsFixed(1),
              Icons.star,
              Colors.amber,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsList(List<CounselingSession> sessions, {required bool isUpcoming}) {
    if (sessions.isEmpty) {
      return NoSessions(
        message: isUpcoming
            ? 'No upcoming sessions scheduled'
            : 'No past sessions yet',
        onBookSession: isUpcoming && ref.read(studentCounselingProvider).counselor != null
            ? () => _navigateToBookSession(ref.read(studentCounselingProvider).counselor!)
            : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SessionCard(
          session: session,
          onTap: () => _showSessionDetails(session),
          onCancel: session.canCancel
              ? () => _confirmCancelSession(session)
              : null,
        );
      },
    );
  }

  void _navigateToBookSession(CounselorInfo counselor) {
    context.push('/student/counseling/book', extra: counselor);
  }

  void _showCounselorDetails(CounselorInfo counselor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _CounselorDetailsSheet(
          counselor: counselor,
          scrollController: scrollController,
          onBookSession: () {
            Navigator.pop(context);
            _navigateToBookSession(counselor);
          },
        ),
      ),
    );
  }

  void _showSessionDetails(CounselingSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SessionDetailsSheet(
        session: session,
        onCancel: session.canCancel ? () => _confirmCancelSession(session) : null,
        onFeedback: session.canProvideFeedback
            ? () => _showFeedbackDialog(session)
            : null,
      ),
    );
  }

  void _confirmCancelSession(CounselingSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Session'),
        content: const Text(
          'Are you sure you want to cancel this session? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(studentCounselingProvider.notifier)
                  .cancelSession(session.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session cancelled')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(CounselingSession session) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate Your Session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How was your counseling session?'),
              const SizedBox(height: 16),
              RatingInput(
                value: rating,
                onChanged: (value) => setState(() => rating = value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Comments (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await ref
                    .read(studentCounselingProvider.notifier)
                    .submitFeedback(
                      session.id,
                      rating,
                      commentController.text.isEmpty
                          ? null
                          : commentController.text,
                    );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your feedback!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Counselor details bottom sheet
class _CounselorDetailsSheet extends StatelessWidget {
  final CounselorInfo counselor;
  final ScrollController scrollController;
  final VoidCallback onBookSession;

  const _CounselorDetailsSheet({
    required this.counselor,
    required this.scrollController,
    required this.onBookSession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        // Handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Avatar and name
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              counselor.name.isNotEmpty ? counselor.name[0].toUpperCase() : 'C',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          counselor.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          counselor.email,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        if (counselor.averageRating != null)
          Center(child: RatingStars(rating: counselor.averageRating)),
        const SizedBox(height: 24),

        // Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat('Sessions', '${counselor.completedSessions}'),
            _buildStat(
              'Rating',
              counselor.averageRating?.toStringAsFixed(1) ?? '-',
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Availability
        if (counselor.availability.isNotEmpty) ...[
          Text(
            'Availability',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...counselor.availability.map((slot) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        slot.dayName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${slot.startTime} - ${slot.endTime}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
        ],

        // Book button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onBookSession,
            icon: const Icon(Icons.calendar_month),
            label: const Text('Book a Session'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

/// Session details bottom sheet
class _SessionDetailsSheet extends StatelessWidget {
  final CounselingSession session;
  final VoidCallback? onCancel;
  final VoidCallback? onFeedback;

  const _SessionDetailsSheet({
    required this.session,
    this.onCancel,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SessionTypeBadge(type: session.type),
                        const SizedBox(width: 8),
                        SessionStatusBadge(status: session.status),
                      ],
                    ),
                    if (session.topic != null && session.topic!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        session.topic!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Details
          _buildDetailRow(Icons.calendar_today, 'Date',
              '${session.scheduledDate.day}/${session.scheduledDate.month}/${session.scheduledDate.year}'),
          _buildDetailRow(Icons.access_time, 'Time',
              '${session.scheduledDate.hour}:${session.scheduledDate.minute.toString().padLeft(2, '0')}'),
          _buildDetailRow(
              Icons.timer, 'Duration', '${session.durationMinutes} minutes'),
          if (session.counselorName != null)
            _buildDetailRow(Icons.person, 'Counselor', session.counselorName!),

          if (session.notes != null && session.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Notes',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              session.notes!,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],

          if (session.feedbackRating != null) ...[
            const SizedBox(height: 16),
            Text(
              'Your Feedback',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            RatingStars(rating: session.feedbackRating),
            if (session.feedbackComment != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  session.feedbackComment!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
          ],

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              if (onCancel != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onCancel!();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancel Session'),
                  ),
                ),
              if (onCancel != null && onFeedback != null)
                const SizedBox(width: 12),
              if (onFeedback != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onFeedback!();
                    },
                    child: const Text('Leave Feedback'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
