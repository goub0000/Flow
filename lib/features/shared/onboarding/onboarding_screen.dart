import 'package:flutter/material.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/onboarding_widgets.dart';

/// Onboarding Screen
///
/// Multi-page onboarding flow introducing app features and benefits.
/// Features:
/// - Swipeable pages
/// - Skip option
/// - Progress indicators
/// - Smooth animations
///
/// Backend Integration TODO:
/// - Track onboarding completion
/// - Save user preferences from onboarding
/// - Record analytics events
/// - Sync onboarding state across devices

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Welcome to Flow',
      description:
          'Your all-in-one platform for discovering courses, managing applications, and achieving your educational goals.',
      imagePath: 'assets/onboarding/welcome.png',
      icon: Icons.waving_hand,
      backgroundColor: Colors.white,
    ),
    OnboardingPageData(
      title: 'Discover Courses',
      description:
          'Browse thousands of courses from top institutions. Filter by subject, level, duration, and more to find the perfect fit.',
      imagePath: 'assets/onboarding/courses.png',
      icon: Icons.explore,
      backgroundColor: Colors.white,
    ),
    OnboardingPageData(
      title: 'Track Applications',
      description:
          'Manage all your course applications in one place. Get real-time updates and never miss a deadline.',
      imagePath: 'assets/onboarding/applications.png',
      icon: Icons.description,
      backgroundColor: Colors.white,
    ),
    OnboardingPageData(
      title: 'Study Smarter',
      description:
          'Take notes, set goals, and track your progress. Stay organized with our powerful study tools.',
      imagePath: 'assets/onboarding/study.png',
      icon: Icons.auto_stories,
      backgroundColor: Colors.white,
    ),
    OnboardingPageData(
      title: 'Stay Connected',
      description:
          'Message institutions directly, get personalized counseling, and receive instant notifications for important updates.',
      imagePath: 'assets/onboarding/connected.png',
      icon: Icons.connect_without_contact,
      backgroundColor: Colors.white,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // TODO: Mark onboarding as completed
    // TODO: Track analytics
    // TODO: Navigate to main screen or login

    Navigator.of(context).pushReplacementNamed('/login');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Welcome to Flow!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: const Text('Skip'),
                    ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Page indicator
                  PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _pages.length,
                  ),
                  const SizedBox(height: 32),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _nextPage,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
