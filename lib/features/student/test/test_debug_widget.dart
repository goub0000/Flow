/// TEMPORARY DEBUG WIDGET - DELETE AFTER TESTING
/// This widget helps verify that the applications are being fetched correctly
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart' hide currentUserProvider;
import '../../authentication/providers/auth_provider.dart';

class TestDebugWidget extends ConsumerWidget {
  const TestDebugWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final apiClient = ref.watch(apiClientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current User ID: ${user?.id ?? 'None'}'),
            Text('Current User Email: ${user?.email ?? 'None'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Test the debug endpoint
                  print('[TEST] Calling debug endpoint...');
                  final response = await apiClient.get(
                    '/debug/applications',
                    fromJson: (data) => data as Map<String, dynamic>,
                  );

                  if (response.success && response.data != null) {
                    final data = response.data!;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Debug Results'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('User ID in backend: ${data['current_user_id']}'),
                              Text('Total apps in DB: ${data['total_applications_in_db']}'),
                              Text('Your apps count: ${data['user_applications_count']}'),
                              const SizedBox(height: 10),
                              Text('Sample IDs: ${data['sample_app_student_ids']}'),
                              const SizedBox(height: 10),
                              if (data['user_applications'] != null)
                                ...List.generate(
                                  (data['user_applications'] as List).length,
                                  (index) {
                                    final app = data['user_applications'][index];
                                    return Text('App ${index + 1}: ${app['id']}');
                                  },
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    print('[TEST] Failed: ${response.message}');
                  }
                } catch (e) {
                  print('[TEST] Error: $e');
                }
              },
              child: const Text('Test Debug Endpoint'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Test the actual applications endpoint
                  print('[TEST] Calling actual applications endpoint...');
                  final response = await apiClient.get(
                    '${ApiConfig.students}/me/applications',
                    fromJson: (data) => data,
                  );

                  print('[TEST] Response success: ${response.success}');
                  print('[TEST] Response data: ${response.data}');
                  print('[TEST] Response message: ${response.message}');
                } catch (e) {
                  print('[TEST] Error calling applications endpoint: $e');
                }
              },
              child: const Text('Test Applications Endpoint'),
            ),
          ],
        ),
      ),
    );
  }
}