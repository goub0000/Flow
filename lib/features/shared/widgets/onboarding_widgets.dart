import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Onboarding & Tutorial Widgets
///
/// Comprehensive onboarding and feature discovery UI components including:
/// - Onboarding page templates
/// - Page indicators
/// - Feature highlight overlays
/// - Tooltip widgets
/// - Tutorial step components
///
/// Backend Integration TODO:
/// ```dart
/// // Track onboarding completion
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// class OnboardingService {
///   static const String _keyOnboardingCompleted = 'onboarding_completed';
///   static const String _keyTutorialsShown = 'tutorials_shown';
///
///   Future<bool> hasCompletedOnboarding() async {
///     final prefs = await SharedPreferences.getInstance();
///     return prefs.getBool(_keyOnboardingCompleted) ?? false;
///   }
///
///   Future<void> markOnboardingCompleted() async {
///     final prefs = await SharedPreferences.getInstance();
///     await prefs.setBool(_keyOnboardingCompleted, true);
///   }
///
///   Future<Set<String>> getShownTutorials() async {
///     final prefs = await SharedPreferences.getInstance();
///     final list = prefs.getStringList(_keyTutorialsShown) ?? [];
///     return list.toSet();
///   }
///
///   Future<void> markTutorialShown(String tutorialId) async {
///     final prefs = await SharedPreferences.getInstance();
///     final shown = await getShownTutorials();
///     shown.add(tutorialId);
///     await prefs.setStringList(_keyTutorialsShown, shown.toList());
///   }
///
///   Future<bool> shouldShowTutorial(String tutorialId) async {
///     final shown = await getShownTutorials();
///     return !shown.contains(tutorialId);
///   }
/// }
///
/// // Analytics tracking
/// // TODO: Implement with Supabase or analytics service
///
/// class OnboardingAnalytics {
///   Future<void> trackOnboardingStarted() async {
///     // TODO: Implement analytics tracking
///   }
///
///   Future<void> trackOnboardingCompleted() async {
///     // TODO: Implement analytics tracking
///   }
///
///   Future<void> trackOnboardingSkipped(int pageIndex) async {
///     // TODO: Implement analytics tracking
///   }
///
///   Future<void> trackTutorialShown(String tutorialId) async {
///     // TODO: Implement analytics tracking
///   }
///
///   Future<void> trackTutorialCompleted(String tutorialId) async {
///     // TODO: Implement analytics tracking
///   }
/// }
///
/// // Backend sync
/// import 'package:dio/dio.dart';
///
/// class OnboardingRepository {
///   final Dio _dio;
///
///   Future<void> recordOnboardingCompletion() async {
///     await _dio.post('/api/user/onboarding/complete', data: {
///       'completedAt': DateTime.now().toIso8601String(),
///     });
///   }
///
///   Future<void> recordTutorialProgress(String tutorialId, bool completed) async {
///     await _dio.post('/api/user/tutorials', data: {
///       'tutorialId': tutorialId,
///       'completed': completed,
///       'timestamp': DateTime.now().toIso8601String(),
///     });
///   }
/// }
/// ```

/// Onboarding Page Data Model
class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;
  final Color? backgroundColor;
  final IconData? icon;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.backgroundColor,
    this.icon,
  });
}

/// Tutorial Step Data Model
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final GlobalKey targetKey;
  final TooltipPosition position;
  final ShapeBorder? highlightShape;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetKey,
    this.position = TooltipPosition.bottom,
    this.highlightShape,
  });
}

/// Tooltip Position Enum
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center,
}

/// Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: data.backgroundColor ?? AppColors.background,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          if (data.icon != null)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                size: 100,
                color: AppColors.primary,
              ),
            )
          else
            Container(
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.surface,
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(height: 60),

          // Title
          Text(
            data.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Page Indicator Widget
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? (activeColor ?? AppColors.primary)
                : (inactiveColor ?? AppColors.textSecondary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Feature Card Widget
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tutorial Overlay Widget
class TutorialOverlay extends StatelessWidget {
  final TutorialStep step;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentStep;
  final int totalSteps;

  const TutorialOverlay({
    super.key,
    required this.step,
    required this.onNext,
    required this.onSkip,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final renderBox = step.targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      return const SizedBox.shrink();
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Stack(
      children: [
        // Dark overlay
        Container(
          color: Colors.black.withValues(alpha: 0.7),
        ),

        // Highlight hole
        CustomPaint(
          painter: HighlightPainter(
            targetRect: Rect.fromLTWH(
              position.dx,
              position.dy,
              size.width,
              size.height,
            ),
            shape: step.highlightShape ?? const RoundedRectangleBorder(),
          ),
          child: Container(),
        ),

        // Tooltip
        Positioned(
          top: _getTooltipTop(position, size, context),
          left: _getTooltipLeft(position, size, context),
          right: _getTooltipRight(position, size, context),
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.swOnboardingStepOf(currentStep, totalSteps),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: onSkip,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    step.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: onSkip,
                        child: Text(context.l10n.swOnboardingSkipTutorial),
                      ),
                      FilledButton(
                        onPressed: onNext,
                        child: Text(
                          currentStep == totalSteps ? context.l10n.swOnboardingFinish : context.l10n.swOnboardingNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double? _getTooltipTop(Offset position, Size size, BuildContext context) {
    switch (step.position) {
      case TooltipPosition.top:
        return position.dy - 220;
      case TooltipPosition.bottom:
        return position.dy + size.height + 20;
      case TooltipPosition.center:
        return MediaQuery.of(context).size.height / 2 - 150;
      default:
        return null;
    }
  }

  double? _getTooltipLeft(Offset position, Size size, BuildContext context) {
    switch (step.position) {
      case TooltipPosition.left:
        return 20;
      case TooltipPosition.right:
        return position.dx + size.width + 20;
      default:
        return null;
    }
  }

  double? _getTooltipRight(Offset position, Size size, BuildContext context) {
    switch (step.position) {
      case TooltipPosition.left:
        return MediaQuery.of(context).size.width - position.dx + 20;
      case TooltipPosition.right:
        return 20;
      default:
        return null;
    }
  }
}

/// Highlight Painter
class HighlightPainter extends CustomPainter {
  final Rect targetRect;
  final ShapeBorder shape;

  HighlightPainter({
    required this.targetRect,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    // Expand target rect with padding
    final expandedRect = targetRect.inflate(8);

    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    if (shape is CircleBorder) {
      canvas.drawCircle(
        expandedRect.center,
        expandedRect.width / 2,
        paint,
      );
    } else if (shape is RoundedRectangleBorder) {
      final border = shape as RoundedRectangleBorder;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          expandedRect,
          border.borderRadius.resolve(TextDirection.ltr).topLeft,
        ),
        paint,
      );
    } else {
      canvas.drawRect(expandedRect, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Tooltip Bubble Widget
class TooltipBubble extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final Color? backgroundColor;

  const TooltipBubble({
    super.key,
    required this.message,
    this.onDismiss,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated Pointer Widget
class AnimatedPointer extends StatefulWidget {
  final Offset position;

  const AnimatedPointer({
    super.key,
    required this.position,
  });

  @override
  State<AnimatedPointer> createState() => _AnimatedPointerState();
}

class _AnimatedPointerState extends State<AnimatedPointer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx,
          top: widget.position.dy + _animation.value,
          child: const Icon(
            Icons.touch_app,
            color: AppColors.primary,
            size: 48,
          ),
        );
      },
    );
  }
}

/// Progress Step Indicator
class ProgressStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const ProgressStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1) const SizedBox(width: 4),
                ],
              ),
            );
          }),
        ),
        if (stepLabels.isNotEmpty && currentStep < stepLabels.length) ...[
          const SizedBox(height: 8),
          Text(
            stepLabels[currentStep],
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
