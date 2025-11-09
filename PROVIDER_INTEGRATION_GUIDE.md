# Provider Integration Quick Guide

## 🎯 3-Step Integration Process

### Step 1: Import & Convert Widget

```dart
// Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/your_provider.dart';

// Change from:
class MyScreen extends StatefulWidget

// To:
class MyScreen extends ConsumerStatefulWidget

// And change:
class _MyScreenState extends State<MyScreen>

// To:
class _MyScreenState extends ConsumerState<MyScreen>
```

### Step 2: Remove Manual State

**DELETE these:**
```dart
bool _isLoading = true;
List<YourModel> _data = [];
String? _error;

@override
void initState() {
  super.initState();
  _loadData(); // Remove manual data loading
}

Future<void> _loadData() async {
  setState(() => _isLoading = true);
  // ... API call
  setState(() {
    _data = result;
    _isLoading = false;
  });
}
```

### Step 3: Use Provider

**ADD this in build method:**
```dart
@override
Widget build(BuildContext context) {
  // Watch providers for reactive updates
  final isLoading = ref.watch(yourLoadingProvider);
  final data = ref.watch(yourDataProvider);
  final error = ref.watch(yourErrorProvider);

  // Handle states
  if (isLoading) return const LoadingIndicator();
  if (error != null) return ErrorWidget(error);

  // Use data normally
  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) => YourCard(data[index]),
  );
}
```

---

## 📚 Provider Reference by Module

### Institution Module

```dart
// Programs
import '../../providers/institution_programs_provider.dart';

final programs = ref.watch(institutionProgramsListProvider);
final isLoading = ref.watch(institutionProgramsLoadingProvider);
final stats = ref.watch(institutionProgramStatisticsProvider);

// Actions
ref.read(institutionProgramsProvider.notifier).createProgram(program);
ref.read(institutionProgramsProvider.notifier).updateProgram(program);
ref.read(institutionProgramsProvider.notifier).deleteProgram(id);

// Applicants
import '../../providers/institution_applicants_provider.dart';

final applicants = ref.watch(institutionApplicantsListProvider);
final pending = ref.watch(pendingApplicantsProvider);
final stats = ref.watch(institutionApplicantStatisticsProvider);

// Actions
ref.read(institutionApplicantsProvider.notifier).updateApplicantStatus(id, status);
ref.read(institutionApplicantsProvider.notifier).addReviewNotes(id, notes, reviewer);

// Dashboard
import '../../providers/institution_dashboard_provider.dart';

final stats = ref.watch(institutionDashboardStatisticsProvider);
final activity = ref.watch(institutionRecentActivityProvider);
```

### Parent Module

```dart
// Children
import '../../providers/parent_children_provider.dart';

final children = ref.watch(parentChildrenListProvider);
final stats = ref.watch(parentChildrenStatisticsProvider);
final needingAttention = ref.watch(childrenNeedingAttentionProvider);

// Actions
ref.read(parentChildrenProvider.notifier).addChild(child);
ref.read(parentChildrenProvider.notifier).updateChild(child);

// Monitoring
import '../../providers/parent_monitoring_provider.dart';

ref.read(childMonitoringProvider.notifier).selectChild(childId);
final progress = ref.watch(selectedChildCourseProgressProvider);
final metrics = ref.watch(selectedChildPerformanceMetricsProvider);

// Alerts
import '../../providers/parent_alerts_provider.dart';

final alerts = ref.watch(parentAlertsListProvider);
final unreadCount = ref.watch(unreadAlertsCountProvider);
final highPriority = ref.watch(highSeverityAlertsProvider);

// Actions
ref.read(parentAlertsProvider.notifier).markAsRead(id);
ref.read(parentAlertsProvider.notifier).markAllAsRead();
```

### Counselor Module

```dart
// Students
import '../../providers/counselor_students_provider.dart';

final students = ref.watch(counselorStudentsListProvider);
final stats = ref.watch(counselorStudentStatisticsProvider);
final needingAttention = ref.watch(studentsNeedingAttentionProvider);

// Actions
ref.read(counselorStudentsProvider.notifier).addNotes(studentId, notes);

// Sessions
import '../../providers/counselor_sessions_provider.dart';

final sessions = ref.watch(counselorSessionsListProvider);
final upcoming = ref.watch(upcomingSessionsProvider);
final today = ref.watch(todaySessionsProvider);
final stats = ref.watch(counselorSessionStatisticsProvider);

// Actions
ref.read(counselorSessionsProvider.notifier).createSession(session);
ref.read(counselorSessionsProvider.notifier).updateSessionStatus(id, status);
ref.read(counselorSessionsProvider.notifier).addSessionNotes(id, notes, summary);

// Dashboard
import '../../providers/counselor_dashboard_provider.dart';

final stats = ref.watch(counselorDashboardStatisticsProvider);
final activity = ref.watch(counselorRecentActivityProvider);
```

