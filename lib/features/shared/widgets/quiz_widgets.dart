import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Quizzes & Assessments Widgets
///
/// Comprehensive quiz and assessment UI components including:
/// - Question cards (multiple choice, true/false, fill-in-blank)
/// - Answer options
/// - Progress indicators
/// - Score displays
/// - Result summaries
///
/// Backend Integration TODO:
/// ```dart
/// // Quiz Management API
/// import 'package:dio/dio.dart';
///
/// class QuizRepository {
///   final Dio _dio;
///
///   Future<List<QuizModel>> getQuizzes({
///     String? courseId,
///     String? lessonId,
///     QuizDifficulty? difficulty,
///   }) async {
///     final response = await _dio.get('/api/quizzes', queryParameters: {
///       'courseId': courseId,
///       'lessonId': lessonId,
///       'difficulty': difficulty?.name,
///     });
///
///     return (response.data['quizzes'] as List)
///         .map((json) => QuizModel.fromJson(json))
///         .toList();
///   }
///
///   Future<QuizModel> getQuizDetail(String quizId) async {
///     final response = await _dio.get('/api/quizzes/$quizId');
///     return QuizModel.fromJson(response.data);
///   }
///
///   Future<QuizAttempt> submitQuiz({
///     required String quizId,
///     required Map<String, dynamic> answers,
///   }) async {
///     final response = await _dio.post('/api/quizzes/$quizId/submit', data: {
///       'answers': answers,
///       'startedAt': DateTime.now().toIso8601String(),
///       'completedAt': DateTime.now().toIso8601String(),
///     });
///
///     return QuizAttempt.fromJson(response.data);
///   }
///
///   Future<List<QuizAttempt>> getAttempts(String quizId) async {
///     final response = await _dio.get('/api/quizzes/$quizId/attempts');
///
///     return (response.data['attempts'] as List)
///         .map((json) => QuizAttempt.fromJson(json))
///         .toList();
///   }
///
///   Future<QuizStatistics> getStatistics(String quizId) async {
///     final response = await _dio.get('/api/quizzes/$quizId/statistics');
///     return QuizStatistics.fromJson(response.data);
///   }
/// }
///
/// // Real-time quiz tracking
/// import 'package:supabase_flutter/supabase_flutter.dart';
///
/// class QuizTrackingService {
///   final _supabase = Supabase.instance.client;
///
///   Future<void> startQuiz(String userId, String quizId) async {
///     await _supabase.from('quiz_sessions').insert({
///       'user_id': userId,
///       'quiz_id': quizId,
///       'started_at': DateTime.now().toIso8601String(),
///       'status': 'in_progress',
///     });
///   }
///
///   Future<void> saveAnswer({
///     required String userId,
///     required String quizId,
///     required String questionId,
///     required dynamic answer,
///   }) async {
///     await _supabase.from('quiz_answers').upsert({
///       'user_id': userId,
///       'quiz_id': quizId,
///       'question_id': questionId,
///       'answer': answer,
///       'last_updated': DateTime.now().toIso8601String(),
///     });
///   }
///
///   Future<void> completeQuiz(String userId, String quizId) async {
///     await _supabase
///         .from('quiz_sessions')
///         .update({
///           'completed_at': DateTime.now().toIso8601String(),
///           'status': 'completed',
///         })
///         .eq('user_id', userId)
///         .eq('quiz_id', quizId);
///   }
/// }
/// ```

/// Question Type Enum
enum QuestionType {
  multipleChoice,
  trueFalse,
  fillInBlank,
  multipleAnswer,
  matching,
}

extension QuestionTypeExtension on QuestionType {
  String get displayName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.fillInBlank:
        return 'Fill in the Blank';
      case QuestionType.multipleAnswer:
        return 'Multiple Answer';
      case QuestionType.matching:
        return 'Matching';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked;
      case QuestionType.trueFalse:
        return Icons.check_box;
      case QuestionType.fillInBlank:
        return Icons.edit;
      case QuestionType.multipleAnswer:
        return Icons.checklist;
      case QuestionType.matching:
        return Icons.compare_arrows;
    }
  }
}

/// Quiz Difficulty Enum
enum QuizDifficulty {
  easy,
  medium,
  hard,
}

extension QuizDifficultyExtension on QuizDifficulty {
  String get displayName {
    switch (this) {
      case QuizDifficulty.easy:
        return 'Easy';
      case QuizDifficulty.medium:
        return 'Medium';
      case QuizDifficulty.hard:
        return 'Hard';
    }
  }

  Color get color {
    switch (this) {
      case QuizDifficulty.easy:
        return AppColors.success;
      case QuizDifficulty.medium:
        return AppColors.warning;
      case QuizDifficulty.hard:
        return AppColors.error;
    }
  }
}

/// Question Model
class QuestionModel {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final dynamic correctAnswer;
  final String? explanation;
  final int points;

  const QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.points = 1,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['text'],
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      points: json['points'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'points': points,
    };
  }
}

