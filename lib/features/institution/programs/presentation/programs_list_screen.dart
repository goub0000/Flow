import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/program_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/institution_programs_provider.dart';

class ProgramsListScreen extends ConsumerStatefulWidget {
  const ProgramsListScreen({super.key});

  @override
  ConsumerState<ProgramsListScreen> createState() => _ProgramsListScreenState();
}

class _ProgramsListScreenState extends ConsumerState<ProgramsListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showActiveOnly = true;

  final List<String> _categories = [
    'All',
    'Technology',
    'Business',
    'Science',
    'Health Sciences',
    'Arts',
    'Engineering',
  ];

  List<Program> get _filteredPrograms {
    final programs = _showActiveOnly
        ? ref.read(activeInstitutionProgramsProvider)
        : ref.read(institutionProgramsListProvider);

    var filtered = programs;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = ref
          .read(institutionProgramsProvider.notifier)
          .filterByCategory(_selectedCategory);
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = ref
          .read(institutionProgramsProvider.notifier)
          .searchPrograms(_searchQuery);
    }

    return filtered;
  }

  Future<void> _loadPrograms() async {
    await ref.read(institutionProgramsProvider.notifier).fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(institutionProgramsLoadingProvider);
    final error = ref.watch(institutionProgramsErrorProvider);

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Programs')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(institutionProgramsProvider.notifier).fetchPrograms();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return isLoading
          ? const Scaffold(
              body: LoadingIndicator(message: 'Loading programs...'),
            )
          : Column(
              children: [
                // Active/Inactive Toggle
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilterChip(
                        label: Text(_showActiveOnly ? 'Active Only' : 'Show All'),
                        selected: _showActiveOnly,
                        onSelected: (selected) {
                          setState(() => _showActiveOnly = !_showActiveOnly);
                        },
                        avatar: Icon(
                          _showActiveOnly ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search and Filter
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search programs...',
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
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = category == _selectedCategory;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() => _selectedCategory = category);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Programs List
                Expanded(child: _buildProgramsList()),
              ],
            );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: 'programs_fab',
        onPressed: () async {
          await context.push('/institution/programs/create');
          _loadPrograms();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Program'),
    );
  }

  Widget _buildProgramsList() {
    final programs = _filteredPrograms;

    if (programs.isEmpty) {
      return EmptyState(
        icon: Icons.school_outlined,
        title: 'No Programs Found',
        message: _searchQuery.isNotEmpty
            ? 'Try adjusting your search'
            : 'Create your first program',
        actionLabel: 'Create Program',
        onAction: () async {
          await context.push('/institution/programs/create');
          _loadPrograms();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPrograms,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProgramCard(
              program: program,
              onTap: () async {
                await context.push('/institution/programs/${program.id}');
                _loadPrograms();
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.program,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercentage = program.fillPercentage;

    return CustomCard(
      onTap: onTap,
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
                      program.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.level.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (!program.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'INACTIVE',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            program.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.category, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                program.category,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.timer, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                _formatDuration(program.duration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '\$${program.fee.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Enrollment Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enrollment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    '${program.enrolledStudents}/${program.maxStudents}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fillPercentage / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    fillPercentage >= 90
                        ? AppColors.error
                        : fillPercentage >= 70
                            ? AppColors.warning
                            : AppColors.success,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fillPercentage >= 100
                    ? 'Full'
                    : '${program.availableSlots} slots available',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: fillPercentage >= 90
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontWeight: fillPercentage >= 90
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    if (days < 30) {
      return '$days days';
    } else if (days < 365) {
      final months = (days / 30).round();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (days / 365).round();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }
}