### Recommender Module

```dart
// Requests
import '../../providers/recommender_requests_provider.dart';

final requests = ref.watch(recommenderRequestsListProvider);
final pending = ref.watch(pendingRecommendationRequestsProvider);
final urgent = ref.watch(urgentRecommendationRequestsProvider);
final stats = ref.watch(recommenderRequestStatisticsProvider);

// Actions
ref.read(recommenderRequestsProvider.notifier).submitRecommendation(id, content);
ref.read(recommenderRequestsProvider.notifier).saveDraft(id, content);
ref.read(recommenderRequestsProvider.notifier).declineRequest(id, reason);

// Dashboard
import '../../providers/recommender_dashboard_provider.dart';

final stats = ref.watch(recommenderDashboardStatisticsProvider);
final activity = ref.watch(recommenderRecentActivityProvider);
```

### Admin Module

```dart
// Users
import '../../shared/providers/admin_users_provider.dart';

final users = ref.watch(filteredUsersProvider);
final stats = ref.watch(userStatisticsProvider);
final students = ref.watch(adminStudentsProvider);
final institutions = ref.watch(adminInstitutionsProvider);

// Actions
ref.read(adminUsersProvider.notifier).updateUserStatus(id, isActive);
ref.read(adminUsersProvider.notifier).deleteUser(id);
ref.read(adminUsersProvider.notifier).bulkUpdateRoles(ids, role);

// Finance
import '../../shared/providers/admin_finance_provider.dart';

final transactions = ref.watch(adminTransactionsListProvider);
final stats = ref.watch(adminFinanceStatisticsProvider);

// Actions
ref.read(adminFinanceProvider.notifier).processRefund(txnId, amount, reason);

// Analytics
import '../../shared/providers/admin_analytics_provider.dart';

final metrics = ref.watch(adminAnalyticsMetricsProvider);

// Actions
ref.read(adminAnalyticsProvider.notifier).generateReport(
  reportType: 'user_activity',
  startDate: startDate,
  endDate: endDate,
);

// Communications
import '../../shared/providers/admin_communications_provider.dart';

final campaigns = ref.watch(adminCampaignsListProvider);
final stats = ref.watch(adminCampaignStatisticsProvider);

// Actions
ref.read(adminCommunicationsProvider.notifier).sendAnnouncement(
  title: 'Title',
  message: 'Message',
  targetRoles: ['student', 'parent'],
  type: 'push',
);

// Support
import '../../shared/providers/admin_support_provider.dart';

final tickets = ref.watch(adminTicketsListProvider);
final stats = ref.watch(adminTicketStatisticsProvider);

// Actions
ref.read(adminSupportProvider.notifier).updateTicketStatus(id, status);
ref.read(adminSupportProvider.notifier).assignTicket(id, adminName);
ref.read(adminSupportProvider.notifier).addResponse(id, message);

// Audit
import '../../shared/providers/admin_audit_provider.dart';

final logs = ref.watch(adminAuditLogsListProvider);
final stats = ref.watch(adminAuditStatisticsProvider);

// Actions
ref.read(adminAuditProvider.notifier).logAction(
  userId: userId,
  userName: userName,
  userRole: role,
  action: 'update',
  resource: 'user',
  resourceId: resourceId,
  ipAddress: ip,
);

// System
import '../../shared/providers/admin_system_provider.dart';

final settings = ref.watch(adminSystemSettingsProvider);
final info = ref.watch(adminSystemInfoProvider);

// Actions
ref.read(adminSystemProvider.notifier).updateSetting(key, value);
ref.read(adminSystemProvider.notifier).clearCache();
ref.read(adminSystemProvider.notifier).backupDatabase();

// Content
import '../../shared/providers/admin_content_provider.dart';

final content = ref.watch(adminContentListProvider);
final stats = ref.watch(adminContentStatisticsProvider);
final pending = ref.watch(adminContentPendingReviewProvider);

// Actions
ref.read(adminContentProvider.notifier).approveContent(id);
ref.read(adminContentProvider.notifier).rejectContent(id);
```

### Shared Module

