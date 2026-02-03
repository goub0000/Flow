import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart

/// Placeholder screen for admin features not yet implemented
class AdminPlaceholderScreen extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;

  const AdminPlaceholderScreen({
    required this.title,
    this.description,
    this.icon = Icons.construction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Center(
      child: Container(
          padding: const EdgeInsets.all(48),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 120,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description ?? context.l10n.adminSharedFeatureUnderDevelopment,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(context.l10n.adminSharedGoBack),
              ),
            ],
          ),
        ),
    );
  }
}
