/// Quiz and Assignment Models
/// Models for quiz content, questions, assignments, and submissions
/// Matches backend schemas

import 'package:flutter/material.dart';

// =============================================================================
// QUIZ CONTENT MODEL
// =============================================================================

/// Quiz Content Model
class QuizContent {
  final String id;
  final String lessonId;
  final String? title;
  final String? instructions;
  final double passingScore;
  final int? maxAttempts;
  final int? timeLimitMinutes;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final bool showCorrectAnswers;
  final bool showFeedback;
  final int totalPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final List<QuizQuestion>? questions;

  QuizContent({
    required this.id,
    required this.lessonId,
    this.title,
    this.instructions,
    this.passingScore = 70.0,
    this.maxAttempts,
    this.timeLimitMinutes,
    this.shuffleQuestions = false,
    this.shuffleOptions = false,
    this.showCorrectAnswers = true,
    this.showFeedback = true,
    this.totalPoints = 0,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
  });

  factory QuizContent.fromJson(Map<String, dynamic> json) {
    return QuizContent(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      title: json['title'] as String?,
      instructions: json['instructions'] as String?,
      passingScore: (json['passing_score'] as num?)?.toDouble() ?? 70.0,
      maxAttempts: json['max_attempts'] as int?,
      timeLimitMinutes: json['time_limit_minutes'] as int?,
      shuffleQuestions: json['shuffle_questions'] as bool? ?? false,
      shuffleOptions: json['shuffle_options'] as bool? ?? false,
      showCorrectAnswers: json['show_correct_answers'] as bool? ?? true,
      showFeedback: json['show_feedback'] as bool? ?? true,
      totalPoints: json['total_points'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'instructions': instructions,
      'passing_score': passingScore,
      'max_attempts': maxAttempts,
      'time_limit_minutes': timeLimitMinutes,
      'shuffle_questions': shuffleQuestions,
      'shuffle_options': shuffleOptions,
      'show_correct_answers': showCorrectAnswers,
      'show_feedback': showFeedback,
      'total_points': totalPoints,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get attemptLimitText {
    if (maxAttempts == null) return 'Unlimited attempts';
    return '$maxAttempts attempt${maxAttempts! > 1 ? 's' : ''} allowed';
  }

  String get timeLimitText {
    if (timeLimitMinutes == null) return 'No time limit';
    return '$timeLimitMinutes minutes';
  }
}

/// Quiz Content Request
class QuizContentRequest {
  final String? title;
  final String? instructions;
  final double? passingScore;
  final int? maxAttempts;
  final int? timeLimitMinutes;
  final bool? shuffleQuestions;
  final bool? shuffleOptions;
  final bool? showCorrectAnswers;
  final bool? showFeedback;
  final List<QuizQuestionRequest>? questions;

  QuizContentRequest({
    this.title,
    this.instructions,
    this.passingScore,
    this.maxAttempts,
    this.timeLimitMinutes,
    this.shuffleQuestions,
    this.shuffleOptions,
    this.showCorrectAnswers,
    this.showFeedback,
    this.questions,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (title != null) json['title'] = title;
    if (instructions != null) json['instructions'] = instructions;
    if (passingScore != null) json['passing_score'] = passingScore;
    if (maxAttempts != null) json['max_attempts'] = maxAttempts;
    if (timeLimitMinutes != null) json['time_limit_minutes'] = timeLimitMinutes;
    if (shuffleQuestions != null) json['shuffle_questions'] = shuffleQuestions;
    if (shuffleOptions != null) json['shuffle_options'] = shuffleOptions;
    if (showCorrectAnswers != null) {
      json['show_correct_answers'] = showCorrectAnswers;
    }
    if (showFeedback != null) json['show_feedback'] = showFeedback;
    if (questions != null) {
      json['questions'] = questions!.map((q) => q.toJson()).toList();
    }

    return json;
  }
}

// =============================================================================
// QUIZ QUESTION MODEL
// =============================================================================

/// Question Type Enumeration
enum QuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay;

  String get value {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'multiple_choice';
      case QuestionType.trueFalse:
        return 'true_false';
      case QuestionType.shortAnswer:
        return 'short_answer';
      case QuestionType.essay:
        return 'essay';
    }
  }

  String get displayName {
    switch (this) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.shortAnswer:
        return 'Short Answer';
      case QuestionType.essay:
        return 'Essay';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionType.multipleChoice:
        return Icons.radio_button_checked;
      case QuestionType.trueFalse:
        return Icons.check_box_outlined;
      case QuestionType.shortAnswer:
        return Icons.short_text;
      case QuestionType.essay:
        return Icons.notes;
    }
  }

  static QuestionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'true_false':
        return QuestionType.trueFalse;
      case 'short_answer':
        return QuestionType.shortAnswer;
      case 'essay':
        return QuestionType.essay;
      default:
        return QuestionType.multipleChoice;
    }
  }
}

