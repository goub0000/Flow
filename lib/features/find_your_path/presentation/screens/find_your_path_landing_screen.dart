import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../application/providers/find_your_path_provider.dart';

/// Landing screen for Find Your Path feature
class FindYourPathLandingScreen extends ConsumerWidget {
  const FindYourPathLandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userId = authState.user?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.fypTitle),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Section
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.l10n.fypHeroTitle,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.fypHeroSubtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // How It Works Section
                Text(
                  context.l10n.fypHowItWorks,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildStep(
                  number: '1',
                  title: context.l10n.fypStep1Title,
                  description: context.l10n.fypStep1Description,
                  icon: Icons.edit_note,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),

                _buildStep(
                  number: '2',
                  title: context.l10n.fypStep2Title,
                  description: context.l10n.fypStep2Description,
                  icon: Icons.auto_awesome,
                  color: AppColors.success,
                ),
                const SizedBox(height: 16),

                _buildStep(
                  number: '3',
                  title: context.l10n.fypStep3Title,
                  description: context.l10n.fypStep3Description,
                  icon: Icons.check_circle,
                  color: AppColors.info,
                ),

                const SizedBox(height: 40),

                // Features Section
                Text(
                  context.l10n.fypWhatYoullGet,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildFeatureChip(
                      icon: Icons.analytics,
                      label: context.l10n.fypFeatureMatchScore,
                      color: AppColors.primary,
                    ),
                    _buildFeatureChip(
                      icon: Icons.category,
                      label: context.l10n.fypFeatureSafetyMatchReach,
                      color: AppColors.success,
                    ),
                    _buildFeatureChip(
                      icon: Icons.attach_money,
                      label: context.l10n.fypFeatureCostAnalysis,
                      color: AppColors.warning,
                    ),
                    _buildFeatureChip(
                      icon: Icons.psychology,
                      label: context.l10n.fypFeatureDetailedInsights,
                      color: AppColors.info,
                    ),
                    _buildFeatureChip(
                      icon: Icons.favorite,
                      label: context.l10n.fypFeatureSaveFavorites,
                      color: AppColors.error,
                    ),
                    _buildFeatureChip(
                      icon: Icons.compare,
                      label: context.l10n.fypFeatureCompareOptions,
                      color: AppColors.primary,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // CTA Button
                ElevatedButton(
                  onPressed: () {
                    context.push('/find-your-path/questionnaire');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.fypGetStarted,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Secondary Button - View Existing Results
                FutureBuilder<bool>(
                  future: ref
                      .read(findYourPathServiceProvider)
                      .profileExists(userId),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return OutlinedButton(
                        onPressed: () {
                          context.push('/find-your-path/results');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          context.l10n.fypViewMyRecommendations,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 40),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.fypDisclaimer,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
