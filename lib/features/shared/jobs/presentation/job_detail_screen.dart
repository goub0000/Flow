import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../widgets/job_career_widgets.dart';

/// Job Detail Screen
///
/// Displays complete job information and allows users to apply.
/// Features:
/// - Complete job description
/// - Requirements and responsibilities
/// - Benefits and company info
/// - Application form
/// - Similar jobs recommendations
///
/// Backend Integration TODO:
/// - Fetch job details from API
/// - Submit job applications
/// - Track application status
/// - Upload resume and cover letter
/// - Send application notifications

class JobDetailScreen extends StatefulWidget {
  final JobListing job;

  const JobDetailScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.job.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.jobDetailsTitle),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? AppColors.primary : null,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isSaved
                        ? context.l10n.jobSavedSuccessfully
                        : context.l10n.jobRemovedFromSaved,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement sharing
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.jobShareComingSoon),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Company Header
                _buildCompanyHeader(theme),
                const SizedBox(height: 24),

                // Job Type and Experience Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _JobBadge(
                      label: widget.job.type.displayName,
                      color: widget.job.type.color,
                      icon: Icons.work,
                    ),
                    _JobBadge(
                      label: widget.job.experienceLevel.displayName,
                      color: AppColors.info,
                      icon: Icons.school,
                    ),
                    if (widget.job.isRemote)
                      const _JobBadge(
                        label: 'Remote',
                        color: AppColors.success,
                        icon: Icons.home_work,
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Salary
                _buildSectionCard(
                  icon: Icons.payments,
                  iconColor: AppColors.success,
                  title: context.l10n.jobSalaryRange,
                  child: Text(
                    widget.job.salary,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Location
                _buildSectionCard(
                  icon: Icons.location_on,
                  iconColor: AppColors.error,
                  title: context.l10n.jobLocation,
                  child: Text(
                    widget.job.isRemote ? 'Remote' : widget.job.location,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 16),

                // Application Deadline
                if (widget.job.applicationDeadline != null)
                  _buildSectionCard(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.warning,
                    title: context.l10n.jobApplicationDeadline,
                    child: Text(
                      _formatDeadline(widget.job.applicationDeadline!),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (widget.job.applicationDeadline != null)
                  const SizedBox(height: 24),

                // Job Description
                _buildSection(
                  title: context.l10n.jobDescription,
                  icon: Icons.description,
                  content: widget.job.description,
                ),
                const SizedBox(height: 24),

                // Requirements
                if (widget.job.requirements.isNotEmpty)
                  _buildListSection(
                    title: context.l10n.jobRequirements,
                    icon: Icons.checklist,
                    items: widget.job.requirements,
                  ),
                if (widget.job.requirements.isNotEmpty)
                  const SizedBox(height: 24),

                // Responsibilities
                if (widget.job.responsibilities.isNotEmpty)
                  _buildListSection(
                    title: context.l10n.jobResponsibilities,
                    icon: Icons.assignment,
                    items: widget.job.responsibilities,
                  ),
                if (widget.job.responsibilities.isNotEmpty)
                  const SizedBox(height: 24),

                // Required Skills
                if (widget.job.skills.isNotEmpty)
                  _buildSkillsSection(theme),
                if (widget.job.skills.isNotEmpty) const SizedBox(height: 24),

                // Benefits
                if (widget.job.benefits.isNotEmpty)
                  _buildListSection(
                    title: context.l10n.jobBenefits,
                    icon: Icons.card_giftcard,
                    items: widget.job.benefits,
                    iconColor: AppColors.success,
                  ),
                if (widget.job.benefits.isNotEmpty) const SizedBox(height: 24),

                // Company Info
                _buildCompanyInfoSection(theme),
                const SizedBox(height: 24),

                // Similar Jobs (mock)
                _buildSimilarJobsSection(),
                const SizedBox(height: 80), // Space for bottom button
              ],
            ),
          ),

          // Apply Button (Fixed at bottom)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showApplicationDialog(),
                icon: const Icon(Icons.send),
                label: Text(context.l10n.jobApplyNow),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyHeader(ThemeData theme) {
    return Row(
      children: [
        // Company Logo
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.job.companyLogo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.job.companyLogo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.business,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : const Icon(
                  Icons.business,
                  size: 32,
                  color: AppColors.primary,
                ),
        ),
        const SizedBox(width: 16),

        // Company and Job Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.job.company,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.job.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Posted ${_getRelativeTime(widget.job.postedDate)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildListSection({
    required String title,
    required IconData icon,
    required List<String> items,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSkillsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.extension, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              context.l10n.jobRequiredSkills,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.job.skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompanyInfoSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                context.l10n.jobAboutTheCompany,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.job.company,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A leading technology company focused on innovation and growth. We\'re committed to building a diverse and inclusive workplace.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              // TODO: View company profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.jobCompanyProfileComingSoon),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: Text(context.l10n.jobViewCompanyProfile),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarJobsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.work_outline, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              context.l10n.jobSimilarJobs,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senior ${widget.job.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tech Company ${index + 1}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Remote',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showApplicationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.jobApplyForThisJob),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.jobYouAreApplyingFor,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.job.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'at ${widget.job.company}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: context.l10n.jobCoverLetter,
                  hintText: context.l10n.jobCoverLetterHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Upload resume
                },
                icon: const Icon(Icons.upload_file),
                label: Text(context.l10n.jobUploadResume),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.jobCancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.jobApplicationSubmittedSuccess),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.l10n.jobSubmitApplication),
          ),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;

    if (difference < 0) return 'Expired';
    if (difference == 0) return 'Today (Last day!)';
    if (difference == 1) return 'Tomorrow';
    if (difference < 7) return '$difference days left';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[deadline.month - 1]} ${deadline.day}, ${deadline.year}';
  }

  String _getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

/// Job Badge with Icon Widget
class _JobBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _JobBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
