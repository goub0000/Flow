import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/course_content_models.dart';
import '../../../core/models/quiz_assignment_models.dart';
import '../../../core/services/course_content_api_service.dart';
import '../../../features/authentication/providers/auth_provider.dart';

/// State class for managing course modules
class ModulesState {
  final List<CourseModule> modules;
  final bool isLoading;
  final String? error;
  final String? courseId;

  const ModulesState({
    this.modules = const [],
    this.isLoading = false,
    this.error,
    this.courseId,
  });

  ModulesState copyWith({
    List<CourseModule>? modules,
    bool? isLoading,
    String? error,
    String? courseId,
  }) {
    return ModulesState(
      modules: modules ?? this.modules,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      courseId: courseId ?? this.courseId,
    );
  }
}

/// StateNotifier for managing course modules
class ModulesNotifier extends StateNotifier<ModulesState> {
  final Ref _ref;
  late final CourseContentApiService _apiService;

  ModulesNotifier(this._ref, String courseId)
      : super(ModulesState(courseId: courseId)) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CourseContentApiService(accessToken: accessToken);
    fetchModules();
  }

  /// Fetch all modules for the course
  Future<void> fetchModules() async {
    if (state.courseId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final modules = await _apiService.getCourseModules(state.courseId!);
      state = state.copyWith(
        modules: modules,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch modules: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new module
  Future<CourseModule?> createModule(ModuleRequest moduleData) async {
    if (state.courseId == null) return null;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final module = await _apiService.createModule(state.courseId!, moduleData);

      state = state.copyWith(
        modules: [...state.modules, module],
        isLoading: false,
      );

      return module;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create module: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Update an existing module
  Future<CourseModule?> updateModule(
    String moduleId,
    ModuleRequest moduleData,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedModule = await _apiService.updateModule(moduleId, moduleData);

      final updatedModules = state.modules.map((m) {
        return m.id == moduleId ? updatedModule : m;
      }).toList();

      state = state.copyWith(
        modules: updatedModules,
        isLoading: false,
      );

      return updatedModule;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update module: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Delete a module
  Future<bool> deleteModule(String moduleId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.deleteModule(moduleId);

      final updatedModules = state.modules.where((m) => m.id != moduleId).toList();

      state = state.copyWith(
        modules: updatedModules,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete module: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Reorder modules
  Future<bool> reorderModules(List<Map<String, dynamic>> orderData) async {
    if (state.courseId == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.reorderModules(state.courseId!, orderData);

      // Refresh modules to get updated order
      await fetchModules();

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to reorder modules: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Refresh modules
  Future<void> refresh() async {
    await fetchModules();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// State class for managing lessons
class LessonsState {
  final Map<String, List<CourseLesson>> lessonsByModule;
  final bool isLoading;
  final String? error;

  const LessonsState({
    this.lessonsByModule = const {},
    this.isLoading = false,
    this.error,
  });

  LessonsState copyWith({
    Map<String, List<CourseLesson>>? lessonsByModule,
    bool? isLoading,
    String? error,
  }) {
    return LessonsState(
      lessonsByModule: lessonsByModule ?? this.lessonsByModule,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<CourseLesson> getLessonsForModule(String moduleId) {
    return lessonsByModule[moduleId] ?? [];
  }
}

/// StateNotifier for managing lessons
class LessonsNotifier extends StateNotifier<LessonsState> {
  final Ref _ref;
  late final CourseContentApiService _apiService;

  LessonsNotifier(this._ref) : super(const LessonsState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CourseContentApiService(accessToken: accessToken);
  }

  /// Fetch lessons for a specific module
  Future<void> fetchModuleLessons(String moduleId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lessons = await _apiService.getModuleLessons(moduleId);

      final updatedLessonsByModule = Map<String, List<CourseLesson>>.from(state.lessonsByModule);
      updatedLessonsByModule[moduleId] = lessons;

      state = state.copyWith(
        lessonsByModule: updatedLessonsByModule,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch lessons: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new lesson
  Future<CourseLesson?> createLesson(
    String moduleId,
    LessonRequest lessonData,
    Map<String, dynamic>? content,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final lesson = await _apiService.createLesson(moduleId, lessonData, content);

      final currentLessons = state.getLessonsForModule(moduleId);
      final updatedLessonsByModule = Map<String, List<CourseLesson>>.from(state.lessonsByModule);
      updatedLessonsByModule[moduleId] = [...currentLessons, lesson];

      state = state.copyWith(
        lessonsByModule: updatedLessonsByModule,
        isLoading: false,
      );

      return lesson;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create lesson: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Update an existing lesson
  Future<CourseLesson?> updateLesson(
    String lessonId,
    String moduleId,
    LessonRequest lessonData,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedLesson = await _apiService.updateLesson(lessonId, lessonData);

      final currentLessons = state.getLessonsForModule(moduleId);
      final updatedLessons = currentLessons.map((l) {
        return l.id == lessonId ? updatedLesson : l;
      }).toList();

      final updatedLessonsByModule = Map<String, List<CourseLesson>>.from(state.lessonsByModule);
      updatedLessonsByModule[moduleId] = updatedLessons;

      state = state.copyWith(
        lessonsByModule: updatedLessonsByModule,
        isLoading: false,
      );

      return updatedLesson;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update lesson: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Delete a lesson
  Future<bool> deleteLesson(String lessonId, String moduleId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.deleteLesson(lessonId);

      final currentLessons = state.getLessonsForModule(moduleId);
      final updatedLessons = currentLessons.where((l) => l.id != lessonId).toList();

      final updatedLessonsByModule = Map<String, List<CourseLesson>>.from(state.lessonsByModule);
      updatedLessonsByModule[moduleId] = updatedLessons;

      state = state.copyWith(
        lessonsByModule: updatedLessonsByModule,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete lesson: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Reorder lessons within a module
  Future<bool> reorderLessons(String moduleId, List<Map<String, dynamic>> orderData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.reorderLessons(moduleId, orderData);

      // Refresh lessons to get updated order
      await fetchModuleLessons(moduleId);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to reorder lessons: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Refresh lessons for a module
  Future<void> refresh(String moduleId) async {
    await fetchModuleLessons(moduleId);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// State class for managing lesson content
class ContentState {
  final dynamic content;
  final bool isLoading;
  final String? error;
  final String? lessonId;

  const ContentState({
    this.content,
    this.isLoading = false,
    this.error,
    this.lessonId,
  });

  ContentState copyWith({
    dynamic content,
    bool? isLoading,
    String? error,
    String? lessonId,
  }) {
    return ContentState(
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lessonId: lessonId ?? this.lessonId,
    );
  }
}

/// StateNotifier for managing lesson content
class ContentNotifier extends StateNotifier<ContentState> {
  final Ref _ref;
  late final CourseContentApiService _apiService;

  ContentNotifier(this._ref) : super(const ContentState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CourseContentApiService(accessToken: accessToken);
  }

  /// Fetch lesson content
  Future<void> fetchContent(String lessonId) async {
    state = state.copyWith(isLoading: true, error: null, lessonId: lessonId);

    try {
      final content = await _apiService.getLessonContent(lessonId);
      state = state.copyWith(
        content: content,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch content: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update lesson content
  Future<bool> updateContent(String lessonId, Map<String, dynamic> content) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.updateLessonContent(lessonId, content);

      // Refresh content
      await fetchContent(lessonId);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update content: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Clear content state
  void clear() {
    state = const ContentState();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// State class for managing course progress (for students)
class ProgressState {
  final CourseProgress? progress;
  final bool isLoading;
  final String? error;

  const ProgressState({
    this.progress,
    this.isLoading = false,
    this.error,
  });

  ProgressState copyWith({
    CourseProgress? progress,
    bool? isLoading,
    String? error,
  }) {
    return ProgressState(
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing student progress
class ProgressNotifier extends StateNotifier<ProgressState> {
  final Ref _ref;
  late final CourseContentApiService _apiService;

  ProgressNotifier(this._ref) : super(const ProgressState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CourseContentApiService(accessToken: accessToken);
  }

  /// Fetch course progress
  Future<void> fetchProgress(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final progress = await _apiService.getCourseProgress(courseId);
      state = state.copyWith(
        progress: progress,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch progress: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Mark a lesson as complete
  Future<bool> markLessonComplete(String lessonId, String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.markLessonComplete(lessonId);

      // Refresh progress
      await fetchProgress(courseId);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark lesson complete: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider factory for course modules (per course)
final courseModulesProvider = StateNotifierProvider.family<
    ModulesNotifier, ModulesState, String>((ref, courseId) {
  return ModulesNotifier(ref, courseId);
});

/// Provider for lessons management
final lessonsProvider = StateNotifierProvider<LessonsNotifier, LessonsState>((ref) {
  return LessonsNotifier(ref);
});

/// Provider for content management
final contentProvider = StateNotifierProvider<ContentNotifier, ContentState>((ref) {
  return ContentNotifier(ref);
});

/// Provider for progress tracking
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier(ref);
});

/// Simple state providers for UI state management

/// Selected module for editing
final selectedModuleProvider = StateProvider<CourseModule?>((ref) => null);

/// Selected lesson for editing
final selectedLessonProvider = StateProvider<CourseLesson?>((ref) => null);

/// Expanded modules in the UI (for accordion/expansion)
final expandedModulesProvider = StateProvider<Set<String>>((ref) => {});

/// Expanded lessons in the UI
final expandedLessonsProvider = StateProvider<Set<String>>((ref) => {});

/// Quiz attempt state for students
final quizAttemptProvider = StateProvider<QuizAttempt?>((ref) => null);

/// Assignment submission state for students
final assignmentSubmissionProvider = StateProvider<AssignmentSubmission?>((ref) => null);
