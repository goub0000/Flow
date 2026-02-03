import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Job & Career Widgets Library
///
/// Reusable components for job board, career resources, and career counseling features.
/// All components work without backend integration using mock data patterns.
///
/// Backend Integration TODO:
/// - Fetch job listings from API
/// - Submit job applications
/// - Track application status
/// - Book career counseling sessions
/// - Store resume data
/// - Track career goals and progress

// ============================================================================
// MODELS
// ============================================================================

/// Job Type Enum
enum JobType {
  fullTime,
  partTime,
  contract,
  internship,
  freelance,
}

extension JobTypeExtension on JobType {
  String get displayName {
    switch (this) {
      case JobType.fullTime:
        return 'Full-time';
      case JobType.partTime:
        return 'Part-time';
      case JobType.contract:
        return 'Contract';
      case JobType.internship:
        return 'Internship';
      case JobType.freelance:
        return 'Freelance';
    }
  }

  Color get color {
    switch (this) {
      case JobType.fullTime:
        return AppColors.primary;
      case JobType.partTime:
        return AppColors.info;
      case JobType.contract:
        return AppColors.warning;
      case JobType.internship:
        return AppColors.success;
      case JobType.freelance:
        return Colors.purple;
    }
  }
}

/// Job Experience Level Enum
enum ExperienceLevel {
  entry,
  junior,
  mid,
  senior,
  lead,
}

extension ExperienceLevelExtension on ExperienceLevel {
  String get displayName {
    switch (this) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.junior:
        return 'Junior';
      case ExperienceLevel.mid:
        return 'Mid-Level';
      case ExperienceLevel.senior:
        return 'Senior';
      case ExperienceLevel.lead:
        return 'Lead';
    }
  }
}

/// Application Status Enum
enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  interviewing,
  offered,
  accepted,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.interviewing:
        return 'Interviewing';
      case ApplicationStatus.offered:
        return 'Offered';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.draft:
        return AppColors.textSecondary;
      case ApplicationStatus.submitted:
        return AppColors.info;
      case ApplicationStatus.underReview:
        return AppColors.warning;
      case ApplicationStatus.interviewing:
        return Colors.orange;
      case ApplicationStatus.offered:
        return AppColors.success;
      case ApplicationStatus.accepted:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.error;
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.draft:
        return Icons.edit;
      case ApplicationStatus.submitted:
        return Icons.send;
      case ApplicationStatus.underReview:
        return Icons.hourglass_empty;
      case ApplicationStatus.interviewing:
        return Icons.calendar_today;
      case ApplicationStatus.offered:
        return Icons.celebration;
      case ApplicationStatus.accepted:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
    }
  }
}

/// Job Listing Model
class JobListing {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String location;
  final bool isRemote;
  final JobType type;
  final ExperienceLevel experienceLevel;
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> benefits;
  final List<String> skills;
  final DateTime postedDate;
  final DateTime? applicationDeadline;
  final bool isSaved;

  const JobListing({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    required this.location,
    this.isRemote = false,
    required this.type,
    required this.experienceLevel,
    required this.salary,
    required this.description,
    this.requirements = const [],
    this.responsibilities = const [],
    this.benefits = const [],
    this.skills = const [],
    required this.postedDate,
    this.applicationDeadline,
    this.isSaved = false,
  });

