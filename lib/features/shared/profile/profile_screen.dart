import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../authentication/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/logo_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(profileLoadingProvider);
    final user = ref.watch(currentProfileProvider);
    final error = ref.watch(profileErrorProvider);
    final completeness = ref.watch(profileCompletenessProvider);
    final theme = Theme.of(context);

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileProvider.notifier).loadProfile();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Loading profile...'),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: showBackButton ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ) : null,
        automaticallyImplyLeading: showBackButton,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/profile/edit');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Completeness Indicator
              if (completeness < 100)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile $completeness% Complete',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complete your profile to unlock all features',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Profile Header
              CustomCard(
                child: Column(
                  children: [
                    LogoAvatar.user(
                      photoUrl: user.photoUrl,
                      initials: user.initials,
                      size: 100,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.getRoleColor(user.activeRole.name)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.getRoleColor(user.activeRole.name)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.getRoleColor(user.activeRole.name),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.activeRole.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.getRoleColor(user.activeRole.name),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Profile Information
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _ProfileInfoRow(
                    icon: Icons.person,
                    label: 'Full Name',
                    value: user.displayName ?? 'Not set',
                  ),
                  const Divider(),
                  _ProfileInfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: user.email,
                  ),
                  if (user.phoneNumber != null) ...[
                    const Divider(),
                    _ProfileInfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: user.phoneNumber!,
                    ),
                  ],
                  const Divider(),
                  _ProfileInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Member Since',
                    value:
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Status
            Text(
              'Account Status',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _ProfileInfoRow(
                    icon: user.isEmailVerified
                        ? Icons.check_circle
                        : Icons.cancel,
                    label: 'Email Verification',
                    value: user.isEmailVerified ? 'Verified' : 'Not Verified',
                    valueColor: user.isEmailVerified
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  const Divider(),
                  _ProfileInfoRow(
                    icon: user.isPhoneVerified
                        ? Icons.check_circle
                        : Icons.cancel,
                    label: 'Phone Verification',
                    value: user.isPhoneVerified ? 'Verified' : 'Not Verified',
                    valueColor: user.isPhoneVerified
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ],
              ),
            ),

            // Available Roles
            if (user.hasMultipleRoles) ...[
              const SizedBox(height: 24),
              Text(
                'Available Roles',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Column(
                  children: user.availableRoles.map((role) {
                    final isActive = role == user.activeRole;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.getRoleColor(role.name),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              role.displayName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isActive)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 20,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/profile/edit');
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/profile/change-password');
                },
                icon: const Icon(Icons.lock),
                label: const Text('Change Password'),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
