import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/notification_preferences_provider.dart';
import '../widgets/loading_indicator.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(notificationPreferencesDataProvider);
    final isLoading = ref.watch(notificationPreferencesLoadingProvider);
    final error = ref.watch(notificationPreferencesErrorProvider);

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notification Settings'),
        ),
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
                  ref.read(notificationPreferencesProvider.notifier).fetchPreferences();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading && preferences == null) {
      return const Scaffold(
        appBar: null,
        body: LoadingIndicator(message: 'Loading preferences...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: preferences == null
          ? const Center(child: Text('No preferences found'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Notification Channels Section
                const Text('Notification Channels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: SwitchListTile(
                    secondary: const Icon(Icons.notifications, color: AppColors.primary),
                    title: const Text('In-App Notifications'),
                    subtitle: const Text('Receive notifications within the app'),
                    value: preferences.inAppEnabled,
                    onChanged: (value) async {
                      await ref.read(notificationPreferencesProvider.notifier).toggleInApp(value);
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}
