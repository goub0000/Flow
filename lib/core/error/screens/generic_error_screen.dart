import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

/// Generic Error Screen - Can be customized for different error types
class GenericErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final bool showBackButton;
  final bool showHomeButton;
  final Widget? customAction;

  const GenericErrorScreen({
    this.title,
    this.message,
    this.icon,
    this.onRetry,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.customAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon ?? Icons.error_outline,
                      size: 80,
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  title ?? 'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  message ??
                      'An unexpected error occurred. Please try again or contact support if the problem persists.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Custom Action or Default Actions
                if (customAction != null)
                  customAction!
                else
                  _buildDefaultActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Column(
      children: [
        // Retry Button
        if (onRetry != null)
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 48),
            ),
          ),
        if (onRetry != null) const SizedBox(height: 16),

        // Navigation Buttons
        if (showBackButton || showHomeButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showBackButton && context.canPop())
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              if (showBackButton && showHomeButton && context.canPop())
                const SizedBox(width: 16),
              if (showHomeButton)
                OutlinedButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home, size: 20),
                  label: const Text('Go Home'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
