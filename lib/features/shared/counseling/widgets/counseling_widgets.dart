// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/counseling_models.dart';

/// Session status badge widget
class SessionStatusBadge extends StatelessWidget {
  final SessionStatus status;
  final bool showIcon;

  const SessionStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStatusStyle();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusStyle() {
    switch (status) {
      case SessionStatus.scheduled:
        return (AppColors.info, Icons.schedule);
      case SessionStatus.inProgress:
        return (AppColors.warning, Icons.play_circle);
      case SessionStatus.completed:
        return (AppColors.success, Icons.check_circle);
      case SessionStatus.cancelled:
        return (AppColors.error, Icons.cancel);
      case SessionStatus.rescheduled:
        return (AppColors.warning, Icons.update);
      case SessionStatus.noShow:
        return (AppColors.error, Icons.person_off);
    }
  }
}

/// Session type badge widget
class SessionTypeBadge extends StatelessWidget {
  final SessionType type;

  const SessionTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.displayName,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case SessionType.academic:
        return AppColors.primary;
      case SessionType.career:
        return Colors.purple;
      case SessionType.personal:
        return Colors.teal;
      case SessionType.college:
        return Colors.indigo;
      case SessionType.general:
        return Colors.blueGrey;
    }
  }
}

/// Rating stars widget
class RatingStars extends StatelessWidget {
  final double? rating;
  final double size;
  final bool showValue;

  const RatingStars({
    super.key,
    this.rating,
    this.size = 16,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return Text(
        'No rating',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          if (rating! >= starValue) {
            return Icon(Icons.star, size: size, color: Colors.amber);
          } else if (rating! > starValue - 1) {
            return Icon(Icons.star_half, size: size, color: Colors.amber);
          } else {
            return Icon(Icons.star_border, size: size, color: Colors.grey[300]);
          }
        }),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating!.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.75,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ],
    );
  }
}

/// Interactive rating input widget
class RatingInput extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double size;

  const RatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () => onChanged(starValue.toDouble()),
          child: Icon(
            value >= starValue ? Icons.star : Icons.star_border,
            size: size,
            color: value >= starValue ? Colors.amber : Colors.grey[300],
          ),
        );
      }),
    );
  }
}

/// Counselor card widget
class CounselorCard extends StatelessWidget {
  final CounselorInfo counselor;
  final VoidCallback? onTap;
  final VoidCallback? onBookSession;
  final bool showBookButton;
  final bool compact;

  const CounselorCard({
    super.key,
    required this.counselor,
    this.onTap,
    this.onBookSession,
    this.showBookButton = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return _buildCompactCard(theme);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: counselor.avatarUrl != null
                        ? NetworkImage(counselor.avatarUrl!)
                        : null,
                    child: counselor.avatarUrl == null
                        ? Text(
                            counselor.name.isNotEmpty
                                ? counselor.name[0].toUpperCase()
                                : 'C',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
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
                        const SizedBox(height: 2),
                        Text(
                          counselor.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (counselor.averageRating != null)
                    RatingStars(rating: counselor.averageRating, size: 14),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStat(
                    Icons.check_circle_outline,
                    '${counselor.completedSessions}',
                    'Sessions',
                  ),
                  const SizedBox(width: 24),
                  if (counselor.assignedAt != null)
                    _buildStat(
                      Icons.calendar_today,
                      DateFormat('MMM d, y').format(counselor.assignedAt!),
                      'Assigned',
                    ),
                ],
              ),
              if (showBookButton && onBookSession != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onBookSession,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Book Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  counselor.name.isNotEmpty ? counselor.name[0].toUpperCase() : 'C',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      counselor.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RatingStars(rating: counselor.averageRating, size: 12),
                  ],
                ),
              ),
              if (onBookSession != null)
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: onBookSession,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}

/// Session card widget
class SessionCard extends StatelessWidget {
  final CounselingSession session;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool showCounselor;
  final bool showStudent;

  const SessionCard({
    super.key,
    required this.session,
    this.onTap,
    this.onCancel,
    this.showCounselor = true,
    this.showStudent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        const SizedBox(height: 8),
                        if (session.topic != null && session.topic!.isNotEmpty)
                          Text(
                            session.topic!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
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
              const Divider(height: 16),
              Row(
                children: [
                  if (showCounselor && session.counselorName != null) ...[
                    Icon(Icons.person, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      session.counselorName!,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (showStudent && session.studentName != null) ...[
                    Icon(Icons.school, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      session.studentName!,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${session.durationMinutes} min',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (session.feedbackRating != null)
                    RatingStars(rating: session.feedbackRating, size: 12),
                  if (session.canCancel && onCancel != null)
                    TextButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(60, 30),
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
}

/// Time slot picker widget
class TimeSlotPicker extends StatelessWidget {
  final List<BookingSlot> slots;
  final BookingSlot? selectedSlot;
  final ValueChanged<BookingSlot> onSlotSelected;
  final DateTime selectedDate;

  const TimeSlotPicker({
    super.key,
    required this.slots,
    this.selectedSlot,
    required this.onSlotSelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final daySlots = slots.where((s) {
      return s.start.year == selectedDate.year &&
          s.start.month == selectedDate.month &&
          s.start.day == selectedDate.day;
    }).toList();

    if (daySlots.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No available slots for this day',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: daySlots.map((slot) {
        final isSelected = selectedSlot?.start == slot.start;
        return ChoiceChip(
          label: Text(DateFormat('h:mm a').format(slot.start)),
          selected: isSelected,
          onSelected: (_) => onSlotSelected(slot),
          selectedColor: AppColors.primary.withValues(alpha: 0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}

/// No counselor assigned placeholder
class NoCounselorAssigned extends StatelessWidget {
  final VoidCallback? onContactAdmin;

  const NoCounselorAssigned({super.key, this.onContactAdmin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Counselor Assigned',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have a counselor assigned yet. Please contact your institution administrator.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (onContactAdmin != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onContactAdmin,
                icon: const Icon(Icons.mail_outline),
                label: const Text('Contact Admin'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty sessions placeholder
class NoSessions extends StatelessWidget {
  final String message;
  final VoidCallback? onBookSession;

  const NoSessions({
    super.key,
    this.message = 'No counseling sessions yet',
    this.onBookSession,
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
              Icons.event_available,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            if (onBookSession != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onBookSession,
                icon: const Icon(Icons.add),
                label: const Text('Book a Session'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
