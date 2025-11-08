import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/child_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../providers/parent_children_provider.dart';

class ChildrenListScreen extends ConsumerWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(parentChildrenLoadingProvider);
    final children = ref.watch(parentChildrenListProvider);
    final error = ref.watch(parentChildrenErrorProvider);

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
                ref.read(parentChildrenProvider.notifier).fetchChildren();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const LoadingIndicator(message: 'Loading children...');
    }

    if (children.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline,
        title: 'No Children',
        message: 'Add your children to monitor their progress',
        actionLabel: 'Add Child',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(parentChildrenProvider.notifier).fetchChildren();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ChildCard(
              child: child,
              onTap: () {
                context.go('/parent/children/${child.id}');
              },
            ),
          );
        },
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  final Child child;
  final VoidCallback onTap;

  const _ChildCard({
    required this.child,
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
                photoUrl: child.photoUrl,
                initials: child.initials,
                size: 64,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${child.grade} • Age ${child.age}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    if (child.schoolName != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.school,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              child.schoolName!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getGradeColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      child.averageGrade.toStringAsFixed(1),
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(),
                              ),
                    ),
                    Text(
                      'AVG',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getGradeColor(),
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.book_outlined,
                  label: 'Courses',
                  value: '${child.enrolledCourses.length}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.surface,
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.description_outlined,
                  label: 'Applications',
                  value: '${child.applications.length}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.surface,
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.access_time,
                  label: 'Last Active',
                  value: _getLastActiveText(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor() {
    if (child.averageGrade >= 90) return AppColors.success;
    if (child.averageGrade >= 75) return AppColors.info;
    if (child.averageGrade >= 60) return AppColors.warning;
    return AppColors.error;
  }

  String _getLastActiveText() {
    final difference = DateTime.now().difference(child.lastActive);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}
