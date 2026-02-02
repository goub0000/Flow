import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../../core/l10n_extension.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/home_constants.dart';
import '../../../core/constants/user_roles.dart';
import '../../authentication/providers/auth_provider.dart';
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
    final authState = ref.watch(authProvider);
    final isWide = MediaQuery.of(context).size.width > 600;

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
                    if (isWide) ...[
                      const SizedBox(width: 32),
                      _NavTextButton(label: context.l10n.navUniversities, path: '/universities', theme: theme),
                      _NavTextButton(label: context.l10n.navAbout, path: '/about', theme: theme),
                      _NavTextButton(label: context.l10n.navContact, path: '/contact', theme: theme),
                    ],
                  ],
                ),
                actions: [
                  const _LanguageToggle(),
                  const SizedBox(width: 8),
                  if (authState.isAuthenticated) ...[
                    FilledButton.icon(
                      onPressed: () => context.go(
                        authState.user?.activeRole.dashboardRoute ?? '/login',
                      ),
                      icon: const Icon(Icons.dashboard, size: 18),
                      label: Text(context.l10n.navDashboard),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: () => context.go('/login'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: Text(context.l10n.navSignIn),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => context.go('/register'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(context.l10n.navGetStarted),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                  if (!isWide) ...[
                    const SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.menu),
                      onSelected: (path) => context.go(path),
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: '/universities', child: Text(ctx.l10n.navUniversities)),
                        PopupMenuItem(value: '/about', child: Text(ctx.l10n.navAbout)),
                        PopupMenuItem(value: '/contact', child: Text(ctx.l10n.navContact)),
                      ],
                    ),
                  ],
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
                  height: 36,
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
                  color: theme.colorScheme.secondary.withValues(alpha:0.1),
                  height: 30,
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
                  height: 36,
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
              child: FloatingActionButton.small(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                tooltip: context.l10n.backToTop,
                elevation: 4,
                child: const Icon(Icons.arrow_upward),
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
                      theme.colorScheme.primary.withValues(alpha: 0.10),
                      AppColors.terracotta.withValues(alpha: 0.07),
                      AppColors.coral.withValues(alpha: 0.05),
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

          // Decorative floating circles (web-compatible)
          if (!isMobile) ...[
            // Top right decorative circle - large, floating
            Positioned(
              top: -50,
              right: -50,
              child: FloatingElement(
                floatHeight: 12,
                duration: const Duration(seconds: 5),
                delay: 0,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.18),
                        theme.colorScheme.primary.withValues(alpha: 0.06),
                        theme.colorScheme.primary.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom left decorative circle - floating
            Positioned(
              bottom: -30,
              left: -30,
              child: FloatingElement(
                floatHeight: 10,
                duration: const Duration(seconds: 6),
                delay: 0.5,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.terracotta.withValues(alpha: 0.15),
                        AppColors.terracotta.withValues(alpha: 0.05),
                        AppColors.terracotta.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Middle right accent circle - floating
            Positioned(
              top: size.height * 0.3,
              right: 60,
              child: FloatingElement(
                floatHeight: 8,
                duration: const Duration(seconds: 4),
                delay: 1.0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.coral.withValues(alpha: 0.14),
                        AppColors.coral.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Top left small accent circle - floating
            Positioned(
              top: size.height * 0.15,
              left: 40,
              child: FloatingElement(
                floatHeight: 6,
                duration: const Duration(seconds: 3),
                delay: 1.5,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.12),
                        theme.colorScheme.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

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
                    // 0: Trust Badge - with PulsingElement
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
                                context.l10n.heroTrustBadge,
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
                        context.l10n.heroHeadline,
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
                        context.l10n.heroSubheadline,
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
                              label: Text(context.l10n.heroStartFreeTrial),
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
                              label: Text(context.l10n.heroTakeATour),
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
                          stats: [
                            StatItem(
                              icon: Icons.people_rounded,
                              value: 50000,
                              suffix: '+',
                              label: context.l10n.heroStatActiveUsers,
                            ),
                            StatItem(
                              icon: Icons.account_balance_rounded,
                              value: 18000,
                              suffix: '+',
                              label: context.l10n.heroStatUniversities,
                            ),
                            StatItem(
                              icon: Icons.public_rounded,
                              value: 100,
                              suffix: '+',
                              label: context.l10n.heroStatCountries,
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
                context.l10n.whyChooseTitle,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.whyChooseSubtitle,
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
                    title: context.l10n.valueOfflineTitle,
                    description: context.l10n.valueOfflineDesc,
                    color: theme.colorScheme.primary,
                  ),
                  _ValueCard(
                    icon: Icons.payment_rounded,
                    title: context.l10n.valueMobileMoneyTitle,
                    description: context.l10n.valueMobileMoneyDesc,
                    color: AppColors.terracotta,
                  ),
                  _ValueCard(
                    icon: Icons.translate_rounded,
                    title: context.l10n.valueMultiLangTitle,
                    description: context.l10n.valueMultiLangDesc,
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
        transform: Matrix4.identity()..scaleByDouble(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0, 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isHovered
                ? widget.color.withValues(alpha:0.4)
                : theme.colorScheme.outlineVariant,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.color.withValues(alpha:0.15)
                  : Colors.black.withValues(alpha:0.05),
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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: HomeConstants.sectionSpacingMedium,
        horizontal: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: HomeConstants.maxContentWidth),
          child: UniversityLogosSection(
            title: context.l10n.socialProofTitle,
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
                context.l10n.testimonialsTitle,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.testimonialsSubtitle,
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
                context.l10n.quizBadge,
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
          context.l10n.quizTitle,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.quizDescription,
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
              context.l10n.quizDuration,
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
              context.l10n.quizAIPowered,
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
                context.l10n.featuresTitle,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.featuresSubtitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              _FeatureItem(
                icon: Icons.auto_stories,
                title: context.l10n.featureLearningTitle,
                description: context.l10n.featureLearningDesc,
              ),
              const SizedBox(height: 28),
              _FeatureItem(
                icon: Icons.people_rounded,
                title: context.l10n.featureCollabTitle,
                description: context.l10n.featureCollabDesc,
              ),
              const SizedBox(height: 28),
              _FeatureItem(
                icon: Icons.security_rounded,
                title: context.l10n.featureSecurityTitle,
                description: context.l10n.featureSecurityDesc,
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
                  AppColors.terracotta.withValues(alpha:0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha:0.1),
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
                      color: Colors.white.withValues(alpha:0.2),
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
                      color: Colors.white.withValues(alpha:0.15),
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
                        context.l10n.featuresWorksOnAllDevices,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha:0.7),
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
          context.l10n.featuresTitle,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.featuresSubtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        _FeatureItem(
          icon: Icons.auto_stories,
          title: context.l10n.featureLearningTitle,
          description: context.l10n.featureLearningDesc,
        ),
        const SizedBox(height: 24),
        _FeatureItem(
          icon: Icons.people_rounded,
          title: context.l10n.featureCollabTitle,
          description: context.l10n.featureCollabDesc,
        ),
        const SizedBox(height: 24),
        _FeatureItem(
          icon: Icons.security_rounded,
          title: context.l10n.featureSecurityTitle,
          description: context.l10n.featureSecurityDesc,
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

  List<_UserType> _buildUserTypes(BuildContext context) => [
    _UserType(
      icon: Icons.person_rounded,
      name: context.l10n.roleStudents,
      description: context.l10n.roleStudentsDesc,
      color: AppColors.studentRole,
    ),
    _UserType(
      icon: Icons.business_rounded,
      name: context.l10n.roleInstitutions,
      description: context.l10n.roleInstitutionsDesc,
      color: AppColors.institutionRole,
    ),
    _UserType(
      icon: Icons.family_restroom_rounded,
      name: context.l10n.roleParents,
      description: context.l10n.roleParentsDesc,
      color: AppColors.parentRole,
    ),
    _UserType(
      icon: Icons.psychology_rounded,
      name: context.l10n.roleCounselors,
      description: context.l10n.roleCounselorsDesc,
      color: AppColors.counselorRole,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userTypes = _buildUserTypes(context);
    final selected = userTypes[_selectedIndex];

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
                context.l10n.builtForEveryoneTitle,
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.builtForEveryoneSubtitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Segmented Button — hide icons on narrow screens to prevent label truncation
              LayoutBuilder(
                builder: (context, constraints) {
                  final showIcons = constraints.maxWidth >= 500;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: SegmentedButton<int>(
                        segments: userTypes.asMap().entries.map((entry) {
                          return ButtonSegment<int>(
                            value: entry.key,
                            icon: showIcons ? Icon(entry.value.icon) : null,
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
                    ),
                  );
                },
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
                        label: Text(context.l10n.getStartedAs(selected.name)),
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

/// Navigation text button used in the homepage app bar.
class _NavTextButton extends StatelessWidget {
  final String label;
  final String path;
  final ThemeData theme;

  const _NavTextButton({
    required this.label,
    required this.path,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(path),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }
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
            theme.colorScheme.primaryContainer.withValues(alpha:0.5),
            AppColors.warmSand.withValues(alpha:0.3),
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
                  color: theme.colorScheme.primary.withValues(alpha:0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  context.l10n.ctaTitle,
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
                  context.l10n.ctaSubtitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha:0.9),
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
                    label: Text(context.l10n.ctaButton),
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
                      color: Colors.white.withValues(alpha:0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.ctaNoCreditCard,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha:0.8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.white.withValues(alpha:0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.cta14DayTrial,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha:0.8),
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
    final textColor = Colors.white.withValues(alpha:0.9);
    final secondaryTextColor = Colors.white.withValues(alpha:0.6);

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
                            context.l10n.footerTagline,
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
                        title: context.l10n.footerProducts,
                        isDark: true,
                        links: [
                          _FooterLink(context.l10n.footerStudentPortal, () => context.go('/login'), icon: Icons.school_outlined, isDark: true),
                          _FooterLink(context.l10n.footerInstitutionDashboard, () => context.go('/login'), icon: Icons.business_outlined, isDark: true),
                          _FooterLink(context.l10n.footerParentApp, () => context.go('/login'), icon: Icons.family_restroom_outlined, isDark: true),
                          _FooterLink(context.l10n.footerCounselorTools, () => context.go('/login'), icon: Icons.support_agent_outlined, isDark: true),
                          _FooterLink(context.l10n.footerMobileApps, () => context.go('/mobile-apps'), icon: Icons.phone_iphone_outlined, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Company Column
                    Expanded(
                      child: _FooterColumn(
                        title: context.l10n.footerCompany,
                        isDark: true,
                        links: [
                          _FooterLink(context.l10n.footerAboutUs, () => context.go('/about'), icon: Icons.info_outline, isDark: true),
                          _FooterLink(context.l10n.footerCareers, () => context.go('/careers'), icon: Icons.work_outline, isDark: true),
                          _FooterLink(context.l10n.footerPressKit, () => context.go('/press'), icon: Icons.newspaper_outlined, isDark: true),
                          _FooterLink(context.l10n.footerPartners, () => context.go('/partners'), icon: Icons.handshake_outlined, isDark: true),
                          _FooterLink(context.l10n.footerContact, () => context.go('/contact'), icon: Icons.mail_outline, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Resources Column
                    Expanded(
                      child: _FooterColumn(
                        title: context.l10n.footerResources,
                        isDark: true,
                        links: [
                          _FooterLink(context.l10n.footerHelpCenter, () => context.go('/help'), icon: Icons.help_outline, isDark: true),
                          _FooterLink(context.l10n.footerDocumentation, () => context.go('/docs'), icon: Icons.description_outlined, isDark: true),
                          _FooterLink(context.l10n.footerApiReference, () => context.go('/api-docs'), icon: Icons.code_outlined, isDark: true),
                          _FooterLink(context.l10n.footerCommunity, () => context.go('/community'), icon: Icons.groups_outlined, isDark: true),
                          _FooterLink(context.l10n.footerBlog, () => context.go('/blog'), icon: Icons.article_outlined, isDark: true),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Legal Column
                    Expanded(
                      child: _FooterColumn(
                        title: context.l10n.footerLegal,
                        isDark: true,
                        links: [
                          _FooterLink(context.l10n.footerPrivacyPolicy, () => context.go('/privacy'), icon: Icons.privacy_tip_outlined, isDark: true),
                          _FooterLink(context.l10n.footerTermsOfService, () => context.go('/terms'), icon: Icons.gavel_outlined, isDark: true),
                          _FooterLink(context.l10n.footerCookiePolicy, () => context.go('/cookies'), icon: Icons.cookie_outlined, isDark: true),
                          _FooterLink(context.l10n.footerDataProtection, () => context.go('/data-protection'), icon: Icons.security_outlined, isDark: true),
                          _FooterLink(context.l10n.footerCompliance, () => context.go('/compliance'), icon: Icons.verified_outlined, isDark: true),
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
                      context.l10n.footerTagline,
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
                          title: context.l10n.footerProducts,
                          isDark: true,
                          links: [
                            _FooterLink(context.l10n.footerStudentPortal, () => context.go('/login'), icon: Icons.school_outlined, isDark: true),
                            _FooterLink(context.l10n.footerInstitutionDashboard, () => context.go('/login'), icon: Icons.business_outlined, isDark: true),
                            _FooterLink(context.l10n.footerParentApp, () => context.go('/login'), icon: Icons.family_restroom_outlined, isDark: true),
                            _FooterLink(context.l10n.footerCounselorTools, () => context.go('/login'), icon: Icons.support_agent_outlined, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: context.l10n.footerCompany,
                          isDark: true,
                          links: [
                            _FooterLink(context.l10n.footerAboutUs, () => context.go('/about'), icon: Icons.info_outline, isDark: true),
                            _FooterLink(context.l10n.footerCareers, () => context.go('/careers'), icon: Icons.work_outline, isDark: true),
                            _FooterLink(context.l10n.footerContact, () => context.go('/contact'), icon: Icons.mail_outline, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: context.l10n.footerResources,
                          isDark: true,
                          links: [
                            _FooterLink(context.l10n.footerHelpCenter, () => context.go('/help'), icon: Icons.help_outline, isDark: true),
                            _FooterLink(context.l10n.footerDocumentation, () => context.go('/docs'), icon: Icons.description_outlined, isDark: true),
                            _FooterLink(context.l10n.footerCommunity, () => context.go('/community'), icon: Icons.groups_outlined, isDark: true),
                          ],
                        ),
                        _FooterColumn(
                          title: context.l10n.footerLegal,
                          isDark: true,
                          links: [
                            _FooterLink(context.l10n.footerPrivacyPolicy, () => context.go('/privacy'), icon: Icons.privacy_tip_outlined, isDark: true),
                            _FooterLink(context.l10n.footerTermsOfService, () => context.go('/terms'), icon: Icons.gavel_outlined, isDark: true),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),

              const SizedBox(height: 48),

              // Divider
              Divider(color: Colors.white.withValues(alpha:0.2)),

              const SizedBox(height: 24),

              // Bottom Section - Copyright and Trust Badges
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  Text(
                    context.l10n.footerCopyright,
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
                        context.l10n.footerSoc2,
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
                        context.l10n.footerIso27001,
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
                        context.l10n.footerGdpr,
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
            color: isDark ? Colors.white.withValues(alpha:0.9) : null,
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
    final textColor = isDark ? Colors.white.withValues(alpha:0.7) : theme.colorScheme.onSurfaceVariant;

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
                          context.l10n.homeNewFeature,
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
                    context.l10n.homeFindYourPathTitle,
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
                    context.l10n.homeFindYourPathDesc,
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
                        text: context.l10n.homePersonalizedRecs,
                      ),
                      _FindYourPathBenefit(
                        icon: Icons.school_outlined,
                        text: context.l10n.homeTopUniversities,
                      ),
                      _FindYourPathBenefit(
                        icon: Icons.analytics_outlined,
                        text: context.l10n.homeSmartMatching,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // CTA Button
                  ElevatedButton.icon(
                    onPressed: () => context.go('/find-your-path'),
                    icon: const Icon(Icons.arrow_forward, size: 24),
                    label: Text(
                      context.l10n.homeStartYourJourney,
                      style: const TextStyle(
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
                    context.l10n.homeNoAccountRequired,
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
                  color: theme.colorScheme.secondary.withValues(alpha:0.3),
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
                      color: Colors.white.withValues(alpha:0.15),
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
                    context.l10n.uniSearchTitle,
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
                    context.l10n.homeSearchUniversitiesDesc,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha:0.95),
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
                        label: context.l10n.heroStatCountries,
                      ),
                      _UniversityStatChip(
                        icon: Icons.account_balance,
                        value: '18K+',
                        label: context.l10n.heroStatUniversities,
                      ),
                      _UniversityStatChip(
                        icon: Icons.filter_list,
                        value: '10+',
                        label: context.l10n.homeFilters,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // CTA Button
                  ElevatedButton.icon(
                    onPressed: () => context.go('/universities'),
                    icon: const Icon(Icons.search, size: 22),
                    label: Text(
                      context.l10n.homeBrowseUniversities,
                      style: const TextStyle(
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
                      shadowColor: Colors.black.withValues(alpha:0.2),
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
        color: Colors.white.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.25),
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
              color: Colors.white.withValues(alpha:0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEnglish = locale.languageCode == 'en';
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isEnglish ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isEnglish
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('fr')),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !isEnglish ? theme.colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'FR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: !isEnglish
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