  JobListing copyWith({
    String? id,
    String? title,
    String? company,
    String? companyLogo,
    String? location,
    bool? isRemote,
    JobType? type,
    ExperienceLevel? experienceLevel,
    String? salary,
    String? description,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? benefits,
    List<String>? skills,
    DateTime? postedDate,
    DateTime? applicationDeadline,
    bool? isSaved,
  }) {
    return JobListing(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      location: location ?? this.location,
      isRemote: isRemote ?? this.isRemote,
      type: type ?? this.type,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      benefits: benefits ?? this.benefits,
      skills: skills ?? this.skills,
      postedDate: postedDate ?? this.postedDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

/// Job Application Model
class JobApplication {
  final String id;
  final JobListing job;
  final ApplicationStatus status;
  final DateTime appliedDate;
  final DateTime? lastUpdated;
  final String? coverLetter;
  final String? resumeUrl;
  final List<ApplicationEvent> timeline;

  const JobApplication({
    required this.id,
    required this.job,
    required this.status,
    required this.appliedDate,
    this.lastUpdated,
    this.coverLetter,
    this.resumeUrl,
    this.timeline = const [],
  });
}

/// Application Event Model
class ApplicationEvent {
  final String title;
  final String? description;
  final DateTime date;
  final ApplicationStatus status;

  const ApplicationEvent({
    required this.title,
    this.description,
    required this.date,
    required this.status,
  });
}

/// Career Resource Model
class CareerResource {
  final String id;
  final String title;
  final String description;
  final String type; // article, video, course, guide
  final String? thumbnailUrl;
  final String? url;
  final Duration? duration;
  final int? views;
  final bool isBookmarked;

  const CareerResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.thumbnailUrl,
    this.url,
    this.duration,
    this.views,
    this.isBookmarked = false,
  });

  CareerResource copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? thumbnailUrl,
    String? url,
    Duration? duration,
    int? views,
    bool? isBookmarked,
  }) {
    return CareerResource(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      url: url ?? this.url,
      duration: duration ?? this.duration,
      views: views ?? this.views,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

/// Career Counselor Model
class CareerCounselor {
  final String id;
  final String name;
  final String? photoUrl;
  final String specialization;
  final String bio;
  final double rating;
  final int reviewCount;
  final int sessionsCompleted;
  final List<String> expertise;
  final bool isAvailable;

  const CareerCounselor({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.specialization,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.sessionsCompleted,
    this.expertise = const [],
    this.isAvailable = true,
  });
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Job Card - Displays job listing in a card format
class JobCard extends StatelessWidget {
  final JobListing job;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool showSaveButton;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onSave,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysAgo = DateTime.now().difference(job.postedDate).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with company logo and save button
              Row(
                children: [
                  // Company Logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: job.companyLogo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              job.companyLogo!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.business,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.business,
                            color: AppColors.primary,
                          ),
                  ),
                  const SizedBox(width: 12),

                  // Company Name and Posted Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.company,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          daysAgo == 0
                              ? context.l10n.swJobCareerPostedToday
                              : daysAgo == 1
                                  ? context.l10n.swJobCareerPostedYesterday
                                  : context.l10n.swJobCareerPostedDaysAgo(daysAgo),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Save Button
                  if (showSaveButton)
                    IconButton(
                      icon: Icon(
                        job.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: job.isSaved ? AppColors.primary : null,
                      ),
                      onPressed: onSave,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Job Title
              Text(
                job.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Location and Remote Badge
              Row(
                children: [
                  Icon(
                    job.isRemote ? Icons.home_work : Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.isRemote ? context.l10n.swJobCareerRemote : job.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Job Type and Experience Level Badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _JobBadge(
                    label: job.type.displayName,
                    color: job.type.color,
                  ),
                  _JobBadge(
                    label: job.experienceLevel.displayName,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Salary
              Text(
                job.salary,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),

              // Skills (limited to 3)
              if (job.skills.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: job.skills.take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        skill,
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Application Deadline
              if (job.applicationDeadline != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.swJobCareerApplyBy(_formatDate(context, job.applicationDeadline!)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) return context.l10n.swJobCareerExpired;
    if (difference == 0) return context.l10n.swJobCareerToday;
    if (difference == 1) return context.l10n.swJobCareerTomorrow;
    if (difference < 7) return context.l10n.swJobCareerInDays(difference);

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
    return '${months[date.month - 1]} ${date.day}';
  }
}

/// Job Badge Widget
class _JobBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _JobBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Application Status Badge
class ApplicationStatusBadge extends StatelessWidget {
  final ApplicationStatus status;
  final bool showIcon;

  const ApplicationStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              status.icon,
              size: 14,
              color: status.color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Job Application Card
class JobApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;

  const JobApplicationCard({
    super.key,
    required this.application,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.job.company,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ApplicationStatusBadge(status: application.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.swJobCareerApplied(_getRelativeTime(context, application.appliedDate)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (application.lastUpdated != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.update,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.swJobCareerUpdated(_getRelativeTime(context, application.lastUpdated!)),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRelativeTime(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return context.l10n.swJobCareerDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return context.l10n.swJobCareerHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return context.l10n.swJobCareerMinutesAgo(difference.inMinutes);
    } else {
      return context.l10n.swJobCareerJustNow;
    }
  }
}

/// Career Resource Card
class CareerResourceCard extends StatelessWidget {
  final CareerResource resource;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const CareerResourceCard({
    super.key,
    required this.resource,
    this.onTap,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (resource.thumbnailUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    resource.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.image,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      resource.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    resource.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    resource.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Meta Info
                  Row(
                    children: [
                      if (resource.duration != null) ...[
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${resource.duration!.inMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (resource.views != null) ...[
                        if (resource.duration != null) const SizedBox(width: 16),
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          context.l10n.swJobCareerViewsCount(resource.views!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          resource.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: resource.isBookmarked
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        onPressed: onBookmark,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Career Counselor Card
class CareerCounselorCard extends StatelessWidget {
  final CareerCounselor counselor;
  final VoidCallback? onTap;
  final VoidCallback? onBook;

  const CareerCounselorCard({
    super.key,
    required this.counselor,
    this.onTap,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Photo
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: counselor.photoUrl != null
                        ? NetworkImage(counselor.photoUrl!)
                        : null,
                    child: counselor.photoUrl == null
                        ? Text(
                            counselor.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),

                  // Name and Specialization
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counselor.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          counselor.specialization,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Availability Badge
                  if (counselor.isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.swJobCareerAvailable,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Bio
              Text(
                counselor.bio,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  // Rating
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${counselor.rating}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' (${counselor.reviewCount})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Sessions
                  Icon(
                    Icons.people,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.swJobCareerSessionsCount(counselor.sessionsCompleted),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Expertise Tags
              if (counselor.expertise.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: counselor.expertise.take(3).map((exp) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        exp,
                        style: theme.textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Book Button
              if (onBook != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onBook,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(context.l10n.swJobCareerBookSession),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Job Filter Chip
class JobFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const JobFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
