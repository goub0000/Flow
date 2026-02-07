import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Onboarding Screen
///
/// Introduces new users to the app's key features.
/// Features smooth page transitions, skip/next buttons, and progress indicators.
///
/// To show onboarding only once, use SharedPreferences:
/// ```dart
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// class OnboardingService {
///   static const _key = 'has_seen_onboarding';
///
///   Future<bool> hasSeenOnboarding() async {
///     final prefs = await SharedPreferences.getInstance();
///     return prefs.getBool(_key) ?? false;
///   }
///
///   Future<void> markOnboardingComplete() async {
///     final prefs = await SharedPreferences.getInstance();
///     await prefs.setBool(_key, true);
///   }
/// }
///
/// // In main.dart or app initialization:
/// final onboardingService = OnboardingService();
/// final hasSeenOnboarding = await onboardingService.hasSeenOnboarding();
///
/// if (!hasSeenOnboarding) {
///   // Show onboarding
///   Navigator.push(context, MaterialPageRoute(
///     builder: (context) => OnboardingScreen(),
///   ));
/// }
/// ```

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> _buildPages(BuildContext context) {
    return [
      OnboardingPage(
        title: context.l10n.onboardingWelcomeTitle,
        description: context.l10n.onboardingWelcomeDesc,
        icon: Icons.waving_hand,
        color: AppColors.primary,
        image: 'assets/images/onboarding_1.png', // Add your images
      ),
      OnboardingPage(
        title: context.l10n.onboardingCoursesTitle,
        description: context.l10n.onboardingCoursesDesc,
        icon: Icons.explore,
        color: AppColors.success,
        image: 'assets/images/onboarding_2.png',
      ),
      OnboardingPage(
        title: context.l10n.onboardingProgressTitle,
        description: context.l10n.onboardingProgressDesc,
        icon: Icons.trending_up,
        color: AppColors.info,
        image: 'assets/images/onboarding_3.png',
      ),
      OnboardingPage(
        title: context.l10n.onboardingConnectTitle,
        description: context.l10n.onboardingConnectDesc,
        icon: Icons.people,
        color: AppColors.warning,
        image: 'assets/images/onboarding_4.png',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // TODO: Mark onboarding as complete
    // await OnboardingService().markOnboardingComplete();

    // Navigate to biometric setup
    // User can skip biometric setup if they want
    context.go('/biometric-setup?setup=true');
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (only show after first page)
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                      label: Text(context.l10n.onboardingBack),
                    )
                  else
                    const SizedBox(width: 80),

                  // Skip Button (hide on last page)
                  if (_currentPage < pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(context.l10n.onboardingSkip),
                    )
                  else
                    const SizedBox(width: 80),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _buildPageIndicator(index, pages),
                ),
              ),
            ),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _nextPage(pages.length),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pages[_currentPage].color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == pages.length - 1
                            ? context.l10n.onboardingGetStarted
                            : context.l10n.onboardingNext,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentPage == pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Image
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: 0.5 + (value * 0.5),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: page.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: _currentPage == 0
                        ? Padding(
                            padding: const EdgeInsets.all(40),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(
                            page.icon,
                            size: 100,
                            color: page.color,
                          ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),

          // Title
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    page.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: page.color,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Description
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Text(
                    page.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Feature List (for relevant pages)
          if (_currentPage == 1 || _currentPage == 2) ...[
            const SizedBox(height: 32),
            _buildFeatureList(context, page),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context, OnboardingPage page) {
    List<String> features = [];

    if (_currentPage == 1) {
      features = [
        context.l10n.onboardingFeatureCourseSelection,
        context.l10n.onboardingFeatureFilter,
        context.l10n.onboardingFeatureDetails,
      ];
    } else if (_currentPage == 2) {
      features = [
        context.l10n.onboardingFeatureProgress,
        context.l10n.onboardingFeatureAnalytics,
        context.l10n.onboardingFeatureAchievements,
      ];
    }

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: page.color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                feature,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageIndicator(int index, List<OnboardingPage> pages) {
    bool isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? pages[_currentPage].color
            : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.image,
  });
}

/// Onboarding Service for managing onboarding state
class OnboardingService {
  // Key for SharedPreferences: 'has_completed_onboarding'

  /// Check if user has completed onboarding
  /// TODO: Implement with shared_preferences
  /// ```dart
  /// Future<bool> hasCompletedOnboarding() async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   return prefs.getBool('has_completed_onboarding') ?? false;
  /// }
  /// ```
  Future<bool> hasCompletedOnboarding() async {
    // For now, always return false to show onboarding
    // In production, use SharedPreferences
    return false;
  }

  /// Mark onboarding as complete
  /// TODO: Implement with shared_preferences
  /// ```dart
  /// Future<void> completeOnboarding() async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   await prefs.setBool('has_completed_onboarding', true);
  /// }
  /// ```
  Future<void> completeOnboarding() async {
    // TODO: Save to SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('has_completed_onboarding', true);
  }

  /// Reset onboarding (useful for testing)
  /// TODO: Implement with shared_preferences
  /// ```dart
  /// Future<void> resetOnboarding() async {
  ///   final prefs = await SharedPreferences.getInstance();
  ///   await prefs.remove('has_completed_onboarding');
  /// }
  /// ```
  Future<void> resetOnboarding() async {
    // TODO: Remove from SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('has_completed_onboarding');
  }
}
