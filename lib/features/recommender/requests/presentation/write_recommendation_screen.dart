import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/recommendation_letter_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/recommender_requests_provider.dart';

class WriteRecommendationScreen extends ConsumerStatefulWidget {
  final RecommendationRequest request;

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
  bool _isSaving = false;
  LetterOfRecommendation? _currentLetter;

  @override
  void initState() {
    super.initState();
    _loadExistingLetter();
  }

  Future<void> _loadExistingLetter() async {
    // Check if there's an existing letter for this request
    final letter = ref.read(recommenderRequestsProvider.notifier)
        .getLetterForRequest(widget.request.id);
    if (letter != null) {
      setState(() {
        _currentLetter = letter;
        _contentController.text = letter.content;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.request.isCompleted;
    final isReadOnly = isCompleted || _currentLetter?.isSubmitted == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.recRecommendationLetter),
        actions: [
          if (!isReadOnly)
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveDraft,
              tooltip: context.l10n.recSaveDraft,
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
                            (widget.request.studentName ?? 'S').substring(0, 1),
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
                                widget.request.studentName ?? context.l10n.recStudent,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.recApplyingTo(widget.request.institutionName ?? context.l10n.recInstitution),
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
                      icon: Icons.description,
                      label: context.l10n.recPurpose,
                      value: widget.request.purpose,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.category,
                      label: context.l10n.recType,
                      value: widget.request.requestType.name.toUpperCase(),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: context.l10n.recDeadline,
                      value: _formatDate(widget.request.deadline),
                      valueColor: widget.request.isOverdue
                          ? AppColors.error
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.label,
                      label: context.l10n.recStatus,
                      value: _getStatusLabel(widget.request.status),
                      valueColor: _getStatusColor(widget.request.status),
                    ),
                    if (widget.request.studentMessage != null) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.recMessageFromStudent,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.request.studentMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                    if (widget.request.achievements != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.recAchievements,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.request.achievements!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Accept/Decline buttons for pending requests
              if (widget.request.isPending) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeclineDialog(),
                        icon: const Icon(Icons.close, color: AppColors.error),
                        label: Text(context.l10n.recDecline),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _acceptRequest(),
                        icon: const Icon(Icons.check),
                        label: Text(context.l10n.recAccept),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Recommendation Templates (if accepted and no content yet)
              if ((widget.request.isAccepted || widget.request.isInProgress) &&
                  !isReadOnly &&
                  _contentController.text.isEmpty) ...[
                Text(
                  context.l10n.recQuickStartTemplates,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.business, color: AppColors.primary),
                        title: Text(context.l10n.recProfessionalTemplate),
                        subtitle: Text(context.l10n.recProfessionalTemplateDesc),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_professionalTemplate),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.school, color: AppColors.info),
                        title: Text(context.l10n.recAcademicTemplate),
                        subtitle: Text(context.l10n.recAcademicTemplateDesc),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_academicTemplate),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.person, color: AppColors.success),
                        title: Text(context.l10n.recPersonalTemplate),
                        subtitle: Text(context.l10n.recPersonalTemplateDesc),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _useTemplate(_personalTemplate),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recommendation Content (only show if accepted)
              if (widget.request.isAccepted || widget.request.isInProgress || widget.request.isCompleted) ...[
                Text(
                  context.l10n.recRecommendationLetter,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: isReadOnly
                        ? ''
                        : context.l10n.recWriteHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 20,
                  readOnly: isReadOnly,
                  validator: (value) {
                    if (!isReadOnly && (value == null || value.trim().isEmpty)) {
                      return context.l10n.recPleaseWriteRecommendation;
                    }
                    if (value != null && value.trim().length < 100) {
                      return context.l10n.recMinCharacters;
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
                      label: Text(context.l10n.recSubmitRecommendation),
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
                      onPressed: _isSubmitting || _isSaving ? null : _saveDraft,
                      icon: const Icon(Icons.save),
                      label: Text(context.l10n.recSaveDraft),
                    ),
                  ),
                ],
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
        widget.request.studentName ?? context.l10n.recTheStudent,
      ).replaceAll(
        '[Institution Name]',
        widget.request.institutionName ?? context.l10n.recYourInstitution,
      ).replaceAll(
        '[Purpose]',
        widget.request.purpose,
      );
    });
  }

  Future<void> _acceptRequest() async {
    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(recommenderRequestsProvider.notifier)
          .acceptRequest(widget.request.id);

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recRequestAccepted),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh to get updated request status
          ref.read(recommenderRequestsProvider.notifier).refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recFailedToAcceptRequest),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.recErrorAcceptingRequest(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showDeclineDialog() {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.recDeclineRequest),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.recDeclineReason),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.recReasonLabel,
                hintText: context.l10n.recReasonHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.recCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.recReasonMinCharacters),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await _declineRequest(reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.recDecline),
          ),
        ],
      ),
    );
  }

  Future<void> _declineRequest(String reason) async {
    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(recommenderRequestsProvider.notifier)
          .declineRequest(widget.request.id, reason);

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recRequestDeclined),
              backgroundColor: AppColors.warning,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recFailedToDeclineRequest),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.recErrorDecliningRequest(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _saveDraft() async {
    if (_contentController.text.length < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.recLetterMinCharacters),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(recommenderRequestsProvider.notifier);

      if (_currentLetter == null) {
        // Create new letter
        final letter = await notifier.createLetter(
          requestId: widget.request.id,
          content: _contentController.text,
        );
        if (letter != null) {
          setState(() => _currentLetter = letter);
        }
      } else {
        // Update existing letter
        await notifier.updateLetter(
          _currentLetter!.id,
          content: _contentController.text,
        );
      }

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.recDraftSaved),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.recErrorSavingDraft(e.toString())),
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
        title: Text(context.l10n.recSubmitConfirmTitle),
        content: Text(
          context.l10n.recSubmitConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.recCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubmission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: Text(context.l10n.recSubmit),
          ),
        ],
      ),
    );
  }

  Future<void> _processSubmission() async {
    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(recommenderRequestsProvider.notifier);

      // First, ensure letter exists
      if (_currentLetter == null) {
        final letter = await notifier.createLetter(
          requestId: widget.request.id,
          content: _contentController.text,
        );
        if (letter == null) {
          throw Exception('Failed to create letter');
        }
        _currentLetter = letter;
      } else {
        // Update content before submitting
        await notifier.updateLetter(
          _currentLetter!.id,
          content: _contentController.text,
        );
      }

      // Now submit the letter
      final success = await notifier.submitLetter(_currentLetter!.id);

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recSubmittedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.recFailedToSubmit),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.recErrorSubmitting(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusLabel(RecommendationRequestStatus status) {
    switch (status) {
      case RecommendationRequestStatus.pending:
        return context.l10n.recStatusPending;
      case RecommendationRequestStatus.accepted:
        return context.l10n.recStatusAccepted;
      case RecommendationRequestStatus.inProgress:
        return context.l10n.recStatusInProgress;
      case RecommendationRequestStatus.completed:
        return context.l10n.recStatusCompleted;
      case RecommendationRequestStatus.declined:
        return context.l10n.recStatusDeclined;
      case RecommendationRequestStatus.cancelled:
        return context.l10n.recStatusCancelled;
    }
  }

  Color _getStatusColor(RecommendationRequestStatus status) {
    switch (status) {
      case RecommendationRequestStatus.pending:
        return AppColors.info;
      case RecommendationRequestStatus.accepted:
        return AppColors.success;
      case RecommendationRequestStatus.inProgress:
        return AppColors.warning;
      case RecommendationRequestStatus.completed:
        return AppColors.success;
      case RecommendationRequestStatus.declined:
        return AppColors.error;
      case RecommendationRequestStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  // Template constants
  static const _professionalTemplate = '''Dear Admissions Committee,

I am writing to recommend [Student Name] for admission to your program at [Institution Name]. I have had the privilege of working with [Student Name] for [duration], and I can confidently say that they are one of the most dedicated and talented students I have encountered.

[Student Name] has consistently demonstrated exceptional skills in [areas]. Their ability to [specific achievement] and [another achievement] sets them apart from their peers. They approach challenges with determination and creativity, always seeking innovative solutions.

Beyond academic excellence, [Student Name] possesses outstanding personal qualities including [quality 1], [quality 2], and [quality 3]. These attributes, combined with their intellectual curiosity and work ethic, make them an ideal candidate for your program.

I strongly recommend [Student Name] for admission and am confident they will make significant contributions to your academic community.

Sincerely,
[Your Name]''';

  static const _academicTemplate = '''To the Admissions Committee,

It is my pleasure to recommend [Student Name] for admission to [Institution Name]. As their instructor/advisor, I have observed their academic journey and can attest to their exceptional capabilities.

Academically, [Student Name] has excelled in [subjects/areas], consistently achieving [grades/honors]. Their research on [topic] demonstrated advanced analytical thinking and thorough understanding of complex concepts. They have shown particular strength in [specific skills].

[Student Name]'s intellectual curiosity extends beyond the classroom. They actively participate in [activities] and have contributed to [projects/initiatives]. Their ability to synthesize information and apply theoretical knowledge to practical situations is remarkable.

I have no doubt that [Student Name] will thrive in your program and continue to pursue academic excellence. I give them my highest recommendation.

Respectfully,
[Your Name]''';

  static const _personalTemplate = '''Dear Selection Committee,

I am delighted to recommend [Student Name] for admission to [Institution Name]. I have known [Student Name] for [duration] and have witnessed their growth both personally and academically.

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
      crossAxisAlignment: CrossAxisAlignment.start,
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
