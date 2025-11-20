import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../providers/profile_provider.dart';
import '../widgets/custom_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/logo_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure profile is loaded when the widget is initialized
    // This is crucial for when the ProfileScreen is used as a tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileIfNeeded();
    });
  }

  void _loadProfileIfNeeded() {
    print('[DEBUG] ProfileScreen._loadProfileIfNeeded() called');
    final user = ref.read(currentProfileProvider);
    final isLoading = ref.read(profileLoadingProvider);
    final error = ref.read(profileErrorProvider);

    // If no user data and not currently loading, trigger load
    if (user == null && !isLoading) {
      print('[DEBUG] No user data found, triggering profile load');
      ref.read(profileProvider.notifier).loadProfile();
    } else if (error != null && user == null && !isLoading) {
      // Also retry if there was an error but we're not currently loading
      print('[DEBUG] Previous error detected, retrying profile load');
      ref.read(profileProvider.notifier).loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug logging
    print('[DEBUG] ProfileScreen build - showBackButton: ${widget.showBackButton}');

    final isLoading = ref.watch(profileLoadingProvider);
    final user = ref.watch(currentProfileProvider);
    final error = ref.watch(profileErrorProvider);
    final completeness = ref.watch(profileCompletenessProvider);
    final theme = Theme.of(context);

    print('[DEBUG] ProfileScreen state - isLoading: $isLoading, user: ${user != null}, error: $error');

    // When used in dashboard tabs (showBackButton = false), don't create a Scaffold
    // The DashboardScaffold already provides the AppBar and structure
    if (!widget.showBackButton) {
      // Handle loading state
      if (isLoading && user == null) {
        return const Center(
          child: LoadingIndicator(message: 'Loading profile...'),
        );
      }

      // Handle error state with better UI
      if (error != null && user == null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  'Failed to load profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(profileProvider.notifier).loadProfile();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Handle no user state
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_off,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                'No profile data available',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Please log in to view your profile',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(profileProvider.notifier).loadProfile();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        );
      }

      // Return the profile content wrapped in RefreshIndicator
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).refresh();
        },
        child: _buildProfileContent(user, completeness, theme, context),
      );
    }

    // Original behavior for standalone profile screen (with back button)
    // Handle error state first for standalone screen
    if (error != null && user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  'Failed to load profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(profileProvider.notifier).loadProfile();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isLoading && user == null) {
      return const Scaffold(
        body: Center(
          child: LoadingIndicator(message: 'Loading profile...'),
        ),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_off,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                'No profile data available',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Please log in to view your profile',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(profileProvider.notifier).loadProfile();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
                tooltip: 'Back',
              )
            : null,
        automaticallyImplyLeading: widget.showBackButton,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/profile/edit');
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).refresh();
        },
        child: _buildProfileContent(user, completeness, theme, context),
      ),
    );
  }

  Widget _buildProfileContent(
      dynamic user, int completeness, ThemeData theme, BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // Profile Header Card
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
                  user.displayName ?? user.email,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
                    color: AppColors.getRoleColor(user.activeRole.roleName)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.getRoleColor(user.activeRole.roleName)
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
                          color: AppColors.getRoleColor(user.activeRole.roleName),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.activeRole.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.getRoleColor(user.activeRole.roleName),
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

          // Personal Information Section
          Text(
            'Personal Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                const Divider(height: 1),
                _ProfileInfoRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: user.email,
                ),
                if (user.phoneNumber != null &&
                    user.phoneNumber!.isNotEmpty) ...[
                  const Divider(height: 1),
                  _ProfileInfoRow(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: user.phoneNumber!,
                  ),
                ],
                const Divider(height: 1),
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

          // Account Status Section
          Text(
            'Account Status',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                const Divider(height: 1),
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

          // Available Roles Section (if user has multiple roles)
          if (user.hasMultipleRoles) ...[
            const SizedBox(height: 24),
            Text(
              'Available Roles',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: user.availableRoles.map<Widget>((role) {
                  final isActive = role == user.activeRole;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.getRoleColor(role.roleName),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            role.displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.normal,
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
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
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
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 32), // Extra padding at bottom
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: valueColor ?? AppColors.textSecondary,
          ),
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