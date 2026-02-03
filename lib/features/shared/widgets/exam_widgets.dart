import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Exam and Testing Widgets
///
/// Comprehensive widget library for exam management:
/// - Exam models and types
/// - Question types (MCQ, True/False, Essay, etc.)
/// - Exam cards and lists
/// - Question widgets
/// - Result displays
/// - Timer widgets
///
/// Backend Integration TODO:
/// - Fetch exams from backend
/// - Submit exam answers
/// - Auto-save progress
/// - Handle time extensions
/// - Proctoring integration

// Enums
enum ExamType { quiz, midterm, final_, practice, assignment }

enum ExamStatus { upcoming, inProgress, completed, missed }

enum QuestionType { multipleChoice, trueFalse, shortAnswer, essay, matching }

enum DifficultyLevel { easy, medium, hard }

// Models
class ExamModel {
  final String id;
  final String title;
  final ExamType type;
  final String courseId;
  final String courseName;
  final DateTime scheduledDate;
  final Duration duration;
  final int totalQuestions;
  final int totalMarks;
  final bool isProctored;
  final ExamStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? score;
  final List<String> topics;
  final String? instructions;
  final int? attemptsAllowed;
  final int? attemptsUsed;

  const ExamModel({
    required this.id,
    required this.title,
    required this.type,
    required this.courseId,
    required this.courseName,
    required this.scheduledDate,
    required this.duration,
    required this.totalQuestions,
    required this.totalMarks,
    this.isProctored = false,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.score,
    this.topics = const [],
    this.instructions,
    this.attemptsAllowed,
    this.attemptsUsed,
  });

  String get typeLabel {
    switch (type) {
      case ExamType.quiz:
        return 'Quiz';
      case ExamType.midterm:
        return 'Midterm';
      case ExamType.final_:
        return 'Final Exam';
      case ExamType.practice:
        return 'Practice';
      case ExamType.assignment:
        return 'Assignment';
    }
  }

  Color get typeColor {
    switch (type) {
      case ExamType.quiz:
        return AppColors.primary;
      case ExamType.midterm:
        return Colors.orange;
      case ExamType.final_:
        return AppColors.error;
      case ExamType.practice:
        return Colors.green;
      case ExamType.assignment:
        return Colors.purple;
    }
  }

  String get statusLabel {
    switch (status) {
      case ExamStatus.upcoming:
        return 'Upcoming';
      case ExamStatus.inProgress:
        return 'In Progress';
      case ExamStatus.completed:
        return 'Completed';
      case ExamStatus.missed:
        return 'Missed';
    }
  }

  Color get statusColor {
    switch (status) {
      case ExamStatus.upcoming:
        return Colors.blue;
      case ExamStatus.inProgress:
        return Colors.orange;
      case ExamStatus.completed:
        return AppColors.success;
      case ExamStatus.missed:
        return AppColors.error;
    }
  }

  bool get canAttempt {
    if (attemptsAllowed == null) return true;
    if (attemptsUsed == null) return true;
    return attemptsUsed! < attemptsAllowed!;
  }

  String get attemptsText {
    if (attemptsAllowed == null) return 'Unlimited attempts';
    if (attemptsUsed == null) return '$attemptsAllowed attempts allowed';
    return '${attemptsAllowed! - attemptsUsed!} attempts remaining';
  }

  double? get scorePercentage {
    if (score == null) return null;
    return (score! / totalMarks) * 100;
  }

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class QuestionModel {
  final String id;
  final QuestionType type;
  final String question;
  final int marks;
  final DifficultyLevel difficulty;
  final List<String>? options; // For MCQ
  final String? correctAnswer; // For practice/review
  final String? userAnswer;
  final bool? isCorrect;
  final String? explanation;

  const QuestionModel({
    required this.id,
    required this.type,
    required this.question,
    required this.marks,
    this.difficulty = DifficultyLevel.medium,
    this.options,
    this.correctAnswer,
    this.userAnswer,
    this.isCorrect,
    this.explanation,
  });

  String get typeLabel {
    switch (type) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.shortAnswer:
        return 'Short Answer';
      case QuestionType.essay:
        return 'Essay';
      case QuestionType.matching:
        return 'Matching';
    }
  }

  String get difficultyLabel {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Colors.green;
      case DifficultyLevel.medium:
        return Colors.orange;
      case DifficultyLevel.hard:
        return AppColors.error;
    }
  }
}

class ExamResultModel {
  final String examId;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int score;
  final int totalMarks;
  final Duration timeTaken;
  final Map<QuestionType, int> questionTypeBreakdown;
  final List<QuestionModel> questions;

  const ExamResultModel({
    required this.examId,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.score,
    required this.totalMarks,
    required this.timeTaken,
    required this.questionTypeBreakdown,
    required this.questions,
  });

  double get percentage => (score / totalMarks) * 100;

  double get accuracy => totalQuestions > 0
      ? (correctAnswers / totalQuestions) * 100
      : 0;

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 85) return 'A';
    if (percentage >= 80) return 'A-';
    if (percentage >= 75) return 'B+';
    if (percentage >= 70) return 'B';
    if (percentage >= 65) return 'B-';
    if (percentage >= 60) return 'C+';
    if (percentage >= 55) return 'C';
    if (percentage >= 50) return 'C-';
    return 'F';
  }

  Color get gradeColor {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return Colors.orange;
    return AppColors.error;
  }
}

