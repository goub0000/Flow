import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/job_career_widgets.dart';

/// Career Counseling Screen
///
/// Allows users to browse career counselors and book counseling sessions.
/// Features:
/// - Browse available career counselors
/// - View counselor profiles and specializations
/// - Book counseling sessions
/// - View upcoming and past sessions
/// - Rate and review counselors
///
/// Backend Integration TODO:
/// - Fetch counselors from API
/// - Implement booking system
/// - Handle payment processing
/// - Send booking confirmations
/// - Manage session scheduling
/// - Store session notes and feedback

class CareerCounselingScreen extends StatefulWidget {
  const CareerCounselingScreen({super.key});

  @override
  State<CareerCounselingScreen> createState() =>
      _CareerCounselingScreenState();
}

class _CareerCounselingScreenState extends State<CareerCounselingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<CareerCounselor> _mockCounselors = [];
  List<CareerCounselor> _filteredCounselors = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockCounselors();
    _filteredCounselors = _mockCounselors;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockCounselors() {
    _mockCounselors = const [
      CareerCounselor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'Tech Career Specialist',
        bio:
            'Over 10 years of experience helping professionals navigate tech careers. Specialized in career transitions and skill development.',
        rating: 4.9,
        reviewCount: 234,
        sessionsCompleted: 450,
        expertise: [
          'Career Transitions',
          'Tech Industry',
          'Skill Development',
          'Interview Prep'
        ],
        isAvailable: true,
      ),
      CareerCounselor(
        id: '2',
        name: 'James Kamau',
        specialization: 'Business & Management',
        bio:
            'Experienced career counselor focusing on business leadership and management career paths.',
        rating: 4.8,
        reviewCount: 189,
        sessionsCompleted: 380,
        expertise: [
          'Leadership',
          'Management',
          'Career Planning',
          'Executive Coaching'
        ],
        isAvailable: true,
      ),
      CareerCounselor(
        id: '3',
        name: 'Grace Mwangi',
        specialization: 'Creative Industries',
        bio:
            'Helping creatives build sustainable and fulfilling careers in design, media, and arts.',
        rating: 4.7,
        reviewCount: 156,
        sessionsCompleted: 290,
        expertise: ['Creative Careers', 'Portfolio Building', 'Freelancing'],
        isAvailable: false,
      ),
      CareerCounselor(
        id: '4',
        name: 'Michael Odhiambo',
        specialization: 'Finance & Accounting',
        bio:
            'Expert in finance and accounting career development with focus on certification paths.',
        rating: 4.9,
        reviewCount: 201,
        sessionsCompleted: 410,
        expertise: [
          'Finance Careers',
          'Certifications',
          'Career Advancement'
        ],
        isAvailable: true,
      ),
      CareerCounselor(
        id: '5',
        name: 'Amina Hassan',
        specialization: 'Healthcare Careers',
        bio:
            'Specialized in healthcare career guidance, from nursing to medical administration.',
        rating: 4.8,
        reviewCount: 178,
        sessionsCompleted: 350,
        expertise: [
          'Healthcare',
          'Medical Careers',
          'Continuing Education'
        ],
        isAvailable: true,
      ),
    ];
  }

  void _filterCounselors() {
    setState(() {
      _filteredCounselors = _mockCounselors.where((counselor) {
        if (_searchController.text.isEmpty) return true;

        final searchLower = _searchController.text.toLowerCase();
        return counselor.name.toLowerCase().contains(searchLower) ||
            counselor.specialization.toLowerCase().contains(searchLower) ||
            counselor.expertise
                .any((exp) => exp.toLowerCase().contains(searchLower));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Counseling'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Find Counselor'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past Sessions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Find Counselor Tab
          _buildFindCounselorTab(),

          // Upcoming Sessions Tab
          _buildUpcomingSessionsTab(theme),

          // Past Sessions Tab
          _buildPastSessionsTab(theme),
        ],
      ),
    );
  }

  Widget _buildFindCounselorTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, specialization, or expertise...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterCounselors();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (_) => _filterCounselors(),
              ),
              const SizedBox(height: 12),

              // Filter Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Available Now'),
                      selected: false,
                      onSelected: (value) {
                        // TODO: Filter by availability
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Highest Rated'),
                      selected: false,
                      onSelected: (value) {
                        // TODO: Sort by rating
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Most Experienced'),
                      selected: false,
                      onSelected: (value) {
                        // TODO: Sort by experience
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results Count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            '${_filteredCounselors.length} counselors available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),

        // Counselors List
        Expanded(
          child: _buildCounselorsList(_filteredCounselors),
        ),
      ],
    );
  }

  Widget _buildCounselorsList(List<CareerCounselor> counselors) {
    if (counselors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No counselors found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: counselors.length,
      itemBuilder: (context, index) {
        final counselor = counselors[index];
        return CareerCounselorCard(
          counselor: counselor,
          onTap: () {
            _showCounselorDetail(counselor);
          },
          onBook: () {
            _showBookingDialog(counselor);
          },
        );
      },
    );
  }

  Widget _buildUpcomingSessionsTab(ThemeData theme) {
    // Mock upcoming session
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      child: const Text(
                        'SJ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Sarah Johnson',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Tech Career Specialist',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SessionInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Tomorrow, Mar 15, 2024',
                ),
                const SizedBox(height: 8),
                _SessionInfoRow(
                  icon: Icons.access_time,
                  label: '2:00 PM - 3:00 PM (60 min)',
                ),
                const SizedBox(height: 8),
                _SessionInfoRow(
                  icon: Icons.video_call,
                  label: 'Video Call Session',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Reschedule
                        },
                        child: const Text('Reschedule'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Join session
                        },
                        child: const Text('Join Session'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPastSessionsTab(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No past sessions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your completed sessions will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCounselorDetail(CareerCounselor counselor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      counselor.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counselor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          counselor.specialization,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.star,
                          label: 'Rating',
                          value: '${counselor.rating}',
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people,
                          label: 'Sessions',
                          value: '${counselor.sessionsCompleted}',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.thumb_up,
                          label: 'Reviews',
                          value: '${counselor.reviewCount}',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bio
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    counselor.bio,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Expertise
                  const Text(
                    'Areas of Expertise',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: counselor.expertise.map((exp) {
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
                          exp,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Book Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: counselor.isAvailable
                      ? () {
                          Navigator.pop(context);
                          _showBookingDialog(counselor);
                        }
                      : null,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    counselor.isAvailable
                        ? 'Book Session'
                        : 'Currently Unavailable',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(CareerCounselor counselor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Counseling Session'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking with ${counselor.name}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Session Type
              const Text('Session Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: '30',
                    child: Text('30 min - KSh 2,000'),
                  ),
                  DropdownMenuItem(
                    value: '60',
                    child: Text('60 min - KSh 3,500'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),

              // Date Selection
              const Text('Preferred Date'),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Show date picker
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date'),
              ),
              const SizedBox(height: 16),

              // Notes
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Session Notes (Optional)',
                  hintText: 'What would you like to discuss?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
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
                  content: Text('Session booked successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}

/// Session Info Row Widget
class _SessionInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SessionInfoRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
