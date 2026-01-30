import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/providers/cookie_providers.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart

class UserDataViewerScreen extends ConsumerStatefulWidget {
  const UserDataViewerScreen({super.key});

  @override
  ConsumerState<UserDataViewerScreen> createState() =>
      _UserDataViewerScreenState();
}

class _UserDataViewerScreenState extends ConsumerState<UserDataViewerScreen> {
  ConsentStatus? _filterStatus;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      children: [
        // Page Header
        _buildPageHeader(),

        // Search and filter bar
        _buildSearchAndFilterBar(),

        // User list
        Expanded(
          child: _buildUserList(),
        ),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.people, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Cookie Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'View and manage user cookie consent data',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportAllData(),
            tooltip: 'Export All Data',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by User ID...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 12),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                _buildFilterChip('All', null),
                const SizedBox(width: 8),
                _buildFilterChip('Accepted', ConsentStatus.accepted),
                const SizedBox(width: 8),
                _buildFilterChip('Customized', ConsentStatus.customized),
                const SizedBox(width: 8),
                _buildFilterChip('Declined', ConsentStatus.declined),
                const SizedBox(width: 8),
                _buildFilterChip('Not Asked', ConsentStatus.notAsked),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ConsentStatus? status) {
    final isSelected = _filterStatus == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = selected ? status : null;
        });
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  List<Map<String, dynamic>> _mapBackendUsers(Map<String, dynamic> data) {
    final usersList = (data['users'] as List<dynamic>?) ?? [];
    return usersList.map<Map<String, dynamic>>((u) {
      final raw = u as Map<String, dynamic>;
      final cats = raw['categories'] as Map<String, dynamic>? ?? {};

      // Derive ConsentStatus from the backend status string
      ConsentStatus status;
      switch (raw['status']) {
        case 'accepted':
          status = ConsentStatus.accepted;
          break;
        case 'customized':
          status = ConsentStatus.customized;
          break;
        case 'declined':
          status = ConsentStatus.declined;
          break;
        default:
          status = ConsentStatus.notAsked;
      }

      // Parse timestamp
      DateTime timestamp;
      try {
        timestamp = DateTime.parse(raw['timestamp'] ?? raw['lastUpdated'] ?? '');
      } catch (_) {
        timestamp = DateTime.now();
      }

      return {
        'userId': raw['userId'] ?? '',
        'displayName': raw['displayName'] ?? '',
        'status': status,
        'timestamp': timestamp,
        'consentDate': raw['consentDate'] ?? '',
        'lastUpdated': raw['lastUpdated'] ?? '',
        'categories': {
          CookieCategory.essential: cats['essential'] == true,
          CookieCategory.functional: cats['functional'] == true,
          CookieCategory.analytics: cats['analytics'] == true,
          CookieCategory.marketing: cats['marketing'] == true,
        },
      };
    }).toList();
  }

  Widget _buildUserList() {
    final usersAsync = ref.watch(adminConsentUsersProvider);

    return usersAsync.when(
      data: (data) {
        final users = _mapBackendUsers(data);
        final filteredUsers = users.where((user) {
          final matchesSearch = _searchQuery.isEmpty ||
              user['userId'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (user['displayName'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesFilter = _filterStatus == null ||
              user['status'] == _filterStatus;
          return matchesSearch && matchesFilter;
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _buildUserCard(user);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading users: $error',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(adminConsentUsersProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final userId = user['userId'] as String;
    final displayName = user['displayName'] as String? ?? '';
    final status = user['status'] as ConsentStatus;
    final timestamp = user['timestamp'] as DateTime;
    final categories = user['categories'] as Map<CookieCategory, bool>;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(status).withOpacity(0.2),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
          ),
        ),
        title: Text(
          displayName.isNotEmpty ? displayName : 'User: ${userId.length > 8 ? '${userId.substring(0, 8)}...' : userId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              _getStatusLabel(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Last updated: ${_formatDate(timestamp)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cookie Preferences',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...CookieCategory.values.map((category) {
                  final isEnabled = categories[category] ?? false;
                  return _buildCategoryRow(category, isEnabled);
                }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewUserDetails(userId),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _exportUserData(userId),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Export Data'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteUserData(userId),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(CookieCategory category, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            category.icon,
            size: 20,
            color: isEnabled ? AppColors.success : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.displayName,
              style: TextStyle(
                color: isEnabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            color: isEnabled ? AppColors.success : Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ConsentStatus status) {
    switch (status) {
      case ConsentStatus.accepted:
        return AppColors.success;
      case ConsentStatus.customized:
        return AppColors.warning;
      case ConsentStatus.declined:
        return AppColors.error;
      case ConsentStatus.notAsked:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(ConsentStatus status) {
    switch (status) {
      case ConsentStatus.accepted:
        return Icons.check_circle;
      case ConsentStatus.customized:
        return Icons.tune;
      case ConsentStatus.declined:
        return Icons.cancel;
      case ConsentStatus.notAsked:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel(ConsentStatus status) {
    switch (status) {
      case ConsentStatus.accepted:
        return 'Accepted All Cookies';
      case ConsentStatus.customized:
        return 'Customized Preferences';
      case ConsentStatus.declined:
        return 'Declined Cookies';
      case ConsentStatus.notAsked:
        return 'No Consent Given';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _viewUserDetails(String userId) {
    // Find the user data from the current provider snapshot
    final usersAsync = ref.read(adminConsentUsersProvider);
    Map<String, dynamic>? userData;
    usersAsync.whenData((data) {
      final users = _mapBackendUsers(data);
      for (final u in users) {
        if (u['userId'] == userId) {
          userData = u;
          break;
        }
      }
    });

    final consentDate = userData?['consentDate'] as String? ?? '';
    final lastUpdated = userData?['lastUpdated'] as String? ?? '';
    final displayName = userData?['displayName'] as String? ?? '';
    final categories = userData?['categories'] as Map<CookieCategory, bool>? ?? {};

    final enabledCount = categories.values.where((v) => v).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details: ${displayName.isNotEmpty ? displayName : userId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (displayName.isNotEmpty) ...[
                Text('User ID: $userId', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 12),
              ],
              const Text(
                'Cookie Data Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Categories enabled: $enabledCount / ${CookieCategory.values.length}'),
              ...categories.entries.map((e) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Row(
                  children: [
                    Icon(
                      e.value ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: e.value ? AppColors.success : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(e.key.displayName),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              const Text(
                'Data Collection Period',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('First consent: ${_formatIsoDate(consentDate)}'),
              Text('Last updated: ${_formatIsoDate(lastUpdated)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatIsoDate(String isoDate) {
    if (isoDate.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(isoDate);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  void _exportUserData(String userId) async {
    final cookieService = ref.read(cookieServiceProvider);

    try {
      final data = await cookieService.exportUserData(userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data exported for user $userId'),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // Show exported data
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _deleteUserData(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User Data'),
        content: Text(
          'Are you sure you want to delete all cookie data for user $userId? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final cookieService = ref.read(cookieServiceProvider);

              try {
                await cookieService.deleteUserCookieData(userId);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data deleted for user $userId'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting data: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportAllData() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export All Data'),
        content: const Text(
          'This will export cookie data for all users. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting all user data...'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

}
