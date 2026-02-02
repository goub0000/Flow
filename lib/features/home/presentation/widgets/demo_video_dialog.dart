import 'package:flutter/material.dart';

import '../../../../core/l10n_extension.dart';

/// Data class for a single feature tour slide.
class _TourSlide {
  final IconData icon;
  final String title;
  final String description;
  final List<String> highlights;
  final Color color;

  const _TourSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlights,
    required this.color,
  });
}

List<_TourSlide> _buildSlides(BuildContext context) => [
      _TourSlide(
        icon: Icons.school_rounded,
        title: context.l10n.tourSlide1Title,
        description: context.l10n.tourSlide1Desc,
        highlights: [
          context.l10n.tourSlide1H1,
          context.l10n.tourSlide1H2,
          context.l10n.tourSlide1H3,
        ],
        color: Color(0xFF6366F1),
      ),
      _TourSlide(
        icon: Icons.route_rounded,
        title: context.l10n.tourSlide2Title,
        description: context.l10n.tourSlide2Desc,
        highlights: [
          context.l10n.tourSlide2H1,
          context.l10n.tourSlide2H2,
          context.l10n.tourSlide2H3,
        ],
        color: Color(0xFF0EA5E9),
      ),
      _TourSlide(
        icon: Icons.dashboard_rounded,
        title: context.l10n.tourSlide3Title,
        description: context.l10n.tourSlide3Desc,
        highlights: [
          context.l10n.tourSlide3H1,
          context.l10n.tourSlide3H2,
          context.l10n.tourSlide3H3,
        ],
        color: Color(0xFF10B981),
      ),
      _TourSlide(
        icon: Icons.chat_rounded,
        title: context.l10n.tourSlide4Title,
        description: context.l10n.tourSlide4Desc,
        highlights: [
          context.l10n.tourSlide4H1,
          context.l10n.tourSlide4H2,
          context.l10n.tourSlide4H3,
        ],
        color: Color(0xFFF59E0B),
      ),
      _TourSlide(
        icon: Icons.people_rounded,
        title: context.l10n.tourSlide5Title,
        description: context.l10n.tourSlide5Desc,
        highlights: [
          context.l10n.tourSlide5H1,
          context.l10n.tourSlide5H2,
          context.l10n.tourSlide5H3,
        ],
        color: Color(0xFFEC4899),
      ),
    ];

/// A dialog that displays a guided feature tour for the Flow platform.
class DemoVideoDialog extends StatefulWidget {
  const DemoVideoDialog({super.key});

  @override
  State<DemoVideoDialog> createState() => _DemoVideoDialogState();
}

class _DemoVideoDialogState extends State<DemoVideoDialog>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController;
  late final AnimationController _progressController;
  late List<_TourSlide> _currentSlides;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= _currentSlides.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    _progressController.forward(from: 0);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 800;
    final dialogWidth = isDesktop ? 720.0 : screenSize.width * 0.95;
    final slides = _buildSlides(context);
    _currentSlides = slides;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 12,
        vertical: 24,
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxWidth: 780,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.tourTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.l10n.tourSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Slide counter
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${slides.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: context.l10n.tourClose,
                  ),
                ],
              ),
            ),

            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(slides.length, (i) {
                  final isActive = i == _currentIndex;
                  final isPast = i < _currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _goTo(i),
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: isActive
                              ? slides[_currentIndex].color
                              : isPast
                                  ? slides[i].color.withValues(alpha: 0.5)
                                  : theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            // Slide content
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (i) {
                  _progressController.forward(from: 0);
                  setState(() => _currentIndex = i);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _SlideContent(
                    slide: slide,
                    animation: _progressController,
                  );
                },
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Row(
                children: [
                  // Back button
                  if (_currentIndex > 0)
                    TextButton.icon(
                      onPressed: () => _goTo(_currentIndex - 1),
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: Text(context.l10n.tourBack),
                    )
                  else
                    const SizedBox(width: 80),

                  const Spacer(),

                  // Dot indicators (compact)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(slides.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _currentIndex ? 20 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: i == _currentIndex
                              ? slides[_currentIndex].color
                              : theme.colorScheme.outlineVariant,
                        ),
                      );
                    }),
                  ),

                  const Spacer(),

                  // Next / Get Started button
                  if (_currentIndex < slides.length - 1)
                    FilledButton.icon(
                      onPressed: () => _goTo(_currentIndex + 1),
                      icon: Text(context.l10n.tourNext),
                      label: const Icon(Icons.arrow_forward_rounded, size: 18),
                      style: FilledButton.styleFrom(
                        backgroundColor: slides[_currentIndex].color,
                      ),
                    )
                  else
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Text(context.l10n.tourGetStarted),
                      label: const Icon(Icons.arrow_forward_rounded, size: 18),
                      style: FilledButton.styleFrom(
                        backgroundColor: slides[_currentIndex].color,
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

/// A single slide in the feature tour.
class _SlideContent extends StatelessWidget {
  final _TourSlide slide;
  final Animation<double> animation;

  const _SlideContent({required this.slide, required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 600;

    return FadeTransition(
      opacity: animation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: illustration
                  Expanded(flex: 2, child: _buildIllustration(theme)),
                  const SizedBox(width: 32),
                  // Right: text content
                  Expanded(flex: 3, child: _buildTextContent(theme)),
                ],
              )
            : Column(
                children: [
                  _buildIllustration(theme),
                  const SizedBox(height: 24),
                  _buildTextContent(theme),
                ],
              ),
      ),
    );
  }

  Widget _buildIllustration(ThemeData theme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            slide.color.withValues(alpha: 0.1),
            slide.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: slide.color.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Icon(
          slide.icon,
          size: 80,
          color: slide.color,
        ),
      ),
    );
  }

  Widget _buildTextContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          slide.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          slide.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        ...slide.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: slide.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: slide.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      h,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

/// Shows the demo feature tour dialog.
///
/// Call this from any button's onPressed handler:
/// ```dart
/// OutlinedButton(
///   onPressed: () => showDemoVideoDialog(context),
///   child: Text('Watch Demo'),
/// )
/// ```
void showDemoVideoDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const DemoVideoDialog(),
  );
}
