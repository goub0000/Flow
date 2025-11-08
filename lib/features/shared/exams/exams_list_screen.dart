import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/exam_widgets.dart';

/// Exams List Screen
///
/// Main interface for exam management:
/// - Browse all exams by status
/// - Upcoming exams tab
/// - Completed exams with scores
/// - Missed exams
/// - Search and filters
/// - Quick statistics
///
/// Backend Integration TODO:
/// - Fetch exams from backend
/// - Real-time exam updates
/// - Push notifications for upcoming exams
/// - Sync exam results

class ExamsListScreen extends ConsumerStatefulWidget {
  const ExamsListScreen({super.key});

  @override
  ConsumerState<ExamsListScreen> createState() => _ExamsListScreenState();
}

class _ExamsListScreenState extends ConsumerState<ExamsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ExamType? _selectedType;
  late List<ExamModel> _allExams;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateMockExams();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockExams() {
    final now = DateTime.now();

    _allExams = [
      ExamModel(
        id: '1',
        title: 'Flutter Basics Quiz',
        type: ExamType.quiz,
        courseId: '1',
        courseName: 'Mobile App Development',
        scheduledDate: now.add(const Duration(hours: 3)),
        duration: const Duration(minutes: 30),
        totalQuestions: 15,
        totalMarks: 20,
        status: ExamStatus.upcoming,
        topics: ['Widgets', 'State Management', 'Navigation'],
        instructions: 'Read each question carefully. You have one attempt.',
        attemptsAllowed: 1,
        attemptsUsed: 0,
      ),
      ExamModel(
        id: '2',
        title: 'Data Structures Midterm',
        type: ExamType.midterm,
        courseId: '2',
        courseName: 'Data Structures & Algorithms',
        scheduledDate: now.add(const Duration(days: 2)),
        duration: const Duration(hours: 2),
        totalQuestions: 30,
        totalMarks: 100,
        isProctored: true,
        status: ExamStatus.upcoming,
        topics: ['Arrays', 'Linked Lists', 'Trees', 'Graphs'],
        instructions:
            'This is a proctored exam. Ensure your webcam is working.',
        attemptsAllowed: 1,
        attemptsUsed: 0,
      ),
      ExamModel(
        id: '3',
        title: 'Web Dev Practice Test',
        type: ExamType.practice,
        courseId: '3',
        courseName: 'Web Technologies',
        scheduledDate: now.subtract(const Duration(days: 1)),
        duration: const Duration(minutes: 45),
        totalQuestions: 20,
        totalMarks: 30,
        status: ExamStatus.completed,
        topics: ['HTML', 'CSS', 'JavaScript'],
        score: 24,
        startedAt: now.subtract(const Duration(days: 1, hours: 1)),
        completedAt: now.subtract(const Duration(days: 1)),
      ),
      ExamModel(
        id: '4',
        title: 'AI Fundamentals Final',
        type: ExamType.final_,
        courseId: '4',
        courseName: 'Artificial Intelligence',
        scheduledDate: now.add(const Duration(days: 7)),
        duration: const Duration(hours: 3),
        totalQuestions: 50,
        totalMarks: 150,
        isProctored: true,
        status: ExamStatus.upcoming,
        topics: [
          'Machine Learning',
          'Neural Networks',
          'Search Algorithms',
          'Knowledge Representation'
        ],
        instructions:
            'Final comprehensive exam. Covers all course material. Calculator allowed.',
        attemptsAllowed: 1,
        attemptsUsed: 0,
      ),
      ExamModel(
        id: '5',
        title: 'Database Systems Quiz',
        type: ExamType.quiz,
        courseId: '5',
        courseName: 'Database Management',
        scheduledDate: now.subtract(const Duration(days: 3)),
        duration: const Duration(minutes: 20),
        totalQuestions: 10,
        totalMarks: 15,
        status: ExamStatus.completed,
        topics: ['SQL', 'Normalization'],
        score: 13,
        startedAt: now.subtract(const Duration(days: 3, minutes: 25)),
        completedAt: now.subtract(const Duration(days: 3, minutes: 5)),
      ),
      ExamModel(
        id: '6',
        title: 'Programming Assignment',
        type: ExamType.assignment,
        courseId: '1',
        courseName: 'Mobile App Development',
        scheduledDate: now.subtract(const Duration(days: 7)),
        duration: const Duration(hours: 4),
        totalQuestions: 5,
        totalMarks: 50,
        status: ExamStatus.missed,
        topics: ['Flutter Project', 'State Management'],
        attemptsAllowed: 2,
        attemptsUsed: 0,
      ),
      ExamModel(
        id: '7',
        title: 'Algorithms Practice',
        type: ExamType.practice,
        courseId: '2',
        courseName: 'Data Structures & Algorithms',
        scheduledDate: now.add(const Duration(hours: 1)),
        duration: const Duration(minutes: 60),
        totalQuestions: 25,
        totalMarks: 40,
        status: ExamStatus.upcoming,
        topics: ['Sorting', 'Searching', 'Dynamic Programming'],
        instructions: 'Unlimited attempts available.',
      ),
      ExamModel(
        id: '8',
        title: 'Object-Oriented Programming Quiz',
        type: ExamType.quiz,
        courseId: '6',
        courseName: 'Advanced Programming',
        scheduledDate: now.subtract(const Duration(days: 5)),
        duration: const Duration(minutes: 30),
        totalQuestions: 15,
        totalMarks: 25,
        status: ExamStatus.completed,
        topics: ['Inheritance', 'Polymorphism', 'Encapsulation'],
        score: 22,
        startedAt: now.subtract(const Duration(days: 5, minutes: 35)),
        completedAt: now.subtract(const Duration(days: 5, minutes: 5)),
      ),
    ];
  }

  List<ExamModel> get _upcomingExams {
    return _filteredExams
        .where((exam) => exam.status == ExamStatus.upcoming)
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  List<ExamModel> get _completedExams {
    return _filteredExams
        .where((exam) => exam.status == ExamStatus.completed)
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  List<ExamModel> get _missedExams {
    return _filteredExams
        .where((exam) => exam.status == ExamStatus.missed)
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  List<ExamModel> get _filteredExams {
    return _allExams.where((exam) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!exam.title.toLowerCase().contains(query) &&
            !exam.courseName.toLowerCase().contains(query) &&
            !exam.topics.any((topic) => topic.toLowerCase().contains(query))) {
          return false;
        }
      }

      // Type filter
      if (_selectedType != null && exam.type != _selectedType) {
        return false;
      }

      return true;
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
        title: const Text('Exams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filter',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${_filteredExams.length})'),
            Tab(text: 'Upcoming (${_upcomingExams.length})'),
            Tab(text: 'Completed (${_completedExams.length})'),
            Tab(text: 'Missed (${_missedExams.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Dashboard
          _buildStatsDashboard(),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exams...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Active filters
          if (_selectedType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(_selectedType!.name),
                    onDeleted: () {
                      setState(() {
                        _selectedType = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Exams List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExamsList(_filteredExams),
                _buildExamsList(_upcomingExams),
                _buildExamsList(_completedExams),
                _buildExamsList(_missedExams),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsDashboard() {
    final totalExams = _allExams.length;
    final upcomingCount = _allExams.where((e) => e.status == ExamStatus.upcoming).length;
    final completedCount = _allExams.where((e) => e.status == ExamStatus.completed).length;
    final avgScore = _allExams
        .where((e) => e.score != null && e.scorePercentage != null)
        .map((e) => e.scorePercentage!)
        .fold<double>(0, (sum, score) => sum + score) /
        (completedCount > 0 ? completedCount : 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              totalExams.toString(),
              Icons.assignment,
              AppColors.primary,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Upcoming',
              upcomingCount.toString(),
              Icons.upcoming,
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Completed',
              completedCount.toString(),
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Avg Score',
              completedCount > 0 ? '${avgScore.toStringAsFixed(0)}%' : '-',
              Icons.grade,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildExamsList(List<ExamModel> exams) {
    if (exams.isEmpty) {
      return EmptyExamsState(
        message: _searchQuery.isNotEmpty || _selectedType != null
            ? 'No exams found'
            : 'No exams available',
        subtitle: _searchQuery.isNotEmpty || _selectedType != null
            ? 'Try adjusting your filters'
            : 'Check back later for upcoming exams',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh exams from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return ExamCard(
            exam: exam,
            onTap: () => _openExam(exam),
            onStart: exam.status == ExamStatus.upcoming
                ? () => _startExam(exam)
                : null,
          );
        },
      ),
    );
  }

  void _openExam(ExamModel exam) {
    if (exam.status == ExamStatus.completed) {
      Navigator.pushNamed(
        context,
        '/exams/results',
        arguments: exam,
      );
    } else if (exam.status == ExamStatus.upcoming) {
      Navigator.pushNamed(
        context,
        '/exams/details',
        arguments: exam,
      );
    }
  }

  void _startExam(ExamModel exam) {
    if (!exam.canAttempt) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have used all available attempts'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Exam?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to start "${exam.title}"'),
            const SizedBox(height: 16),
            Text('Duration: ${exam.formattedDuration}'),
            Text('Questions: ${exam.totalQuestions}'),
            Text('Total Marks: ${exam.totalMarks}'),
            if (exam.attemptsAllowed != null)
              Text('Attempts: ${exam.attemptsText}'),
            if (exam.isProctored) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.videocam, color: AppColors.error, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This exam is proctored. Your webcam will be used.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/exams/take',
                arguments: exam,
              );
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Exams',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Exam Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedType == null,
                      onSelected: (selected) {
                        setSheetState(() {
                          _selectedType = null;
                        });
                        setState(() {
                          _selectedType = null;
                        });
                      },
                    ),
                    ...ExamType.values.map((type) {
                      final typeLabel = type == ExamType.final_
                          ? 'Final Exam'
                          : type.name[0].toUpperCase() + type.name.substring(1);
                      return FilterChip(
                        label: Text(typeLabel),
                        selected: _selectedType == type,
                        onSelected: (selected) {
                          setSheetState(() {
                            _selectedType = selected ? type : null;
                          });
                          setState(() {
                            _selectedType = selected ? type : null;
                          });
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedType = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Clear All'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
