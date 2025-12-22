import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/recommendation_letter_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/student_recommendation_requests_provider.dart';
import '../../providers/student_applications_provider.dart';

class RecommendationRequestsScreen extends ConsumerStatefulWidget {
  const RecommendationRequestsScreen({super.key});

  @override
  ConsumerState<RecommendationRequestsScreen> createState() =>
      _RecommendationRequestsScreenState();
}

class _RecommendationRequestsScreenState
    extends ConsumerState<RecommendationRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentRecommendationRequestsProvider);
    final isLoading = state.isLoading;
    final error = state.error;
    final allRequests = state.requests;
    final pendingRequests = ref.watch(studentPendingRecommendationRequestsProvider);
    final inProgressRequests = ref.watch(studentInProgressRecommendationRequestsProvider);
    final completedRequests = ref.watch(studentCompletedRecommendationRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Letters'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'All (${allRequests.length})'),
            Tab(text: 'Pending (${pendingRequests.length})'),
            Tab(text: 'In Progress (${inProgressRequests.length})'),
            Tab(text: 'Completed (${completedRequests.length})'),
          ],
        ),
      ),
      body: error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(studentRecommendationRequestsProvider.notifier).refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : isLoading
              ? const LoadingIndicator(message: 'Loading requests...')
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRequestsList(allRequests, 'all'),
                    _buildRequestsList(pendingRequests, 'pending'),
                    _buildRequestsList(inProgressRequests, 'in_progress'),
                    _buildRequestsList(completedRequests, 'completed'),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateRequestDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Request Letter'),
      ),
    );
  }

  Widget _buildRequestsList(List<RecommendationRequest> requests, String type) {
    if (requests.isEmpty) {
      String message;
      switch (type) {
        case 'pending':
          message = 'No pending recommendation requests';
          break;
        case 'in_progress':
          message = 'No letters being written';
          break;
        case 'completed':
          message = 'No completed recommendation letters yet';
          break;
        default:
          message = 'No recommendation requests yet.\nTap + to request a letter.';
      }

      return EmptyState(
        icon: Icons.mail_outline,
        title: 'No Requests',
        message: message,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(studentRecommendationRequestsProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RequestCard(
              request: request,
              onTap: () => _showRequestDetailsDialog(context, request),
              onEdit: request.isPending
                  ? () => _showEditRequestDialog(context, request)
                  : null,
              onCancel: request.isPending
                  ? () => _cancelRequest(request.id)
                  : null,
              onRemind: (request.isAccepted || request.isInProgress)
                  ? () => _sendReminder(request.id)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCreateRequestDialog(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateRequestSheet(
        onSubmit: (data) async {
          final success = await ref.read(studentRecommendationRequestsProvider.notifier).createRequestByEmail(
            recommenderEmail: data['recommender_email'],
            recommenderName: data['recommender_name'],
            requestType: data['request_type'],
            purpose: data['purpose'],
            deadline: data['deadline'],
            institutionNames: List<String>.from(data['institution_names']),
            priority: data['priority'] ?? 'normal',
            studentMessage: data['student_message'],
            achievements: data['achievements'],
            goals: data['goals'],
          );

          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recommendation request sent! The recommender will receive an email invitation.'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to send request'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }

  void _showRequestDetailsDialog(BuildContext context, RecommendationRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.recommenderName ?? 'Recommender'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'Status', value: _getStatusLabel(request.status)),
              _DetailRow(label: 'Type', value: request.requestType.name.toUpperCase()),
              _DetailRow(label: 'Purpose', value: request.purpose),
              if (request.institutionName != null)
                _DetailRow(label: 'Institution', value: request.institutionName!),
              _DetailRow(
                label: 'Deadline',
                value: '${request.deadline.day}/${request.deadline.month}/${request.deadline.year}',
              ),
              _DetailRow(
                label: 'Requested',
                value: '${request.requestedAt.day}/${request.requestedAt.month}/${request.requestedAt.year}',
              ),
              if (request.isDeclined && request.declineReason != null) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Decline Reason',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(request.declineReason!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (request.isPending)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelRequest(request.id);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Cancel Request'),
            ),
          if (request.isAccepted || request.isInProgress)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _sendReminder(request.id);
              },
              child: const Text('Send Reminder'),
            ),
        ],
      ),
    );
  }

  Future<void> _cancelRequest(String requestId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: const Text('Are you sure you want to cancel this recommendation request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(studentRecommendationRequestsProvider.notifier)
          .cancelRequest(requestId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Request cancelled' : 'Failed to cancel request'),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _sendReminder(String requestId) async {
    final success = await ref.read(studentRecommendationRequestsProvider.notifier)
        .sendReminder(requestId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Reminder sent!' : 'Failed to send reminder'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  String _getStatusLabel(RecommendationRequestStatus status) {
    switch (status) {
      case RecommendationRequestStatus.pending:
        return 'Pending';
      case RecommendationRequestStatus.accepted:
        return 'Accepted';
      case RecommendationRequestStatus.inProgress:
        return 'In Progress';
      case RecommendationRequestStatus.completed:
        return 'Completed';
      case RecommendationRequestStatus.declined:
        return 'Declined';
      case RecommendationRequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  Future<void> _showEditRequestDialog(BuildContext context, RecommendationRequest request) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditRequestSheet(
        request: request,
        onSubmit: (data) async {
          final success = await ref.read(studentRecommendationRequestsProvider.notifier).updateRequest(
            requestId: request.id,
            purpose: data['purpose'],
            institutionName: data['institution_name'],
            deadline: data['deadline'],
            priority: data['priority'],
            studentMessage: data['student_message'],
            achievements: data['achievements'],
            goals: data['goals'],
          );

          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request updated successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update request'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final RecommendationRequest request;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onRemind;

  const _RequestCard({
    required this.request,
    required this.onTap,
    this.onEdit,
    this.onCancel,
    this.onRemind,
  });

  @override
  Widget build(BuildContext context) {
    final daysLeft = request.deadline.difference(DateTime.now()).inDays;
    final isOverdue = request.isOverdue;

    return CustomCard(
      onTap: onTap,
      color: isOverdue && !request.isCompleted
          ? AppColors.error.withValues(alpha: 0.05)
          : request.isDeclined
              ? AppColors.error.withValues(alpha: 0.05)
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _getStatusColor(),
                child: Icon(
                  _getStatusIcon(),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.recommenderName ?? 'Recommender',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.recommenderTitle ?? request.recommenderEmail ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.school, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  request.institutionName ?? request.purpose,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: isOverdue && !request.isCompleted
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                request.isCompleted
                    ? 'Completed'
                    : isOverdue
                        ? 'Overdue!'
                        : daysLeft == 0
                            ? 'Due today'
                            : '$daysLeft days left',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOverdue && !request.isCompleted
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontWeight: isOverdue && !request.isCompleted
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
              const Spacer(),
              if (onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('Edit'),
                ),
              if (onCancel != null)
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('Cancel'),
                ),
              if (onRemind != null)
                TextButton(
                  onPressed: onRemind,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('Remind'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (request.status) {
      case RecommendationRequestStatus.pending:
        return AppColors.warning;
      case RecommendationRequestStatus.accepted:
        return AppColors.info;
      case RecommendationRequestStatus.inProgress:
        return AppColors.info;
      case RecommendationRequestStatus.completed:
        return AppColors.success;
      case RecommendationRequestStatus.declined:
        return AppColors.error;
      case RecommendationRequestStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (request.status) {
      case RecommendationRequestStatus.pending:
        return Icons.hourglass_empty;
      case RecommendationRequestStatus.accepted:
        return Icons.check;
      case RecommendationRequestStatus.inProgress:
        return Icons.edit;
      case RecommendationRequestStatus.completed:
        return Icons.check_circle;
      case RecommendationRequestStatus.declined:
        return Icons.close;
      case RecommendationRequestStatus.cancelled:
        return Icons.cancel;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final RecommendationRequestStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case RecommendationRequestStatus.pending:
        color = AppColors.warning;
        label = 'PENDING';
        break;
      case RecommendationRequestStatus.accepted:
        color = AppColors.info;
        label = 'ACCEPTED';
        break;
      case RecommendationRequestStatus.inProgress:
        color = AppColors.info;
        label = 'WRITING';
        break;
      case RecommendationRequestStatus.completed:
        color = AppColors.success;
        label = 'COMPLETED';
        break;
      case RecommendationRequestStatus.declined:
        color = AppColors.error;
        label = 'DECLINED';
        break;
      case RecommendationRequestStatus.cancelled:
        color = AppColors.textSecondary;
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateRequestSheet extends ConsumerStatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const _CreateRequestSheet({required this.onSubmit});

  @override
  ConsumerState<_CreateRequestSheet> createState() => _CreateRequestSheetState();
}

class _CreateRequestSheetState extends ConsumerState<_CreateRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final _recommenderEmailController = TextEditingController();
  final _recommenderNameController = TextEditingController();
  final _purposeController = TextEditingController();
  final _messageController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _goalsController = TextEditingController();

  List<String> _selectedInstitutions = [];
  String _selectedType = 'academic';
  String _selectedPriority = 'normal';
  DateTime _deadline = DateTime.now().add(const Duration(days: 14));
  bool _isSubmitting = false;

  @override
  void dispose() {
    _recommenderEmailController.dispose();
    _recommenderNameController.dispose();
    _purposeController.dispose();
    _messageController.dispose();
    _achievementsController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get student's applications for institution selection
    final applicationsState = ref.watch(applicationsProvider);
    final applications = applicationsState.applications;

    // Get unique institution names from applications
    final institutionNames = applications
        .map((app) => app.institutionName)
        .toSet()
        .toList()
      ..sort();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Request Recommendation Letter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recommender Email
                    Text(
                      'Recommender Email *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _recommenderEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'professor@university.edu',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        helperText: 'They will receive an invitation to submit the recommendation',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter recommender email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Recommender Name
                    Text(
                      'Recommender Name *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _recommenderNameController,
                      decoration: const InputDecoration(
                        hintText: 'Dr. John Smith',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter recommender name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Type
                    Text(
                      'Type *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'academic', child: Text('Academic')),
                        DropdownMenuItem(value: 'professional', child: Text('Professional')),
                        DropdownMenuItem(value: 'character', child: Text('Character')),
                        DropdownMenuItem(value: 'scholarship', child: Text('Scholarship')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedType = value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Purpose
                    Text(
                      'Purpose *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Graduate school application, Job application',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Please describe the purpose (min 10 characters)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Target Institutions (Multi-select from applications)
                    Text(
                      'Target Institutions *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    if (institutionNames.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.warning),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You have no applications yet. Please submit applications first to request recommendations.',
                                style: TextStyle(color: AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.school, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Select institutions (${_selectedInstitutions.length} selected)',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // Institution list
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: institutionNames.length,
                                itemBuilder: (context, index) {
                                  final institution = institutionNames[index];
                                  final isSelected = _selectedInstitutions.contains(institution);
                                  return CheckboxListTile(
                                    title: Text(institution),
                                    value: isSelected,
                                    dense: true,
                                    onChanged: (checked) {
                                      setState(() {
                                        if (checked == true) {
                                          _selectedInstitutions.add(institution);
                                        } else {
                                          _selectedInstitutions.remove(institution);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_selectedInstitutions.isEmpty && institutionNames.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Please select at least one institution',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Deadline
                    Text(
                      'Deadline *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _deadline = date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 12),
                            Text('${_deadline.day}/${_deadline.month}/${_deadline.year}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Priority
                    Text(
                      'Priority',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPriority,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'normal', child: Text('Normal')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedPriority = value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Message to recommender
                    Text(
                      'Message to Recommender',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Any specific points you\'d like them to highlight?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Achievements
                    Text(
                      'Your Achievements',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _achievementsController,
                      decoration: const InputDecoration(
                        hintText: 'List relevant achievements to help the recommender',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Goals
                    Text(
                      'Your Goals',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _goalsController,
                      decoration: const InputDecoration(
                        hintText: 'What are your career/academic goals?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitRequest,
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Send Request'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate institution selection
    if (_selectedInstitutions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one institution'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    widget.onSubmit({
      'recommender_email': _recommenderEmailController.text.trim(),
      'recommender_name': _recommenderNameController.text.trim(),
      'request_type': _selectedType,
      'purpose': _purposeController.text,
      'institution_names': _selectedInstitutions,
      'deadline': _deadline,
      'priority': _selectedPriority,
      'student_message': _messageController.text.isEmpty ? null : _messageController.text,
      'achievements': _achievementsController.text.isEmpty ? null : _achievementsController.text,
      'goals': _goalsController.text.isEmpty ? null : _goalsController.text,
    });

    setState(() => _isSubmitting = false);
  }
}

class _EditRequestSheet extends StatefulWidget {
  final RecommendationRequest request;
  final Function(Map<String, dynamic>) onSubmit;

  const _EditRequestSheet({
    required this.request,
    required this.onSubmit,
  });

  @override
  State<_EditRequestSheet> createState() => _EditRequestSheetState();
}

class _EditRequestSheetState extends State<_EditRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _purposeController;
  late TextEditingController _institutionController;
  late TextEditingController _messageController;
  late TextEditingController _achievementsController;
  late TextEditingController _goalsController;

  late String _selectedPriority;
  late DateTime _deadline;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _purposeController = TextEditingController(text: widget.request.purpose);
    _institutionController = TextEditingController(text: widget.request.institutionName ?? '');
    _messageController = TextEditingController(text: widget.request.studentMessage ?? '');
    _achievementsController = TextEditingController(text: widget.request.achievements ?? '');
    _goalsController = TextEditingController(text: widget.request.goals ?? '');
    _selectedPriority = widget.request.priority.name;
    _deadline = widget.request.deadline;
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _institutionController.dispose();
    _messageController.dispose();
    _achievementsController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Edit Request',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recommender info (read-only)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.request.recommenderName ?? 'Recommender',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                if (widget.request.recommenderEmail != null)
                                  Text(
                                    widget.request.recommenderEmail!,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Purpose
                    Text(
                      'Purpose *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _purposeController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Graduate school application, Job application',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 10) {
                          return 'Please describe the purpose (min 10 characters)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Institution
                    Text(
                      'Target Institution',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _institutionController,
                      decoration: const InputDecoration(
                        hintText: 'Institution name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deadline
                    Text(
                      'Deadline *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _deadline = date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 12),
                            Text('${_deadline.day}/${_deadline.month}/${_deadline.year}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Priority
                    Text(
                      'Priority',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPriority,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'normal', child: Text('Normal')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                        DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedPriority = value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Message to recommender
                    Text(
                      'Message to Recommender',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Any specific points you\'d like them to highlight?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Achievements
                    Text(
                      'Your Achievements',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _achievementsController,
                      decoration: const InputDecoration(
                        hintText: 'List relevant achievements to help the recommender',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Goals
                    Text(
                      'Your Goals',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _goalsController,
                      decoration: const InputDecoration(
                        hintText: 'What are your career/academic goals?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitUpdate,
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save Changes'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    widget.onSubmit({
      'purpose': _purposeController.text,
      'institution_name': _institutionController.text.isEmpty ? null : _institutionController.text,
      'deadline': _deadline,
      'priority': _selectedPriority,
      'student_message': _messageController.text.isEmpty ? null : _messageController.text,
      'achievements': _achievementsController.text.isEmpty ? null : _achievementsController.text,
      'goals': _goalsController.text.isEmpty ? null : _goalsController.text,
    });

    setState(() => _isSubmitting = false);
  }
}
