// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/applicant_model.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../providers/institution_applicants_provider.dart';

class ApplicantsListScreen extends ConsumerStatefulWidget {
  const ApplicantsListScreen({super.key});

  @override
  ConsumerState<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends ConsumerState<ApplicantsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Applicant> get _filteredApplicants {
    // Get applicants based on tab
    var filtered = switch (_tabController.index) {
      1 => ref.read(pendingApplicantsProvider),
      2 => ref.read(underReviewApplicantsProvider),
      3 => ref.read(acceptedApplicantsProvider),
      4 => ref.read(rejectedApplicantsProvider),
      _ => ref.read(institutionApplicantsListProvider),
    };

    // Apply search filter if needed
    if (_searchQuery.isNotEmpty) {
      filtered = ref.read(institutionApplicantsProvider.notifier).searchApplicants(_searchQuery);

      // Re-apply tab filter to search results
      if (_tabController.index != 0) {
        final statusFilter = switch (_tabController.index) {
          1 => 'pending',
          2 => 'under_review',
          3 => 'accepted',
          4 => 'rejected',
          _ => null,
        };
        if (statusFilter != null) {
          filtered = filtered.where((a) => a.status == statusFilter).toList();
        }
      }
    }

    return filtered;
  }

  int _getStatusCount(String status) {
    final allApplicants = ref.read(institutionApplicantsListProvider);
    return allApplicants.where((a) => a.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(institutionApplicantsLoadingProvider);
    final error = ref.watch(institutionApplicantsErrorProvider);
    final allApplicants = ref.watch(institutionApplicantsListProvider);

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(institutionApplicantsProvider.notifier).fetchApplicants();
              },
              child: Text(context.l10n.instApplicantRetry),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search Bar and Tabs Header
        Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.instApplicantSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                onTap: (_) => setState(() {}),
                tabs: [
                  Tab(text: context.l10n.instApplicantTabAll(allApplicants.length)),
                  Tab(text: context.l10n.instApplicantTabPending(_getStatusCount('pending'))),
                  Tab(text: context.l10n.instApplicantTabUnderReview(_getStatusCount('under_review'))),
                  Tab(text: context.l10n.instApplicantTabAccepted(_getStatusCount('accepted'))),
                  Tab(text: context.l10n.instApplicantTabRejected(_getStatusCount('rejected'))),
                ],
              ),
            ],
          ),
          ),
        ),
        // Body
        Expanded(
          child: isLoading
          ? LoadingIndicator(message: context.l10n.instApplicantLoading)
          : _buildApplicantsList(),
        ),
      ],
    );
  }

  Widget _buildApplicantsList() {
    final applicants = _filteredApplicants;

    if (applicants.isEmpty) {
      return EmptyState(
        icon: Icons.person_search,
        title: context.l10n.instApplicantNoApplicantsFound,
        message: _searchQuery.isNotEmpty
            ? context.l10n.instApplicantTryAdjustingSearch
            : context.l10n.instApplicantNoAppsInCategory,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(institutionApplicantsProvider.notifier).fetchApplicants();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ApplicantCard(
              applicant: applicant,
              onTap: () {
                // Pass the applicant data via extra to avoid fetching again
                context.go(
                  '/institution/applicants/${applicant.id}',
                  extra: applicant,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final VoidCallback onTap;

  const _ApplicantCard({
    required this.applicant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LogoAvatar.user(
                photoUrl: null, // TODO: Add from applicant model
                initials: applicant.studentName.split(' ').map((e) => e[0]).join().toUpperCase(),
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.studentName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      applicant.programName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: applicant.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  applicant.studentEmail,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                applicant.studentPhone,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.school, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                context.l10n.instApplicantGpaValue(applicant.gpa.toString()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                context.l10n.instApplicantSubmittedDate(_formatDate(applicant.submittedAt)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'pending':
        color = AppColors.warning;
        label = context.l10n.instApplicantChipPending;
        icon = Icons.pending;
        break;
      case 'under_review':
        color = AppColors.info;
        label = context.l10n.instApplicantChipReviewing;
        icon = Icons.rate_review;
        break;
      case 'accepted':
        color = AppColors.success;
        label = context.l10n.instApplicantStatusAccepted;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        color = AppColors.error;
        label = context.l10n.instApplicantStatusRejected;
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
