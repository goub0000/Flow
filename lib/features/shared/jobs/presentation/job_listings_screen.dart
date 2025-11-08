import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/job_career_widgets.dart';

/// Job Listings Screen
///
/// Displays available job opportunities with search and filter capabilities.
/// Features:
/// - Search jobs by title, company, or skills
/// - Filter by job type, experience level, location
/// - Save/bookmark jobs
/// - Sort by relevance, date, salary
///
/// Backend Integration TODO:
/// - Fetch job listings from API
/// - Implement real-time search
/// - Save user's job preferences
/// - Track saved jobs
/// - Implement pagination

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  // Filter states
  final Set<JobType> _selectedTypes = {};
  final Set<ExperienceLevel> _selectedLevels = {};
  bool _remoteOnly = false;
  String _sortBy = 'relevance'; // relevance, date, salary

  // Mock data
  List<JobListing> _mockJobs = [];
  List<JobListing> _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockJobs();
    _filteredJobs = _mockJobs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockJobs() {
    _mockJobs = [
      JobListing(
        id: '1',
        title: 'Software Engineer',
        company: 'TechCorp Kenya',
        location: 'Nairobi, Kenya',
        isRemote: true,
        type: JobType.fullTime,
        experienceLevel: ExperienceLevel.mid,
        salary: 'KSh 150,000 - 250,000/month',
        description:
            'We are looking for a talented software engineer to join our team...',
        requirements: [
          '3+ years of software development experience',
          'Proficiency in Flutter/React',
          'Experience with REST APIs',
        ],
        responsibilities: [
          'Develop and maintain mobile applications',
          'Collaborate with cross-functional teams',
          'Write clean, maintainable code',
        ],
        benefits: [
          'Health insurance',
          'Remote work',
          'Professional development budget',
        ],
        skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        postedDate: DateTime.now().subtract(const Duration(days: 2)),
        applicationDeadline:
            DateTime.now().add(const Duration(days: 14)),
      ),
      JobListing(
        id: '2',
        title: 'Product Designer',
        company: 'Design Studio',
        location: 'Mombasa, Kenya',
        isRemote: false,
        type: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        salary: 'KSh 120,000 - 180,000/month',
        description:
            'Join our creative team as a product designer and help shape the future of our products...',
        requirements: [
          '5+ years of product design experience',
          'Proficiency in Figma and Adobe Creative Suite',
          'Strong portfolio',
        ],
        responsibilities: [
          'Lead product design initiatives',
          'Conduct user research',
          'Create wireframes and prototypes',
        ],
        benefits: [
          'Health insurance',
          'Flexible hours',
          'Creative workspace',
        ],
        skills: ['Figma', 'UI/UX', 'Prototyping', 'User Research'],
        postedDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      JobListing(
        id: '3',
        title: 'Data Analyst Intern',
        company: 'Analytics Hub',
        location: 'Kisumu, Kenya',
        isRemote: true,
        type: JobType.internship,
        experienceLevel: ExperienceLevel.entry,
        salary: 'KSh 30,000 - 50,000/month',
        description:
            'Great opportunity for recent graduates to gain hands-on experience in data analytics...',
        requirements: [
          'Bachelor\'s degree in related field',
          'Basic knowledge of SQL and Python',
          'Strong analytical skills',
        ],
        responsibilities: [
          'Analyze data sets',
          'Create reports and visualizations',
          'Support data-driven decision making',
        ],
        benefits: [
          'Mentorship program',
          'Remote work',
          'Learning opportunities',
        ],
        skills: ['Python', 'SQL', 'Excel', 'Data Visualization'],
        postedDate: DateTime.now().subtract(const Duration(days: 1)),
        applicationDeadline:
            DateTime.now().add(const Duration(days: 21)),
        isSaved: true,
      ),
      JobListing(
        id: '4',
        title: 'Content Writer',
        company: 'Media Company Ltd',
        location: 'Nakuru, Kenya',
        isRemote: true,
        type: JobType.contract,
        experienceLevel: ExperienceLevel.junior,
        salary: 'KSh 60,000 - 90,000/month',
        description:
            'We need a creative content writer to produce engaging content for our platforms...',
        requirements: [
          '2+ years of content writing experience',
          'Excellent English writing skills',
          'SEO knowledge',
        ],
        responsibilities: [
          'Write articles and blog posts',
          'Research industry topics',
          'Optimize content for SEO',
        ],
        benefits: [
          'Flexible schedule',
          'Remote work',
          'Byline credit',
        ],
        skills: ['Writing', 'SEO', 'Content Strategy', 'Research'],
        postedDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
      JobListing(
        id: '5',
        title: 'Marketing Manager',
        company: 'Growth Agency',
        location: 'Nairobi, Kenya',
        isRemote: false,
        type: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        salary: 'KSh 180,000 - 280,000/month',
        description:
            'Lead our marketing efforts and drive business growth through innovative campaigns...',
        requirements: [
          '5+ years of marketing experience',
          'Proven track record in digital marketing',
          'Team leadership experience',
        ],
        responsibilities: [
          'Develop marketing strategies',
          'Manage marketing team',
          'Analyze campaign performance',
        ],
        benefits: [
          'Health insurance',
          'Performance bonuses',
          'Professional development',
        ],
        skills: [
          'Digital Marketing',
          'SEO/SEM',
          'Analytics',
          'Team Leadership'
        ],
        postedDate: DateTime.now().subtract(const Duration(days: 3)),
        applicationDeadline:
            DateTime.now().add(const Duration(days: 10)),
      ),
      JobListing(
        id: '6',
        title: 'DevOps Engineer',
        company: 'Cloud Solutions Inc',
        location: 'Remote',
        isRemote: true,
        type: JobType.fullTime,
        experienceLevel: ExperienceLevel.mid,
        salary: 'KSh 200,000 - 300,000/month',
        description:
            'Join our infrastructure team and help us build scalable cloud solutions...',
        requirements: [
          '3+ years of DevOps experience',
          'AWS/Azure/GCP certification',
          'Kubernetes experience',
        ],
        responsibilities: [
          'Manage cloud infrastructure',
          'Implement CI/CD pipelines',
          'Monitor system performance',
        ],
        benefits: [
          'Fully remote',
          'Health insurance',
          'Equipment provided',
        ],
        skills: ['AWS', 'Kubernetes', 'Docker', 'CI/CD', 'Linux'],
        postedDate: DateTime.now(),
      ),
    ];
  }

  void _filterJobs() {
    setState(() {
      _filteredJobs = _mockJobs.where((job) {
        // Search filter
        if (_searchController.text.isNotEmpty) {
          final searchLower = _searchController.text.toLowerCase();
          if (!job.title.toLowerCase().contains(searchLower) &&
              !job.company.toLowerCase().contains(searchLower) &&
              !job.skills.any((s) => s.toLowerCase().contains(searchLower))) {
            return false;
          }
        }

        // Type filter
        if (_selectedTypes.isNotEmpty &&
            !_selectedTypes.contains(job.type)) {
          return false;
        }

        // Experience level filter
        if (_selectedLevels.isNotEmpty &&
            !_selectedLevels.contains(job.experienceLevel)) {
          return false;
        }

        // Remote filter
        if (_remoteOnly && !job.isRemote) {
          return false;
        }

        return true;
      }).toList();

      // Sort
      if (_sortBy == 'date') {
        _filteredJobs.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      } else if (_sortBy == 'salary') {
        // Simple salary sort (would need better parsing in production)
        _filteredJobs.sort((a, b) => b.salary.compareTo(a.salary));
      }
    });
  }

  void _toggleSaveJob(JobListing job) {
    setState(() {
      final index = _mockJobs.indexWhere((j) => j.id == job.id);
      if (index != -1) {
        _mockJobs[index] = job.copyWith(isSaved: !job.isSaved);
        _filterJobs();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          job.isSaved ? 'Job removed from saved' : 'Job saved successfully',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Job Opportunities'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Jobs'),
            Tab(text: 'Saved'),
            Tab(text: 'Applied'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs, companies, or skills...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterJobs();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) => _filterJobs(),
                ),
                const SizedBox(height: 12),

                // Filter Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Filter Button
                      OutlinedButton.icon(
                        onPressed: _showFilterSheet,
                        icon: const Icon(Icons.filter_list),
                        label: Text(
                          _getFilterCount() > 0
                              ? 'Filters (${_getFilterCount()})'
                              : 'Filters',
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Sort Button
                      OutlinedButton.icon(
                        onPressed: _showSortSheet,
                        icon: const Icon(Icons.sort),
                        label: Text('Sort: ${_getSortLabel()}'),
                      ),
                      const SizedBox(width: 8),

                      // Remote Only Toggle
                      FilterChip(
                        label: const Text('Remote Only'),
                        selected: _remoteOnly,
                        onSelected: (value) {
                          setState(() {
                            _remoteOnly = value;
                            _filterJobs();
                          });
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
              '${_filteredJobs.length} jobs found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),

          // Job List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Jobs Tab
                _buildJobList(_filteredJobs),

                // Saved Jobs Tab
                _buildJobList(
                  _filteredJobs.where((j) => j.isSaved).toList(),
                ),

                // Applied Jobs Tab (mock empty state)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No applications yet',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start applying to jobs to see them here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList(List<JobListing> jobs) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No jobs found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
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
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(
          job: job,
          onTap: () {
            // TODO: Navigate to job detail screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Job detail screen coming soon'),
              ),
            );
          },
          onSave: () => _toggleSaveJob(job),
        );
      },
    );
  }

  int _getFilterCount() {
    return _selectedTypes.length + _selectedLevels.length;
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'date':
        return 'Newest';
      case 'salary':
        return 'Salary';
      default:
        return 'Relevance';
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
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
                    const Text(
                      'Filter Jobs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedTypes.clear();
                          _selectedLevels.clear();
                        });
                        setState(() {
                          _filterJobs();
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),

              // Filter Options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Job Type
                    const Text(
                      'Job Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: JobType.values.map((type) {
                        return JobFilterChip(
                          label: type.displayName,
                          isSelected: _selectedTypes.contains(type),
                          onTap: () {
                            setModalState(() {
                              if (_selectedTypes.contains(type)) {
                                _selectedTypes.remove(type);
                              } else {
                                _selectedTypes.add(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Experience Level
                    const Text(
                      'Experience Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ExperienceLevel.values.map((level) {
                        return JobFilterChip(
                          label: level.displayName,
                          isSelected: _selectedLevels.contains(level),
                          onTap: () {
                            setModalState(() {
                              if (_selectedLevels.contains(level)) {
                                _selectedLevels.remove(level);
                              } else {
                                _selectedLevels.add(level);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filterJobs();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Sort Options
          RadioListTile<String>(
            title: const Text('Relevance'),
            value: 'relevance',
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _filterJobs();
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Newest First'),
            value: 'date',
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _filterJobs();
              });
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Highest Salary'),
            value: 'salary',
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _filterJobs();
              });
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
