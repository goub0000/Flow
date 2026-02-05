import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import '../../../../core/l10n_extension.dart';
import '../widgets/dynamic_page_wrapper.dart';

/// Partners page showing partnership opportunities - fetches content from CMS
class PartnersPage extends ConsumerWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildDynamicPage(BuildContext context, PublicPageContent content) {
    final theme = Theme.of(context);
    final sections = content.getSections();
    final partnerships = content.getList('partnerships');
    final currentPartners = content.getList('current_partners');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(content.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.handshake, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        content.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (content.subtitle != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          content.subtitle!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Partnership Types
                if (partnerships.isNotEmpty) ...[
                  Text(
                    'Partnership Opportunities',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ...partnerships.map((p) {
                    final partnership = p as Map<String, dynamic>;
                    final benefits = (partnership['benefits'] as List<dynamic>?)
                            ?.map((b) => b.toString())
                            .toList() ??
                        [];
                    return _buildPartnershipCard(
                      theme,
                      icon: _getPartnerIcon(partnership['icon']?.toString()),
                      title: partnership['title']?.toString() ?? '',
                      description: partnership['description']?.toString() ?? '',
                      benefits: benefits,
                    );
                  }),

                  const SizedBox(height: 40),
                ],

                // Sections from CMS
                if (sections.isNotEmpty)
                  ContentSectionsWidget(sections: sections),

                // Current Partners
                if (currentPartners.isNotEmpty) ...[
                  Text(
                    'Our Partners',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: currentPartners
                        .map((partner) => _buildPartnerLogo(theme, partner.toString()))
                        .toList(),
                  ),

                  const SizedBox(height: 40),
                ],

                // CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.partnersPageReadyToPartner,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.partnersPageLetsDiscuss,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.go('/contact'),
                        icon: const Icon(Icons.mail),
                        label: Text(context.l10n.partnersPageContactTeam),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPartnerIcon(String? iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'support_agent':
        return Icons.support_agent;
      case 'business':
        return Icons.business;
      case 'public':
        return Icons.public;
      default:
        return Icons.handshake;
    }
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(context.l10n.partnersPageTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.handshake, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.partnersPageHeroTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.partnersPageHeroSubtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Partnership Types
                Text(
                  context.l10n.partnersPageOpportunities,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                _buildPartnershipCard(
                  theme,
                  icon: Icons.school,
                  title: context.l10n.partnersPageUniversities,
                  description: context.l10n.partnersPageUniversitiesDesc,
                  benefits: [
                    context.l10n.partnersPageBenefitDirectAccess,
                    context.l10n.partnersPageBenefitAppManagement,
                    context.l10n.partnersPageBenefitAnalytics,
                    context.l10n.partnersPageBenefitBrandVisibility,
                  ],
                ),

                _buildPartnershipCard(
                  theme,
                  icon: Icons.support_agent,
                  title: context.l10n.partnersPageCounselors,
                  description: context.l10n.partnersPageCounselorsDesc,
                  benefits: [
                    context.l10n.partnersPageBenefitClientManagement,
                    context.l10n.partnersPageBenefitStudentMatching,
                    context.l10n.partnersPageBenefitScheduling,
                    context.l10n.partnersPageBenefitRevenue,
                  ],
                ),

                _buildPartnershipCard(
                  theme,
                  icon: Icons.business,
                  title: context.l10n.partnersPageCorporate,
                  description: context.l10n.partnersPageCorporateDesc,
                  benefits: [
                    context.l10n.partnersPageBenefitCsrVisibility,
                    context.l10n.partnersPageBenefitTalentPipeline,
                    context.l10n.partnersPageBenefitBrandAssociation,
                    context.l10n.partnersPageBenefitImpactReporting,
                  ],
                ),

                _buildPartnershipCard(
                  theme,
                  icon: Icons.public,
                  title: context.l10n.partnersPageNgo,
                  description: context.l10n.partnersPageNgoDesc,
                  benefits: [
                    context.l10n.partnersPageBenefitDataInsights,
                    context.l10n.partnersPageBenefitPlatformIntegration,
                    context.l10n.partnersPageBenefitReachScale,
                    context.l10n.partnersPageBenefitImpactMeasurement,
                  ],
                ),

                const SizedBox(height: 40),

                // Current Partners
                Text(
                  context.l10n.partnersPageOurPartners,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerUnivGhana),
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerAshesi),
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerKenyatta),
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerUnilag),
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerKnust),
                    _buildPartnerLogo(theme, context.l10n.partnersPagePartnerMakerere),
                  ],
                ),

                const SizedBox(height: 40),

                // CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.partnersPageReadyToPartner,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.partnersPageLetsDiscuss,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context.go('/contact'),
                        icon: const Icon(Icons.mail),
                        label: Text(context.l10n.partnersPageContactTeam),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnershipCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required List<String> benefits,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: benefits
                      .map((b) => Chip(
                            label: Text(b, style: const TextStyle(fontSize: 12)),
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerLogo(ThemeData theme, String name) {
    return Container(
      width: 140,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          name,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
