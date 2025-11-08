import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/quiz_widgets.dart';

/// Quiz Taking Screen
///
/// Interactive quiz interface with:
/// - Question navigation
/// - Timer countdown
/// - Answer tracking
/// - Auto-submit on timeout
/// - Progress saving
///
/// Backend Integration TODO:
/// - Save progress in real-time
/// - Handle network interruptions
/// - Resume incomplete attempts
/// - Submit answers to backend

class QuizTakingScreen extends StatefulWidget {
  final QuizModel quiz;

  const QuizTakingScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  late PageController _pageController;
  int _currentQuestionIndex = 0;
  final Map<String, dynamic> _answers = {};
  late int _timeRemaining; // seconds
  Timer? _timer;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timeRemaining = widget.quiz.duration * 60;
    _startTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timeExpired();
      }
    });
  }

  void _timeExpired() {
    _timer?.cancel();
    _showTimeExpiredDialog();
  }

  void _showTimeExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time\'s Up!'),
        content: const Text(
          'The quiz time has expired. Your answers will be submitted automatically.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onAnswerSelected(String questionId, dynamic answer) {
    setState(() {
      _answers[questionId] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _jumpToQuestion(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  void _submitQuiz() {
    // Check for unanswered questions
    final unansweredCount = widget.quiz.questions.length - _answers.length;

    if (unansweredCount > 0) {
      _showUnansweredQuestionsDialog(unansweredCount);
      return;
    }

    _confirmSubmit();
  }

  void _showUnansweredQuestionsDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unanswered Questions'),
        content: Text(
          'You have $count unanswered ${count == 1 ? 'question' : 'questions'}. '
          'Do you want to review them or submit anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Review'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmSubmit();
            },
            child: const Text('Submit Anyway'),
          ),
        ],
      ),
    );
  }

  void _confirmSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: const Text(
          'Are you sure you want to submit? You cannot change your answers after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubmission();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _processSubmission() {
    _timer?.cancel();

    // Calculate score
    int score = 0;
    for (final question in widget.quiz.questions) {
      final userAnswer = _answers[question.id];
      if (userAnswer == question.correctAnswer) {
        score += question.points;
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(_startTime!);
    final totalPoints = widget.quiz.totalPoints;
    final percentage = (score / totalPoints) * 100;
    final passed = percentage >= widget.quiz.passingScore;

    // TODO: Submit to backend

    // Navigate to results
    Navigator.pushReplacementNamed(
      context,
      '/quiz/results',
      arguments: {
        'quiz': widget.quiz,
        'score': score,
        'totalPoints': totalPoints,
        'timeTaken': timeTaken,
        'passed': passed,
        'answers': _answers,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldExit = await _onWillPop();
              if (shouldExit && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.grid_view),
              onPressed: _showQuestionNavigator,
              tooltip: 'Question Navigator',
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress and Timer
            QuizProgressIndicator(
              currentQuestion: _currentQuestionIndex + 1,
              totalQuestions: widget.quiz.questions.length,
              timeRemaining: _timeRemaining,
            ),

            // Questions PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemCount: widget.quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = widget.quiz.questions[index];
                  return QuestionCard(
                    question: question,
                    questionNumber: index + 1,
                    totalQuestions: widget.quiz.questions.length,
                    selectedAnswer: _answers[question.id],
                    onAnswerSelected: (answer) {
                      _onAnswerSelected(question.id, answer);
                    },
                  );
                },
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (_currentQuestionIndex > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _previousQuestion,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                        ),
                      ),
                    if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _currentQuestionIndex ==
                              widget.quiz.questions.length - 1
                          ? FilledButton.icon(
                              onPressed: _submitQuiz,
                              icon: const Icon(Icons.check),
                              label: const Text('Submit Quiz'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            )
                          : FilledButton.icon(
                              onPressed: _nextQuestion,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Next'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionNavigator() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question Navigator',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                widget.quiz.questions.length,
                (index) {
                  final question = widget.quiz.questions[index];
                  final isAnswered = _answers.containsKey(question.id);
                  final isCurrent = index == _currentQuestionIndex;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _jumpToQuestion(index);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primary
                            : isAnswered
                                ? AppColors.success.withValues(alpha: 0.2)
                                : AppColors.surface,
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : isAnswered
                                  ? AppColors.success
                                  : AppColors.border,
                          width: isCurrent ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? Colors.white
                                : isAnswered
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildLegendItem(
                  AppColors.primary,
                  'Current',
                  isSolid: true,
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  AppColors.success,
                  'Answered',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  AppColors.border,
                  'Unanswered',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isSolid = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isSolid ? color : color.withValues(alpha: 0.2),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