// Widgets
class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback? onTap;
  final VoidCallback? onStart;

  const ExamCard({
    super.key,
    required this.exam,
    this.onTap,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: exam.typeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type and status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: exam.typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      exam.typeLabel,
                      style: TextStyle(
                        color: exam.typeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: exam.statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      exam.statusLabel,
                      style: TextStyle(
                        color: exam.statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (exam.isProctored)
                    const Icon(
                      Icons.videocam,
                      size: 20,
                      color: AppColors.error,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                exam.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Course name
              Text(
                exam.courseName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),

              // Info row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    Icons.calendar_today,
                    _formatDate(context, exam.scheduledDate),
                  ),
                  _buildInfoChip(
                    Icons.schedule,
                    exam.formattedDuration,
                  ),
                  _buildInfoChip(
                    Icons.help_outline,
                    context.l10n.swExamQuestionsCount(exam.totalQuestions),
                  ),
                  _buildInfoChip(
                    Icons.grade,
                    context.l10n.swExamMarksCount(exam.totalMarks),
                  ),
                ],
              ),

              // Score or attempts
              if (exam.status == ExamStatus.completed && exam.score != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: exam.scorePercentage! >= 60
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        exam.scorePercentage! >= 60
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: exam.scorePercentage! >= 60
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.swExamScoreDisplay(exam.score!, exam.totalMarks),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: exam.scorePercentage! >= 60
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (exam.attemptsAllowed != null) ...[
                const SizedBox(height: 8),
                Text(
                  exam.attemptsText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              // Start button for upcoming exams
              if (exam.status == ExamStatus.upcoming && onStart != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: exam.canAttempt ? onStart : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.swExamStartExam),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return '${context.l10n.swExamToday} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return context.l10n.swExamTomorrow;
    } else if (difference.inDays < 7) {
      return context.l10n.swExamDaysCount(difference.inDays);
    }

    return '${date.day}/${date.month}/${date.year}';
  }
}

class QuestionWidget extends StatelessWidget {
  final QuestionModel question;
  final int questionNumber;
  final String? selectedAnswer;
  final ValueChanged<String>? onAnswerChanged;
  final bool showResults;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    this.selectedAnswer,
    this.onAnswerChanged,
    this.showResults = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q$questionNumber',
                    style: const TextStyle(
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
                        question.typeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${question.marks} mark${question.marks > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: question.difficultyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    question.difficultyLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: question.difficultyColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question text
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Answer options based on type
            if (question.type == QuestionType.multipleChoice &&
                question.options != null)
              ...question.options!.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
                final isSelected = selectedAnswer == option;
                final isCorrect = showResults && option == question.correctAnswer;
                final isWrong = showResults && isSelected && !isCorrect;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: onAnswerChanged != null && !showResults
                        ? () => onAnswerChanged!(option)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isCorrect
                              ? AppColors.success
                              : isWrong
                                  ? AppColors.error
                                  : isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isCorrect
                            ? AppColors.success.withValues(alpha: 0.1)
                            : isWrong
                                ? AppColors.error.withValues(alpha: 0.1)
                                : isSelected
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCorrect
                                  ? AppColors.success
                                  : isWrong
                                      ? AppColors.error
                                      : isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade200,
                            ),
                            child: Center(
                              child: Text(
                                optionLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected || isCorrect || isWrong
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          if (isCorrect)
                            const Icon(Icons.check_circle, color: AppColors.success)
                          else if (isWrong)
                            const Icon(Icons.cancel, color: AppColors.error),
                        ],
                      ),
                    ),
                  ),
                );
              }),

            if (question.type == QuestionType.trueFalse)
              Row(
                children: [
                  Expanded(
                    child: _buildTrueFalseButton(
                      context,
                      'True',
                      'True' == selectedAnswer,
                      showResults && 'True' == question.correctAnswer,
                      showResults &&
                          'True' == selectedAnswer &&
                          'True' != question.correctAnswer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTrueFalseButton(
                      context,
                      'False',
                      'False' == selectedAnswer,
                      showResults && 'False' == question.correctAnswer,
                      showResults &&
                          'False' == selectedAnswer &&
                          'False' != question.correctAnswer,
                    ),
                  ),
                ],
              ),

            if (question.type == QuestionType.shortAnswer ||
                question.type == QuestionType.essay)
              TextField(
                controller: TextEditingController(text: selectedAnswer),
                onChanged: onAnswerChanged,
                maxLines: question.type == QuestionType.essay ? 6 : 2,
                enabled: !showResults,
                decoration: InputDecoration(
                  hintText: question.type == QuestionType.essay
                      ? context.l10n.swExamWriteAnswerHint
                      : context.l10n.swExamEnterAnswerHint,
                  border: const OutlineInputBorder(),
                ),
              ),

            // Explanation for results
            if (showResults && question.explanation != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.swExamExplanation,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(question.explanation!),
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

  Widget _buildTrueFalseButton(
    BuildContext context,
    String label,
    bool isSelected,
    bool isCorrect,
    bool isWrong,
  ) {
    return InkWell(
      onTap: onAnswerChanged != null && !showResults
          ? () => onAnswerChanged!(label)
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCorrect
                ? AppColors.success
                : isWrong
                    ? AppColors.error
                    : isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.1)
              : isWrong
                  ? AppColors.error.withValues(alpha: 0.1)
                  : isSelected
                      ? AppColors.primary.withValues(alpha: 0.05)
                      : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCorrect
                  ? AppColors.success
                  : isWrong
                      ? AppColors.error
                      : isSelected
                          ? AppColors.primary
                          : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class ExamTimerWidget extends StatelessWidget {
  final Duration remainingTime;
  final bool isWarning;

  const ExamTimerWidget({
    super.key,
    required this.remainingTime,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;
    final seconds = remainingTime.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isWarning ? AppColors.error : AppColors.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: isWarning ? AppColors.error : AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            hours > 0
                ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
                : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isWarning ? AppColors.error : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyExamsState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyExamsState({
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
              Icons.assignment_outlined,
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
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
