import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Careers page showing job opportunities - fetches content from CMS
class CareersPage extends ConsumerWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(context.l10n.careersPageTitle),
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
                // Hero section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.accent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.rocket_launch,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.careersPageJoinMission,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.careersPageHeroSubtitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Why Join Us
                Text(
                  context.l10n.careersPageWhyJoin,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildBenefitCard(theme, Icons.public, context.l10n.careersPageGlobalImpact,
                        context.l10n.careersPageGlobalImpactDesc),
                    _buildBenefitCard(theme, Icons.trending_up, context.l10n.careersPageGrowth,
                        context.l10n.careersPageGrowthDesc),
                    _buildBenefitCard(theme, Icons.groups, context.l10n.careersPageGreatTeam,
                        context.l10n.careersPageGreatTeamDesc),
                    _buildBenefitCard(theme, Icons.work_outline, context.l10n.careersPageFlexibility,
                        context.l10n.careersPageFlexibilityDesc),
                  ],
                ),

                const SizedBox(height: 40),

                // Open Positions
                Text(
                  context.l10n.careersPageOpenPositions,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                _buildJobCard(
                  context,
                  theme,
                  title: context.l10n.careersPageJobSeniorFlutter,
                  department: context.l10n.careersPageDepartmentEngineering,
                  location: context.l10n.careersPageLocationRemoteAfrica,
                  type: context.l10n.careersPageTypeFullTime,
                ),
                _buildJobCard(
                  context,
                  theme,
                  title: context.l10n.careersPageJobBackendEngineer,
                  department: context.l10n.careersPageDepartmentEngineering,
                  location: context.l10n.careersPageLocationAccra,
                  type: context.l10n.careersPageTypeFullTime,
                ),
                _buildJobCard(
                  context,
                  theme,
                  title: context.l10n.careersPageJobProductDesigner,
                  department: context.l10n.careersPageDepartmentDesign,
                  location: context.l10n.careersPageLocationRemoteAfrica,
                  type: context.l10n.careersPageTypeFullTime,
                ),
                _buildJobCard(
                  context,
                  theme,
                  title: context.l10n.careersPageJobContentSpecialist,
                  department: context.l10n.careersPageDepartmentContent,
                  location: context.l10n.careersPageLocationLagos,
                  type: context.l10n.careersPageTypeFullTime,
                ),
                _buildJobCard(
                  context,
                  theme,
                  title: context.l10n.careersPageJobCustomerSuccess,
                  department: context.l10n.careersPageDepartmentOperations,
                  location: context.l10n.careersPageLocationNairobi,
                  type: context.l10n.careersPageTypeFullTime,
                ),

                const SizedBox(height: 40),

                // Don't see a fit?
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.careersPageNoFit,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.careersPageNoFitDesc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/contact'),
                        icon: const Icon(Icons.send),
                        label: Text(context.l10n.careersPageContactUs),
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

  Widget _buildBenefitCard(ThemeData theme, IconData icon, String title, String description) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    ThemeData theme, {
    required String title,
    required String department,
    required String location,
    required String type,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildJobTag(theme, Icons.business, department),
                    _buildJobTag(theme, Icons.location_on, location),
                    _buildJobTag(theme, Icons.schedule, type),
                  ],
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: Text(context.l10n.careersPageApply),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTag(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