/// Quiz Model
class QuizModel {
  final String id;
  final String title;
  final String? description;
  final List<QuestionModel> questions;
  final int duration; // minutes
  final int passingScore;
  final QuizDifficulty difficulty;
  final String? courseId;
  final String? lessonId;
  final int maxAttempts;

  const QuizModel({
    required this.id,
    required this.title,
    this.description,
    required this.questions,
    required this.duration,
    this.passingScore = 70,
    this.difficulty = QuizDifficulty.medium,
    this.courseId,
    this.lessonId,
    this.maxAttempts = 3,
  });

  int get totalPoints => questions.fold(0, (sum, q) => sum + q.points);

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List)
          .map((q) => QuestionModel.fromJson(q))
          .toList(),
      duration: json['duration'],
      passingScore: json['passingScore'] ?? 70,
      difficulty: QuizDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => QuizDifficulty.medium,
      ),
      courseId: json['courseId'],
      lessonId: json['lessonId'],
      maxAttempts: json['maxAttempts'] ?? 3,
    );
  }
}

/// Quiz Attempt Model
class QuizAttempt {
  final String id;
  final String quizId;
  final int score;
  final int totalPoints;
  final DateTime completedAt;
  final Duration timeTaken;
  final bool passed;

  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.score,
    required this.totalPoints,
    required this.completedAt,
    required this.timeTaken,
    required this.passed,
  });

  double get percentage => (score / totalPoints) * 100;

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'],
      quizId: json['quizId'],
      score: json['score'],
      totalPoints: json['totalPoints'],
      completedAt: DateTime.parse(json['completedAt']),
      timeTaken: Duration(seconds: json['timeTakenSeconds']),
      passed: json['passed'],
    );
  }
}

/// Question Card Widget
class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final int totalQuestions;
  final dynamic selectedAnswer;
  final ValueChanged<dynamic>? onAnswerSelected;
  final bool showCorrectAnswer;
  final bool isReviewMode;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    this.selectedAnswer,
    this.onAnswerSelected,
    this.showCorrectAnswer = false,
    this.isReviewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Question $questionNumber of $totalQuestions',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        question.type.icon,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${question.points} ${question.points == 1 ? 'pt' : 'pts'}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Question Text
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Answer Options
            if (question.type == QuestionType.multipleChoice ||
                question.type == QuestionType.trueFalse)
              ...question.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = selectedAnswer == index;
                final isCorrect = showCorrectAnswer && question.correctAnswer == index;
                final isWrong = showCorrectAnswer && isSelected && question.correctAnswer != index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AnswerOption(
                    text: option,
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    isWrong: isWrong,
                    showResult: showCorrectAnswer,
                    onTap: isReviewMode ? null : () => onAnswerSelected?.call(index),
                  ),
                );
              }),

            if (question.type == QuestionType.fillInBlank && !isReviewMode)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type your answer here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: onAnswerSelected,
              ),

            // Explanation (if showing correct answer)
            if (showCorrectAnswer && question.explanation != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explanation',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            question.explanation!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
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

/// Answer Option Widget
class _AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool showResult;
  final VoidCallback? onTap;

  const _AnswerOption({
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.showResult = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color borderColor = AppColors.border;
    Color backgroundColor = AppColors.surface;
    IconData? icon;

    if (showResult) {
      if (isCorrect) {
        borderColor = AppColors.success;
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        icon = Icons.check_circle;
      } else if (isWrong) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        icon = Icons.cancel;
      }
    } else if (isSelected) {
      borderColor = AppColors.primary;
      backgroundColor = AppColors.primary.withValues(alpha: 0.05);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isSelected || showResult ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio/Check indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge,
              ),
            ),

            // Result icon
            if (icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                icon,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quiz Progress Indicator
class QuizProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int? timeRemaining; // seconds

  const QuizProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = currentQuestion / totalQuestions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (timeRemaining != null)
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: timeRemaining! < 60
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(timeRemaining!),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: timeRemaining! < 60
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 1 ? AppColors.success : AppColors.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

/// Score Display Widget
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int totalPoints;
  final bool passed;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.totalPoints,
    required this.passed,
  });

  double get percentage => (score / totalPoints) * 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: passed
              ? [AppColors.success, AppColors.success.withValues(alpha: 0.7)]
              : [AppColors.error, AppColors.error.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            passed ? 'Congratulations!' : 'Keep Practicing!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You scored',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$score out of $totalPoints points',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quiz Card Widget
class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final int? attemptsUsed;
  final QuizAttempt? bestAttempt;
  final VoidCallback? onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    this.attemptsUsed,
    this.bestAttempt,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: quiz.difficulty.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      quiz.difficulty.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: quiz.difficulty.color,
                      ),
                    ),
                  ),
                ],
              ),
              if (quiz.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  quiz.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.questions.length} questions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.duration} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${attemptsUsed ?? 0}/${quiz.maxAttempts} attempts',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (bestAttempt != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bestAttempt!.passed
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        bestAttempt!.passed ? Icons.check_circle : Icons.info,
                        size: 16,
                        color: bestAttempt!.passed
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Best Score: ${bestAttempt!.percentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: bestAttempt!.passed
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
