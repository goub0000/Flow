import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/focus_tools_widgets.dart';

/// Focus Timer Screen
///
/// Pomodoro-style focus timer:
/// - Customizable timer durations
/// - Auto-start breaks
/// - Session tracking
/// - Distraction logging
/// - Task association
///
/// Backend Integration TODO:
/// - Save sessions to backend
/// - Sync timer settings
/// - Track productivity metrics
/// - Generate focus reports

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  late Timer _timer;
  late PomodoroSettings _settings;
  late Duration _remainingTime;
  SessionStatus _status = SessionStatus.notStarted;
  SessionType _currentType = SessionType.pomodoro;
  int _completedPomodoros = 0;
  String? _currentTask;

  @override
  void initState() {
    super.initState();
    _settings = const PomodoroSettings();
    _remainingTime = _settings.focusDuration;
  }

  @override
  void dispose() {
    if (_status == SessionStatus.running) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _status = SessionStatus.running;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _handleTimerComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    if (_status == SessionStatus.running) {
      _timer.cancel();
      setState(() {
        _status = SessionStatus.paused;
      });
    }
  }

  void _resumeTimer() {
    if (_status == SessionStatus.paused) {
      _startTimer();
    }
  }

  void _resetTimer() {
    if (_status == SessionStatus.running) {
      _timer.cancel();
    }

    setState(() {
      _status = SessionStatus.notStarted;
      _remainingTime = _getTypeDuration(_currentType);
    });
  }

  void _handleTimerComplete() {
    _timer.cancel();

    setState(() {
      _status = SessionStatus.completed;
    });

    // Show completion dialog
    _showCompletionDialog();

    // Update pomodoro count
    if (_currentType == SessionType.pomodoro) {
      _completedPomodoros++;
    }

    // Auto-start next session if enabled
    if (_shouldAutoStartNext()) {
      Future.delayed(const Duration(seconds: 3), () {
        _startNextSession();
      });
    }
  }

  bool _shouldAutoStartNext() {
    if (_currentType == SessionType.pomodoro) {
      return _settings.autoStartBreaks;
    } else {
      return _settings.autoStartPomodoros;
    }
  }

  void _startNextSession() {
    SessionType nextType;

    if (_currentType == SessionType.pomodoro) {
      // Start break
      if (_completedPomodoros % _settings.sessionsUntilLongBreak == 0) {
        nextType = SessionType.longBreak;
      } else {
        nextType = SessionType.shortBreak;
      }
    } else {
      // Start pomodoro
      nextType = SessionType.pomodoro;
    }

    setState(() {
      _currentType = nextType;
      _remainingTime = _getTypeDuration(nextType);
      _status = SessionStatus.notStarted;
    });

    if (_shouldAutoStartNext()) {
      _startTimer();
    }
  }

  Duration _getTypeDuration(SessionType type) {
    switch (type) {
      case SessionType.pomodoro:
        return _settings.focusDuration;
      case SessionType.shortBreak:
        return _settings.shortBreakDuration;
      case SessionType.longBreak:
        return _settings.longBreakDuration;
      case SessionType.custom:
        return const Duration(minutes: 30);
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(context.l10n.sharedFocusSessionComplete),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentType == SessionType.pomodoro
                  ? context.l10n.sharedFocusGreatWorkTimeForBreak
                  : context.l10n.sharedFocusBreakCompleteReadyToFocus,
              style: const TextStyle(fontSize: 16),
            ),
            if (_currentType == SessionType.pomodoro) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.sharedFocusPomodorosToday(_completedPomodoros),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!_shouldAutoStartNext())
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(context.l10n.sharedFocusFinish),
            ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _startNextSession();
              if (!_shouldAutoStartNext()) {
                _startTimer();
              }
            },
            child: Text(_currentType == SessionType.pomodoro
                ? context.l10n.sharedFocusStartBreak
                : context.l10n.sharedFocusStartFocus),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = _getTypeDuration(_currentType);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sharedFocusTimerTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Session type selector
              _buildSessionTypeSelector(),
              const SizedBox(height: 32),

              // Circular timer
              CircularTimerDisplay(
                remainingTime: _remainingTime,
                totalDuration: totalDuration,
                isRunning: _status == SessionStatus.running,
                color: _getSessionColor(),
              ),
              const SizedBox(height: 32),

              // Task name
              if (_currentTask != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.task_alt,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _currentTask!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() {
                            _currentTask = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (_currentType == SessionType.pomodoro) ...[
                TextButton.icon(
                  onPressed: _setTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Task'),
                ),
                const SizedBox(height: 24),
              ],

              // Control buttons
              _buildControlButtons(),
              const SizedBox(height: 32),

              // Stats
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton(
            SessionType.pomodoro,
            'Focus',
            Icons.timer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeButton(
            SessionType.shortBreak,
            'Short Break',
            Icons.coffee,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeButton(
            SessionType.longBreak,
            'Long Break',
            Icons.self_improvement,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(SessionType type, String label, IconData icon) {
    final isSelected = _currentType == type;
    final canSwitch = _status == SessionStatus.notStarted ||
        _status == SessionStatus.completed;

    return FilledButton(
      onPressed: canSwitch
          ? () {
              setState(() {
                _currentType = type;
                _remainingTime = _getTypeDuration(type);
                _status = SessionStatus.notStarted;
              });
            }
          : null,
      style: FilledButton.styleFrom(
        backgroundColor: isSelected
            ? _getSessionColor()
            : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_status == SessionStatus.running || _status == SessionStatus.paused)
          OutlinedButton.icon(
            onPressed: _resetTimer,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        if (_status == SessionStatus.running ||
            _status == SessionStatus.paused)
          const SizedBox(width: 16),
        FilledButton.icon(
          onPressed: _status == SessionStatus.notStarted ||
                  _status == SessionStatus.completed
              ? _startTimer
              : _status == SessionStatus.running
                  ? _pauseTimer
                  : _resumeTimer,
          icon: Icon(
            _status == SessionStatus.running
                ? Icons.pause
                : Icons.play_arrow,
          ),
          label: Text(
            _status == SessionStatus.running
                ? 'Pause'
                : _status == SessionStatus.paused
                    ? 'Resume'
                    : 'Start',
          ),
          style: FilledButton.styleFrom(
            backgroundColor: _getSessionColor(),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_completedPomodoros',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '7',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Day Streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getSessionColor() {
    switch (_currentType) {
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

  void _setTask() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What are you working on?'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Study for exam, Complete assignment...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final task = controller.text.trim();
              if (task.isNotEmpty) {
                setState(() {
                  _currentTask = task;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SettingsScreen(
          settings: _settings,
          onSave: (newSettings) {
            setState(() {
              _settings = newSettings;
              if (_status == SessionStatus.notStarted) {
                _remainingTime = _getTypeDuration(_currentType);
              }
            });
          },
        ),
      ),
    );
  }
}

class _SettingsScreen extends StatefulWidget {
  final PomodoroSettings settings;
  final ValueChanged<PomodoroSettings> onSave;

  const _SettingsScreen({
    required this.settings,
    required this.onSave,
  });

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  late PomodoroSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Settings'),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(_settings);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Duration Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDurationSetting(
            'Focus Session',
            _settings.focusDuration,
            (duration) {
              setState(() {
                _settings = _settings.copyWith(focusDuration: duration);
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDurationSetting(
            'Short Break',
            _settings.shortBreakDuration,
            (duration) {
              setState(() {
                _settings = _settings.copyWith(shortBreakDuration: duration);
              });
            },
          ),
          const SizedBox(height: 12),
          _buildDurationSetting(
            'Long Break',
            _settings.longBreakDuration,
            (duration) {
              setState(() {
                _settings = _settings.copyWith(longBreakDuration: duration);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Automation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Auto-start breaks'),
            subtitle:
                const Text('Automatically start break when focus session ends'),
            value: _settings.autoStartBreaks,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(autoStartBreaks: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Auto-start focus sessions'),
            subtitle:
                const Text('Automatically start focus when break ends'),
            value: _settings.autoStartPomodoros,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(autoStartPomodoros: value);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Play sound when session ends'),
            value: _settings.soundEnabled,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(soundEnabled: value);
              });
            },
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate when session ends'),
            value: _settings.vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(vibrationEnabled: value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSetting(
    String label,
    Duration duration,
    ValueChanged<Duration> onChanged,
  ) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text('${duration.inMinutes} minutes'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: duration.inMinutes > 1
                  ? () {
                      onChanged(Duration(minutes: duration.inMinutes - 1));
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: duration.inMinutes < 60
                  ? () {
                      onChanged(Duration(minutes: duration.inMinutes + 1));
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
