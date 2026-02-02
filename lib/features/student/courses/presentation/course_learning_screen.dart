import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../../core/l10n_extension.dart';
import '../../../institution/providers/course_content_provider.dart';
import '../widgets/video_lesson_player.dart';
import '../widgets/text_lesson_reader.dart';
import '../widgets/quiz_lesson_taker.dart';
import '../widgets/assignment_lesson_submitter.dart';

/// Course Learning Screen
/// Main interface for students to consume course content
class CourseLearningScreen extends ConsumerStatefulWidget {
  final Course course;
  final String? initialLessonId;

  const CourseLearningScreen({
    super.key,
    required this.course,
    this.initialLessonId,
  });

  @override
  ConsumerState<CourseLearningScreen> createState() =>
      _CourseLearningScreenState();
}

class _CourseLearningScreenState extends ConsumerState<CourseLearningScreen> {
  String? _currentLessonId;
  bool _isSidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _currentLessonId = widget.initialLessonId;

    // Load course content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseModulesProvider(widget.course.id).notifier).fetchModules();
      ref.read(progressProvider.notifier).fetchProgress(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final modulesState = ref.watch(courseModulesProvider(widget.course.id));
    final lessonsState = ref.watch(lessonsProvider);
    final progressState = ref.watch(progressProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.title, style: const TextStyle(fontSize: 18)),
            if (progressState.progress != null)
              Text(
                context.l10n.courseLessonsCompleted(
                  progressState.progress!.completedLessons,
                  progressState.progress!.totalLessons,
                ),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          if (progressState.progress != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Chip(
                  label: Text(
                    '${progressState.progress!.progressPercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green[100],
                ),
              ),
            ),
          if (!isMobile)
            IconButton(
              icon: Icon(_isSidebarExpanded ? Icons.menu_open : Icons.menu),
              onPressed: () {
                setState(() {
                  _isSidebarExpanded = !_isSidebarExpanded;
                });
              },
              tooltip: _isSidebarExpanded
                  ? context.l10n.courseCollapseSidebar
                  : context.l10n.courseExpandSidebar,
            ),
        ],
      ),
      drawer: isMobile ? _buildSidebar(modulesState, lessonsState, progressState) : null,
      body: Row(
        children: [
          // Desktop sidebar
          if (!isMobile && _isSidebarExpanded)
            SizedBox(
              width: 320,
              child: _buildSidebar(modulesState, lessonsState, progressState),
            ),

          // Main content area
          Expanded(
            child: _buildMainContent(modulesState, lessonsState, progressState),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    ModulesState modulesState,
    LessonsState lessonsState,
    ProgressState progressState,
  ) {
    if (modulesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (modulesState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                context.l10n.courseErrorLoadingModules(modulesState.error!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(courseModulesProvider(widget.course.id).notifier).fetchModules();
                },
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.courseRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (modulesState.modules.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                context.l10n.courseNoContentYet,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.courseNoLessonsAdded,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: modulesState.modules.length,
        itemBuilder: (context, index) {
          final module = modulesState.modules[index];
          final lessons = lessonsState.lessonsByModule[module.id] ?? [];
          final completedLessonIds = progressState.progress?.completedLessonIds ?? [];
          final completedLessons = completedLessonIds
              .where((id) => lessons.any((l) => l.id == id))
              .length;

          return _buildModuleCard(
            module,
            lessons,
            completedLessons,
            completedLessonIds.toSet(),
          );
        },
      ),
    );
  }

  Widget _buildModuleCard(
    CourseModule module,
    List<CourseLesson> lessons,
    int completedLessons,
    Set<String> completedLessonIds,
  ) {
    final isExpanded = ref.watch(expandedModulesProvider).contains(module.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                '${module.orderIndex}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              module.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(context.l10n.courseLessonsCount(completedLessons, lessons.length)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lessons.isNotEmpty)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      value: lessons.isEmpty ? 0 : completedLessons / lessons.length,
                      backgroundColor: Colors.grey[200],
                      strokeWidth: 3,
                    ),
                  ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    final expanded = ref.read(expandedModulesProvider);
                    if (isExpanded) {
                      ref.read(expandedModulesProvider.notifier).state =
                          {...expanded}..remove(module.id);
                    } else {
                      ref.read(expandedModulesProvider.notifier).state =
                          {...expanded, module.id};
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              final expanded = ref.read(expandedModulesProvider);
              if (isExpanded) {
                final newSet = Set<String>.from(expanded);
                newSet.remove(module.id);
                ref.read(expandedModulesProvider.notifier).state = newSet;
              } else {
                ref.read(expandedModulesProvider.notifier).state = {...expanded, module.id};
              }
            },
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            ...lessons.map((lesson) => _buildLessonItem(
                  lesson,
                  completedLessonIds.contains(lesson.id),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonItem(CourseLesson lesson, bool isCompleted) {
    final isCurrent = _currentLessonId == lesson.id;

    return Container(
      color: isCurrent ? AppColors.primary.withOpacity(0.1) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        leading: Icon(
          lesson.lessonType.icon,
          color: isCurrent ? AppColors.primary : Colors.grey[600],
          size: 20,
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? AppColors.primary : null,
          ),
        ),
        subtitle: lesson.durationMinutes > 0
            ? Text(
                '${lesson.durationMinutes} min',
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
            : (lesson.isMandatory
                ? const Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 20)
                : null),
        onTap: () {
          setState(() {
            _currentLessonId = lesson.id;
          });
          // Close drawer on mobile
          if (MediaQuery.of(context).size.width < 768) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildMainContent(
    ModulesState modulesState,
    LessonsState lessonsState,
    ProgressState progressState,
  ) {
    if (_currentLessonId == null) {
      return _buildWelcomeScreen();
    }

    // Find current lesson
    CourseLesson? currentLesson;
    for (final lessons in lessonsState.lessonsByModule.values) {
      currentLesson = lessons.cast<CourseLesson?>().firstWhere(
            (l) => l?.id == _currentLessonId,
            orElse: () => null,
          );
      if (currentLesson != null) break;
    }

    if (currentLesson == null) {
      return _buildWelcomeScreen();
    }

    final completedLessonIds = progressState.progress?.completedLessonIds ?? [];
    final isCompleted = completedLessonIds.contains(currentLesson.id);

    return Column(
      children: [
        // Lesson header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(currentLesson.lessonType.icon, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentLesson.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isCompleted)
                    Chip(
                      label: Text(context.l10n.courseCompleted),
                      backgroundColor: Colors.green,
                      labelStyle: const TextStyle(color: Colors.white),
                      avatar: const Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                ],
              ),
              if (currentLesson.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  currentLesson.description!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),

        // Lesson content
        Expanded(
          child: _buildLessonContent(currentLesson),
        ),

        // Navigation bar
        _buildNavigationBar(currentLesson, modulesState, lessonsState, isCompleted),
      ],
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline, size: 100, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              context.l10n.courseWelcomeTo(widget.course.title),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.course.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Find first lesson
                final modulesState = ref.read(courseModulesProvider(widget.course.id));
                final lessonsState = ref.read(lessonsProvider);

                if (modulesState.modules.isNotEmpty) {
                  final firstModule = modulesState.modules.first;
                  final firstModuleLessons = lessonsState.lessonsByModule[firstModule.id];

                  if (firstModuleLessons != null && firstModuleLessons.isNotEmpty) {
                    setState(() {
                      _currentLessonId = firstModuleLessons.first.id;
                    });
                  }
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: Text(context.l10n.courseStartLearning),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonContent(CourseLesson lesson) {
    switch (lesson.lessonType) {
      case LessonType.video:
        return VideoLessonPlayer(lessonId: lesson.id);
      case LessonType.text:
        return TextLessonReader(lessonId: lesson.id);
      case LessonType.quiz:
        return QuizLessonTaker(lessonId: lesson.id);
      case LessonType.assignment:
        return AssignmentLessonSubmitter(lessonId: lesson.id);
    }
  }

  Widget _buildNavigationBar(
    CourseLesson currentLesson,
    ModulesState modulesState,
    LessonsState lessonsState,
    bool isCompleted,
  ) {
    // Find previous and next lessons
    final allLessons = <CourseLesson>[];
    for (final module in modulesState.modules) {
      final moduleLessons = lessonsState.lessonsByModule[module.id] ?? [];
      allLessons.addAll(moduleLessons);
    }

    final currentIndex = allLessons.indexWhere((l) => l.id == currentLesson.id);
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex < allLessons.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          if (hasPrevious)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _currentLessonId = allLessons[currentIndex - 1].id;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: Text(context.l10n.coursePrevious),
            )
          else
            const SizedBox.shrink(),

          // Mark complete button
          if (!isCompleted && currentLesson.isMandatory)
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(progressProvider.notifier)
                    .markLessonComplete(currentLesson.id, widget.course.id);
              },
              icon: const Icon(Icons.check),
              label: Text(context.l10n.courseMarkAsComplete),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),

          // Next button
          if (hasNext)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentLessonId = allLessons[currentIndex + 1].id;
                });
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(context.l10n.courseNext),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
