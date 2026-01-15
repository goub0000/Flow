import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar / Navigation Header
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surface,
              ),
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              title: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      // Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: ClipOval(
                          child: Container(
                            color: AppColors.surface,
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Flow',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Navigation Links
                      if (constraints.maxWidth > 1600) ...[
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.star, size: 18),
                          label: const Text('Features'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.info, size: 18),
                          label: const Text('About'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.contact_mail, size: 18),
                          label: const Text('Contact'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () => context.go('/login'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Login'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => context.go('/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Sign Up'),
                        ),
                      ] else ...[
                    // Mobile menu icon
                    IconButton(
                      icon: Icon(Icons.menu, color: AppColors.primary),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.7,
                            minChildSize: 0.5,
                            maxChildSize: 0.95,
                            expand: false,
                            builder: (context, scrollController) => SafeArea(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 8),
                                    // Drag Handle
                                    Container(
                                      width: 40,
                                      height: 4,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.star, color: AppColors.primary),
                                      title: const Text('Features'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.info, color: AppColors.primary),
                                      title: const Text('About'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.contact_mail, color: AppColors.primary),
                                      title: const Text('Contact'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Text(
                                        'Account Types',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.school, color: AppColors.studentRole),
                                      title: const Text('Students'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.business, color: AppColors.institutionRole),
                                      title: const Text('Institutions'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.family_restroom, color: AppColors.parentRole),
                                      title: const Text('Parents'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.psychology, color: AppColors.counselorRole),
                                      title: const Text('Counselors'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.rate_review, color: AppColors.recommenderRole),
                                      title: const Text('Recommenders'),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: Icon(Icons.login, color: AppColors.primary),
                                      title: const Text('Login'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.go('/login');
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.person_add, color: AppColors.primary),
                                      title: const Text('Sign Up'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.go('/register');
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
                },
              ),
            ),
          ),

          // Main Content
          SliverList(
            delegate: SliverChildListDelegate([
              // Welcome Section with Stats - Enhanced Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                children: [
                  // Badge/Tag above title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.rocket_launch, color: AppColors.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Africa\'s Premier EdTech Platform',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Flow',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Text(
                      'A comprehensive EdTech platform designed to connect students, institutions, parents, counselors, and recommenders across Africa. Built for offline-first experiences with mobile money integration.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Primary CTA Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add, size: 22),
                        label: const Text('Get Started Free'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login, size: 20),
                        label: const Text('Sign In'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(
                            color: AppColors.secondary,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Platform Stats - Enhanced
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _StatItem(
                        icon: Icons.school,
                        value: '5+',
                        label: 'User Roles',
                        color: AppColors.primary,
                      ),
                      _StatItem(
                        icon: Icons.language,
                        value: '20+',
                        label: 'African Countries',
                        color: AppColors.secondary,
                      ),
                      _StatItem(
                        icon: Icons.offline_bolt,
                        value: '100%',
                        label: 'Offline Access',
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Find Your Path Feature Highlight - NEW
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
                child: Column(
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.explore, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'NEW FEATURE',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Icon(
                      Icons.school,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Find Your Path',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        'Answer a few questions about your academic profile and goals, and we\'ll recommend the perfect universities for you.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                          height: 1.5,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Benefits
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
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
                    const SizedBox(height: 24),

                    // CTA Button
                    ElevatedButton.icon(
                      onPressed: () => context.go('/find-your-path'),
                      icon: const Icon(Icons.arrow_forward, size: 22),
                      label: const Text('Start Your Journey'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 18,
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Create a free account to see your results',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Key Features Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surface,
                    AppColors.surfaceVariant,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'WHY CHOOSE FLOW',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Platform Features',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Text(
                      'Everything you need for a complete educational experience',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _PlatformFeature(
                        icon: Icons.offline_bolt,
                        title: 'Offline-First Design',
                        description: 'Access your content even without internet connectivity',
                      ),
                      _PlatformFeature(
                        icon: Icons.payment,
                        title: 'Mobile Money Integration',
                        description: 'Pay with M-Pesa, MTN, and other mobile money services',
                      ),
                      _PlatformFeature(
                        icon: Icons.language,
                        title: 'Multi-Language Support',
                        description: 'Available in English, French, Swahili, and more',
                      ),
                      _PlatformFeature(
                        icon: Icons.security,
                        title: 'Secure & Private',
                        description: 'End-to-end encryption for all your data',
                      ),
                      _PlatformFeature(
                        icon: Icons.phone_android,
                        title: 'USSD Support',
                        description: 'Access features via basic phones without internet',
                      ),
                      _PlatformFeature(
                        icon: Icons.cloud_sync,
                        title: 'Cloud Sync',
                        description: 'Automatically sync across all your devices',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // How It Works Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.surfaceVariant,
                    AppColors.surface,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'SIMPLE PROCESS',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'How It Works',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _HowItWorksStep(
                        step: '1',
                        icon: Icons.person_add,
                        title: 'Create Account',
                        description: 'Sign up with your role - student, institution, parent, counselor, or recommender',
                      ),
                      _HowItWorksStep(
                        step: '2',
                        icon: Icons.dashboard,
                        title: 'Access Dashboard',
                        description: 'Get a personalized dashboard tailored to your needs',
                      ),
                      _HowItWorksStep(
                        step: '3',
                        icon: Icons.explore,
                        title: 'Explore Features',
                        description: 'Browse courses, applications, or manage your responsibilities',
                      ),
                      _HowItWorksStep(
                        step: '4',
                        icon: Icons.rocket_launch,
                        title: 'Achieve Goals',
                        description: 'Track progress, collaborate, and reach your educational objectives',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Testimonials Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    AppColors.surfaceVariant,
                    AppColors.surface,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'TESTIMONIALS',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.accentDark,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Trusted Across Africa',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      'Hear from our community of students, institutions, and educators',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _TestimonialCard(
                        name: 'Amina Mensah',
                        role: 'Student, University of Ghana',
                        quote: 'Flow made my application process so much easier. I could track everything in one place!',
                        avatarColor: AppColors.studentRole,
                      ),
                      _TestimonialCard(
                        name: 'Dr. Kwame Nkrumah',
                        role: 'Dean, Ashesi University',
                        quote: 'Managing applications has never been this efficient. Flow is a game-changer for institutions.',
                        avatarColor: AppColors.institutionRole,
                      ),
                      _TestimonialCard(
                        name: 'Sarah Okonkwo',
                        role: 'Parent, Nigeria',
                        quote: 'I can now monitor my children\'s academic progress even when I\'m traveling. Peace of mind!',
                        avatarColor: AppColors.parentRole,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Account Types Section
            _AccountTypesSection(),

            // Final CTA Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.secondary.withValues(alpha: 0.05),
                    AppColors.accent.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, color: AppColors.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'JOIN THE MOVEMENT',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ready to Get Started?',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Text(
                      'Join thousands of students, institutions, and educators across Africa who are transforming education with Flow.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add, size: 22),
                        label: const Text('Sign Up Free'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          elevation: 6,
                          shadowColor: AppColors.primary.withValues(alpha: 0.5),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login, size: 22),
                        label: const Text('Login'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(
                            color: AppColors.secondary,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Top Section - Compact Layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, color: AppColors.accent, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Flow EdTech',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transforming Education Across Africa',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Links
                  Wrap(
                    spacing: 20,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _FooterLinkWithIcon(
                        icon: Icons.info_outline,
                        label: 'About',
                        onTap: () {},
                      ),
                      _FooterLinkWithIcon(
                        icon: Icons.email_outlined,
                        label: 'Contact',
                        onTap: () {},
                      ),
                      _FooterLinkWithIcon(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy',
                        onTap: () {},
                      ),
                      _FooterLinkWithIcon(
                        icon: Icons.description_outlined,
                        label: 'Terms',
                        onTap: () {},
                      ),
                      _FooterLinkWithIcon(
                        icon: Icons.help_outline,
                        label: 'Help',
                        onTap: () {},
                      ),
                      _FooterLinkWithIcon(
                        icon: Icons.work_outline,
                        label: 'Careers',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Social Media Icons
                  Wrap(
                    spacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _SocialIcon(icon: Icons.facebook, onTap: () {}),
                      _SocialIcon(icon: Icons.smart_display, onTap: () {}), // YouTube
                      _SocialIcon(icon: Icons.telegram, onTap: () {}),
                      _SocialIcon(icon: Icons.link, onTap: () {}), // LinkedIn
                      _SocialIcon(icon: Icons.chat_bubble_outline, onTap: () {}), // WhatsApp
                    ],
                  ),
                  const SizedBox(height: 16),

                  Divider(color: AppColors.border, thickness: 1),
                  const SizedBox(height: 16),

                  // Bottom Row - Copyright and Back to Top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Features on Left
                      Expanded(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            _FooterFeature(icon: Icons.offline_bolt, text: 'Offline'),
                            _FooterFeature(icon: Icons.payment, text: 'Mobile Money'),
                            _FooterFeature(icon: Icons.language, text: 'Multi-Language'),
                          ],
                        ),
                      ),
                      // Copyright Center
                      Expanded(
                        flex: 2,
                        child: Text(
                          '© 2025 Flow EdTech. All rights reserved.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Back to Top Button
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: _scrollToTop,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Top',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget{
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.08),
            color.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: AppColors.textOnPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: color,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.arrow_forward,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class _FooterLinkWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterLinkWithIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _FooterFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FooterFeature({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _PlatformFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PlatformFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String description;

  const _HowItWorksStep({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppColors.textOnPrimary,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.accent, AppColors.accentLight],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String quote;
  final Color avatarColor;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.quote,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: avatarColor.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: avatarColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: avatarColor.withValues(alpha: 0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: avatarColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: avatarColor,
                  child: Text(
                    name.split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: avatarColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Icon(
                  Icons.star,
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: avatarColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"$quote"',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontStyle: FontStyle.italic,
                height: 1.7,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypesSection extends StatefulWidget {
  const _AccountTypesSection();

  @override
  State<_AccountTypesSection> createState() => _AccountTypesSectionState();
}

class _AccountTypesSectionState extends State<_AccountTypesSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(
        children: [
          Text(
            'Who Can Use Flow?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Discover how Flow empowers each member of the educational ecosystem',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),

          // Tab Navigation
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.textOnPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(8),
              labelPadding: const EdgeInsets.symmetric(horizontal: 24),
              tabs: const [
                Tab(
                  icon: Icon(Icons.school),
                  text: 'Students',
                ),
                Tab(
                  icon: Icon(Icons.business),
                  text: 'Institutions',
                ),
                Tab(
                  icon: Icon(Icons.family_restroom),
                  text: 'Parents',
                ),
                Tab(
                  icon: Icon(Icons.psychology),
                  text: 'Counselors',
                ),
                Tab(
                  icon: Icon(Icons.rate_review),
                  text: 'Recommenders',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Tab Content
          SizedBox(
            height: 550,
            child: TabBarView(
              controller: _tabController,
              children: const [
                _AccountTypeDetails(
                  icon: Icons.school,
                  title: 'For Students',
                  subtitle: 'Your gateway to academic success',
                  color: AppColors.studentRole,
                  description: 'Flow empowers students to take control of their educational journey with comprehensive tools designed for modern learners across Africa.',
                  features: [
                    _FeatureItem(
                      icon: Icons.book,
                      title: 'Course Access',
                      description: 'Browse and enroll in thousands of courses from top institutions across Africa',
                    ),
                    _FeatureItem(
                      icon: Icons.assignment,
                      title: 'Application Management',
                      description: 'Apply to multiple institutions, track application status, and manage deadlines in one place',
                    ),
                    _FeatureItem(
                      icon: Icons.bar_chart,
                      title: 'Progress Tracking',
                      description: 'Monitor your academic progress with detailed analytics and performance insights',
                    ),
                    _FeatureItem(
                      icon: Icons.description,
                      title: 'Document Management',
                      description: 'Store and share transcripts, certificates, and other academic documents securely',
                    ),
                    _FeatureItem(
                      icon: Icons.payment,
                      title: 'Easy Payments',
                      description: 'Pay tuition and fees using mobile money services like M-Pesa, MTN Money, and more',
                    ),
                    _FeatureItem(
                      icon: Icons.offline_bolt,
                      title: 'Offline Access',
                      description: 'Download course materials and access them without internet connectivity',
                    ),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.business,
                  title: 'For Institutions',
                  subtitle: 'Streamline admissions and student management',
                  color: AppColors.institutionRole,
                  description: 'Transform your institution\'s operations with powerful tools for admissions, student management, and program delivery.',
                  features: [
                    _FeatureItem(
                      icon: Icons.people,
                      title: 'Applicant Management',
                      description: 'Review, process, and track applications efficiently with automated workflows',
                    ),
                    _FeatureItem(
                      icon: Icons.school,
                      title: 'Program Management',
                      description: 'Create and manage academic programs, set requirements, and track enrollments',
                    ),
                    _FeatureItem(
                      icon: Icons.analytics,
                      title: 'Analytics Dashboard',
                      description: 'Get insights into application trends, student performance, and institutional metrics',
                    ),
                    _FeatureItem(
                      icon: Icons.message,
                      title: 'Communication Hub',
                      description: 'Engage with students, parents, and staff through integrated messaging',
                    ),
                    _FeatureItem(
                      icon: Icons.verified,
                      title: 'Document Verification',
                      description: 'Verify student documents and credentials securely',
                    ),
                    _FeatureItem(
                      icon: Icons.account_balance,
                      title: 'Financial Management',
                      description: 'Track payments, manage scholarships, and generate financial reports',
                    ),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.family_restroom,
                  title: 'For Parents',
                  subtitle: 'Stay connected to your child\'s education',
                  color: AppColors.parentRole,
                  description: 'Stay informed and engaged in your children\'s educational journey with real-time updates and comprehensive monitoring tools.',
                  features: [
                    _FeatureItem(
                      icon: Icons.bar_chart,
                      title: 'Progress Monitoring',
                      description: 'Track your children\'s academic performance, attendance, and achievements',
                    ),
                    _FeatureItem(
                      icon: Icons.notifications,
                      title: 'Real-time Updates',
                      description: 'Receive instant notifications about grades, assignments, and school events',
                    ),
                    _FeatureItem(
                      icon: Icons.chat,
                      title: 'Teacher Communication',
                      description: 'Connect directly with teachers and counselors about your child\'s progress',
                    ),
                    _FeatureItem(
                      icon: Icons.payment,
                      title: 'Fee Management',
                      description: 'View and pay school fees conveniently using mobile money',
                    ),
                    _FeatureItem(
                      icon: Icons.calendar_today,
                      title: 'Schedule Access',
                      description: 'View class schedules, exam dates, and school calendar events',
                    ),
                    _FeatureItem(
                      icon: Icons.report,
                      title: 'Report Cards',
                      description: 'Access detailed report cards and performance summaries',
                    ),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.psychology,
                  title: 'For Counselors',
                  subtitle: 'Guide students to their best future',
                  color: AppColors.counselorRole,
                  description: 'Empower your counseling practice with tools to manage sessions, track student progress, and provide personalized guidance.',
                  features: [
                    _FeatureItem(
                      icon: Icons.calendar_month,
                      title: 'Session Management',
                      description: 'Schedule, track, and document counseling sessions with students',
                    ),
                    _FeatureItem(
                      icon: Icons.people,
                      title: 'Student Portfolio',
                      description: 'Maintain comprehensive profiles and notes for each student you counsel',
                    ),
                    _FeatureItem(
                      icon: Icons.task,
                      title: 'Action Plans',
                      description: 'Create and monitor personalized action plans and goals for students',
                    ),
                    _FeatureItem(
                      icon: Icons.school,
                      title: 'College Guidance',
                      description: 'Help students explore programs and navigate the application process',
                    ),
                    _FeatureItem(
                      icon: Icons.assessment,
                      title: 'Career Assessment',
                      description: 'Provide career assessments and recommend suitable paths',
                    ),
                    _FeatureItem(
                      icon: Icons.handshake,
                      title: 'Parent Collaboration',
                      description: 'Coordinate with parents to support student success',
                    ),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.rate_review,
                  title: 'For Recommenders',
                  subtitle: 'Support students with powerful recommendations',
                  color: AppColors.recommenderRole,
                  description: 'Write, manage, and submit recommendation letters efficiently while maintaining your professional network.',
                  features: [
                    _FeatureItem(
                      icon: Icons.edit_document,
                      title: 'Letter Management',
                      description: 'Write, edit, and store recommendation letters with templates',
                    ),
                    _FeatureItem(
                      icon: Icons.send,
                      title: 'Easy Submission',
                      description: 'Submit recommendations directly to institutions securely',
                    ),
                    _FeatureItem(
                      icon: Icons.assignment_turned_in,
                      title: 'Request Tracking',
                      description: 'Track all recommendation requests and deadlines in one place',
                    ),
                    _FeatureItem(
                      icon: Icons.history,
                      title: 'Letter Templates',
                      description: 'Use customizable templates to streamline your writing process',
                    ),
                    _FeatureItem(
                      icon: Icons.verified_user,
                      title: 'Digital Signature',
                      description: 'Sign and verify letters digitally with secure authentication',
                    ),
                    _FeatureItem(
                      icon: Icons.timeline,
                      title: 'Student History',
                      description: 'Maintain records of students you\'ve recommended over time',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeDetails extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String description;
  final List<_FeatureItem> features;

  const _AccountTypeDetails({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.description,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 48, color: AppColors.textOnPrimary),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Features Grid
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: features.map((feature) {
                return Container(
                  width: 280,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(feature.icon, color: color, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feature.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // CTA Button
            ElevatedButton.icon(
              onPressed: () => context.go('/register'),
              icon: const Icon(Icons.arrow_forward),
              label: Text('Get Started as ${title.replaceAll("For ", "")}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _AccountTypesTabDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 56,
      color: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                'Who Can Use Flow: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              _TabButton(
                icon: Icons.school,
                label: 'Students',
                color: AppColors.studentRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.business,
                label: 'Institutions',
                color: AppColors.institutionRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.family_restroom,
                label: 'Parents',
                color: AppColors.parentRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.psychology,
                label: 'Counselors',
                color: AppColors.counselorRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.rate_review,
                label: 'Recommenders',
                color: AppColors.recommenderRole,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FindYourPathBenefit extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FindYourPathBenefit({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
