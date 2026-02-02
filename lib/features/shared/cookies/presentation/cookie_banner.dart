// lib/features/shared/cookies/presentation/cookie_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import 'cookie_preferences_modal.dart';

class CookieBanner extends ConsumerStatefulWidget {
  const CookieBanner({super.key});

  @override
  ConsumerState<CookieBanner> createState() => _CookieBannerState();
}

class _CookieBannerState extends ConsumerState<CookieBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _checkIfNeedsConsent();
  }

  Future<void> _checkIfNeedsConsent() async {
    final userId = ref.read(currentUserIdProvider);

    // Don't show banner if user is not logged in
    if (userId == null) return;

    // Check if banner was already handled this session
    final alreadyHandled = ref.read(cookieBannerHandledProvider);
    if (alreadyHandled) return;

    final needsConsent = await ref.read(
      consentNeededProvider(userId).future,
    );

    if (needsConsent && mounted) {
      setState(() => _isVisible = true);
      _animationController.forward();
    } else {
      // Consent already given, mark as handled for this session
      ref.read(cookieBannerHandledProvider.notifier).markAsHandled();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _acceptAll() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final service = ref.read(consentServiceProvider);
    final accessToken = ref.read(accessTokenProvider);
    final success = await service.acceptAll(userId, accessToken: accessToken);

    if (success && mounted) {
      // Mark as handled for this session to prevent re-showing
      ref.read(cookieBannerHandledProvider.notifier).markAsHandled();

      await _animationController.reverse();
      setState(() => _isVisible = false);

      // Start analytics session
      final analytics = ref.read(analyticsServiceProvider);
      await analytics.startSession(userId);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.cookiePreferencesSaved),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _acceptEssential() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final service = ref.read(consentServiceProvider);
    final accessToken = ref.read(accessTokenProvider);
    final success = await service.acceptEssentialOnly(userId, accessToken: accessToken);

    if (success && mounted) {
      // Mark as handled for this session to prevent re-showing
      ref.read(cookieBannerHandledProvider.notifier).markAsHandled();

      await _animationController.reverse();
      setState(() => _isVisible = false);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.cookieEssentialOnly),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showPreferences() {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CookiePreferencesModal(userId: userId),
    ).then((saved) {
      if (saved == true && mounted) {
        // Mark as handled for this session to prevent re-showing
        ref.read(cookieBannerHandledProvider.notifier).markAsHandled();
        _animationController.reverse();
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cookie,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.cookieWeUseCookies,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.cookieBannerDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: _acceptAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(context.l10n.cookieAcceptAll),
                  ),
                  OutlinedButton(
                    onPressed: _acceptEssential,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(context.l10n.cookieEssentialOnly),
                  ),
                  TextButton(
                    onPressed: _showPreferences,
                    child: Text(context.l10n.cookieCustomize),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to privacy policy
                      // context.push('/privacy-policy');
                    },
                    child: Text(context.l10n.cookiePrivacyPolicy),
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