/// Quiz Question Model
class QuizQuestion {
  final String id;
  final String quizId;
  final String questionText;
  final QuestionType questionType;
  final int orderIndex;
  final int points;
  final String? correctAnswer;
  final String? sampleAnswer;
  final String? explanation;
  final String? hint;
  final bool isRequired;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI
  final List<QuestionOption>? options;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.questionType,
    required this.orderIndex,
    this.points = 1,
    this.correctAnswer,
    this.sampleAnswer,
    this.explanation,
    this.hint,
    this.isRequired = true,
    required this.createdAt,
    required this.updatedAt,
    this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      questionText: json['question_text'] as String,
      questionType: QuestionType.fromString(json['question_type'] as String),
      orderIndex: json['order_index'] as int,
      points: json['points'] as int? ?? 1,
      correctAnswer: json['correct_answer'] as String?,
      sampleAnswer: json['sample_answer'] as String?,
      explanation: json['explanation'] as String?,
      hint: json['hint'] as String?,
      isRequired: json['is_required'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question_text': questionText,
      'question_type': questionType.value,
      'order_index': orderIndex,
      'points': points,
      'correct_answer': correctAnswer,
      'sample_answer': sampleAnswer,
      'explanation': explanation,
      'hint': hint,
      'is_required': isRequired,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Quiz Question Request
class QuizQuestionRequest {
  final String questionText;
  final QuestionType questionType;
  final int? orderIndex;
  final int? points;
  final String? correctAnswer;
  final String? sampleAnswer;
  final String? explanation;
  final String? hint;
  final bool? isRequired;
  final List<QuestionOptionRequest>? options;

  QuizQuestionRequest({
    required this.questionText,
    required this.questionType,
    this.orderIndex,
    this.points,
    this.correctAnswer,
    this.sampleAnswer,
    this.explanation,
    this.hint,
    this.isRequired,
    this.options,
  });

  QuizQuestionRequest copyWith({
    String? questionText,
    QuestionType? questionType,
    int? orderIndex,
    int? points,
    String? correctAnswer,
    String? sampleAnswer,
    String? explanation,
    String? hint,
    bool? isRequired,
    List<QuestionOptionRequest>? options,
  }) {
    return QuizQuestionRequest(
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      orderIndex: orderIndex ?? this.orderIndex,
      points: points ?? this.points,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      sampleAnswer: sampleAnswer ?? this.sampleAnswer,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      isRequired: isRequired ?? this.isRequired,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'question_text': questionText,
      'question_type': questionType.value,
    };

    if (orderIndex != null) json['order_index'] = orderIndex;
    if (points != null) json['points'] = points;
    if (correctAnswer != null) json['correct_answer'] = correctAnswer;
    if (sampleAnswer != null) json['sample_answer'] = sampleAnswer;
    if (explanation != null) json['explanation'] = explanation;
    if (hint != null) json['hint'] = hint;
    if (isRequired != null) json['is_required'] = isRequired;

    return json;
  }
}

// =============================================================================
// QUESTION OPTION MODEL
// =============================================================================

/// Question Option Model
class QuestionOption {
  final String id;
  final String questionId;
  final String optionText;
  final int orderIndex;
  final bool isCorrect;
  final String? feedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuestionOption({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.orderIndex,
    this.isCorrect = false,
    this.feedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      questionId: json['question_id'] as String,
      optionText: json['option_text'] as String,
      orderIndex: json['order_index'] as int,
      isCorrect: json['is_correct'] as bool? ?? false,
      feedback: json['feedback'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'option_text': optionText,
      'order_index': orderIndex,
      'is_correct': isCorrect,
      'feedback': feedback,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Question Option Request
class QuestionOptionRequest {
  final String optionText;
  final int? orderIndex;
  final bool? isCorrect;
  final String? feedback;

  QuestionOptionRequest({
    required this.optionText,
    this.orderIndex,
    this.isCorrect,
    this.feedback,
  });

  QuestionOptionRequest copyWith({
    String? optionText,
    int? orderIndex,
    bool? isCorrect,
    String? feedback,
  }) {
    return QuestionOptionRequest(
      optionText: optionText ?? this.optionText,
      orderIndex: orderIndex ?? this.orderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      feedback: feedback ?? this.feedback,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'option_text': optionText,
    };

    if (orderIndex != null) json['order_index'] = orderIndex;
    if (isCorrect != null) json['is_correct'] = isCorrect;
    if (feedback != null) json['feedback'] = feedback;

    return json;
  }
}

// =============================================================================
// QUIZ ATTEMPT MODEL
// =============================================================================

/// Quiz Attempt Status Enumeration
enum QuizAttemptStatus {
  inProgress,
  submitted,
  graded;

  String get value {
    switch (this) {
      case QuizAttemptStatus.inProgress:
        return 'in_progress';
      case QuizAttemptStatus.submitted:
        return 'submitted';
      case QuizAttemptStatus.graded:
        return 'graded';
    }
  }

  String get displayName {
    switch (this) {
      case QuizAttemptStatus.inProgress:
        return 'In Progress';
      case QuizAttemptStatus.submitted:
        return 'Submitted';
      case QuizAttemptStatus.graded:
        return 'Graded';
    }
  }

  static QuizAttemptStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'in_progress':
        return QuizAttemptStatus.inProgress;
      case 'submitted':
        return QuizAttemptStatus.submitted;
      case 'graded':
        return QuizAttemptStatus.graded;
      default:
        return QuizAttemptStatus.inProgress;
    }
  }
}

/// Quiz Attempt Model
class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final int attemptNumber;
  final QuizAttemptStatus status;
  final double score;
  final int pointsEarned;
  final int pointsPossible;
  final bool passed;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final int? timeTakenMinutes;
  final List<Map<String, dynamic>> answers;
  final String? instructorFeedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    this.attemptNumber = 1,
    this.status = QuizAttemptStatus.inProgress,
    this.score = 0.0,
    this.pointsEarned = 0,
    this.pointsPossible = 0,
    this.passed = false,
    required this.startedAt,
    this.submittedAt,
    this.timeTakenMinutes,
    this.answers = const [],
    this.instructorFeedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      userId: json['user_id'] as String,
      attemptNumber: json['attempt_number'] as int? ?? 1,
      status: QuizAttemptStatus.fromString(json['status'] as String),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      pointsEarned: json['points_earned'] as int? ?? 0,
      pointsPossible: json['points_possible'] as int? ?? 0,
      passed: json['passed'] as bool? ?? false,
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      timeTakenMinutes: json['time_taken_minutes'] as int?,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      instructorFeedback: json['instructor_feedback'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  String get scoreDisplay => '${score.toStringAsFixed(1)}%';
  String get pointsDisplay => '$pointsEarned / $pointsPossible';
}

// =============================================================================
// ASSIGNMENT CONTENT MODEL
// =============================================================================

/// Submission Type Enumeration
enum SubmissionType {
  text,
  file,
  url,
  both;

  String get value => name;
  String get displayName {
    switch (this) {
      case SubmissionType.text:
        return 'Text';
      case SubmissionType.file:
        return 'File Upload';
      case SubmissionType.url:
        return 'URL';
      case SubmissionType.both:
        return 'Text & File';
    }
  }

  static SubmissionType fromString(String value) {
    return SubmissionType.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => SubmissionType.both,
    );
  }
}

/// Assignment Content Model
class AssignmentContent {
  final String id;
  final String lessonId;
  final String title;
  final String instructions;
  final SubmissionType submissionType;
  final List<String> allowedFileTypes;
  final int maxFileSizeMb;
  final int pointsPossible;
  final List<Map<String, dynamic>> rubric;
  final DateTime? dueDate;
  final bool allowLateSubmission;
  final double latePenaltyPercent;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignmentContent({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.instructions,
    this.submissionType = SubmissionType.both,
    this.allowedFileTypes = const [],
    this.maxFileSizeMb = 10,
    this.pointsPossible = 100,
    this.rubric = const [],
    this.dueDate,
    this.allowLateSubmission = true,
    this.latePenaltyPercent = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignmentContent.fromJson(Map<String, dynamic> json) {
    return AssignmentContent(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      title: json['title'] as String,
      instructions: json['instructions'] as String,
      submissionType:
          SubmissionType.fromString(json['submission_type'] as String),
      allowedFileTypes: (json['allowed_file_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      maxFileSizeMb: json['max_file_size_mb'] as int? ?? 10,
      pointsPossible: json['points_possible'] as int? ?? 100,
      rubric: (json['rubric'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      allowLateSubmission: json['allow_late_submission'] as bool? ?? true,
      latePenaltyPercent:
          (json['late_penalty_percent'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'title': title,
      'instructions': instructions,
      'submission_type': submissionType.value,
      'allowed_file_types': allowedFileTypes,
      'max_file_size_mb': maxFileSizeMb,
      'points_possible': pointsPossible,
      'rubric': rubric,
      'due_date': dueDate?.toIso8601String(),
      'allow_late_submission': allowLateSubmission,
      'late_penalty_percent': latePenaltyPercent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPastDue => dueDate != null && DateTime.now().isAfter(dueDate!);
}

/// Assignment Content Request
class AssignmentContentRequest {
  final String title;
  final String instructions;
  final SubmissionType? submissionType;
  final List<String>? allowedFileTypes;
  final int? maxFileSizeMb;
  final int? pointsPossible;
  final List<Map<String, dynamic>>? rubric;
  final DateTime? dueDate;
  final bool? allowLateSubmission;
  final double? latePenaltyPercent;

  AssignmentContentRequest({
    required this.title,
    required this.instructions,
    this.submissionType,
    this.allowedFileTypes,
    this.maxFileSizeMb,
    this.pointsPossible,
    this.rubric,
    this.dueDate,
    this.allowLateSubmission,
    this.latePenaltyPercent,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'instructions': instructions,
    };

    if (submissionType != null) {
      json['submission_type'] = submissionType!.value;
    }
    if (allowedFileTypes != null) {
      json['allowed_file_types'] = allowedFileTypes;
    }
    if (maxFileSizeMb != null) json['max_file_size_mb'] = maxFileSizeMb;
    if (pointsPossible != null) json['points_possible'] = pointsPossible;
    if (rubric != null) json['rubric'] = rubric;
    if (dueDate != null) json['due_date'] = dueDate!.toIso8601String();
    if (allowLateSubmission != null) {
      json['allow_late_submission'] = allowLateSubmission;
    }
    if (latePenaltyPercent != null) {
      json['late_penalty_percent'] = latePenaltyPercent;
    }

    return json;
  }
}

// =============================================================================
// ASSIGNMENT SUBMISSION MODEL
// =============================================================================

/// Submission Status Enumeration
enum SubmissionStatus {
  draft,
  submitted,
  grading,
  graded,
  returned;

  String get value => name;
  String get displayName {
    switch (this) {
      case SubmissionStatus.draft:
        return 'Draft';
      case SubmissionStatus.submitted:
        return 'Submitted';
      case SubmissionStatus.grading:
        return 'Being Graded';
      case SubmissionStatus.graded:
        return 'Graded';
      case SubmissionStatus.returned:
        return 'Returned';
    }
  }

  static SubmissionStatus fromString(String value) {
    return SubmissionStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => SubmissionStatus.draft,
    );
  }
}

/// Assignment Submission Model
class AssignmentSubmission {
  final String id;
  final String assignmentId;
  final String userId;
  final SubmissionStatus status;
  final String? textSubmission;
  final List<Map<String, dynamic>> fileUrls;
  final String? externalUrl;
  final double? pointsEarned;
  final int? pointsPossible;
  final double? gradePercentage;
  final String? instructorFeedback;
  final List<Map<String, dynamic>> rubricScores;
  final String? gradedBy;
  final DateTime? gradedAt;
  final DateTime? submittedAt;
  final DateTime? returnedAt;
  final bool isLate;
  final int lateDays;
  final double latePenaltyApplied;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.userId,
    this.status = SubmissionStatus.draft,
    this.textSubmission,
    this.fileUrls = const [],
    this.externalUrl,
    this.pointsEarned,
    this.pointsPossible,
    this.gradePercentage,
    this.instructorFeedback,
    this.rubricScores = const [],
    this.gradedBy,
    this.gradedAt,
    this.submittedAt,
    this.returnedAt,
    this.isLate = false,
    this.lateDays = 0,
    this.latePenaltyApplied = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmission(
      id: json['id'] as String,
      assignmentId: json['assignment_id'] as String,
      userId: json['user_id'] as String,
      status: SubmissionStatus.fromString(json['status'] as String),
      textSubmission: json['text_submission'] as String?,
      fileUrls: (json['file_urls'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      externalUrl: json['external_url'] as String?,
      pointsEarned: (json['points_earned'] as num?)?.toDouble(),
      pointsPossible: json['points_possible'] as int?,
      gradePercentage: (json['grade_percentage'] as num?)?.toDouble(),
      instructorFeedback: json['instructor_feedback'] as String?,
      rubricScores: (json['rubric_scores'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      gradedBy: json['graded_by'] as String?,
      gradedAt: json['graded_at'] != null
          ? DateTime.parse(json['graded_at'] as String)
          : null,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      returnedAt: json['returned_at'] != null
          ? DateTime.parse(json['returned_at'] as String)
          : null,
      isLate: json['is_late'] as bool? ?? false,
      lateDays: json['late_days'] as int? ?? 0,
      latePenaltyApplied:
          (json['late_penalty_applied'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  bool get isGraded =>
      status == SubmissionStatus.graded || status == SubmissionStatus.returned;
  String get gradeDisplay =>
      gradePercentage != null ? '${gradePercentage!.toStringAsFixed(1)}%' : 'Not graded';
  String get pointsDisplay => pointsEarned != null && pointsPossible != null
      ? '$pointsEarned / $pointsPossible'
      : 'Not graded';
}

/// Assignment Submission Request
class AssignmentSubmissionRequest {
  final String userId;
  final String? textSubmission;
  final List<Map<String, dynamic>>? fileUrls;
  final String? externalUrl;
  final SubmissionStatus? status;

  AssignmentSubmissionRequest({
    required this.userId,
    this.textSubmission,
    this.fileUrls,
    this.externalUrl,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'user_id': userId,
    };

    if (textSubmission != null) json['text_submission'] = textSubmission;
    if (fileUrls != null) json['file_urls'] = fileUrls;
    if (externalUrl != null) json['external_url'] = externalUrl;
    if (status != null) json['status'] = status!.value;

    return json;
  }
}