```dart
// Notifications
import '../../providers/notifications_provider.dart';

final notifications = ref.watch(notificationsListProvider);
final unreadCount = ref.watch(unreadNotificationsCountProvider);

// Actions
ref.read(notificationsProvider.notifier).markAsRead(id);
ref.read(notificationsProvider.notifier).markAllAsRead();
ref.read(notificationsProvider.notifier).deleteNotification(id);

// Messaging
import '../../providers/messaging_provider.dart';

final conversations = ref.watch(conversationsListProvider);
final unreadCount = ref.watch(totalUnreadMessagesCountProvider);

// Actions
ref.read(messagingProvider.notifier).fetchMessages(conversationId);
ref.read(messagingProvider.notifier).sendMessage(conversationId, content, senderId);
ref.read(messagingProvider.notifier).markConversationAsRead(conversationId);

// Documents
import '../../providers/documents_provider.dart';

final documents = ref.watch(documentsListProvider);
final folders = ref.watch(foldersListProvider);
final stats = ref.watch(documentStatisticsProvider);

// Actions
ref.read(documentsProvider.notifier).uploadDocument(document);
ref.read(documentsProvider.notifier).deleteDocument(id);
ref.read(documentsProvider.notifier).createFolder(name);

// Payments
import '../../providers/payments_provider.dart';

final payments = ref.watch(paymentsListProvider);
final methods = ref.watch(paymentMethodsListProvider);
final stats = ref.watch(paymentStatisticsProvider);

// Actions
ref.read(paymentsProvider.notifier).processPayment(
  itemId: itemId,
  itemType: 'course',
  amount: 100.0,
  currency: 'USD',
  method: paymentMethod,
);
ref.read(paymentsProvider.notifier).addPaymentMethod(method);

// Profile
import '../../providers/profile_provider.dart';

final user = ref.watch(currentProfileProvider);
final completeness = ref.watch(profileCompletenessProvider);

// Actions
ref.read(profileProvider.notifier).updateProfile(
  displayName: name,
  phoneNumber: phone,
);
ref.read(profileProvider.notifier).uploadProfilePhoto(filePath);
ref.read(profileProvider.notifier).changePassword(
  currentPassword: current,
  newPassword: newPass,
);
```

---

## ⚡ Common Patterns

### Pattern 1: List Screen with Loading

```dart
@override
Widget build(BuildContext context) {
  final isLoading = ref.watch(yourLoadingProvider);
  final items = ref.watch(yourListProvider);

  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (items.isEmpty) {
    return const EmptyState(message: 'No items found');
  }

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ItemCard(item: items[index]),
  );
}
```

### Pattern 2: Search & Filter

```dart
String _searchQuery = '';
String _filterStatus = 'all';

List<Item> get _filteredItems {
  final notifier = ref.read(yourProvider.notifier);

  var items = ref.read(yourListProvider);

  if (_searchQuery.isNotEmpty) {
    items = notifier.searchItems(_searchQuery);
  }

  if (_filterStatus != 'all') {
    items = notifier.filterByStatus(_filterStatus);
  }

  return items;
}
```

### Pattern 3: Create/Update Actions

```dart
void _saveItem() async {
  final success = await ref.read(yourProvider.notifier).createItem(newItem);

  if (success) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item created successfully')),
      );
      context.pop();
    }
  }
}
```

### Pattern 4: Refresh

```dart
Future<void> _refresh() async {
  await ref.read(yourProvider.notifier).fetchData();
}

// In build:
RefreshIndicator(
  onRefresh: _refresh,
  child: ListView(...),
)
```

### Pattern 5: Error Handling

```dart
final error = ref.watch(yourErrorProvider);

if (error != null) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text(error),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => ref.read(yourProvider.notifier).fetchData(),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
```

---

## 🎯 Copy-Paste Templates

### Template 1: Simple List Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/your_provider.dart';

class YourListScreen extends ConsumerWidget {
  const YourListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(yourLoadingProvider);
    final items = ref.watch(yourListProvider);
    final error = ref.watch(yourErrorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name),
                      onTap: () => context.push('/item/${item.id}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Template 2: Dashboard with Stats

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/your_provider.dart';

class YourDashboard extends ConsumerWidget {
  const YourDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(yourStatisticsProvider);
    final isLoading = ref.watch(yourLoadingProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: [
        StatCard(
          title: 'Total',
          value: stats['total'].toString(),
          icon: Icons.analytics,
        ),
        StatCard(
          title: 'Active',
          value: stats['active'].toString(),
          icon: Icons.check_circle,
        ),
      ],
    );
  }
}
```

### Template 3: Detail Screen with Actions

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/your_provider.dart';

class ItemDetailScreen extends ConsumerWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(yourListProvider);
    final item = items.firstWhere((i) => i.id == itemId);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/edit/$itemId'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                final success = await ref
                    .read(yourProvider.notifier)
                    .deleteItem(itemId);

                if (success && context.mounted) {
                  context.pop();
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(item.description),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Final Checklist

Before marking a screen as "complete":

- [ ] Imported provider
- [ ] Changed to ConsumerStatefulWidget/ConsumerWidget
- [ ] Removed manual state variables (_isLoading, _data, etc.)
- [ ] Removed initState() data loading
- [ ] Using ref.watch() for reactive data
- [ ] Using ref.read() for actions
- [ ] Handling loading state
- [ ] Handling error state
- [ ] Handling empty state
- [ ] Tested UI updates when data changes

---

**Happy Coding! 🚀**
