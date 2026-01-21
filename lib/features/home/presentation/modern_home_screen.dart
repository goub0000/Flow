import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/home_constants.dart';
import 'dart:math' as math;
import 'widgets/demo_video_dialog.dart';
import 'widgets/section_divider.dart';
import 'widgets/testimonial_carousel.dart';
import 'widgets/university_logos_section.dart';
import 'widgets/animated_counter.dart';
import 'widgets/floating_elements.dart';
import 'widgets/search_preview.dart';
import 'widgets/mini_quiz_preview.dart';
import '../data/testimonials_data.dart';

/// Modern Home Screen - Minimalistic Material Design 3
class ModernHomeScreen extends ConsumerStatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  ConsumerState<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends ConsumerState<ModernHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Transparent App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: _scrollOffset > 10
                        ? ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                        : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(
                          alpha: _scrollOffset > 10 ? 0.8 : 0,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Flow',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => context.go('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => context.go('/register'),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Get Started'),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // Hero Section
              SliverToBoxAdapter(
                child: _HeroSection(animationController: _animationController),
              ),

              // Wave Divider - Hero to Value Props
              SliverToBoxAdapter(
                child: WaveDivider(
                  color: AppColors.sectionLight,
                  height: 60,
                  style: WaveStyle.gentle,
                ),
              ),

              // Value Proposition - Light background
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.sectionLight,
                  child: const _ValuePropositionSection(),
                ),
              ),

              // Social Proof with University Logos - White background
              const SliverToBoxAdapter(
                child: _SocialProofSection(),
              ),

              // Wave Divider - Social Proof to University Search
              SliverToBoxAdapter(
                child: WaveDivider(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  height: 50,
                  style: WaveStyle.minimal,
                ),
              ),

              // University Search Section
              const SliverToBoxAdapter(
                child: _UniversitySearchSection(),
              ),

              // Find Your Path Feature Highlight
              const SliverToBoxAdapter(
                child: _FindYourPathSection(),
              ),

              // Key Features - White background
              const SliverToBoxAdapter(
                child: _KeyFeaturesSection(),
              ),

              // User Types - Warm background
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.sectionWarm,
                  child: const _UserTypesSection(),
                ),
              ),

              // Testimonials Section
              const SliverToBoxAdapter(
                child: _TestimonialsSection(),
              ),

              // Interactive Quiz Teaser Section
              const SliverToBoxAdapter(
                child: _QuizTeaserSection(),
              ),

              // Wave Divider before Final CTA
              SliverToBoxAdapter(
                child: WaveDivider(
                  color: theme.colorScheme.primaryContainer,
                  height: 60,
                  style: WaveStyle.curved,
                ),
              ),

              // Final CTA
              const SliverToBoxAdapter(
                child: _FinalCTASection(),
              ),

              // Minimal Footer - Dark background
              SliverToBoxAdapter(
                child: Container(
                  color: AppColors.sectionDark,
                  child: _MinimalFooter(),
                ),
              ),
            ],
          ),

          // Floating Action Button - Extended
          Positioned(
            right: 24,
            bottom: 24,
            child: AnimatedOpacity(
              opacity: _scrollOffset > 200 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(Icons.arrow_upward),
                label: const Text('Back to Top'),
                elevation: 4,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

/// Hero Section with Animated Gradient and Staggered Animations
class _HeroSection extends StatefulWidget {
  final AnimationController animationController;

  const _HeroSection({required this.animationController});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _staggerControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initStaggerAnimations();
  }

  void _initStaggerAnimations() {
    // 5 elements: badge, title, subtitle, CTAs, stats
    _staggerControllers = List.generate(5, (index) {
      return AnimationController(
        vsync: this,
        duration: HomeConstants.fadeInDuration,
      );
    });

    _fadeAnimations = _staggerControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: HomeConstants.fadeInCurve),
      );
    }).toList();

    _slideAnimations = _staggerControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 30),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: HomeConstants.fadeInCurve),
      );
    }).toList();

    // Start staggered animations
    _startStaggeredAnimations();
  }

  Future<void> _startStaggeredAnimations() async {
    for (int i = 0; i < _staggerControllers.length; i++) {
      await Future.delayed(HomeConstants.staggerDelay);
      if (mounted) {
        _staggerControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _staggerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildAnimatedChild(int index, Widget child) {
    return AnimatedBuilder(
      animation: _staggerControllers[index],
      builder: (context, _) {
        return Transform.translate(
          offset: _slideAnimations[index].value,
          child: Opacity(
            opacity: _fadeAnimations[index].value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isMobile = size.width < HomeConstants.mobileBreakpoint;

    return Container(
      constraints: BoxConstraints(
        minHeight: isMobile ? size.height * 0.95 : size.height * 0.9,
      ),
      child: Stack(
        children: [
          // Animated Gradient Background with African warmth
          AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.04),
                      AppColors.terracotta.withValues(alpha: 0.03),
                      AppColors.coral.withValues(alpha: 0.02),
                    ],
                    stops: [
                      0.0,
                      0.5 + (0.15 * math.sin(widget.animationController.value * 2 * math.pi)),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating decorative shapes
          if (!isMobile)
            FloatingShapes(
              primaryColor: theme.colorScheme.primary,
              secondaryColor: AppColors.terracotta,
              opacity: 0.08,
            ),

          // Mouse-following gradient overlay (desktop only)
          if (!isMobile)
            MouseFollowingGradient(
              colors: [theme.colorScheme.primary, AppColors.terracotta],
              intensity: 0.08,
              child: const SizedBox.expand(),
            ),

          // Content
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: HomeConstants.maxHeroWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 24,
                  vertical: isMobile ? 40 : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 0: Trust Badge - Updated copy
                    _buildAnimatedChild(
                      0,
                      PulsingElement(
                        minScale: 0.98,
                        maxScale: 1.02,
                        duration: const Duration(seconds: 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Trusted by 200+ Universities',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 1: Main Headline - Benefit-focused
                    _buildAnimatedChild(
                      1,
                      Text(
                        'Find Your Perfect\nUniversity Match',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: isMobile ? 40 : 56,
                          height: 1.1,
                          letterSpacing: -1.5,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2: Subheadline - Benefit-focused
                    _buildAnimatedChild(
                      2,
                      Text(
                        'Discover, compare, and apply to 18,000+ universities\nwith personalized recommendations powered by AI',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.6,
                          fontSize: isMobile ? 16 : 20,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 2.5: Interactive Search Bar
                    _buildAnimatedChild(
                      2,
                      const SearchBarButton(),
                    ),
                    const SizedBox(height: 32),

                    // 3: CTA Buttons - Larger with min height
                    _buildAnimatedChild(
                      3,
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            height: HomeConstants.buttonMinHeight,
                            child: FilledButton.icon(
                              onPressed: () => context.go('/register'),
                              icon: const Icon(Icons.rocket_launch_rounded),
                              label: const Text('Start Free Trial'),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 0,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                elevation: 2,
                                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: HomeConstants.buttonMinHeight,
                            child: OutlinedButton.icon(
                              onPressed: () => showDemoVideoDialog(context),
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Watch Demo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(
                                  color: theme.colorScheme.outline,
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 0,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // 4: Animated Stats Counters
                    _buildAnimatedChild(
                      4,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: AnimatedStatsRow(
                          stats: const [
                            StatItem(
                              icon: Icons.people_rounded,
                              value: 50000,
                              suffix: '+',
                              label: 'Active Users',
                            ),
                            StatItem(
                              icon: Icons.account_balance_rounded,
                              value: 18000,
                              suffix: '+',
                              label: 'Universities',
                            ),
                            StatItem(
                              icon: Icons.public_rounded,
                              value: 100,
                              suffix: '+',
                              label: 'Countries',
                            ),
                          ],
                          spacing: isMobile ? 32 : 64,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustIndicator extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _TrustIndicator({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Value Proposition Section
class _ValuePropositionSection extends StatelessWidget {
  const _ValuePropositionSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: Column(
            children: [
              Text(
                'Why Choose Flow?',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Built for Africa, designed for everyone',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: HomeConstants.cardSpacing,
                runSpacing: HomeConstants.cardSpacing,
                alignment: WrapAlignment.center,
                children: [
                  _ValueCard(
                    icon: Icons.offline_bolt_rounded,
                    title: 'Offline-First',
                    description:
                        'Access your content anytime, anywhere—even without internet connectivity',
                    color: theme.colorScheme.primary,
                  ),
                  _ValueCard(
                    icon: Icons.payment_rounded,
                    title: 'Mobile Money',
                    description:
                        'Pay with M-Pesa, MTN Money, and other local payment methods you trust',
                    color: AppColors.terracotta,
                  ),
                  _ValueCard(
                    icon: Icons.translate_rounded,
                    title: 'Multi-Language',
                    description:
                        'Platform available in multiple African languages for your convenience',
                    color: AppColors.deepOchre,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: HomeConstants.hoverDuration,
        curve: HomeConstants.hoverCurve,
        width: HomeConstants.cardMinWidth,
        padding: EdgeInsets.all(HomeConstants.cardPadding),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered
                ? widget.color.withOpacity(0.4)
                : theme.colorScheme.outlineVariant,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.color.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 24 : 10,
              offset: Offset(0, _isHovered ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: HomeConstants.hoverDuration,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: _isHovered ? 0.15 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 48,
                color: widget.color,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              widget.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Social Proof Section with University Logos
class _SocialProofSection extends StatelessWidget {
  const _SocialProofSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingMedium,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: const UniversityLogosSection(
            title: 'Trusted by Leading Institutions Across Africa',
          ),
        ),
      ),
    );
  }
}

/// Testimonials Section with Carousel
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: Column(
            children: [
              Text(
                'What Our Users Say',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Success stories from students, institutions, and educators',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TestimonialCarousel(
                testimonials: Testimonials.all,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Interactive Quiz Teaser Section
class _QuizTeaserSection extends StatelessWidget {
  const _QuizTeaserSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < HomeConstants.mobileBreakpoint;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sectionLight,
            AppColors.warmSand.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: isMobile
              ? Column(
                  children: [
                    _buildContent(context, theme),
                    const SizedBox(height: 40),
                    const MiniQuizPreview(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildContent(context, theme),
                    ),
                    const SizedBox(width: 64),
                    const Expanded(
                      child: MiniQuizPreview(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore_rounded,
                size: 18,
                color: AppColors.accentDark,
              ),
              const SizedBox(width: 8),
              Text(
                'Find Your Path',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.accentDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Not Sure Where\nto Start?',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Take our quick quiz to discover universities and programs '
          'that match your interests, goals, and academic profile.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '2 minutes',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 24),
            Icon(
              Icons.psychology_outlined,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'AI-Powered',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Key Features Section - Minimalistic with responsive layout
class _KeyFeaturesSection extends StatelessWidget {
  const _KeyFeaturesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < HomeConstants.tabletBreakpoint;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: isMobile
              ? _buildMobileLayout(context, theme)
              : _buildDesktopLayout(context, theme),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Feature list
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Everything you need',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'A complete educational ecosystem designed for modern Africa',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              const _FeatureItem(
                icon: Icons.auto_stories,
                title: 'Comprehensive Learning',
                description: 'Access courses, track progress, and manage applications all in one place',
              ),
              const SizedBox(height: 28),
              const _FeatureItem(
                icon: Icons.people_rounded,
                title: 'Built for Collaboration',
                description: 'Connect students, parents, counselors, and institutions seamlessly',
              ),
              const SizedBox(height: 28),
              const _FeatureItem(
                icon: Icons.security_rounded,
                title: 'Enterprise-Grade Security',
                description: 'Bank-level encryption and GDPR-compliant data protection',
              ),
            ],
          ),
        ),
        const SizedBox(width: 80),

        // Right side - Visual
        Expanded(
          child: Container(
            height: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  AppColors.terracotta.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: 40,
                  right: 40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.devices_rounded,
                        size: 100,
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Works on all devices',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Text(
          'Everything you need',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'A complete educational ecosystem designed for modern Africa',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        const _FeatureItem(
          icon: Icons.auto_stories,
          title: 'Comprehensive Learning',
          description: 'Access courses, track progress, and manage applications all in one place',
        ),
        const SizedBox(height: 24),
        const _FeatureItem(
          icon: Icons.people_rounded,
          title: 'Built for Collaboration',
          description: 'Connect students, parents, counselors, and institutions seamlessly',
        ),
        const SizedBox(height: 24),
        const _FeatureItem(
          icon: Icons.security_rounded,
          title: 'Enterprise-Grade Security',
          description: 'Bank-level encryption and GDPR-compliant data protection',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// User Types Section - Segmented
class _UserTypesSection extends StatefulWidget {
  const _UserTypesSection();

  @override
  State<_UserTypesSection> createState() => _UserTypesSectionState();
}

class _UserTypesSectionState extends State<_UserTypesSection> {
  int _selectedIndex = 0;

  final List<_UserType> _userTypes = const [
    _UserType(
      icon: Icons.person_rounded,
      name: 'Students',
      description: 'Track courses, manage applications, and achieve your educational goals',
      color: AppColors.studentRole,
    ),
    _UserType(
      icon: Icons.business_rounded,
      name: 'Institutions',
      description: 'Streamline admissions, manage programs, and engage with students',
      color: AppColors.institutionRole,
    ),
    _UserType(
      icon: Icons.family_restroom_rounded,
      name: 'Parents',
      description: 'Monitor progress, communicate with teachers, and support your children',
      color: AppColors.parentRole,
    ),
    _UserType(
      icon: Icons.psychology_rounded,
      name: 'Counselors',
      description: 'Guide students, manage sessions, and track counseling outcomes',
      color: AppColors.counselorRole,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _userTypes[_selectedIndex];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: Column(
            children: [
              Text(
                'Built for Everyone',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose your role and get started with a personalized experience',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Segmented Button
              SegmentedButton<int>(
                segments: _userTypes.asMap().entries.map((entry) {
                  return ButtonSegment<int>(
                    value: entry.key,
                    icon: Icon(entry.value.icon),
                    label: Text(entry.value.name),
                  );
                }).toList(),
                selected: {_selectedIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _selectedIndex = newSelection.first;
                  });
                },
                showSelectedIcon: false,
              ),
              const SizedBox(height: 48),

              // Selected User Type Card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_selectedIndex),
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: selected.color.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              selected.color.withValues(alpha: 0.2),
                              selected.color.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          selected.icon,
                          size: 56,
                          color: selected.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        selected.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: selected.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        selected.description,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      FilledButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text('Get Started as ${selected.name}'),
                        style: FilledButton.styleFrom(
                          backgroundColor: selected.color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserType {
  final IconData icon;
  final String name;
  final String description;
  final Color color;

  const _UserType({
    required this.icon,
    required this.name,
    required this.description,
    required this.color,
  });
}

/// Final CTA Section
class _FinalCTASection extends StatelessWidget {
  const _FinalCTASection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < HomeConstants.mobileBreakpoint;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingLarge,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.5),
            AppColors.warmSand.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 40 : 64),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Transform\nYour Educational Journey?',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: Colors.white,
                    fontSize: isMobile ? 28 : 36,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Join 50,000+ students, institutions, and educators who trust Flow',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isMobile ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: HomeConstants.buttonMinHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/register'),
                    icon: const Icon(Icons.rocket_launch_rounded),
                    label: const Text('Start Your Free Trial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 32 : 48,
                        vertical: 0,
                      ),
                      textStyle: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'No credit card required',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '14-day free trial',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Comprehensive Footer with Dark Theme
class _MinimalFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // Use light colors for dark background
    final textColor = Colors.white.withOpacity(0.9);
    final secondaryTextColor = Colors.white.withOpacity(0.6);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.sectionDark,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section - Logo, Description, and Columns
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and Description
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  height: 48,
                                  width: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Flow',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),

                    // Products Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Products',
                        isDark: true,
                        links: [
                          _FooterLink('Student Portal', () => context.go('/login'), icon: Icons.school_outlined, isDark: true),
                          _FooterLink('Institution Dashboard', () => context.go('/login'), icon: Icons.business_outlined, isDark: true),
                          _FooterLink('Parent App', () => context.go('/login'), icon: Icons.family_restroom_outlined, isDark: true),
                          _FooterLink('Counselor Tools', () => context.go('/login'), icon: Icons.support_agent_outlined, isDark: true),
                          _FooterLink('Mobile Apps', () => context.go('/mobile-apps'), icon: Icons.phone_iphone_outlined, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Company Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Company',
                        isDark: true,
                        links: [
                          _FooterLink('About Us', () => context.go('/about'), icon: Icons.info_outline, isDark: true),
                          _FooterLink('Careers', () => context.go('/careers'), icon: Icons.work_outline, isDark: true),
                          _FooterLink('Press Kit', () => context.go('/press'), icon: Icons.newspaper_outlined, isDark: true),
                          _FooterLink('Partners', () => context.go('/partners'), icon: Icons.handshake_outlined, isDark: true),
                          _FooterLink('Contact', () => context.go('/contact'), icon: Icons.mail_outline, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Resources Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Resources',
                        isDark: true,
                        links: [
                          _FooterLink('Help Center', () => context.go('/help'), icon: Icons.help_outline, isDark: true),
                          _FooterLink('Documentation', () => context.go('/docs'), icon: Icons.description_outlined, isDark: true),
                          _FooterLink('API Reference', () => context.go('/api-docs'), icon: Icons.code_outlined, isDark: true),
                          _FooterLink('Community', () => context.go('/community'), icon: Icons.groups_outlined, isDark: true),
                          _FooterLink('Blog', () => context.go('/blog'), icon: Icons.article_outlined, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Legal Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Legal',
                        isDark: true,
                        links: [
                          _FooterLink('Privacy Policy', () => context.go('/privacy'), icon: Icons.privacy_tip_outlined, isDark: true),
                          _FooterLink('Terms of Service', () => context.go('/terms'), icon: Icons.gavel_outlined, isDark: true),
                          _FooterLink('Cookie Policy', () => context.go('/cookies'), icon: Icons.cookie_outlined, isDark: true),
                          _FooterLink('Data Protection', () => context.go('/data-protection'), icon: Icons.security_outlined, isDark: true),
                          _FooterLink('Compliance', () => context.go('/compliance'), icon: Icons.verified_outlined, isDark: true),
                        ],
                      ),
                    ),
                  ],
                )
              else
                // Mobile/Tablet Layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo and Description
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Flow',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer Columns in Mobile
                    Wrap(
                      spacing: 48,
                      runSpacing: 32,
                      children: [
                        _FooterColumn(
                          title: 'Products',
                          isDark: true,
                          links: [
                            _FooterLink('Student Portal', () => context.go('/login'), icon: Icons.school_outlined, isDark: true),
                            _FooterLink('Institution Dashboard', () => context.go('/login'), icon: Icons.business_outlined, isDark: true),
                            _FooterLink('Parent App', () => context.go('/login'), icon: Icons.family_restroom_outlined, isDark: true),
                            _FooterLink('Counselor Tools', () => context.go('/login'), icon: Icons.support_agent_outlined, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Company',
                          isDark: true,
                          links: [
                            _FooterLink('About Us', () => context.go('/about'), icon: Icons.info_outline, isDark: true),
                            _FooterLink('Careers', () => context.go('/careers'), icon: Icons.work_outline, isDark: true),
                            _FooterLink('Contact', () => context.go('/contact'), icon: Icons.mail_outline, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Resources',
                          isDark: true,
                          links: [
                            _FooterLink('Help Center', () => context.go('/help'), icon: Icons.help_outline, isDark: true),
                            _FooterLink('Documentation', () => context.go('/docs'), icon: Icons.description_outlined, isDark: true),
                            _FooterLink('Community', () => context.go('/community'), icon: Icons.groups_outlined, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Legal',
                          isDark: true,
                          links: [
                            _FooterLink('Privacy Policy', () => context.go('/privacy'), icon: Icons.privacy_tip_outlined, isDark: true),
                            _FooterLink('Terms of Service', () => context.go('/terms'), icon: Icons.gavel_outlined, isDark: true),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),

              const SizedBox(height: 48),

              // Divider
              Divider(color: Colors.white.withOpacity(0.2)),

              const SizedBox(height: 24),

              // Bottom Section - Copyright and Trust Badges
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  Text(
                    '© 2025 Flow EdTech. All rights reserved.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SOC 2 Certified',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.security,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ISO 27001',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.lock,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'GDPR Compliant',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Footer Column Widget
class _FooterColumn extends StatelessWidget {
  final String title;
  final List<_FooterLink> links;
  final bool isDark;

  const _FooterColumn({
    required this.title,
    required this.links,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white.withOpacity(0.9) : null,
          ),
        ),
        const SizedBox(height: 16),
        ...links,
      ],
    );
  }
}

/// Footer Link Widget with optional icon
class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDark;

  const _FooterLink(this.text, this.onPressed, {this.icon, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark ? Colors.white.withOpacity(0.7) : theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: textColor,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Social Media Button Widget
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Find Your Path Feature Section
class _FindYourPathSection extends StatelessWidget {
  const _FindYourPathSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withValues(alpha: 0.95),
                  AppColors.accentDark,
                  AppColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 40),
              child: Column(
                children: [
                  // New Feature Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'NEW FEATURE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.explore_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Find Your Path',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      letterSpacing: -1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Discover universities that match your goals, budget, and aspirations.\nLet our intelligent recommendation system guide you to the perfect fit.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.6,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Benefits
                  Wrap(
                    spacing: 32,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _FindYourPathBenefit(
                        icon: Icons.lightbulb_outline,
                        text: 'Personalized Recommendations',
                      ),
                      _FindYourPathBenefit(
                        icon: Icons.school_outlined,
                        text: '12+ Top Universities',
                      ),
                      _FindYourPathBenefit(
                        icon: Icons.analytics_outlined,
                        text: 'Smart Matching Algorithm',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // CTA Button
                  ElevatedButton.icon(
                    onPressed: () => context.go('/find-your-path'),
                    icon: const Icon(Icons.arrow_forward, size: 24),
                    label: const Text(
                      'Start Your Journey',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 20,
                      ),
                      elevation: 8,
                      shadowColor: Colors.black.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtext
                  Text(
                    'Create a free account to see your results',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper Widget for Find Your Path Benefits
class _FindYourPathBenefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FindYourPathBenefit({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// University Search Section - Search universities worldwide
class _UniversitySearchSection extends StatelessWidget {
  const _UniversitySearchSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.secondary,
                  theme.colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.secondary.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
              child: Column(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Search Universities',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    'Explore 18,000+ universities from around the world.\nFilter by country, tuition, acceptance rate, and more.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                      height: 1.6,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Stats Row
                  Wrap(
                    spacing: 32,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _UniversityStatChip(
                        icon: Icons.public,
                        value: '100+',
                        label: 'Countries',
                      ),
                      _UniversityStatChip(
                        icon: Icons.account_balance,
                        value: '18K+',
                        label: 'Universities',
                      ),
                      _UniversityStatChip(
                        icon: Icons.filter_list,
                        value: '10+',
                        label: 'Filters',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // CTA Button
                  ElevatedButton.icon(
                    onPressed: () => context.go('/universities'),
                    icon: const Icon(Icons.search, size: 22),
                    label: const Text(
                      'Browse Universities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 18,
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper widget for university search stats
class _UniversityStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _UniversityStatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
