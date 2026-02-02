import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/l10n_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../shared/counseling/models/counseling_models.dart';
import '../../../../shared/counseling/widgets/counseling_widgets.dart';
import '../../../providers/parent_counseling_provider.dart';

/// Tab showing child's counseling information for parent view
class ChildCounselingTab extends ConsumerStatefulWidget {
  final String childId;
  final String childName;

  const ChildCounselingTab({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  ConsumerState<ChildCounselingTab> createState() => _ChildCounselingTabState();
}

class _ChildCounselingTabState extends ConsumerState<ChildCounselingTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(childCounselingProvider.notifier).loadChildCounseling(widget.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(childCounselingProvider);
    final theme = Theme.of(context);

    if (state.isLoading && state.counselor == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.counselor == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(childCounselingProvider.notifier)
                  .loadChildCounseling(widget.childId),
              child: Text(context.l10n.parentChildRetry),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(childCounselingProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Counselor section
            _buildCounselorSection(state, theme),
            const SizedBox(height: 24),

            // Sessions section
            _buildSessionsSection(state, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorSection(ChildCounselingState state, ThemeData theme) {
    if (state.counselor == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.person_search,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.parentChildNoCounselor,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.parentChildNoCounselorDescription(widget.childName),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final counselor = state.counselor!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.parentChildChildCounselor(widget.childName),
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    counselor.name.isNotEmpty
                        ? counselor.name[0].toUpperCase()
                        : 'C',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        counselor.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        counselor.email,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (counselor.averageRating != null)
                  RatingStars(rating: counselor.averageRating, size: 14),
              ],
            ),
            if (counselor.assignedAt != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.parentChildAssigned(DateFormat('MMM d, y').format(counselor.assignedAt!)),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  Widget _buildSessionsSection(ChildCounselingState state, ThemeData theme) {
    final upcomingSessions = state.upcomingSessions;
    final pastSessions = state.pastSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context.l10n.parentChildTotal,
                '${state.sessions.length}',
                Icons.calendar_month,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context.l10n.parentChildUpcoming,
                '${upcomingSessions.length}',
                Icons.schedule,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context.l10n.parentChildCompleted,
                '${pastSessions.where((s) => s.status == SessionStatus.completed).length}',
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Upcoming sessions
        Text(
          context.l10n.parentChildUpcomingSessions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (upcomingSessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  context.l10n.parentChildNoUpcomingSessions,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...upcomingSessions.map((session) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildSessionCard(session, theme),
              )),

        const SizedBox(height: 24),

        // Past sessions
        Text(
          context.l10n.parentChildPastSessions,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (pastSessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  context.l10n.parentChildNoPastSessions,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        else
          ...pastSessions.take(5).map((session) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildSessionCard(session, theme),
              )),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
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
    );
  }

  Widget _buildSessionCard(CounselingSession session, ThemeData theme) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SessionTypeBadge(type: session.type),
                const SizedBox(width: 8),
                SessionStatusBadge(status: session.status),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dateFormat.format(session.scheduledDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeFormat.format(session.scheduledDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (session.topic != null && session.topic!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                session.topic!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (session.counselorName != null) ...[
                  Icon(Icons.person, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    session.counselorName!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  context.l10n.parentChildMinutes(session.durationMinutes.toString()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (session.feedbackRating != null)
                  RatingStars(rating: session.feedbackRating, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
