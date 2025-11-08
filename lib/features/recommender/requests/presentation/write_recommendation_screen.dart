import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/recommender_requests_provider.dart';

class WriteRecommendationScreen extends ConsumerStatefulWidget {
  final Recommendation request;

  const WriteRecommendationScreen({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<WriteRecommendationScreen> createState() =>
      _WriteRecommendationScreenState();
}

class _WriteRecommendationScreenState extends ConsumerState<WriteRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.request.content != null) {
      _contentController.text = widget.request.content!;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReadOnly = widget.request.isSubmitted;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Letter'),
        actions: [
          if (!isReadOnly)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _saveDraft();
              },
              tooltip: 'Save Draft',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Info Card
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            widget.request.studentName.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.request.studentName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Applying to ${widget.request.institutionName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.school,
                      label: 'Program',
                      value: widget.request.programName,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Deadline',
                      value: widget.request.deadline != null
                          ? _formatDate(widget.request.deadline!)
                          : 'No deadline',
                      valueColor: widget.request.isOverdue
                          ? AppColors.error
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.label,
                      label: 'Status',
                      value: widget.request.status.toUpperCase(),
                      valueColor: widget.request.isSubmitted
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recommendation Templates (if draft)
              if (!isReadOnly && _contentController.text.isEmpty) ...[
                Text(
                  'Quick Start Templates',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.business, color: AppColors.primary),
                        title: const Text('Professional Template'),
                        subtitle: const Text('Formal business-style recommendation'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_professionalTemplate),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.school, color: AppColors.info),
                        title: const Text('Academic Template'),
                        subtitle: const Text('Focus on academic achievements'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_academicTemplate),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.person, color: AppColors.success),
                        title: const Text('Personal Template'),
                        subtitle: const Text('Emphasize personal qualities'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_personalTemplate),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recommendation Content
              Text(
                'Recommendation Letter',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: isReadOnly
                      ? ''
                      : 'Write your recommendation here or use a template above...',
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 20,
                readOnly: isReadOnly,
                validator: (value) {
                  if (!isReadOnly && (value == null || value.trim().isEmpty)) {
                    return 'Please write a recommendation';
                  }
                  if (value != null && value.trim().length < 100) {
                    return 'Recommendation should be at least 100 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              if (!isReadOnly) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitRecommendation,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.send),
                    label: const Text('Submit Recommendation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _saveDraft,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Draft'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _useTemplate(String template) {
    setState(() {
      _contentController.text = template.replaceAll(
        '[Student Name]',
        widget.request.studentName,
      ).replaceAll(
        '[Institution Name]',
        widget.request.institutionName,
      ).replaceAll(
        '[Program Name]',
        widget.request.programName,
      );
    });
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(recommenderRequestsProvider.notifier).saveDraft(
        widget.request.id,
        _contentController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving draft: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _submitRecommendation() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Recommendation?'),
        content: const Text(
          'Once submitted, you will not be able to edit this recommendation. Are you sure you want to submit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubmission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _processSubmission() async {
    setState(() => _isSubmitting = true);

    try {
      await ref.read(recommenderRequestsProvider.notifier).submitRecommendation(
        widget.request.id,
        _contentController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recommendation submitted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        setState(() => _isSubmitting = false);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting recommendation: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Template constants
  static const _professionalTemplate = '''Dear Admissions Committee,

I am writing to recommend [Student Name] for admission to the [Program Name] at [Institution Name]. I have had the privilege of working with [Student Name] for [duration], and I can confidently say that they are one of the most dedicated and talented students I have encountered.

[Student Name] has consistently demonstrated exceptional skills in [areas]. Their ability to [specific achievement] and [another achievement] sets them apart from their peers. They approach challenges with determination and creativity, always seeking innovative solutions.

Beyond academic excellence, [Student Name] possesses outstanding personal qualities including [quality 1], [quality 2], and [quality 3]. These attributes, combined with their intellectual curiosity and work ethic, make them an ideal candidate for your program.

I strongly recommend [Student Name] for admission and am confident they will make significant contributions to your academic community.

Sincerely,
[Your Name]''';

  static const _academicTemplate = '''To the Admissions Committee,

It is my pleasure to recommend [Student Name] for the [Program Name] at [Institution Name]. As their instructor/advisor, I have observed their academic journey and can attest to their exceptional capabilities.

Academically, [Student Name] has excelled in [subjects/areas], consistently achieving [grades/honors]. Their research on [topic] demonstrated advanced analytical thinking and thorough understanding of complex concepts. They have shown particular strength in [specific skills].

[Student Name]'s intellectual curiosity extends beyond the classroom. They actively participate in [activities] and have contributed to [projects/initiatives]. Their ability to synthesize information and apply theoretical knowledge to practical situations is remarkable.

I have no doubt that [Student Name] will thrive in your program and continue to pursue academic excellence. I give them my highest recommendation.

Respectfully,
[Your Name]''';

  static const _personalTemplate = '''Dear Selection Committee,

I am delighted to recommend [Student Name] for admission to [Program Name] at [Institution Name]. I have known [Student Name] for [duration] and have witnessed their growth both personally and academically.

What distinguishes [Student Name] is their character. They consistently demonstrate [quality 1], [quality 2], and [quality 3]. They are respected by peers for their [trait] and admired by faculty for their [trait]. Their positive attitude and collaborative spirit make them a valuable member of any community.

[Student Name] has overcome [challenges] with resilience and determination. This experience has shaped them into a mature, thoughtful individual ready for the challenges of higher education. They bring unique perspectives from [background/experience] that will enrich your diverse student body.

I wholeheartedly recommend [Student Name] and believe they will be an asset to your institution.

Warm regards,
[Your Name]''';
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: valueColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
