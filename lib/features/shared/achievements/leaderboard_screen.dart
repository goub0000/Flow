import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import '../widgets/achievements_widgets.dart';
import '../widgets/logo_avatar.dart';

/// Leaderboard Screen
///
/// Competitive rankings interface:
/// - Global leaderboard
/// - Course-specific leaderboards
/// - Weekly/monthly rankings
/// - Friend rankings
/// - Filter and search
///
/// Backend Integration TODO:
/// - Fetch leaderboard data from backend
/// - Real-time rank updates
/// - Load more entries (pagination)
/// - Friend system integration

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late List<LeaderboardEntry> _globalEntries;
  late List<LeaderboardEntry> _weeklyEntries;
  late List<LeaderboardEntry> _monthlyEntries;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    _globalEntries = [
      const LeaderboardEntry(
        userId: '1',
        userName: 'Alex Thompson',
        rank: 1,
        points: 15420,
        coursesCompleted: 25,
        achievementsUnlocked: 48,
        averageScore: 94.5,
        tier: BadgeTier.diamond,
      ),
      const LeaderboardEntry(
        userId: '2',
        userName: 'Sarah Chen',
        rank: 2,
        points: 14230,
        coursesCompleted: 22,
        achievementsUnlocked: 45,
        averageScore: 92.8,
        tier: BadgeTier.platinum,
      ),
      const LeaderboardEntry(
        userId: '3',
        userName: 'Michael Rodriguez',
        rank: 3,
        points: 13890,
        coursesCompleted: 21,
        achievementsUnlocked: 42,
        averageScore: 91.2,
        tier: BadgeTier.platinum,
      ),
      const LeaderboardEntry(
        userId: '4',
        userName: 'Emily Johnson',
        rank: 4,
        points: 12650,
        coursesCompleted: 19,
        achievementsUnlocked: 40,
        averageScore: 89.7,
        tier: BadgeTier.gold,
      ),
      const LeaderboardEntry(
        userId: '5',
        userName: 'David Kim',
        rank: 5,
        points: 11920,
        coursesCompleted: 18,
        achievementsUnlocked: 38,
        averageScore: 88.5,
        tier: BadgeTier.gold,
      ),
      const LeaderboardEntry(
        userId: 'current',
        userName: 'You',
        rank: 127,
        points: 4850,
        coursesCompleted: 8,
        achievementsUnlocked: 15,
        averageScore: 82.3,
        isCurrentUser: true,
        tier: BadgeTier.silver,
      ),
      const LeaderboardEntry(
        userId: '6',
        userName: 'Jessica Martinez',
        rank: 128,
        points: 4820,
        coursesCompleted: 8,
        achievementsUnlocked: 14,
        averageScore: 81.9,
        tier: BadgeTier.silver,
      ),
      const LeaderboardEntry(
        userId: '7',
        userName: 'James Wilson',
        rank: 129,
        points: 4790,
        coursesCompleted: 7,
        achievementsUnlocked: 14,
        averageScore: 81.5,
        tier: BadgeTier.silver,
      ),
      const LeaderboardEntry(
        userId: '8',
        userName: 'Lisa Anderson',
        rank: 130,
        points: 4760,
        coursesCompleted: 7,
        achievementsUnlocked: 13,
        averageScore: 81.2,
        tier: BadgeTier.bronze,
      ),
      const LeaderboardEntry(
        userId: '9',
        userName: 'Robert Taylor',
        rank: 131,
        points: 4730,
        coursesCompleted: 7,
        achievementsUnlocked: 13,
        averageScore: 80.8,
        tier: BadgeTier.bronze,
      ),
    ];

    _weeklyEntries = [
      const LeaderboardEntry(
        userId: '2',
        userName: 'Sarah Chen',
        rank: 1,
        points: 1250,
        coursesCompleted: 3,
        achievementsUnlocked: 8,
        averageScore: 95.2,
        tier: BadgeTier.platinum,
      ),
      const LeaderboardEntry(
        userId: 'current',
        userName: 'You',
        rank: 2,
        points: 1180,
        coursesCompleted: 2,
        achievementsUnlocked: 6,
        averageScore: 88.5,
        isCurrentUser: true,
        tier: BadgeTier.silver,
      ),
      const LeaderboardEntry(
        userId: '4',
        userName: 'Emily Johnson',
        rank: 3,
        points: 1120,
        coursesCompleted: 2,
        achievementsUnlocked: 7,
        averageScore: 91.3,
        tier: BadgeTier.gold,
      ),
      const LeaderboardEntry(
        userId: '1',
        userName: 'Alex Thompson',
        rank: 4,
        points: 1050,
        coursesCompleted: 2,
        achievementsUnlocked: 5,
        averageScore: 89.7,
        tier: BadgeTier.diamond,
      ),
      const LeaderboardEntry(
        userId: '5',
        userName: 'David Kim',
        rank: 5,
        points: 980,
        coursesCompleted: 2,
        achievementsUnlocked: 5,
        averageScore: 87.2,
        tier: BadgeTier.gold,
      ),
    ];

    _monthlyEntries = [
      const LeaderboardEntry(
        userId: '1',
        userName: 'Alex Thompson',
        rank: 1,
        points: 4320,
        coursesCompleted: 8,
        achievementsUnlocked: 18,
        averageScore: 93.8,
        tier: BadgeTier.diamond,
      ),
      const LeaderboardEntry(
        userId: '4',
        userName: 'Emily Johnson',
        rank: 2,
        points: 3950,
        coursesCompleted: 7,
        achievementsUnlocked: 16,
        averageScore: 91.5,
        tier: BadgeTier.gold,
      ),
      const LeaderboardEntry(
        userId: '2',
        userName: 'Sarah Chen',
        rank: 3,
        points: 3820,
        coursesCompleted: 7,
        achievementsUnlocked: 15,
        averageScore: 90.2,
        tier: BadgeTier.platinum,
      ),
      const LeaderboardEntry(
        userId: 'current',
        userName: 'You',
        rank: 12,
        points: 2540,
        coursesCompleted: 5,
        achievementsUnlocked: 10,
        averageScore: 85.7,
        isCurrentUser: true,
        tier: BadgeTier.silver,
      ),
      const LeaderboardEntry(
        userId: '5',
        userName: 'David Kim',
        rank: 13,
        points: 2480,
        coursesCompleted: 4,
        achievementsUnlocked: 9,
        averageScore: 84.3,
        tier: BadgeTier.gold,
      ),
    ];
  }

  List<LeaderboardEntry> _getFilteredEntries(List<LeaderboardEntry> entries) {
    if (_searchQuery.isEmpty) return entries;

    return entries
        .where((entry) =>
            entry.userName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Time'),
            Tab(text: 'This Week'),
            Tab(text: 'This Month'),
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
                hintText: 'Search users...',
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

          // Tier Legend
          _buildTierLegend(),

          // Leaderboard Lists
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(_getFilteredEntries(_globalEntries)),
                _buildLeaderboardList(_getFilteredEntries(_weeklyEntries)),
                _buildLeaderboardList(_getFilteredEntries(_monthlyEntries)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text(
              'Tiers: ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            _buildTierBadge(BadgeTier.diamond),
            const SizedBox(width: 12),
            _buildTierBadge(BadgeTier.platinum),
            const SizedBox(width: 12),
            _buildTierBadge(BadgeTier.gold),
            const SizedBox(width: 12),
            _buildTierBadge(BadgeTier.silver),
            const SizedBox(width: 12),
            _buildTierBadge(BadgeTier.bronze),
          ],
        ),
      ),
    );
  }

  Widget _buildTierBadge(BadgeTier tier) {
    final entry = LeaderboardEntry(
      userId: '',
      userName: '',
      rank: 0,
      points: 0,
      tier: tier,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          entry.tierIcon,
          size: 16,
          color: entry.tierColor,
        ),
        const SizedBox(width: 4),
        Text(
          entry.tierLabel,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: entry.tierColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return EmptyAchievementsState(
        message: 'No users found',
        subtitle: _searchQuery.isNotEmpty
            ? 'Try a different search term'
            : 'Be the first to compete!',
      );
    }

    // Find current user and top 3
    final currentUserIndex =
        entries.indexWhere((entry) => entry.isCurrentUser);
    final top3 = entries.take(3).toList();
    final hasTopPodium = entries.length >= 3;

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh leaderboard from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // Top 3 Podium
          if (hasTopPodium && _searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: _buildPodium(top3),
            ),

          // Rest of the list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Skip first 3 if showing podium
                  final actualIndex =
                      hasTopPodium && _searchQuery.isEmpty ? index + 3 : index;

                  if (actualIndex >= entries.length) return null;

                  final entry = entries[actualIndex];

                  // Show current user if not in visible range
                  if (hasTopPodium &&
                      _searchQuery.isEmpty &&
                      currentUserIndex >= 3 &&
                      index == 0 &&
                      actualIndex != currentUserIndex) {
                    return Column(
                      children: [
                        LeaderboardCard(
                          entry: entries[currentUserIndex],
                          onTap: () => _showUserProfile(entries[currentUserIndex]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Other Rankings',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                            ],
                          ),
                        ),
                        LeaderboardCard(
                          entry: entry,
                          onTap: () => _showUserProfile(entry),
                        ),
                      ],
                    );
                  }

                  return LeaderboardCard(
                    entry: entry,
                    onTap: () => _showUserProfile(entry),
                  );
                },
                childCount: hasTopPodium && _searchQuery.isEmpty
                    ? entries.length - 3
                    : entries.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardEntry> top3) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Top Performers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd Place
              if (top3.length > 1)
                Expanded(child: _buildPodiumPlace(top3[1], 2, 140))
              else
                const Expanded(child: SizedBox()),

              // 1st Place
              Expanded(child: _buildPodiumPlace(top3[0], 1, 180)),

              // 3rd Place
              if (top3.length > 2)
                Expanded(child: _buildPodiumPlace(top3[2], 3, 120))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(LeaderboardEntry entry, int place, double height) {
    Color placeColor;
    IconData icon;

    switch (place) {
      case 1:
        placeColor = const Color(0xFFFFD700); // Gold
        icon = Icons.emoji_events;
      case 2:
        placeColor = const Color(0xFFC0C0C0); // Silver
        icon = Icons.emoji_events_outlined;
      case 3:
        placeColor = const Color(0xFFCD7F32); // Bronze
        icon = Icons.emoji_events_outlined;
      default:
        placeColor = Colors.grey;
        icon = Icons.workspace_premium;
    }

    return GestureDetector(
      onTap: () => _showUserProfile(entry),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: placeColor,
                    width: 3,
                  ),
                ),
                child: LogoAvatar.user(
                  photoUrl: entry.avatarUrl,
                  initials: entry.userName.split(' ').map((e) => e[0]).join().toUpperCase(),
                  size: 64,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: placeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            entry.userName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Points
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${entry.points}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Podium
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  placeColor,
                  placeColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                '$place',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(LeaderboardEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar and name
                LogoAvatar.user(
                  photoUrl: entry.avatarUrl,
                  initials: entry.userName.split(' ').map((e) => e[0]).join().toUpperCase(),
                  size: 100,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                Text(
                  entry.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (entry.tier != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        entry.tierIcon,
                        color: entry.tierColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.tierLabel} Tier',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: entry.tierColor,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),

                // Stats grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildStatCard('Rank', '#${entry.rank}', Icons.trending_up),
                    _buildStatCard(
                        'Points', '${entry.points}', Icons.stars),
                    _buildStatCard('Courses', '${entry.coursesCompleted}',
                        Icons.school),
                    _buildStatCard('Achievements',
                        '${entry.achievementsUnlocked}', Icons.emoji_events),
                    _buildStatCard('Avg Score',
                        '${entry.averageScore.toStringAsFixed(1)}%', Icons.grade),
                    _buildStatCard('Level', '${(entry.points / 100).floor() + 1}',
                        Icons.workspace_premium),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
