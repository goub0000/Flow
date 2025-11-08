import 'package:flutter/material.dart';
import '../widgets/onboarding_widgets.dart';

/// Tutorial Manager
///
/// Manages feature tutorials and overlays throughout the app.
/// Can be used to show interactive tutorials for any screen.
///
/// Usage:
/// ```dart
/// // Define tutorial steps
/// final steps = [
///   TutorialStep(
///     id: 'home_search',
///     title: 'Search Courses',
///     description: 'Tap here to search for courses',
///     targetKey: _searchKey,
///     position: TooltipPosition.bottom,
///   ),
///   TutorialStep(
///     id: 'home_filter',
///     title: 'Filter Results',
///     description: 'Use filters to narrow down your search',
///     targetKey: _filterKey,
///     position: TooltipPosition.bottom,
///   ),
/// ];
///
/// // Show tutorial
/// TutorialManager.showTutorial(
///   context: context,
///   tutorialId: 'home_tutorial',
///   steps: steps,
/// );
/// ```

class TutorialManager {
  static OverlayEntry? _overlayEntry;
  static int _currentStep = 0;
  static List<TutorialStep>? _steps;
  static String? _tutorialId;

  /// Show a tutorial with multiple steps
  static void showTutorial({
    required BuildContext context,
    required String tutorialId,
    required List<TutorialStep> steps,
    VoidCallback? onComplete,
  }) {
    if (steps.isEmpty) return;

    _tutorialId = tutorialId;
    _steps = steps;
    _currentStep = 0;

    _showCurrentStep(context, onComplete);
  }

  static void _showCurrentStep(BuildContext context, VoidCallback? onComplete) {
    if (_steps == null || _currentStep >= _steps!.length) {
      _completeTutorial(onComplete);
      return;
    }

    _removeOverlay();

    final step = _steps![_currentStep];

    _overlayEntry = OverlayEntry(
      builder: (context) => TutorialOverlay(
        step: step,
        currentStep: _currentStep + 1,
        totalSteps: _steps!.length,
        onNext: () {
          _currentStep++;
          _showCurrentStep(context, onComplete);
        },
        onSkip: () {
          _skipTutorial(onComplete);
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void _completeTutorial(VoidCallback? onComplete) {
    _removeOverlay();

    // TODO: Mark tutorial as completed in storage
    // TODO: Track analytics

    onComplete?.call();

    _tutorialId = null;
    _steps = null;
    _currentStep = 0;
  }

  static void _skipTutorial(VoidCallback? onComplete) {
    _removeOverlay();

    // TODO: Track skip event in analytics

    _tutorialId = null;
    _steps = null;
    _currentStep = 0;
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Check if a tutorial is currently active
  static bool get isActive => _overlayEntry != null;

  /// Get current tutorial ID
  static String? get currentTutorialId => _tutorialId;

  /// Force close any active tutorial
  static void close() {
    _removeOverlay();
    _tutorialId = null;
    _steps = null;
    _currentStep = 0;
  }
}

/// Tutorial Example Screen
///
/// Example screen showing how to implement tutorials in your screens.
class TutorialExampleScreen extends StatefulWidget {
  const TutorialExampleScreen({super.key});

  @override
  State<TutorialExampleScreen> createState() => _TutorialExampleScreenState();
}

class _TutorialExampleScreenState extends State<TutorialExampleScreen> {
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _filterKey = GlobalKey();
  final GlobalKey _notificationsKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Show tutorial after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
  }

  void _showTutorial() {
    final steps = [
      TutorialStep(
        id: 'example_search',
        title: 'Search Feature',
        description: 'Use the search bar to find courses, institutions, or content.',
        targetKey: _searchKey,
        position: TooltipPosition.bottom,
        highlightShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      TutorialStep(
        id: 'example_filter',
        title: 'Filter Options',
        description: 'Apply filters to narrow down your search results.',
        targetKey: _filterKey,
        position: TooltipPosition.bottom,
        highlightShape: const CircleBorder(),
      ),
      TutorialStep(
        id: 'example_notifications',
        title: 'Notifications',
        description: 'Check your notifications for important updates and messages.',
        targetKey: _notificationsKey,
        position: TooltipPosition.bottom,
        highlightShape: const CircleBorder(),
      ),
      TutorialStep(
        id: 'example_profile',
        title: 'Your Profile',
        description: 'Access your profile, settings, and preferences here.',
        targetKey: _profileKey,
        position: TooltipPosition.bottom,
        highlightShape: const CircleBorder(),
      ),
    ];

    TutorialManager.showTutorial(
      context: context,
      tutorialId: 'example_tutorial',
      steps: steps,
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tutorial completed!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial Example'),
        actions: [
          IconButton(
            key: _notificationsKey,
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            key: _profileKey,
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              key: _searchKey,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filter button
            Row(
              children: [
                IconButton(
                  key: _filterKey,
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
                const Text('Filter Options'),
              ],
            ),
            const SizedBox(height: 32),

            // Content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Tutorial Example Screen',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This screen demonstrates how to implement tutorials',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: _showTutorial,
                      child: const Text('Restart Tutorial'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
