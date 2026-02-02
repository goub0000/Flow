import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Email Verification Screen
///
/// Displayed after user registers to verify their email address.
/// Features auto-checking for verification status and manual refresh.
///
/// Backend Integration TODO:
/// ```dart
/// // Option 1: Supabase Auth
/// import 'package:supabase_flutter/supabase_flutter.dart';
///
/// class EmailVerificationService {
///   final _supabase = Supabase.instance.client;
///
///   Future<bool> isEmailVerified() async {
///     final user = _supabase.auth.currentUser;
///     return user?.emailConfirmedAt != null;
///   }
///
///   Future<void> sendVerificationEmail() async {
///     await _supabase.auth.resend(type: OtpType.signup);
///   }
/// }
///
/// // Option 2: Custom API
/// import 'package:dio/dio.dart';
///
/// class EmailVerificationService {
///   final Dio _dio;
///
///   Future<bool> isEmailVerified() async {
///     final response = await _dio.get('/auth/email-verification-status');
///     return response.data['verified'] == true;
///   }
///
///   Future<void> sendVerificationEmail() async {
///     await _dio.post('/auth/resend-verification-email');
///   }
/// }
/// ```

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback? onVerified;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.onVerified,
  });

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _canResend = true;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  Timer? _autoCheckTimer;

  @override
  void initState() {
    super.initState();
    // Auto-check verification status every 5 seconds
    _autoCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkVerificationStatus(silent: true),
    );
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _autoCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerificationStatus({bool silent = false}) async {
    if (!silent) {
      setState(() => _isChecking = true);
    }

    try {
      // TODO: Integrate with actual backend
      // final isVerified = await emailVerificationService.isEmailVerified();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      final isVerified = false; // Change to true to test success flow

      if (mounted) {
        if (!silent) {
          setState(() => _isChecking = false);
        }

        if (isVerified) {
          _autoCheckTimer?.cancel();
          _showSuccessAndNavigate();
        } else if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.emailVerifyNotYet),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted && !silent) {
        setState(() => _isChecking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.emailVerifyCheckError(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _resendCooldown = 60; // 60 seconds cooldown
    });

    // Start cooldown timer
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_resendCooldown > 0) {
          setState(() => _resendCooldown--);
        } else {
          timer.cancel();
          setState(() => _canResend = true);
        }
      },
    );

    try {
      // TODO: Integrate with actual backend
      // await emailVerificationService.sendVerificationEmail();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.emailVerifySent),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.emailVerifySendFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
        // Reset cooldown on error
        setState(() {
          _canResend = true;
          _resendCooldown = 0;
        });
        _cooldownTimer?.cancel();
      }
    }
  }

  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 50,
                      color: AppColors.success,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.emailVerifySuccess,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.emailVerifySuccessMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );

    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        widget.onVerified?.call();
        context.go('/student/dashboard'); // Or appropriate dashboard
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.emailVerifyAppBarTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Icon with Animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - value)),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                size: 60,
                                color: AppColors.primary,
                              ),
                              Positioned(
                                right: 20,
                                top: 20,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: AppColors.warning,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.priority_high,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  context.l10n.emailVerifyTitle,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  context.l10n.emailVerifySentTo,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Instructions Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.emailVerifyNextSteps,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInstructionStep(
                        '1',
                        context.l10n.emailVerifyStep1,
                      ),
                      const SizedBox(height: 12),
                      _buildInstructionStep(
                        '2',
                        context.l10n.emailVerifyStep2,
                      ),
                      const SizedBox(height: 12),
                      _buildInstructionStep(
                        '3',
                        context.l10n.emailVerifyStep3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Check Status Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _checkVerificationStatus,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _isChecking ? context.l10n.emailVerifyChecking : context.l10n.emailVerifyCheckButton,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Resend Button
                SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _canResend ? _resendVerificationEmail : null,
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      _canResend
                          ? context.l10n.emailVerifyResend
                          : context.l10n.emailVerifyResendIn(_resendCooldown),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Help Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: AppColors.warning,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.emailVerifyDidntReceive,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• ${context.l10n.emailVerifySpamTip}\n• ${context.l10n.emailVerifyCorrectTip}\n• ${context.l10n.emailVerifyWaitTip}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Auto-check indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.emailVerifyAutoCheck,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
