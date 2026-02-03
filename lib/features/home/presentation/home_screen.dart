import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/l10n_extension.dart';

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
                      // Language Toggle + Navigation Links
                      _LanguageToggle(),
                      const SizedBox(width: 8),
                      if (constraints.maxWidth > 1600) ...[
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.star, size: 18),
                          label: Text(context.l10n.homeNavFeatures),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.info, size: 18),
                          label: Text(context.l10n.homeNavAbout),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.contact_mail, size: 18),
                          label: Text(context.l10n.homeNavContact),
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
                          child: Text(context.l10n.homeNavLogin),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => context.go('/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(context.l10n.homeNavSignUp),
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
                                      title: Text(context.l10n.homeNavFeatures),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.info, color: AppColors.primary),
                                      title: Text(context.l10n.homeNavAbout),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.contact_mail, color: AppColors.primary),
                                      title: Text(context.l10n.homeNavContact),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    const Divider(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Text(
                                        context.l10n.homeNavAccountTypes,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.school, color: AppColors.studentRole),
                                      title: Text(context.l10n.homeNavStudents),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.business, color: AppColors.institutionRole),
                                      title: Text(context.l10n.homeNavInstitutions),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.family_restroom, color: AppColors.parentRole),
                                      title: Text(context.l10n.homeNavParents),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.psychology, color: AppColors.counselorRole),
                                      title: Text(context.l10n.homeNavCounselors),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.rate_review, color: AppColors.recommenderRole),
                                      title: Text(context.l10n.homeNavRecommenders),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      leading: Icon(Icons.login, color: AppColors.primary),
                                      title: Text(context.l10n.homeNavLogin),
                                      onTap: () {
                                        Navigator.pop(context);
                                        context.go('/login');
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.person_add, color: AppColors.primary),
                                      title: Text(context.l10n.homeNavSignUp),
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  // Badge/Tag above title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.accentLight],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.rocket_launch, color: AppColors.textPrimary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.homeNavBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.homeNavWelcome,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Text(
                      context.l10n.homeNavSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Primary CTA Buttons
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: Text(context.l10n.homeNavGetStarted),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login, size: 16),
                        label: Text(context.l10n.homeNavSignIn),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Platform Stats - Animated
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _AnimatedStatItem(
                        icon: Icons.verified_user,
                        targetValue: 50,
                        suffix: 'K+',
                        label: context.l10n.homeNavActiveUsers,
                        color: AppColors.primary,
                      ),
                      _AnimatedStatItem(
                        icon: Icons.business,
                        targetValue: 200,
                        suffix: '+',
                        label: context.l10n.homeNavInstitutions,
                        color: AppColors.secondary,
                      ),
                      _AnimatedStatItem(
                        icon: Icons.public,
                        targetValue: 20,
                        suffix: '+',
                        label: context.l10n.homeNavCountries,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Find Your Path Feature Highlight
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    // Badge + Icon row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.school, size: 28, color: Colors.white),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(context.l10n.homeNavNew, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.homeNavFindYourPath,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.homeNavFindYourPathDesc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Benefits
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        _FindYourPathBenefit(
                          icon: Icons.lightbulb_outline,
                          text: context.l10n.homeNavPersonalizedRec,
                        ),
                        _FindYourPathBenefit(
                          icon: Icons.school_outlined,
                          text: context.l10n.homeNavTopUniversities,
                        ),
                        _FindYourPathBenefit(
                          icon: Icons.analytics_outlined,
                          text: context.l10n.homeNavSmartMatching,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // CTA Button
                    ElevatedButton.icon(
                      onPressed: () => context.go('/find-your-path'),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(context.l10n.homeNavStartNow),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Key Features Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  Text(
                    context.l10n.homeNavPlatformFeatures,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _PlatformFeature(
                        icon: Icons.offline_bolt,
                        title: context.l10n.homeNavOfflineFirst,
                        description: context.l10n.homeNavOfflineFirstDesc,
                      ),
                      _PlatformFeature(
                        icon: Icons.payment,
                        title: context.l10n.homeNavMobileMoney,
                        description: context.l10n.homeNavMobileMoneyDesc,
                      ),
                      _PlatformFeature(
                        icon: Icons.language,
                        title: context.l10n.homeNavMultiLang,
                        description: context.l10n.homeNavMultiLangDesc,
                      ),
                      _PlatformFeature(
                        icon: Icons.security,
                        title: context.l10n.homeNavSecure,
                        description: context.l10n.homeNavSecureDesc,
                      ),
                      _PlatformFeature(
                        icon: Icons.phone_android,
                        title: context.l10n.homeNavUssd,
                        description: context.l10n.homeNavUssdDesc,
                      ),
                      _PlatformFeature(
                        icon: Icons.cloud_sync,
                        title: context.l10n.homeNavCloudSync,
                        description: context.l10n.homeNavCloudSyncDesc,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // How It Works Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  Text(
                    context.l10n.homeNavHowItWorks,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _HowItWorksStep(
                        step: '1',
                        icon: Icons.person_add,
                        title: context.l10n.homeNavCreateAccount,
                        description: context.l10n.homeNavCreateAccountDesc,
                      ),
                      _HowItWorksStep(
                        step: '2',
                        icon: Icons.dashboard,
                        title: context.l10n.homeNavAccessDashboard,
                        description: context.l10n.homeNavAccessDashboardDesc,
                      ),
                      _HowItWorksStep(
                        step: '3',
                        icon: Icons.explore,
                        title: context.l10n.homeNavExploreFeatures,
                        description: context.l10n.homeNavExploreFeaturesDesc,
                      ),
                      _HowItWorksStep(
                        step: '4',
                        icon: Icons.rocket_launch,
                        title: context.l10n.homeNavAchieveGoals,
                        description: context.l10n.homeNavAchieveGoalsDesc,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Testimonials Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  Text(
                    context.l10n.homeNavTrustedAcrossAfrica,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _TestimonialCard(
                        name: 'Amina Mensah',
                        role: context.l10n.homeNavTestimonialRole1,
                        quote: context.l10n.homeNavTestimonialQuote1,
                        avatarColor: AppColors.studentRole,
                      ),
                      _TestimonialCard(
                        name: 'Dr. Kwame Nkrumah',
                        role: context.l10n.homeNavTestimonialRole2,
                        quote: context.l10n.homeNavTestimonialQuote2,
                        avatarColor: AppColors.institutionRole,
                      ),
                      _TestimonialCard(
                        name: 'Sarah Okonkwo',
                        role: context.l10n.homeNavTestimonialRole3,
                        quote: context.l10n.homeNavTestimonialQuote3,
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  Text(
                    context.l10n.homeNavReadyToStart,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.homeNavJoinThousands,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add, size: 16),
                        label: Text(context.l10n.homeNavSignUp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login, size: 16),
                        label: Text(context.l10n.homeNavLogin),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary, width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, color: AppColors.accent, size: 20),
                      const SizedBox(width: 6),
                      Text(context.l10n.homeNavFlowEdTech, style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Quick Links
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: [
                      _FooterLink(label: context.l10n.homeNavAbout, onTap: () {}),
                      _FooterLink(label: context.l10n.homeNavContact, onTap: () {}),
                      _FooterLink(label: context.l10n.homeNavPrivacy, onTap: () {}),
                      _FooterLink(label: context.l10n.homeNavTerms, onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.homeNavCopyright, style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      InkWell(
                        onTap: _scrollToTop,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_upward, size: 12, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text(context.l10n.homeNavTop, style: TextStyle(color: AppColors.accent, fontSize: 10)),
                          ],
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

class _AnimatedStatItem extends StatefulWidget {
  final IconData icon;
  final int targetValue;
  final String suffix;
  final String label;
  final Color color;

  const _AnimatedStatItem({
    required this.icon,
    required this.targetValue,
    required this.suffix,
    required this.label,
    required this.color,
  });

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 28, color: widget.color),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                '${_animation.value.toInt()}${widget.suffix}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                  fontSize: 22,
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(description, style: TextStyle(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
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
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(step, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(description, style: TextStyle(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
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
      width: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: avatarColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: avatarColor,
                child: Text(name.split(' ').map((n) => n[0]).take(2).join(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    Text(role, style: TextStyle(color: avatarColor, fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => Icon(Icons.star, size: 12, color: AppColors.accent))),
          const SizedBox(height: 6),
          Text('"$quote"', style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic, fontSize: 10), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Text(context.l10n.homeNavWhoCanUse, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 10),

          // Tab Navigation
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.textOnPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(6)),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: [
                Tab(icon: Icon(Icons.school, size: 16), text: context.l10n.homeNavStudents),
                Tab(icon: Icon(Icons.business, size: 16), text: context.l10n.homeNavInstitutions),
                Tab(icon: Icon(Icons.family_restroom, size: 16), text: context.l10n.homeNavParents),
                Tab(icon: Icon(Icons.psychology, size: 16), text: context.l10n.homeNavCounselors),
                Tab(icon: Icon(Icons.rate_review, size: 16), text: context.l10n.homeNavRecommenders),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tab Content
          SizedBox(
            height: 350,
            child: TabBarView(
              controller: _tabController,
              children: [
                _AccountTypeDetails(
                  icon: Icons.school,
                  title: context.l10n.homeNavForStudents,
                  subtitle: context.l10n.homeNavForStudentsSubtitle,
                  color: AppColors.studentRole,
                  description: context.l10n.homeNavForStudentsDesc,
                  features: [
                    _FeatureItem(icon: Icons.book, title: context.l10n.homeNavCourseAccess, description: context.l10n.homeNavCourseAccessDesc),
                    _FeatureItem(icon: Icons.assignment, title: context.l10n.homeNavAppManagement, description: context.l10n.homeNavAppManagementDesc),
                    _FeatureItem(icon: Icons.bar_chart, title: context.l10n.homeNavProgressTracking, description: context.l10n.homeNavProgressTrackingDesc),
                    _FeatureItem(icon: Icons.description, title: context.l10n.homeNavDocManagement, description: context.l10n.homeNavDocManagementDesc),
                    _FeatureItem(icon: Icons.payment, title: context.l10n.homeNavEasyPayments, description: context.l10n.homeNavEasyPaymentsDesc),
                    _FeatureItem(icon: Icons.offline_bolt, title: context.l10n.homeNavOfflineAccess, description: context.l10n.homeNavOfflineAccessDesc),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.business,
                  title: context.l10n.homeNavForInstitutions,
                  subtitle: context.l10n.homeNavForInstitutionsSubtitle,
                  color: AppColors.institutionRole,
                  description: context.l10n.homeNavForInstitutionsDesc,
                  features: [
                    _FeatureItem(icon: Icons.people, title: context.l10n.homeNavApplicantMgmt, description: context.l10n.homeNavApplicantMgmtDesc),
                    _FeatureItem(icon: Icons.school, title: context.l10n.homeNavProgramMgmt, description: context.l10n.homeNavProgramMgmtDesc),
                    _FeatureItem(icon: Icons.analytics, title: context.l10n.homeNavAnalyticsDash, description: context.l10n.homeNavAnalyticsDashDesc),
                    _FeatureItem(icon: Icons.message, title: context.l10n.homeNavCommHub, description: context.l10n.homeNavCommHubDesc),
                    _FeatureItem(icon: Icons.verified, title: context.l10n.homeNavDocVerification, description: context.l10n.homeNavDocVerificationDesc),
                    _FeatureItem(icon: Icons.account_balance, title: context.l10n.homeNavFinancialMgmt, description: context.l10n.homeNavFinancialMgmtDesc),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.family_restroom,
                  title: context.l10n.homeNavForParents,
                  subtitle: context.l10n.homeNavForParentsSubtitle,
                  color: AppColors.parentRole,
                  description: context.l10n.homeNavForParentsDesc,
                  features: [
                    _FeatureItem(icon: Icons.bar_chart, title: context.l10n.homeNavProgressMonitoring, description: context.l10n.homeNavProgressMonitoringDesc),
                    _FeatureItem(icon: Icons.notifications, title: context.l10n.homeNavRealtimeUpdates, description: context.l10n.homeNavRealtimeUpdatesDesc),
                    _FeatureItem(icon: Icons.chat, title: context.l10n.homeNavTeacherComm, description: context.l10n.homeNavTeacherCommDesc),
                    _FeatureItem(icon: Icons.payment, title: context.l10n.homeNavFeeMgmt, description: context.l10n.homeNavFeeMgmtDesc),
                    _FeatureItem(icon: Icons.calendar_today, title: context.l10n.homeNavScheduleAccess, description: context.l10n.homeNavScheduleAccessDesc),
                    _FeatureItem(icon: Icons.report, title: context.l10n.homeNavReportCards, description: context.l10n.homeNavReportCardsDesc),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.psychology,
                  title: context.l10n.homeNavForCounselors,
                  subtitle: context.l10n.homeNavForCounselorsSubtitle,
                  color: AppColors.counselorRole,
                  description: context.l10n.homeNavForCounselorsDesc,
                  features: [
                    _FeatureItem(icon: Icons.calendar_month, title: context.l10n.homeNavSessionMgmt, description: context.l10n.homeNavSessionMgmtDesc),
                    _FeatureItem(icon: Icons.people, title: context.l10n.homeNavStudentPortfolio, description: context.l10n.homeNavStudentPortfolioDesc),
                    _FeatureItem(icon: Icons.task, title: context.l10n.homeNavActionPlans, description: context.l10n.homeNavActionPlansDesc),
                    _FeatureItem(icon: Icons.school, title: context.l10n.homeNavCollegeGuidance, description: context.l10n.homeNavCollegeGuidanceDesc),
                    _FeatureItem(icon: Icons.assessment, title: context.l10n.homeNavCareerAssessment, description: context.l10n.homeNavCareerAssessmentDesc),
                    _FeatureItem(icon: Icons.handshake, title: context.l10n.homeNavParentCollab, description: context.l10n.homeNavParentCollabDesc),
                  ],
                ),
                _AccountTypeDetails(
                  icon: Icons.rate_review,
                  title: context.l10n.homeNavForRecommenders,
                  subtitle: context.l10n.homeNavForRecommendersSubtitle,
                  color: AppColors.recommenderRole,
                  description: context.l10n.homeNavForRecommendersDesc,
                  features: [
                    _FeatureItem(icon: Icons.edit_document, title: context.l10n.homeNavLetterMgmt, description: context.l10n.homeNavLetterMgmtDesc),
                    _FeatureItem(icon: Icons.send, title: context.l10n.homeNavEasySubmission, description: context.l10n.homeNavEasySubmissionDesc),
                    _FeatureItem(icon: Icons.assignment_turned_in, title: context.l10n.homeNavRequestTracking, description: context.l10n.homeNavRequestTrackingDesc),
                    _FeatureItem(icon: Icons.history, title: context.l10n.homeNavLetterTemplates, description: context.l10n.homeNavLetterTemplatesDesc),
                    _FeatureItem(icon: Icons.verified_user, title: context.l10n.homeNavDigitalSignature, description: context.l10n.homeNavDigitalSignatureDesc),
                    _FeatureItem(icon: Icons.timeline, title: context.l10n.homeNavStudentHistory, description: context.l10n.homeNavStudentHistoryDesc),
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
                      Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Features Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: features.take(4).map((feature) {
              return Container(
                width: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(feature.icon, color: color, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(feature.title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // CTA Button
          ElevatedButton(
            onPressed: () => context.go('/register'),
            child: Text(context.l10n.homeNavGetStartedAs(title.replaceAll(context.l10n.homeNavForPrefix, ''))),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
                '${context.l10n.homeNavWhoCanUse}: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              _TabButton(
                icon: Icons.school,
                label: context.l10n.homeNavStudents,
                color: AppColors.studentRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.business,
                label: context.l10n.homeNavInstitutions,
                color: AppColors.institutionRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.family_restroom,
                label: context.l10n.homeNavParents,
                color: AppColors.parentRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.psychology,
                label: context.l10n.homeNavCounselors,
                color: AppColors.counselorRole,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _TabButton(
                icon: Icons.rate_review,
                label: context.l10n.homeNavRecommenders,
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

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isEnglish = locale.languageCode == 'en';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isEnglish ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isEnglish ? AppColors.textOnPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('fr')),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: !isEnglish ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'FR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: !isEnglish ? AppColors.textOnPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10)),
        ],
      ),
    );
  }
}
