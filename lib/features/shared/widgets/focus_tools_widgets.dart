import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Focus Tools and Zen Mode Widgets
///
/// Comprehensive widget library for productivity:
/// - Focus session models
/// - Pomodoro timer
/// - Study session tracking
/// - Focus statistics
/// - Distraction-free mode
///
/// Backend Integration TODO:
/// - Sync focus sessions to backend
/// - Track productivity metrics
/// - Generate focus reports
/// - Save timer preferences

// Enums
enum SessionType { pomodoro, shortBreak, longBreak, custom }

enum SessionStatus { notStarted, running, paused, completed, cancelled }

enum FocusLevel { deep, moderate, light }

// Models
class FocusSession {
  final String id;
  final SessionType type;
  final Duration duration;
  final Duration? completedDuration;
  final SessionStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final String? taskName;
  final String? courseId;
  final String? courseName;
  final FocusLevel? focusLevel;
  final int? distractions;

  const FocusSession({
    required this.id,
    required this.type,
    required this.duration,
    this.completedDuration,
    required this.status,
    required this.startTime,
    this.endTime,
    this.taskName,
    this.courseId,
    this.courseName,
    this.focusLevel,
    this.distractions,
  });

  String get typeLabel {
    switch (type) {
      case SessionType.pomodoro:
        return 'Focus Session';
      case SessionType.shortBreak:
        return 'Short Break';
      case SessionType.longBreak:
        return 'Long Break';
      case SessionType.custom:
        return 'Custom Session';
    }
  }

  Color get typeColor {
    switch (type) {
      case SessionType.pomodoro:
        return AppColors.primary;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.blue;
      case SessionType.custom:
        return Colors.purple;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case SessionType.pomodoro:
        return Icons.timer;
      case SessionType.shortBreak:
        return Icons.coffee;
      case SessionType.longBreak:
        return Icons.self_improvement;
      case SessionType.custom:
        return Icons.schedule;
    }
  }

  String get statusLabel {
    switch (status) {
      case SessionStatus.notStarted:
        return 'Not Started';
      case SessionStatus.running:
        return 'In Progress';
      case SessionStatus.paused:
        return 'Paused';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isCompleted => status == SessionStatus.completed;

  double get completionPercentage {
    if (completedDuration == null) return 0.0;
    return completedDuration!.inSeconds / duration.inSeconds;
  }

  String get formattedDuration {
    final mins = duration.inMinutes;
    if (mins < 60) return '${mins}m';
    final hours = mins ~/ 60;
    final remainingMins = mins % 60;
    return '${hours}h ${remainingMins}m';
  }
}

class StudySessionStats {
  final int totalSessions;
  final int completedSessions;
  final Duration totalFocusTime;
  final Duration longestSession;
  final int currentStreak;
  final int bestStreak;
  final double averageFocusScore;
  final Map<String, int> sessionsByDay;

  const StudySessionStats({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalFocusTime,
    required this.longestSession,
    required this.currentStreak,
    required this.bestStreak,
    required this.averageFocusScore,
    required this.sessionsByDay,
  });

  double get completionRate {
    if (totalSessions == 0) return 0;
    return (completedSessions / totalSessions) * 100;
  }

  String get formattedTotalTime {
    final hours = totalFocusTime.inHours;
    final minutes = totalFocusTime.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedLongestSession {
    final hours = longestSession.inHours;
    final minutes = longestSession.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class PomodoroSettings {
  final Duration focusDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int sessionsUntilLongBreak;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const PomodoroSettings({
    this.focusDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.sessionsUntilLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  PomodoroSettings copyWith({
    Duration? focusDuration,
    Duration? shortBreakDuration,
    Duration? longBreakDuration,
    int? sessionsUntilLongBreak,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return PomodoroSettings(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsUntilLongBreak:
          sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

// Widgets
class FocusSessionCard extends StatelessWidget {
  final FocusSession session;
  final VoidCallback? onTap;

  const FocusSessionCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: session.typeColor.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: session.typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  session.typeIcon,
                  color: session.typeColor,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.taskName ?? session.typeLabel,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: session.isCompleted
                                ? AppColors.success.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            session.statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: session.isCompleted
                                  ? AppColors.success
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (session.courseName != null)
                      Text(
                        session.courseName!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          session.formattedDuration,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (session.isCompleted) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(session.startTime),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm';
  }
}

class CircularTimerDisplay extends StatelessWidget {
  final Duration remainingTime;
  final Duration totalDuration;
  final bool isRunning;
  final Color color;

  const CircularTimerDisplay({
    super.key,
    required this.remainingTime,
    required this.totalDuration,
    required this.isRunning,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalDuration.inSeconds > 0
        ? 1 - (remainingTime.inSeconds / totalDuration.inSeconds)
        : 0.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 20,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.grey.shade200,
              ),
            ),
          ),

          // Progress circle
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 20,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),

          // Time text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(remainingTime),
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isRunning ? context.l10n.swFocusFocusMode : context.l10n.swFocusPaused,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class FocusStatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const FocusStatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.trending_up,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class WeeklyFocusChart extends StatelessWidget {
  final Map<String, int> sessionsByDay;

  const WeeklyFocusChart({
    super.key,
    required this.sessionsByDay,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxSessions = sessionsByDay.values.isEmpty
        ? 1
        : sessionsByDay.values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.swFocusThisWeek,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((day) {
                final sessions = sessionsByDay[day] ?? 0;
                final height = maxSessions > 0 ? (sessions / maxSessions) * 120 : 0.0;

                return Column(
                  children: [
                    Text(
                      '$sessions',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: sessions > 0
                            ? AppColors.primary
                            : Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: height > 0 ? height : 20,
                      decoration: BoxDecoration(
                        color: sessions > 0
                            ? AppColors.primary
                            : Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyFocusState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyFocusState({
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
              Icons.self_improvement,
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
                icon: const Icon(Icons.timer),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
