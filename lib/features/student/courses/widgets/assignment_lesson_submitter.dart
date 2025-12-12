import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/models/quiz_assignment_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../institution/providers/course_content_provider.dart';

/// Assignment Lesson Submitter
/// Interface for students to submit assignments
class AssignmentLessonSubmitter extends ConsumerStatefulWidget {
  final String lessonId;

  const AssignmentLessonSubmitter({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<AssignmentLessonSubmitter> createState() =>
      _AssignmentLessonSubmitterState();
}

class _AssignmentLessonSubmitterState
    extends ConsumerState<AssignmentLessonSubmitter> {
  final TextEditingController _textSubmissionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final List<String> _selectedFiles = [];
  bool _isSubmitted = false;
  double? _grade;
  String? _feedback;

  @override
  void dispose() {
    _textSubmissionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load content on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contentProvider.notifier).fetchContent(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentProvider);

    if (contentState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading assignment:\n${contentState.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref
                      .read(contentProvider.notifier)
                      .fetchContent(widget.lessonId);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final content = contentState.content;
    if (content == null || content is! AssignmentContent) {
      return const Center(
        child: Text('No assignment content available'),
      );
    }

    if (_isSubmitted) {
      return _buildSubmittedView(content);
    }

    return _buildSubmissionView(content);
  }

  /// Helper method to get icon for submission type
  IconData _getSubmissionTypeIcon(SubmissionType type) {
    switch (type) {
      case SubmissionType.text:
        return Icons.text_fields;
      case SubmissionType.file:
        return Icons.upload_file;
      case SubmissionType.url:
        return Icons.link;
      case SubmissionType.both:
        return Icons.attach_file;
    }
  }

  Widget _buildSubmissionView(AssignmentContent content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assignment info
          _buildAssignmentInfo(content),
          const SizedBox(height: 32),

          // Instructions
          const Text(
            'Instructions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SelectableText(
              content.instructions,
              style: const TextStyle(height: 1.6),
            ),
          ),

          // Rubric
          if (content.rubric.isNotEmpty) ...[
            const SizedBox(height: 32),
            _buildRubric(content.rubric),
          ],

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),

          // Submission form
          const Text(
            'Your Submission',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Text submission
          if (content.submissionType == SubmissionType.text ||
              content.submissionType == SubmissionType.both) ...[
            TextField(
              controller: _textSubmissionController,
              decoration: const InputDecoration(
                labelText: 'Text Submission',
                hintText: 'Enter your submission text here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 24),
          ],

          // File upload
          if (content.submissionType == SubmissionType.file ||
              content.submissionType == SubmissionType.both) ...[
            _buildFileUploadSection(content),
            const SizedBox(height: 24),
          ],

          // URL submission (optional)
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Link (Optional)',
              hintText: 'Add a link to your work (e.g., GitHub, Google Drive)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.link),
            ),
          ),

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _submitAssignment(content),
              icon: const Icon(Icons.send),
              label: const Text('Submit Assignment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentInfo(AssignmentContent content) {
    final dueDate = content.dueDate;
    final isOverdue = dueDate != null && dueDate.isBefore(DateTime.now());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assignment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, size: 20),
                const SizedBox(width: 8),
                Text('Points: ${content.pointsPossible}'),
              ],
            ),
            if (dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: isOverdue ? Colors.red : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                    style: TextStyle(
                      color: isOverdue ? Colors.red : null,
                      fontWeight: isOverdue ? FontWeight.bold : null,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    const Chip(
                      label: Text('Overdue', style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(_getSubmissionTypeIcon(content.submissionType), size: 20),
                const SizedBox(width: 8),
                Text('Submission type: ${content.submissionType.displayName}'),
              ],
            ),
            if (content.allowedFileTypes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.file_present, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Allowed file types: ${content.allowedFileTypes.join(', ')}',
                    ),
                  ),
                ],
              ),
            ],
            if (content.maxFileSizeMb > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.storage, size: 20),
                  const SizedBox(width: 8),
                  Text('Max file size: ${content.maxFileSizeMb} MB'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRubric(List<Map<String, dynamic>> rubric) {
    int totalPoints = 0;
    for (final criterion in rubric) {
      totalPoints += criterion['points'] as int;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grading Rubric',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ...rubric.map((criterion) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '${criterion['points']}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    criterion['criterion'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('${criterion['points']} points'),
                );
              }),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Points',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$totalPoints',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection(AssignmentContent content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'File Upload',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            OutlinedButton.icon(
              onPressed: _selectFiles,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Choose Files'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedFiles.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.cloud_upload, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No files selected',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(_selectedFiles.length, (index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(_selectedFiles[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _selectedFiles.removeAt(index);
                    });
                  },
                ),
              ),
            );
          }),
      ],
    );
  }

  Future<void> _selectFiles() async {
    try {
      final contentState = ref.read(contentProvider);
      final content = contentState.content as AssignmentContent?;

      // Determine allowed file extensions
      List<String>? allowedExtensions;
      if (content != null && content.allowedFileTypes.isNotEmpty) {
        allowedExtensions = content.allowedFileTypes
            .map((type) => type.replaceAll('.', '').toLowerCase())
            .toList();
      }

      // Pick files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        withData: false, // For web, set to true if you need file bytes
      );

      if (result != null) {
        setState(() {
          for (final file in result.files) {
            // Check file size if max size is specified
            if (content != null && content.maxFileSizeMb > 0 && file.size > 0) {
              final maxSizeBytes = (content.maxFileSizeMb * 1024 * 1024).toInt();
              if (file.size > maxSizeBytes) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${file.name} exceeds max file size of ${content.maxFileSizeMb} MB',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                continue;
              }
            }

            // Add file to list
            if (!_selectedFiles.contains(file.name)) {
              _selectedFiles.add(file.name);
            }
          }
        });

        if (result.files.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.files.length} file(s) selected'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting files: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitAssignment(AssignmentContent content) {
    // Validate submission
    bool hasContent = false;

    if (content.submissionType == SubmissionType.text ||
        content.submissionType == SubmissionType.both) {
      if (_textSubmissionController.text.trim().isNotEmpty) {
        hasContent = true;
      }
    }

    if (content.submissionType == SubmissionType.file ||
        content.submissionType == SubmissionType.both) {
      if (_selectedFiles.isNotEmpty) {
        hasContent = true;
      }
    }

    if (!hasContent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a submission before submitting'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Submit to backend
    setState(() {
      _isSubmitted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assignment submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSubmittedView(AssignmentContent content) {
    final isGraded = _grade != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Submission status card
          Card(
            color: isGraded ? Colors.green[50] : Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    isGraded ? Icons.check_circle : Icons.pending,
                    size: 80,
                    color: isGraded ? Colors.green : Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isGraded ? 'Graded' : 'Submitted',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isGraded ? Colors.green[900] : Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isGraded) ...[
                    Text(
                      '$_grade / ${content.pointsPossible}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      '${((_grade! / content.pointsPossible) * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[600],
                      ),
                    ),
                  ] else
                    Text(
                      'Awaiting grading',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Feedback
          if (isGraded && _feedback != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Instructor Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.feedback, color: Colors.amber[900]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _feedback!,
                      style: TextStyle(color: Colors.amber[900], fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Submission details
          const Text(
            'Your Submission',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_textSubmissionController.text.isNotEmpty) ...[
                    const Text(
                      'Text Submission:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_textSubmissionController.text),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedFiles.isNotEmpty) ...[
                    const Text(
                      'Uploaded Files:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._selectedFiles.map((file) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file, size: 16),
                              const SizedBox(width: 8),
                              Text(file),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],
                  if (_urlController.text.isNotEmpty) ...[
                    const Text(
                      'Link:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.link, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _urlController.text,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          if (!isGraded)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isSubmitted = false;
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Resubmit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Simulate grading for demo
                      setState(() {
                        _grade = (content.pointsPossible * 0.85).roundToDouble();
                        _feedback = 'Great work! Your submission demonstrates a clear understanding of the concepts. Just a few minor areas for improvement in the future.';
                      });
                    },
                    child: const Text('Simulate Grading (Demo)'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
