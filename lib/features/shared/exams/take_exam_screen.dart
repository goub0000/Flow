import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/exam_widgets.dart';

/// Take Exam Screen
///
/// Interactive exam-taking interface:
/// - Live timer countdown
/// - Question navigation
/// - Answer selection
/// - Progress tracking
/// - Auto-save answers
/// - Submit with confirmation
///
/// Backend Integration TODO:
/// - Auto-save answers to backend
/// - Submit exam answers
/// - Handle time expiry
/// - Proctoring integration
/// - Internet disconnection handling

class TakeExamScreen extends StatefulWidget {
  final ExamModel exam;

  const TakeExamScreen({
    super.key,
    required this.exam,
  });

  @override
  State<TakeExamScreen> createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen> {
  late PageController _pageController;
  late Timer _timer;
  late Duration _remainingTime;
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};
  late List<QuestionModel> _questions;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _remainingTime = widget.exam.duration;
    _generateMockQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _timer.cancel();
          _autoSubmitExam();
        }
      });
    });
  }

  void _generateMockQuestions() {
    _questions = [
      const QuestionModel(
        id: '1',
        type: QuestionType.multipleChoice,
        question: 'What is the primary programming language used for Flutter development?',
        marks: 2,
        difficulty: DifficultyLevel.easy,
        options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      ),
      const QuestionModel(
        id: '2',
        type: QuestionType.multipleChoice,
        question: 'Which widget is used to create a scrollable list in Flutter?',
        marks: 2,
        difficulty: DifficultyLevel.easy,
        options: ['Container', 'ListView', 'Column', 'Row'],
      ),
      const QuestionModel(
        id: '3',
        type: QuestionType.trueFalse,
        question: 'StatefulWidget can change its properties during runtime.',
        marks: 1,
        difficulty: DifficultyLevel.easy,
      ),
      const QuestionModel(
        id: '4',
        type: QuestionType.multipleChoice,
        question: 'What is the purpose of the setState() method in Flutter?',
        marks: 2,
        difficulty: DifficultyLevel.medium,
        options: [
          'To create a new widget',
          'To rebuild the widget with updated state',
          'To dispose of a widget',
          'To initialize a widget',
        ],
      ),
      const QuestionModel(
        id: '5',
        type: QuestionType.trueFalse,
        question: 'Flutter uses a reactive programming model.',
        marks: 1,
        difficulty: DifficultyLevel.medium,
      ),
      const QuestionModel(
        id: '6',
        type: QuestionType.multipleChoice,
        question: 'Which state management solution is built into Flutter?',
        marks: 2,
        difficulty: DifficultyLevel.medium,
        options: ['Provider', 'Riverpod', 'InheritedWidget', 'Bloc'],
      ),
      const QuestionModel(
        id: '7',
        type: QuestionType.shortAnswer,
        question: 'What does the BuildContext parameter represent in Flutter widgets?',
        marks: 3,
        difficulty: DifficultyLevel.medium,
      ),
      const QuestionModel(
        id: '8',
        type: QuestionType.multipleChoice,
        question: 'Which method is called when a StatefulWidget is first created?',
        marks: 2,
        difficulty: DifficultyLevel.hard,
        options: ['build()', 'initState()', 'dispose()', 'createState()'],
      ),
      const QuestionModel(
        id: '9',
        type: QuestionType.trueFalse,
        question: 'Keys are required for all widgets in Flutter.',
        marks: 1,
        difficulty: DifficultyLevel.hard,
      ),
      const QuestionModel(
        id: '10',
        type: QuestionType.essay,
        question: 'Explain the difference between StatelessWidget and StatefulWidget with examples.',
        marks: 5,
        difficulty: DifficultyLevel.hard,
      ),
    ];
  }

  int get _answeredCount => _answers.length;

  double get _progress => _answeredCount / _questions.length;

  bool get _isTimeWarning => _remainingTime.inMinutes < 5;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation();
        if (shouldExit == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exam.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldExit = await _showExitConfirmation();
              if (shouldExit == true && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            // Timer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ExamTimerWidget(
                remainingTime: _remainingTime,
                isWarning: _isTimeWarning,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$_answeredCount answered',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _progress == 1.0 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Questions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: QuestionWidget(
                      question: question,
                      questionNumber: index + 1,
                      selectedAnswer: _answers[question.id],
                      onAnswerChanged: (answer) {
                        setState(() {
                          _answers[question.id] = answer;
                        });
                        // TODO: Auto-save to backend
                      },
                    ),
                  );
                },
              ),
            ),

            // Navigation and Submit
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Previous button
                  if (_currentQuestionIndex > 0)
                    OutlinedButton.icon(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    )
                  else
                    const SizedBox(width: 100),

                  const Spacer(),

                  // Question navigator
                  OutlinedButton(
                    onPressed: _showQuestionNavigator,
                    child: const Icon(Icons.grid_view),
                  ),

                  const Spacer(),

                  // Next or Submit button
                  if (_currentQuestionIndex < _questions.length - 1)
                    FilledButton.icon(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    )
                  else
                    FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submitExam,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isSubmitting ? 'Submitting...' : 'Submit'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                    ),
                ],
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                final isAnswered = _answers.containsKey(question.id);
                final isCurrent = index == _currentQuestionIndex;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primary
                          : isAnswered
                              ? AppColors.success.withValues(alpha: 0.2)
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : isAnswered
                                ? AppColors.success
                                : Colors.grey,
                        width: 2,
                      ),
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
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegendItem(
                  AppColors.success.withValues(alpha: 0.2),
                  AppColors.success,
                  'Answered',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  Colors.grey[200]!,
                  Colors.grey,
                  'Not Answered',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  AppColors.primary,
                  AppColors.primary,
                  'Current',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color bgColor, Color borderColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Exam?'),
        content: const Text(
          'Are you sure you want to exit? Your progress has been saved, but you cannot return to this exam.',
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
  }

  Future<void> _submitExam() async {
    // Check if all questions are answered
    if (_answeredCount < _questions.length) {
      final shouldContinue = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Exam'),
          content: Text(
            'You have answered $_answeredCount out of ${_questions.length} questions. '
            'Do you want to submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Review'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

      if (shouldContinue != true) return;
    }

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam?'),
        content: const Text(
          'Once submitted, you cannot change your answers. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    // TODO: Submit to backend
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/exams/results',
        arguments: widget.exam,
      );
    }
  }

  void _autoSubmitExam() {
    if (_isSubmitting) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time\'s Up!'),
        content: const Text('Your exam has been automatically submitted.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                '/exams/results',
                arguments: widget.exam,
              );
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }
}
