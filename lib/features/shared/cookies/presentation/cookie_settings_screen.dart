// lib/features/shared/cookies/presentation/cookie_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/cookie_constants.dart';
import 'cookie_preferences_modal.dart';

class CookieSettingsScreen extends ConsumerWidget {
  final String userId;

  const CookieSettingsScreen({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(userConsentProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: consentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading consent: $error'),
            ],
          ),
        ),
        data: (consent) {
          if (consent == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cookie, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No consent data available'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CookiePreferencesModal(
                          userId: userId,
                        ),
                      ).then((_) {
                        ref.invalidate(userConsentProvider(userId));
                      });
                    },
                    child: const Text('Set Preferences'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status card
                Card(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          consent.status != ConsentStatus.notAsked
                              ? Icons.check_circle
                              : Icons.info,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                consent.status != ConsentStatus.notAsked
                                    ? 'Consent Active'
                                    : 'No Consent Given',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Updated: ${_formatDate(consent.timestamp)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (consent.expiresAt != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Expires: ${_formatDate(consent.expiresAt!)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Current preferences
                Text(
                  'Current Preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                ...consent.categoryConsents.entries.map((entry) {
                  final category = entry.key;
                  final enabled = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        category.icon,
                        color: enabled ? AppColors.primary : Colors.grey,
                      ),
                      title: Text(category.displayName),
                      subtitle: Text(category.description),
                      trailing: Icon(
                        enabled ? Icons.check_circle : Icons.cancel,
                        color: enabled ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CookiePreferencesModal(
                          userId: userId,
                        ),
                      ).then((_) {
                        // Refresh consent data
                        ref.invalidate(userConsentProvider(userId));
                      });
                    },
                    icon: const Icon(Icons.tune),
                    label: const Text('Change Preferences'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _exportData(context, ref),
                    icon: const Icon(Icons.download),
                    label: const Text('Export My Data'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteData(context, ref),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete My Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Info section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              'About Cookies',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cookies help us provide you with a better experience. '
                          'You can change your preferences at any time. '
                          'Essential cookies are always active for security and functionality.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            // Navigate to privacy policy
                            context.push('/privacy-policy');
                          },
                          child: const Text('Read Privacy Policy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This will create a file with all your cookie and consent data. '
          'The file will be saved to your downloads folder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final service = ref.read(cookieServiceProvider);
      final data = await service.exportUserData(userId);

      // In production, trigger file download
      // For now, show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported: ${data['dataCount']} records'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Data'),
        content: const Text(
          'This will permanently delete all your cookie data. '
          'Essential cookies required for the app to function will remain. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cookieService = ref.read(cookieServiceProvider);

      // Delete functional, analytics, and marketing data
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.functional,
      );
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.analytics,
      );
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.marketing,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh consent
        ref.invalidate(userConsentProvider(userId));
      }
    }
  }
}
