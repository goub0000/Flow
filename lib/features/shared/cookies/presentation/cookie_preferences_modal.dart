// lib/features/shared/cookies/presentation/cookie_preferences_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/theme/app_colors.dart';

class CookiePreferencesModal extends ConsumerStatefulWidget {
  final String userId;

  const CookiePreferencesModal({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<CookiePreferencesModal> createState() =>
      _CookiePreferencesModalState();
}

class _CookiePreferencesModalState
    extends ConsumerState<CookiePreferencesModal> {
  final Map<CookieCategory, bool> _selections = {
    CookieCategory.essential: true,
    CookieCategory.functional: true,
    CookieCategory.analytics: true,
    CookieCategory.marketing: true,
  };

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentConsent();
  }

  Future<void> _loadCurrentConsent() async {
    final consent = await ref.read(
      userConsentProvider(widget.userId).future,
    );

    if (consent != null && mounted) {
      setState(() {
        _selections.addAll(consent.categoryConsents);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    final service = ref.read(consentServiceProvider);
    final success = await service.updateConsent(widget.userId, _selections);

    if (mounted) {
      if (success) {
        // Start/stop analytics based on selection
        if (_selections[CookieCategory.analytics] == true) {
          final analytics = ref.read(analyticsServiceProvider);
          await analytics.startSession(widget.userId);
        }

        Navigator.of(context).pop(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cookie preferences saved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preferences. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.tune, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cookie Preferences',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize your cookie preferences. Essential cookies are always enabled.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    ...CookieCategory.values.map((category) {
                      final isEssential = category == CookieCategory.essential;
                      return _CategoryCard(
                        category: category,
                        isEnabled: _selections[category] ?? false,
                        isLocked: isEssential,
                        onChanged: isEssential
                            ? null
                            : (value) {
                                setState(() {
                                  _selections[category] = value;
                                });
                              },
                      );
                    }),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSaving
                                ? null
                                : () {
                                    setState(() {
                                      _selections[CookieCategory.functional] =
                                          false;
                                      _selections[CookieCategory.analytics] =
                                          false;
                                      _selections[CookieCategory.marketing] =
                                          false;
                                    });
                                  },
                            child: const Text('Reject All'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _savePreferences,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save Preferences'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CookieCategory category;
  final bool isEnabled;
  final bool isLocked;
  final ValueChanged<bool>? onChanged;

  const _CategoryCard({
    required this.category,
    required this.isEnabled,
    required this.isLocked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  category.icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Always Active',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                else
                  Switch(
                    value: isEnabled,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
