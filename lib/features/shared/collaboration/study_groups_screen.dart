import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/collaboration_widgets.dart';

/// Study Groups Screen
///
/// Main interface for study group management:
/// - Browse public groups
/// - My groups tab
/// - Create new groups
/// - Join/leave groups
/// - Group search and filters
///
/// Backend Integration TODO:
/// - Fetch groups from backend
/// - Real-time group updates
/// - Group invitations
/// - Push notifications for group activity

class StudyGroupsScreen extends ConsumerStatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  ConsumerState<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends ConsumerState<StudyGroupsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late List<StudyGroup> _allGroups;
  late List<StudyGroup> _myGroups;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _generateMockGroups();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockGroups() {
    final now = DateTime.now();

    final mockMembers1 = [
      GroupMember(
        id: '1',
        name: 'John Doe',
        role: MemberRole.owner,
        isOnline: true,
        joinedAt: now.subtract(const Duration(days: 30)),
      ),
      GroupMember(
        id: '2',
        name: 'Jane Smith',
        role: MemberRole.moderator,
        isOnline: true,
        joinedAt: now.subtract(const Duration(days: 25)),
      ),
      GroupMember(
        id: '3',
        name: 'Mike Johnson',
        role: MemberRole.member,
        isOnline: false,
        joinedAt: now.subtract(const Duration(days: 20)),
      ),
    ];

    _allGroups = [
      StudyGroup(
        id: '1',
        name: 'Flutter Masters',
        description: 'Learning Flutter together, from basics to advanced topics',
        members: mockMembers1,
        courseId: '1',
        courseName: 'Mobile App Development',
        createdAt: now.subtract(const Duration(days: 30)),
        isPublic: true,
        maxMembers: 20,
        tags: ['Flutter', 'Mobile', 'Dart'],
        lastMessage: ChatMessage(
          id: '1',
          senderId: '2',
          senderName: 'Jane Smith',
          type: MessageType.text,
          content: 'Anyone working on the state management assignment?',
          timestamp: now.subtract(const Duration(minutes: 15)),
          isRead: true,
        ),
      ),
      StudyGroup(
        id: '2',
        name: 'Data Structures Study Group',
        description: 'Preparing for the upcoming exam together',
        members: [
          GroupMember(
            id: '1',
            name: 'John Doe',
            role: MemberRole.owner,
            isOnline: false,
            joinedAt: now.subtract(const Duration(days: 15)),
          ),
          GroupMember(
            id: '4',
            name: 'Sarah Wilson',
            role: MemberRole.member,
            isOnline: true,
            joinedAt: now.subtract(const Duration(days: 10)),
          ),
        ],
        courseId: '2',
        courseName: 'Data Structures',
        createdAt: now.subtract(const Duration(days: 15)),
        isPublic: false,
        maxMembers: 10,
        tags: ['Data Structures', 'Algorithms'],
        lastMessage: ChatMessage(
          id: '2',
          senderId: '4',
          senderName: 'Sarah Wilson',
          type: MessageType.text,
          content: 'Meeting at 3 PM today?',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
      ),
      StudyGroup(
        id: '3',
        name: 'Web Dev Bootcamp',
        description: 'Full-stack web development learning group',
        members: [
          GroupMember(
            id: '5',
            name: 'Alex Brown',
            role: MemberRole.owner,
            isOnline: true,
            joinedAt: now.subtract(const Duration(days: 20)),
          ),
          GroupMember(
            id: '6',
            name: 'Emily Davis',
            role: MemberRole.member,
            isOnline: false,
            joinedAt: now.subtract(const Duration(days: 18)),
          ),
          GroupMember(
            id: '7',
            name: 'David Lee',
            role: MemberRole.member,
            isOnline: true,
            joinedAt: now.subtract(const Duration(days: 15)),
          ),
        ],
        courseId: '3',
        courseName: 'Web Technologies',
        createdAt: now.subtract(const Duration(days: 20)),
        isPublic: true,
        maxMembers: 15,
        tags: ['Web Dev', 'React', 'Node.js'],
      ),
      StudyGroup(
        id: '4',
        name: 'AI/ML Research Group',
        description: 'Exploring machine learning concepts and projects',
        members: [
          GroupMember(
            id: '8',
            name: 'Chris Taylor',
            role: MemberRole.owner,
            isOnline: false,
            joinedAt: now.subtract(const Duration(days: 40)),
          ),
        ],
        courseId: '4',
        courseName: 'Artificial Intelligence',
        createdAt: now.subtract(const Duration(days: 40)),
        isPublic: true,
        maxMembers: 25,
        tags: ['AI', 'Machine Learning', 'Python'],
        lastMessage: ChatMessage(
          id: '3',
          senderId: '8',
          senderName: 'Chris Taylor',
          type: MessageType.link,
          content: 'Check out this interesting article on neural networks',
          timestamp: now.subtract(const Duration(days: 1)),
        ),
      ),
    ];

    _myGroups = [_allGroups[0], _allGroups[1]];
  }

  List<StudyGroup> get _filteredAllGroups {
    return _allGroups.where((group) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return group.name.toLowerCase().contains(query) ||
          (group.description?.toLowerCase().contains(query) ?? false) ||
          group.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<StudyGroup> get _filteredMyGroups {
    return _myGroups.where((group) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return group.name.toLowerCase().contains(query) ||
          (group.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              final user = ref.read(authProvider).user;
              if (user != null) {
                context.go(user.activeRole.dashboardRoute);
              }
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('Study Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createGroup,
            tooltip: 'Create Group',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Discover (${_filteredAllGroups.length})'),
            Tab(text: 'My Groups (${_filteredMyGroups.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search groups...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Groups List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGroupsList(_filteredAllGroups, showJoinButton: true),
                _buildGroupsList(_filteredMyGroups, showJoinButton: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createGroup,
        icon: const Icon(Icons.add),
        label: const Text('Create Group'),
      ),
    );
  }

  Widget _buildGroupsList(List<StudyGroup> groups, {required bool showJoinButton}) {
    if (groups.isEmpty) {
      return EmptyCollaborationState(
        message: _searchQuery.isNotEmpty
            ? 'No groups found'
            : showJoinButton
                ? 'No public groups available'
                : 'You haven\'t joined any groups yet',
        subtitle: _searchQuery.isNotEmpty
            ? 'Try a different search term'
            : showJoinButton
                ? 'Create the first group'
                : 'Join or create a group to get started',
        onAction: _createGroup,
        actionLabel: 'Create Group',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh groups from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return StudyGroupCard(
            group: group,
            onTap: () => _openGroup(group),
            onJoin: showJoinButton ? () => _joinGroup(group) : null,
            showJoinButton: showJoinButton,
          );
        },
      ),
    );
  }

  void _openGroup(StudyGroup group) {
    Navigator.pushNamed(
      context,
      '/collaboration/group',
      arguments: group,
    );
  }

  void _joinGroup(StudyGroup group) {
    if (group.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This group is full'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Group?'),
        content: Text('Do you want to join "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (!_myGroups.contains(group)) {
                  _myGroups.add(group);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Joined ${group.name}'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _createGroup() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPublic = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Create Study Group'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Public Group'),
                    subtitle: const Text('Anyone can join'),
                    value: isPublic,
                    onChanged: (value) {
                      setDialogState(() {
                        isPublic = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a group name'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }

                  // TODO: Create group via backend
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Created group: $name'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}
