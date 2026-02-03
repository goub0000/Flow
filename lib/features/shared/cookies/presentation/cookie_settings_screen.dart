// lib/features/shared/cookies/presentation/cookie_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/l10n_extension.dart';
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
        title: Text(context.l10n.cookieSettingsTitle),
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
              Text(context.l10n.sharedCookiesErrorLoadingConsent(error.toString())),
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
                  Text(context.l10n.cookieNoConsentData),
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
                    child: Text(context.l10n.cookieSetPreferences),
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
                                    ? context.l10n.cookieConsentActive
                                    : context.l10n.cookieNoConsentGiven,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.sharedCookiesUpdated(_formatDate(consent.timestamp)),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (consent.expiresAt != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.sharedCookiesExpires(_formatDate(consent.expiresAt!)),
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
                  context.l10n.cookieCurrentPreferences,
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
                    label: Text(context.l10n.cookieChangePreferences),
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
                    label: Text(context.l10n.cookieExportMyData),
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
                    label: Text(context.l10n.cookieDeleteMyData),
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
                            Text(
                              context.l10n.cookieAboutCookies,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.cookieAboutDescription,
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
                          child: Text(context.l10n.cookieReadPrivacyPolicy),
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
        title: Text(context.l10n.cookieExportData),
        content: Text(
          context.l10n.cookieExportDataDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cookieCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.cookieExport),
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
            content: Text(context.l10n.sharedCookiesDataExportedRecords(data['dataCount'].toString())),
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
        title: Text(context.l10n.cookieDeleteData),
        content: Text(
          context.l10n.cookieDeleteDataDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cookieCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.cookieDelete),
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
          SnackBar(
            content: Text(context.l10n.cookieDataDeletedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh consent
        ref.invalidate(userConsentProvider(userId));
      }
    }
  }
}
