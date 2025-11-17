import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import '../../../core/theme/app_colors.dart';
import 'dart:math' as math;
import '../../chatbot/presentation/widgets/chatbot_fab.dart';

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
    final size = MediaQuery.of(context).size;
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

              // Value Proposition
              const SliverToBoxAdapter(
                child: _ValuePropositionSection(),
              ),

              // Social Proof
              const SliverToBoxAdapter(
                child: _SocialProofSection(),
              ),

              // Find Your Path Feature Highlight
              const SliverToBoxAdapter(
                child: _FindYourPathSection(),
              ),

              // Key Features - Minimalistic
              const SliverToBoxAdapter(
                child: _KeyFeaturesSection(),
              ),

              // User Types - Segmented
              const SliverToBoxAdapter(
                child: _UserTypesSection(),
              ),

              // Final CTA
              const SliverToBoxAdapter(
                child: _FinalCTASection(),
              ),

              // Minimal Footer
              SliverToBoxAdapter(
                child: _MinimalFooter(),
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

          // Chatbot FAB
          const ChatbotFAB(),
        ],
      ),
    );
  }
}

/// Hero Section with Animated Gradient
class _HeroSection extends StatelessWidget {
  final AnimationController animationController;

  const _HeroSection({required this.animationController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      height: size.height * 0.85,
      child: Stack(
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.03),
                      theme.colorScheme.secondary.withValues(alpha: 0.05),
                      theme.colorScheme.tertiary.withValues(alpha: 0.03),
                    ],
                    stops: [
                      0.0,
                      0.5 + (0.2 * math.sin(animationController.value * 2 * math.pi)),
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),

          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Floating Badge
                    Hero(
                      tag: 'badge',
                      child: Material(
                        color: Colors.transparent,
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
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Africa\'s Leading EdTech Platform',
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

                    // Main Headline - Bold & Minimal
                    Text(
                      'Education Without\nBoundaries',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 72,
                        height: 1.1,
                        letterSpacing: -2,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Subheadline
                    Text(
                      'Connect, learn, and grow with Africa\'s first\noffline-first educational ecosystem',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // CTA Buttons - Material 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context.go('/register'),
                          icon: const Icon(Icons.rocket_launch_rounded),
                          label: const Text('Start Free Trial'),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Demo video
                          },
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Watch Demo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            side: BorderSide(
                              color: theme.colorScheme.outline,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),

                    // Trust Indicators - Minimal
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 48,
                      runSpacing: 24,
                      children: [
                        _TrustIndicator(
                          icon: Icons.verified_rounded,
                          value: '50K+',
                          label: 'Active Users',
                        ),
                        _TrustIndicator(
                          icon: Icons.business,
                          value: '200+',
                          label: 'Institutions',
                        ),
                        _TrustIndicator(
                          icon: Icons.public_rounded,
                          value: '20+',
                          label: 'Countries',
                        ),
                      ],
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
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Why Choose Flow?',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
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
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _ValueCard(
                    icon: Icons.offline_bolt_rounded,
                    title: 'Offline-First',
                    description:
                        'Access your content anytime, anywhere—even without internet',
                    color: theme.colorScheme.primary,
                  ),
                  _ValueCard(
                    icon: Icons.payment_rounded,
                    title: 'Mobile Money',
                    description:
                        'Pay with M-Pesa, MTN Money, and other local payment methods',
                    color: theme.colorScheme.secondary,
                  ),
                  _ValueCard(
                    icon: Icons.translate_rounded,
                    title: 'Multi-Language',
                    description:
                        'Platform available in multiple African languages',
                    color: theme.colorScheme.tertiary,
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

class _ValueCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Social Proof Section
class _SocialProofSection extends StatelessWidget {
  const _SocialProofSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Trusted by Institutions Across Africa',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 64,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _LogoPlaceholder('University of Ghana'),
                  _LogoPlaceholder('Ashesi University'),
                  _LogoPlaceholder('Kenyatta University'),
                  _LogoPlaceholder('University of Lagos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  final String name;

  const _LogoPlaceholder(this.name);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Text(
        name,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Key Features Section - Minimalistic
class _KeyFeaturesSection extends StatelessWidget {
  const _KeyFeaturesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Feature list
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Everything you need',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A complete educational ecosystem designed for modern Africa',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _FeatureItem(
                      icon: Icons.auto_stories,
                      title: 'Comprehensive Learning',
                      description: 'Access courses, track progress, and manage applications',
                    ),
                    const SizedBox(height: 24),
                    _FeatureItem(
                      icon: Icons.people_rounded,
                      title: 'Built for Collaboration',
                      description: 'Connect students, parents, counselors, and institutions',
                    ),
                    const SizedBox(height: 24),
                    _FeatureItem(
                      icon: Icons.security_rounded,
                      title: 'Enterprise-Grade Security',
                      description: 'Bank-level encryption and data protection',
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
                        theme.colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.devices_rounded,
                      size: 120,
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'Built for Everyone',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Container(
            padding: const EdgeInsets.all(64),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Transform Education?',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Join thousands of students, institutions, and educators',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () => context.go('/register'),
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: const Text('Start Your Free Trial'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 24,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No credit card required • 14-day free trial',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Comprehensive Footer
class _MinimalFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
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
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),
                          // Social media icons removed - will be added when actual links are available
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),

                    // Products Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Products',
                        links: [
                          _FooterLink('Student Portal', () {}),
                          _FooterLink('Institution Dashboard', () {}),
                          _FooterLink('Parent App', () {}),
                          _FooterLink('Counselor Tools', () {}),
                          _FooterLink('Mobile Apps', () {}),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Company Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Company',
                        links: [
                          _FooterLink('About Us', () {}),
                          _FooterLink('Careers', () {}),
                          _FooterLink('Press Kit', () {}),
                          _FooterLink('Partners', () {}),
                          _FooterLink('Contact', () {}),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Resources Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Resources',
                        links: [
                          _FooterLink('Help Center', () {}),
                          _FooterLink('Documentation', () {}),
                          _FooterLink('API Reference', () {}),
                          _FooterLink('Community', () {}),
                          _FooterLink('Blog', () {}),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Legal Column
                    Expanded(
                      child: _FooterColumn(
                        title: 'Legal',
                        links: [
                          _FooterLink('Privacy Policy', () {}),
                          _FooterLink('Terms of Service', () {}),
                          _FooterLink('Cookie Policy', () {}),
                          _FooterLink('Data Protection', () {}),
                          _FooterLink('Compliance', () {}),
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Africa\'s Leading EdTech Platform\nEmpowering education without boundaries.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
                          links: [
                            _FooterLink('Student Portal', () {}),
                            _FooterLink('Institution Dashboard', () {}),
                            _FooterLink('Parent App', () {}),
                            _FooterLink('Counselor Tools', () {}),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Company',
                          links: [
                            _FooterLink('About Us', () {}),
                            _FooterLink('Careers', () {}),
                            _FooterLink('Contact', () {}),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Resources',
                          links: [
                            _FooterLink('Help Center', () {}),
                            _FooterLink('Documentation', () {}),
                            _FooterLink('Community', () {}),
                          ],
                        ),
                        _FooterColumn(
                          title: 'Legal',
                          links: [
                            _FooterLink('Privacy Policy', () {}),
                            _FooterLink('Terms of Service', () {}),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Social Media Icons (Mobile) - removed until actual links are available
                    const SizedBox.shrink(),
                  ],
                ),

              const SizedBox(height: 48),

              // Divider
              Divider(color: theme.colorScheme.outlineVariant),

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
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SOC 2 Certified',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.security,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ISO 27001',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.lock,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'GDPR Compliant',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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

  const _FooterColumn({
    required this.title,
    required this.links,
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
          ),
        ),
        const SizedBox(height: 16),
        ...links,
      ],
    );
  }
}

/// Footer Link Widget
class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _FooterLink(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onPressed,
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
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
