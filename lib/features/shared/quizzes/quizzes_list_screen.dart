import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/quiz_widgets.dart';

/// Quizzes List Screen
///
/// Displays available quizzes for a course or lesson.
/// Features:
/// - Filter by difficulty
/// - Sort by various criteria
/// - Show attempt history
/// - Quick start quiz
///
/// Backend Integration TODO:
/// - Fetch quizzes from backend
/// - Load attempt history
/// - Check quiz availability/prerequisites
/// - Handle quiz locking/unlocking

class QuizzesListScreen extends StatefulWidget {
  final String? courseId;
  final String? lessonId;

  const QuizzesListScreen({
    super.key,
    this.courseId,
    this.lessonId,
  });

  @override
  State<QuizzesListScreen> createState() => _QuizzesListScreenState();
}

class _QuizzesListScreenState extends State<QuizzesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  QuizDifficulty? _selectedDifficulty;
  late List<QuizModel> _quizzes;
  final Map<String, List<QuizAttempt>> _attempts = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    _quizzes = [
      QuizModel(
        id: '1',
        title: 'Flutter Basics Quiz',
        description: 'Test your understanding of Flutter fundamentals',
        questions: _generateSampleQuestions(10),
        duration: 15,
        passingScore: 70,
        difficulty: QuizDifficulty.easy,
        courseId: widget.courseId,
        maxAttempts: 3,
      ),
      QuizModel(
        id: '2',
        title: 'State Management Assessment',
        description: 'Deep dive into Flutter state management patterns',
        questions: _generateSampleQuestions(15),
        duration: 25,
        passingScore: 75,
        difficulty: QuizDifficulty.medium,
        courseId: widget.courseId,
        maxAttempts: 2,
      ),
      QuizModel(
        id: '3',
        title: 'Advanced Flutter Challenge',
        description: 'Master-level questions on advanced Flutter concepts',
        questions: _generateSampleQuestions(20),
        duration: 45,
        passingScore: 80,
        difficulty: QuizDifficulty.hard,
        courseId: widget.courseId,
        maxAttempts: 1,
      ),
      QuizModel(
        id: '4',
        title: 'Dart Programming Quiz',
        description: 'Test your Dart language knowledge',
        questions: _generateSampleQuestions(12),
        duration: 20,
        passingScore: 70,
        difficulty: QuizDifficulty.easy,
        courseId: widget.courseId,
        maxAttempts: 3,
      ),
      QuizModel(
        id: '5',
        title: 'UI/UX Design Principles',
        description: 'Assess your understanding of design principles in Flutter',
        questions: _generateSampleQuestions(15),
        duration: 30,
        passingScore: 75,
        difficulty: QuizDifficulty.medium,
        courseId: widget.courseId,
        maxAttempts: 2,
      ),
    ];

    // Mock attempt history
    _attempts['1'] = [
      QuizAttempt(
        id: 'a1',
        quizId: '1',
        score: 8,
        totalPoints: 10,
        completedAt: DateTime.now().subtract(const Duration(days: 2)),
        timeTaken: const Duration(minutes: 12),
        passed: true,
      ),
    ];

    _attempts['2'] = [
      QuizAttempt(
        id: 'a2',
        quizId: '2',
        score: 10,
        totalPoints: 15,
        completedAt: DateTime.now().subtract(const Duration(days: 5)),
        timeTaken: const Duration(minutes: 20),
        passed: false,
      ),
    ];
  }

  List<QuestionModel> _generateSampleQuestions(int count) {
    return List.generate(
      count,
      (index) => QuestionModel(
        id: 'q${index + 1}',
        text: 'Sample question ${index + 1}',
        type: QuestionType.multipleChoice,
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctAnswer: 0,
        points: 1,
      ),
    );
  }

  List<QuizModel> get _filteredQuizzes {
    if (_selectedDifficulty == null) {
      return _quizzes;
    }
    return _quizzes.where((q) => q.difficulty == _selectedDifficulty).toList();
  }

  List<QuizModel> get _availableQuizzes {
    return _filteredQuizzes
        .where((q) => (_attempts[q.id]?.length ?? 0) < q.maxAttempts)
        .toList();
  }

  List<QuizModel> get _completedQuizzes {
    return _filteredQuizzes.where((q) {
      final attempts = _attempts[q.id];
      return attempts != null && attempts.any((a) => a.passed);
    }).toList();
  }

  List<QuizModel> get _inProgressQuizzes {
    return _filteredQuizzes.where((q) {
      final attempts = _attempts[q.id];
      return attempts != null &&
          attempts.isNotEmpty &&
          !attempts.any((a) => a.passed) &&
          attempts.length < q.maxAttempts;
    }).toList();
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
        title: const Text('Quizzes'),
        actions: [
          PopupMenuButton<QuizDifficulty?>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by difficulty',
            onSelected: (difficulty) {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All Difficulties'),
              ),
              ...QuizDifficulty.values.map((difficulty) {
                return PopupMenuItem(
                  value: difficulty,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: difficulty.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(difficulty.displayName),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Available (${_availableQuizzes.length})'),
            Tab(text: 'In Progress (${_inProgressQuizzes.length})'),
            Tab(text: 'Completed (${_completedQuizzes.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuizList(_availableQuizzes),
          _buildQuizList(_inProgressQuizzes),
          _buildQuizList(_completedQuizzes),
        ],
      ),
    );
  }

  Widget _buildQuizList(List<QuizModel> quizzes) {
    if (quizzes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz,
                size: 80,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No Quizzes Available',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedDifficulty != null
                    ? 'Try adjusting your difficulty filter'
                    : 'Check back later for new quizzes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh quizzes from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          final attempts = _attempts[quiz.id];
          final attemptsUsed = attempts?.length ?? 0;
          final bestAttempt = attempts?.isNotEmpty == true
              ? attempts!.reduce(
                  (a, b) => a.score > b.score ? a : b,
                )
              : null;

          return QuizCard(
            quiz: quiz,
            attemptsUsed: attemptsUsed,
            bestAttempt: bestAttempt,
            onTap: () => _handleQuizTap(quiz, attemptsUsed),
          );
        },
      ),
    );
  }

  void _handleQuizTap(QuizModel quiz, int attemptsUsed) {
    if (attemptsUsed >= quiz.maxAttempts) {
      _showMaxAttemptsDialog(quiz);
      return;
    }

    _showQuizDetailsDialog(quiz, attemptsUsed);
  }

  void _showQuizDetailsDialog(QuizModel quiz, int attemptsUsed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(quiz.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (quiz.description != null) ...[
                Text(quiz.description!),
                const SizedBox(height: 16),
              ],
              _buildInfoRow(
                Icons.quiz,
                '${quiz.questions.length} questions',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.timer,
                '${quiz.duration} minutes',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.grade,
                'Passing score: ${quiz.passingScore}%',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.repeat,
                'Attempts: $attemptsUsed/${quiz.maxAttempts}',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Once you start, the timer will begin. Make sure you have enough time!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _startQuiz(quiz);
            },
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _showMaxAttemptsDialog(QuizModel quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maximum Attempts Reached'),
        content: Text(
          'You have used all ${quiz.maxAttempts} attempts for this quiz. '
          'Please contact your instructor if you need additional attempts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (_attempts[quiz.id]?.isNotEmpty == true)
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to quiz results
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('View previous attempts'),
                  ),
                );
              },
              child: const Text('View Results'),
            ),
        ],
      ),
    );
  }

  void _startQuiz(QuizModel quiz) {
    // TODO: Navigate to quiz taking screen
    Navigator.pushNamed(
      context,
      '/quiz/take',
      arguments: quiz,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${quiz.title}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
