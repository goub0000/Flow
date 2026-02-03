import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/task_widgets.dart';
import '../../authentication/providers/auth_provider.dart';

/// Tasks List Screen
///
/// Main task management interface with:
/// - Multiple view modes (All, Today, Upcoming, Completed)
/// - Priority filtering
/// - Search functionality
/// - Quick stats overview
/// - Task categories
/// - Sorting options
///
/// Backend Integration TODO:
/// - Fetch tasks from backend
/// - Real-time task synchronization
/// - Collaborative task sharing
/// - Cloud backup and restore

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TaskPriority? _filterPriority;
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateMockTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockTasks() {
    final now = DateTime.now();
    _tasks = [
      TaskModel(
        id: '1',
        title: 'Complete Flutter Assignment',
        description: 'Build a todo app with local storage',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        dueDate: DateTime(now.year, now.month, now.day, 23, 59),
        tags: ['assignment', 'flutter'],
        courseId: '1',
        courseName: 'Mobile App Development',
        createdAt: now.subtract(const Duration(days: 3)),
        subtasks: [
          SubtaskModel(id: '1', title: 'Setup project structure', isCompleted: true),
          SubtaskModel(id: '2', title: 'Implement UI', isCompleted: true),
          SubtaskModel(id: '3', title: 'Add local storage', isCompleted: false),
          SubtaskModel(id: '4', title: 'Test and debug', isCompleted: false),
        ],
      ),
      TaskModel(
        id: '2',
        title: 'Study for Midterm Exam',
        description: 'Review chapters 1-5, practice problems',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        dueDate: DateTime(now.year, now.month, now.day + 2),
        tags: ['exam', 'study'],
        courseId: '2',
        courseName: 'Data Structures',
        createdAt: now.subtract(const Duration(days: 5)),
        isFavorite: true,
      ),
      TaskModel(
        id: '3',
        title: 'Read Chapter 7',
        description: 'Advanced React patterns and hooks',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        dueDate: DateTime(now.year, now.month, now.day + 1),
        tags: ['reading'],
        courseId: '3',
        courseName: 'Web Technologies',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TaskModel(
        id: '4',
        title: 'Team Project Meeting',
        description: 'Discuss final presentation slides',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        dueDate: DateTime(now.year, now.month, now.day),
        tags: ['meeting', 'team'],
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      TaskModel(
        id: '5',
        title: 'Submit Research Paper Outline',
        description: 'AI and Machine Learning topic',
        priority: TaskPriority.high,
        status: TaskStatus.completed,
        dueDate: DateTime(now.year, now.month, now.day - 1),
        tags: ['research', 'assignment'],
        courseId: '4',
        courseName: 'Artificial Intelligence',
        createdAt: now.subtract(const Duration(days: 7)),
        completedAt: now.subtract(const Duration(days: 2)),
      ),
      TaskModel(
        id: '6',
        title: 'Practice Coding Problems',
        description: 'LeetCode medium difficulty problems',
        priority: TaskPriority.low,
        status: TaskStatus.todo,
        dueDate: DateTime(now.year, now.month, now.day + 5),
        tags: ['practice', 'coding'],
        createdAt: now.subtract(const Duration(hours: 6)),
        isFavorite: true,
      ),
      TaskModel(
        id: '7',
        title: 'Update Resume',
        description: 'Add recent projects and skills',
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
        tags: ['career', 'personal'],
        createdAt: now.subtract(const Duration(days: 2)),
        subtasks: [
          SubtaskModel(id: '1', title: 'Add new projects', isCompleted: true),
          SubtaskModel(id: '2', title: 'Update skills section', isCompleted: false),
          SubtaskModel(id: '3', title: 'Proofread', isCompleted: false),
        ],
      ),
      TaskModel(
        id: '8',
        title: 'Review Pull Request',
        description: 'Check team member\'s code changes',
        priority: TaskPriority.low,
        status: TaskStatus.completed,
        dueDate: DateTime(now.year, now.month, now.day - 1),
        tags: ['code-review', 'team'],
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  List<TaskModel> get _allTasks {
    return _filteredTasks;
  }

  List<TaskModel> get _todayTasks {
    return _filteredTasks.where((task) {
      return task.isDueToday && !task.isCompleted;
    }).toList();
  }

  List<TaskModel> get _upcomingTasks {
    return _filteredTasks.where((task) {
      return !task.isCompleted &&
          task.dueDate != null &&
          !task.isDueToday &&
          task.dueDate!.isAfter(DateTime.now());
    }).toList();
  }

  List<TaskModel> get _completedTasks {
    return _filteredTasks.where((task) => task.isCompleted).toList();
  }

  List<TaskModel> get _filteredTasks {
    return _tasks.where((task) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDescription =
            task.description?.toLowerCase().contains(query) ?? false;
        final matchesTags =
            task.tags.any((tag) => tag.toLowerCase().contains(query));

        if (!matchesTitle && !matchesDescription && !matchesTags) {
          return false;
        }
      }

      // Priority filter
      if (_filterPriority != null && task.priority != _filterPriority) {
        return false;
      }

      return true;
    }).toList();
  }

  int get _totalTasksCount => _tasks.length;
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _todayCount =>
      _tasks.where((t) => t.isDueToday && !t.isCompleted).length;
  int get _overdueCount => _tasks.where((t) => t.isOverdue).length;

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
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All (${_allTasks.length})'),
            Tab(text: 'Today (${_todayTasks.length})'),
            Tab(text: 'Upcoming (${_upcomingTasks.length})'),
            Tab(text: 'Completed (${_completedTasks.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Overview
          _buildStatsOverview(),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
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

          // Priority Filter
          if (_filterPriority != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  PriorityFilterChip(
                    priority: _filterPriority!,
                    isSelected: true,
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _filterPriority = null;
                      });
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Clear'),
                  ),
                ],
              ),
            ),
          if (_filterPriority != null) const SizedBox(height: 8),

          // Tasks TabView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksList(_allTasks),
                _buildTasksList(_todayTasks),
                _buildTasksList(_upcomingTasks),
                _buildTasksList(_completedTasks),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tasks_fab',
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsOverview() {
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
      child: Row(
        children: [
          Expanded(
            child: TaskCategoryCard(
              title: 'Total',
              count: _totalTasksCount,
              icon: Icons.list,
              color: AppColors.primary,
              onTap: () => _tabController.animateTo(0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TaskCategoryCard(
              title: 'Today',
              count: _todayCount,
              icon: Icons.today,
              color: AppColors.warning,
              onTap: () => _tabController.animateTo(1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TaskCategoryCard(
              title: 'Done',
              count: _completedCount,
              icon: Icons.check_circle,
              color: AppColors.success,
              onTap: () => _tabController.animateTo(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TaskCategoryCard(
              title: 'Overdue',
              count: _overdueCount,
              icon: Icons.warning,
              color: AppColors.error,
              onTap: _showOverdueTasks,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return EmptyTasksState(
        message: _searchQuery.isNotEmpty
            ? 'No tasks found'
            : 'No tasks yet',
        subtitle: _searchQuery.isNotEmpty
            ? 'Try a different search term'
            : 'Tap + to add a task',
        onAddTask: _addTask,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh tasks from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskCard(
            task: task,
            onTap: () => _viewTaskDetails(task),
            onToggle: (value) => _toggleTaskStatus(task),
            onFavorite: () => _toggleFavorite(task),
            onDelete: () => _deleteTask(task),
            showCourse: true,
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort By'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Due Date'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) {
                    if (a.dueDate == null && b.dueDate == null) return 0;
                    if (a.dueDate == null) return 1;
                    if (b.dueDate == null) return -1;
                    return a.dueDate!.compareTo(b.dueDate!);
                  });
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Priority (High to Low)'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) =>
                      b.priority.index.compareTo(a.priority.index));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Created Date (Newest)'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Name (A-Z)'),
              onTap: () {
                setState(() {
                  _tasks.sort((a, b) => a.title.compareTo(b.title));
                });
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.filter_list),
              title: const Text('Filter by Priority'),
              onTap: () {
                Navigator.pop(context);
                _showPriorityFilter();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPriorityFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Filter by Priority'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(height: 1),
            ...TaskPriority.values.map((priority) {
              return ListTile(
                leading: Icon(priority.icon, color: priority.color),
                title: Text(priority.displayName),
                onTap: () {
                  setState(() {
                    _filterPriority = priority;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Clear Filter'),
              onTap: () {
                setState(() {
                  _filterPriority = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOverdueTasks() {
    final overdueTasks = _tasks.where((t) => t.isOverdue).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overdue Tasks'),
        content: overdueTasks.isEmpty
            ? const Text('No overdue tasks')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: overdueTasks.length,
                  itemBuilder: (context, index) {
                    final task = overdueTasks[index];
                    return TaskListItem(
                      task: task,
                      onTap: () {
                        Navigator.pop(context);
                        _viewTaskDetails(task);
                      },
                      onToggle: (value) {
                        setState(() {
                          _toggleTaskStatus(task);
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    Navigator.pushNamed(context, '/tasks/add');
  }

  void _viewTaskDetails(TaskModel task) {
    Navigator.pushNamed(
      context,
      '/tasks/details',
      arguments: task,
    );
  }

  void _toggleTaskStatus(TaskModel task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        final newStatus = task.isCompleted
            ? TaskStatus.todo
            : TaskStatus.completed;
        _tasks[index] = task.copyWith(
          status: newStatus,
          completedAt: newStatus == TaskStatus.completed
              ? DateTime.now()
              : null,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task.isCompleted
              ? 'Task marked as incomplete'
              : 'Task completed!',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleFavorite(TaskModel task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isFavorite: !task.isFavorite);
      }
    });
  }

  void _deleteTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _tasks.removeWhere((t) => t.id == task.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
