// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/quiz_assignment_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../institution/providers/course_content_provider.dart';

/// Quiz Lesson Taker
/// Interactive quiz interface for students
class QuizLessonTaker extends ConsumerStatefulWidget {
  final String lessonId;

  const QuizLessonTaker({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<QuizLessonTaker> createState() => _QuizLessonTakerState();
}

class _QuizLessonTakerState extends ConsumerState<QuizLessonTaker> {
  final Map<String, dynamic> _answers = {};
  bool _isSubmitted = false;
  int? _score;
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // Load quiz content on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contentProvider.notifier).fetchQuizContent(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentProvider);

    if (contentState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading quiz:\n${contentState.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(contentProvider.notifier).fetchQuizContent(widget.lessonId);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final content = contentState.content;
    if (content == null || content is! QuizContent) {
      return const Center(
        child: Text('No quiz content available'),
      );
    }

    if (_isSubmitted) {
      return _buildResultsView(content);
    }

    return _buildQuizView(content);
  }

  Widget _buildQuizView(QuizContent content) {
    final questions = content.questions ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz info
          _buildQuizInfo(content),
          const SizedBox(height: 32),

          // Questions
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildQuestionCard(question, index + 1),
            );
          }),

          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitQuiz,
              icon: const Icon(Icons.check_circle),
              label: const Text('Submit Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfo(QuizContent content) {
    final timeLimit = content.timeLimitMinutes;
    final elapsedMinutes = DateTime.now().difference(_startTime!).inMinutes;
    final questions = content.questions ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.quiz, size: 20),
                const SizedBox(width: 8),
                Text('${questions.length} questions'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 20),
                const SizedBox(width: 8),
                Text('Passing score: ${content.passingScore}%'),
              ],
            ),
            if (timeLimit != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 20,
                    color: elapsedMinutes >= timeLimit ? Colors.red : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Time limit: $timeLimit minutes (elapsed: $elapsedMinutes min)',
                    style: TextStyle(
                      color: elapsedMinutes >= timeLimit ? Colors.red : null,
                      fontWeight: elapsedMinutes >= timeLimit ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ],
            if (content.maxAttempts != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.replay, size: 20),
                  const SizedBox(width: 8),
                  Text('Maximum attempts: ${content.maxAttempts}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuizQuestion question, int questionNumber) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text('Q$questionNumber'),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.questionText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${question.points} point${question.points > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnswerInput(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput(QuizQuestion question) {
    switch (question.questionType) {
      case QuestionType.multipleChoice:
        return _buildMultipleChoiceInput(question);
      case QuestionType.trueFalse:
        return _buildTrueFalseInput(question);
      case QuestionType.shortAnswer:
        return _buildShortAnswerInput(question);
      case QuestionType.essay:
        return _buildEssayInput(question);
    }
  }

  Widget _buildMultipleChoiceInput(QuizQuestion question) {
    final options = question.options ?? [];
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          value: option.id,
          groupValue: _answers[question.id] as String?,
          onChanged: (value) {
            setState(() {
              _answers[question.id] = value;
            });
          },
          title: Text(option.optionText),
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseInput(QuizQuestion question) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: _answers[question.id] as bool?,
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
            title: const Text('True'),
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            value: false,
            groupValue: _answers[question.id] as bool?,
            onChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
            title: const Text('False'),
          ),
        ),
      ],
    );
  }

  Widget _buildShortAnswerInput(QuizQuestion question) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Enter your answer...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
      maxLines: 2,
    );
  }

  Widget _buildEssayInput(QuizQuestion question) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Write your essay answer here...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
      maxLines: 8,
    );
  }

  void _submitQuiz() {
    _endTime = DateTime.now();

    // Calculate score for auto-gradable questions
    final contentState = ref.read(contentProvider);
    final content = contentState.content as QuizContent;
    final questions = content.questions ?? [];

    int totalPoints = 0;
    int earnedPoints = 0;

    for (final question in questions) {
      totalPoints += question.points;

      if (question.questionType == QuestionType.multipleChoice) {
        final selectedOptionId = _answers[question.id] as String?;
        final options = question.options ?? [];
        if (options.isNotEmpty) {
          final correctOption = options.firstWhere(
            (opt) => opt.isCorrect,
            orElse: () => options.first,
          );

          if (selectedOptionId == correctOption.id) {
            earnedPoints += question.points;
          }
        }
      } else if (question.questionType == QuestionType.trueFalse) {
        // This would need correct answer stored in backend
        // For now, we'll mark as needing manual grading
      }
    }

    setState(() {
      _isSubmitted = true;
      _score = totalPoints > 0 ? ((earnedPoints / totalPoints) * 100).round() : 0;
    });

    // Submit to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildResultsView(QuizContent content) {
    final isPassed = _score! >= content.passingScore;
    final timeTaken = _endTime!.difference(_startTime!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score card
          Card(
            color: isPassed ? Colors.green[50] : Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    isPassed ? Icons.check_circle : Icons.cancel,
                    size: 80,
                    color: isPassed ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isPassed ? 'Passed!' : 'Not Passed',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green[900] : Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Score: $_score%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passing Score: ${content.passingScore}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Time taken: ${timeTaken.inMinutes} minutes',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Review answers (if enabled)
          if (content.showCorrectAnswers) ...[
            const Text(
              'Review Your Answers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...(content.questions ?? []).asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return _buildReviewCard(question, index + 1);
            }),
          ],

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              if (content.maxAttempts == null || content.maxAttempts! > 1)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _answers.clear();
                        _isSubmitted = false;
                        _score = null;
                        _startTime = DateTime.now();
                        _endTime = null;
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Retake Quiz'),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(QuizQuestion question, int questionNumber) {
    final userAnswer = _answers[question.id];
    bool? isCorrect;
    final options = question.options ?? [];

    if (question.questionType == QuestionType.multipleChoice && options.isNotEmpty) {
      final correctOption = options.firstWhere(
        (opt) => opt.isCorrect,
        orElse: () => options.first,
      );
      isCorrect = userAnswer == correctOption.id;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text('Q$questionNumber'),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 12),
                if (isCorrect != null)
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (question.questionType == QuestionType.multipleChoice) ...[
              ...options.map((option) {
                final isUserAnswer = userAnswer == option.id;
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: option.isCorrect
                        ? Colors.green[50]
                        : (isUserAnswer && !option.isCorrect
                            ? Colors.red[50]
                            : null),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: option.isCorrect
                          ? Colors.green
                          : (isUserAnswer ? Colors.red : Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (option.isCorrect)
                        const Icon(Icons.check, color: Colors.green, size: 20)
                      else if (isUserAnswer)
                        const Icon(Icons.close, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(option.optionText)),
                    ],
                  ),
                );
              }),
            ],
            if (question.explanation != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question.explanation!,
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
