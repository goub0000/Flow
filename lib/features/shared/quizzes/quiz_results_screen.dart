import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/quiz_widgets.dart';

/// Quiz Results Screen
///
/// Displays quiz completion results with:
/// - Overall score and percentage
/// - Pass/fail status
/// - Time taken
/// - Question-by-question review
/// - Performance breakdown
/// - Option to retake
///
/// Backend Integration TODO:
/// - Record results in database
/// - Update user progress
/// - Unlock next content if passed
/// - Send achievement notifications

class QuizResultsScreen extends ConsumerStatefulWidget {
  final QuizModel quiz;
  final int score;
  final int totalPoints;
  final Duration timeTaken;
  final bool passed;
  final Map<String, dynamic> answers;

  const QuizResultsScreen({
    super.key,
    required this.quiz,
    required this.score,
    required this.totalPoints,
    required this.timeTaken,
    required this.passed,
    required this.answers,
  });

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get percentage => (widget.score / widget.totalPoints) * 100;

  int get correctAnswers {
    int count = 0;
    for (final question in widget.quiz.questions) {
      if (widget.answers[question.id] == question.correctAnswer) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('Quiz Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                final user = ref.read(authProvider).user;
                if (user != null) {
                  context.go(user.activeRole.dashboardRoute);
                }
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Review Answers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildReviewTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Score Display
          ScoreDisplay(
            score: widget.score,
            totalPoints: widget.totalPoints,
            passed: widget.passed,
          ),
          const SizedBox(height: 24),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Correct',
                  value: '$correctAnswers/${widget.quiz.questions.length}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer,
                  label: 'Time Taken',
                  value: _formatDuration(widget.timeTaken),
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.trending_up,
                  label: 'Score',
                  value: '${percentage.toStringAsFixed(1)}%',
                  color: widget.passed ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.grade,
                  label: 'Pass Mark',
                  value: '${widget.quiz.passingScore}%',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Performance Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPerformanceRow(
                    'Correct Answers',
                    correctAnswers,
                    widget.quiz.questions.length,
                    AppColors.success,
                  ),
                  const SizedBox(height: 12),
                  _buildPerformanceRow(
                    'Incorrect Answers',
                    widget.quiz.questions.length - correctAnswers,
                    widget.quiz.questions.length,
                    AppColors.error,
                  ),
                  const SizedBox(height: 12),
                  _buildPerformanceRow(
                    'Unanswered',
                    widget.quiz.questions.length - widget.answers.length,
                    widget.quiz.questions.length,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          if (!widget.passed)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _retakeQuiz,
                icon: const Icon(Icons.replay),
                label: const Text('Retake Quiz'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.visibility),
              label: const Text('Review Answers'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _downloadCertificate,
              icon: const Icon(Icons.download),
              label: const Text('Download Certificate'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.quiz.questions.length,
      itemBuilder: (context, index) {
        final question = widget.quiz.questions[index];
        final userAnswer = widget.answers[question.id];

        return Column(
          children: [
            QuestionCard(
              question: question,
              questionNumber: index + 1,
              totalQuestions: widget.quiz.questions.length,
              selectedAnswer: userAnswer,
              showCorrectAnswer: true,
              isReviewMode: true,
            ),
            if (index < widget.quiz.questions.length - 1)
              const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceRow(
    String label,
    int value,
    int total,
    Color color,
  ) {
    final theme = Theme.of(context);
    final percentage = (value / total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '$value',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  void _retakeQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retake Quiz?'),
        content: const Text(
          'Are you sure you want to retake this quiz? This will count as a new attempt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close results
              // The quiz list will handle starting a new attempt
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Starting new attempt...'),
                ),
              );
            },
            child: const Text('Retake'),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate() {
    if (!widget.passed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must pass the quiz to get a certificate'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Generate and download certificate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate download coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
