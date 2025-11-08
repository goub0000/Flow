import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

/// Send Feedback Screen
///
/// Allows users to share their thoughts and suggestions.
/// Features:
/// - Feedback type selection
/// - Rating system
/// - Text feedback
/// - Screenshot attachment
/// - Anonymous submission option

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({super.key});

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  String _feedbackType = 'general';
  double _rating = 4.0;
  bool _isAnonymous = false;
  Uint8List? _screenshotBytes;
  String? _screenshotName;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Feedback'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            Card(
              color: AppColors.info.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.feedback, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your feedback helps us improve and serve you better.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Type
            Text(
              'Feedback Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _feedbackType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'general',
                  child: Text('General Feedback'),
                ),
                DropdownMenuItem(
                  value: 'feature',
                  child: Text('Feature Request'),
                ),
                DropdownMenuItem(
                  value: 'improvement',
                  child: Text('Improvement Suggestion'),
                ),
                DropdownMenuItem(
                  value: 'complaint',
                  child: Text('Complaint'),
                ),
                DropdownMenuItem(
                  value: 'praise',
                  child: Text('Praise'),
                ),
              ],
              onChanged: (value) {
                setState(() => _feedbackType = value!);
              },
            ),
            const SizedBox(height: 24),

            // Rating
            Text(
              'Overall Experience',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            size: 40,
                            color: AppColors.warning,
                          ),
                          onPressed: () {
                            setState(() => _rating = index + 1.0);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getRatingLabel(_rating),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Text
            Text(
              'Your Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your feedback';
                }
                if (value.length < 10) {
                  return 'Feedback must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Screenshot Attachment
            Card(
              child: _screenshotBytes == null
                  ? ListTile(
                      leading: Icon(Icons.photo_camera, color: AppColors.primary),
                      title: const Text('Attach Screenshot'),
                      subtitle: const Text('Optional - helps us understand the issue'),
                      trailing: const Icon(Icons.add_a_photo),
                      onTap: _pickScreenshot,
                    )
                  : Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.image, color: AppColors.success),
                          title: Text(_screenshotName ?? 'Screenshot attached'),
                          subtitle: Text(
                            '${(_screenshotBytes!.length / 1024).toStringAsFixed(1)} KB',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: AppColors.error),
                            onPressed: () {
                              setState(() {
                                _screenshotBytes = null;
                                _screenshotName = null;
                              });
                            },
                          ),
                        ),
                        // Preview
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _screenshotBytes!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // Anonymous Toggle
            Card(
              child: SwitchListTile(
                title: const Text('Submit Anonymously'),
                subtitle: const Text('Your identity will not be shared'),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() => _isAnonymous = value);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text('Submit Feedback'),
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

  String _getRatingLabel(double rating) {
    if (rating <= 1) return 'Poor';
    if (rating <= 2) return 'Fair';
    if (rating <= 3) return 'Good';
    if (rating <= 4) return 'Very Good';
    return 'Excellent';
  }

  Future<void> _pickScreenshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        // Check file size (5MB max)
        if (bytes.length > 5 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image is too large. Please select an image under 5MB.'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }

        setState(() {
          _screenshotBytes = bytes;
          _screenshotName = image.name;
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Screenshot attached successfully'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send feedback to backend (including screenshot if attached)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for your feedback!${_screenshotBytes != null ? " (Screenshot attached)" : ""}',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }
}
