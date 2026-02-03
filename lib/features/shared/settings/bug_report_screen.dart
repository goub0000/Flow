import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Bug Report Screen
///
/// Allows users to report bugs and issues.
/// Features:
/// - Bug description form
/// - Screenshot attachment
/// - Device information
/// - Priority selection

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepsController = TextEditingController();
  String _severity = 'medium';
  bool _includeDeviceInfo = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Bug'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.bug_report, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Help us improve by reporting bugs and issues you encounter.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bug Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Bug Title',
                hintText: 'Brief description of the issue',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bug title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Severity
            DropdownButtonFormField<String>(
              value: _severity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'low',
                  child: Row(
                    children: [
                      Icon(Icons.info, size: 16, color: AppColors.info),
                      SizedBox(width: 8),
                      Text('Low - Minor inconvenience'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'medium',
                  child: Row(
                    children: [
                      Icon(Icons.warning, size: 16, color: AppColors.warning),
                      SizedBox(width: 8),
                      Text('Medium - Affects functionality'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'high',
                  child: Row(
                    children: [
                      Icon(Icons.error, size: 16, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('High - App unusable'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _severity = value!);
              },
            ),
            const SizedBox(height: 16),

            // Bug Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What happened?',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the bug';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Steps to Reproduce
            TextFormField(
              controller: _stepsController,
              decoration: const InputDecoration(
                labelText: 'Steps to Reproduce',
                hintText: '1. Go to...\n2. Click on...\n3. See error',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide steps to reproduce';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Screenshot Section
            Card(
              child: ListTile(
                leading: Icon(Icons.photo_camera, color: AppColors.primary),
                title: const Text('Attach Screenshot'),
                subtitle: const Text('Help us understand the issue better'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement screenshot attachment
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Screenshot attachment coming soon'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Device Info Toggle
            Card(
              child: SwitchListTile(
                title: const Text('Include Device Information'),
                subtitle: const Text('OS version, app version, device model'),
                value: _includeDeviceInfo,
                onChanged: (value) {
                  setState(() => _includeDeviceInfo = value);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitBugReport,
                icon: const Icon(Icons.send),
                label: const Text('Submit Bug Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitBugReport() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send bug report to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bug report submitted successfully! Thank you for helping us improve.'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }
}
