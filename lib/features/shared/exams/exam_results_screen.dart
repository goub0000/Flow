import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/exam_widgets.dart';

/// Exam Results Screen
///
/// Comprehensive exam results display:
/// - Overall score and grade
/// - Question-by-question review
/// - Performance analytics
/// - Topic-wise breakdown
/// - Comparison with class average
/// - Download certificate
///
/// Backend Integration TODO:
/// - Fetch results from backend
/// - Load answer explanations
/// - Get class statistics
/// - Generate and download certificate
/// - Share results

class ExamResultsScreen extends ConsumerStatefulWidget {
  final ExamModel exam;

  const ExamResultsScreen({
    super.key,
    required this.exam,
  });

  @override
  ConsumerState<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends ConsumerState<ExamResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ExamResultModel _result;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockResult();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockResult() {
    final questions = [
      const QuestionModel(
        id: '1',
        type: QuestionType.multipleChoice,
        question: 'What is the primary programming language used for Flutter development?',
        marks: 2,
        difficulty: DifficultyLevel.easy,
        options: ['Java', 'Kotlin', 'Dart', 'Swift'],
        correctAnswer: 'Dart',
        userAnswer: 'Dart',
        isCorrect: true,
        explanation: 'Dart is the primary programming language for Flutter, developed by Google.',
      ),
      const QuestionModel(
        id: '2',
        type: QuestionType.multipleChoice,
        question: 'Which widget is used to create a scrollable list in Flutter?',
        marks: 2,
        difficulty: DifficultyLevel.easy,
        options: ['Container', 'ListView', 'Column', 'Row'],
        correctAnswer: 'ListView',
        userAnswer: 'ListView',
        isCorrect: true,
        explanation: 'ListView is the primary widget for creating scrollable lists in Flutter.',
      ),
      const QuestionModel(
        id: '3',
        type: QuestionType.trueFalse,
        question: 'StatefulWidget can change its properties during runtime.',
        marks: 1,
        difficulty: DifficultyLevel.easy,
        correctAnswer: 'True',
        userAnswer: 'True',
        isCorrect: true,
        explanation: 'StatefulWidget maintains mutable state that can change during the widget\'s lifetime.',
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
        correctAnswer: 'To rebuild the widget with updated state',
        userAnswer: 'To create a new widget',
        isCorrect: false,
        explanation: 'setState() notifies the framework that the internal state has changed and triggers a rebuild.',
      ),
      const QuestionModel(
        id: '5',
        type: QuestionType.trueFalse,
        question: 'Flutter uses a reactive programming model.',
        marks: 1,
        difficulty: DifficultyLevel.medium,
        correctAnswer: 'True',
        userAnswer: 'True',
        isCorrect: true,
        explanation: 'Flutter follows a reactive programming paradigm where UI updates automatically when data changes.',
      ),
      const QuestionModel(
        id: '6',
        type: QuestionType.multipleChoice,
        question: 'Which state management solution is built into Flutter?',
        marks: 2,
        difficulty: DifficultyLevel.medium,
        options: ['Provider', 'Riverpod', 'InheritedWidget', 'Bloc'],
        correctAnswer: 'InheritedWidget',
        userAnswer: 'Provider',
        isCorrect: false,
        explanation: 'InheritedWidget is Flutter\'s built-in solution for propagating state down the widget tree.',
      ),
      const QuestionModel(
        id: '7',
        type: QuestionType.shortAnswer,
        question: 'What does the BuildContext parameter represent in Flutter widgets?',
        marks: 3,
        difficulty: DifficultyLevel.medium,
        correctAnswer: 'Handle to the location of a widget in the widget tree',
        userAnswer: 'The location in widget tree',
        isCorrect: true,
        explanation: 'BuildContext is a handle to the location of a widget in the widget tree.',
      ),
      const QuestionModel(
        id: '8',
        type: QuestionType.multipleChoice,
        question: 'Which method is called when a StatefulWidget is first created?',
        marks: 2,
        difficulty: DifficultyLevel.hard,
        options: ['build()', 'initState()', 'dispose()', 'createState()'],
        correctAnswer: 'createState()',
        userAnswer: 'initState()',
        isCorrect: false,
        explanation: 'createState() is called first to create the State object, then initState() is called on that State.',
      ),
      const QuestionModel(
        id: '9',
        type: QuestionType.trueFalse,
        question: 'Keys are required for all widgets in Flutter.',
        marks: 1,
        difficulty: DifficultyLevel.hard,
        correctAnswer: 'False',
        userAnswer: 'False',
        isCorrect: true,
        explanation: 'Keys are optional and only needed when you need to preserve state or identify widgets uniquely.',
      ),
      const QuestionModel(
        id: '10',
        type: QuestionType.essay,
        question: 'Explain the difference between StatelessWidget and StatefulWidget with examples.',
        marks: 5,
        difficulty: DifficultyLevel.hard,
        correctAnswer: 'StatelessWidget is immutable, StatefulWidget maintains mutable state',
        userAnswer: 'StatelessWidget does not change, StatefulWidget can change',
        isCorrect: true,
        explanation: 'StatelessWidget represents immutable widgets, while StatefulWidget can maintain state that changes over time.',
      ),
    ];

    final correctAnswers = questions.where((q) => q.isCorrect == true).length;
    final score = questions
        .where((q) => q.isCorrect == true)
        .fold<int>(0, (sum, q) => sum + q.marks);

    _result = ExamResultModel(
      examId: widget.exam.id,
      totalQuestions: questions.length,
      answeredQuestions: questions.length,
      correctAnswers: correctAnswers,
      score: score,
      totalMarks: widget.exam.totalMarks,
      timeTaken: const Duration(minutes: 25, seconds: 30),
      questionTypeBreakdown: {
        QuestionType.multipleChoice: 6,
        QuestionType.trueFalse: 3,
        QuestionType.shortAnswer: 1,
        QuestionType.essay: 1,
      },
      questions: questions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('Exam Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResults,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadCertificate,
            tooltip: 'Download Certificate',
          ),
        ],
      ),
      body: Column(
        children: [
          // Results Header
          _buildResultsHeader(),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Review'),
              Tab(text: 'Analytics'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildReviewTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
        child: FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to Exams'),
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _result.gradeColor,
            _result.gradeColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.exam.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.exam.courseName,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    _result.grade,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Grade',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.white30,
              ),
              Column(
                children: [
                  Text(
                    '${_result.score}/${_result.totalMarks}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.white30,
              ),
              Column(
                children: [
                  Text(
                    '${_result.percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Percentage',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(
                    'Questions Answered',
                    '${_result.answeredQuestions}/${_result.totalQuestions}',
                    Icons.help_outline,
                  ),
                  _buildStatRow(
                    'Correct Answers',
                    '${_result.correctAnswers}',
                    Icons.check_circle,
                    color: AppColors.success,
                  ),
                  _buildStatRow(
                    'Wrong Answers',
                    '${_result.totalQuestions - _result.correctAnswers}',
                    Icons.cancel,
                    color: AppColors.error,
                  ),
                  _buildStatRow(
                    'Accuracy',
                    '${_result.accuracy.toStringAsFixed(1)}%',
                    Icons.precision_manufacturing,
                  ),
                  _buildStatRow(
                    'Time Taken',
                    _formatDuration(_result.timeTaken),
                    Icons.timer,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Performance by difficulty
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance by Difficulty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDifficultyBreakdown(DifficultyLevel.easy),
                  const SizedBox(height: 12),
                  _buildDifficultyBreakdown(DifficultyLevel.medium),
                  const SizedBox(height: 12),
                  _buildDifficultyBreakdown(DifficultyLevel.hard),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question types
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Questions by Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._result.questionTypeBreakdown.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_getQuestionTypeLabel(entry.key)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${entry.value}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
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
      itemCount: _result.questions.length,
      itemBuilder: (context, index) {
        final question = _result.questions[index];
        return QuestionWidget(
          question: question,
          questionNumber: index + 1,
          selectedAnswer: question.userAnswer,
          showResults: true,
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Score Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildScoreBar('Your Score', _result.percentage, _result.gradeColor),
                  const SizedBox(height: 8),
                  _buildScoreBar('Class Average', 72.5, Colors.blue),
                  const SizedBox(height: 8),
                  _buildScoreBar('Top Score', 95.0, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Strengths and Weaknesses
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Strengths & Weaknesses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTopicPerformance('Widgets', 90),
                  const SizedBox(height: 8),
                  _buildTopicPerformance('State Management', 60),
                  const SizedBox(height: 8),
                  _buildTopicPerformance('Navigation', 80),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommendations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendation(
                    Icons.book,
                    'Review State Management',
                    'You scored 60% on state management questions. Consider reviewing this topic.',
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendation(
                    Icons.play_circle,
                    'Watch Video Tutorials',
                    'Check out the video lessons on advanced Flutter concepts.',
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendation(
                    Icons.quiz,
                    'Practice More',
                    'Take more practice quizzes to improve your understanding.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBreakdown(DifficultyLevel difficulty) {
    final questions = _result.questions.where((q) => q.difficulty == difficulty).toList();
    final correct = questions.where((q) => q.isCorrect == true).length;
    final total = questions.length;
    final percentage = total > 0 ? (correct / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDifficultyColor(difficulty).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getDifficultyLabel(difficulty),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getDifficultyColor(difficulty),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '$correct/$total correct (${percentage.toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: total > 0 ? correct / total : 0,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getDifficultyColor(difficulty)),
        ),
      ],
    );
  }

  Widget _buildScoreBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildTopicPerformance(String topic, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              topic,
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: percentage >= 70 ? AppColors.success : AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage >= 70 ? AppColors.success : AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendation(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getQuestionTypeLabel(QuestionType type) {
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

  String _getDifficultyLabel(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Colors.green;
      case DifficultyLevel.medium:
        return Colors.orange;
      case DifficultyLevel.hard:
        return AppColors.error;
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  void _shareResults() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
      ),
    );
  }

  void _downloadCertificate() {
    // TODO: Implement certificate download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Certificate download coming soon'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
