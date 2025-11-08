import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/models/admin_user_model.dart';
import 'admin_permission_guard.dart';

/// Quick Action Floating Toolbar
/// Provides quick access to common admin actions
class AdminQuickActions extends ConsumerStatefulWidget {
  final AdminUser adminUser;

  const AdminQuickActions({
    required this.adminUser,
    super.key,
  });

  @override
  ConsumerState<AdminQuickActions> createState() => _AdminQuickActionsState();
}

class _AdminQuickActionsState extends ConsumerState<AdminQuickActions>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quickActions = _getQuickActions();

    return Positioned(
      right: 24,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Expanded action buttons
          SizeTransition(
            sizeFactor: _expandAnimation,
            axisAlignment: -1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: quickActions
                  .map((action) => _buildActionButton(action))
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Main FAB
          FloatingActionButton(
            heroTag: 'admin_quick_actions_fab',
            onPressed: _toggleExpanded,
            backgroundColor: AppColors.primary,
            elevation: 4,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 3.14159 * 2,
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(QuickAction action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          FadeTransition(
            opacity: _expandAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                action.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Action button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: action.color,
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _toggleExpanded();
                  action.onTap(context);
                },
                borderRadius: BorderRadius.circular(24),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<QuickAction> _getQuickActions() {
    final actions = <QuickAction>[];
    // TODO: Implement proper permission system with AdminPermissions.fromRole()
    // For now, showing all actions

    // Add User
    actions.add(QuickAction(
      icon: Icons.person_add,
      label: 'Add User',
      color: AppColors.primary,
      onTap: (context) {
        _showAddUserDialog(context);
      },
    ));

    // Add Institution
    actions.add(QuickAction(
      icon: Icons.business,
      label: 'Add Institution',
      color: AppColors.success,
      onTap: (context) {
        _showAddInstitutionDialog(context);
      },
    ));

    // Create Announcement
    actions.add(QuickAction(
      icon: Icons.campaign,
      label: 'Create Announcement',
      color: AppColors.warning,
      onTap: (context) {
        context.go('/admin/communications');
      },
    ));

    // View Analytics
    actions.add(QuickAction(
      icon: Icons.analytics,
      label: 'View Analytics',
      color: AppColors.info,
      onTap: (context) {
        context.go('/admin/analytics');
      },
    ));

    // System Settings
    actions.add(QuickAction(
      icon: Icons.settings,
      label: 'System Settings',
      color: AppColors.textSecondary,
      onTap: (context) {
        context.go('/admin/system/settings');
      },
    ));

    // Support Tickets
    actions.add(QuickAction(
      icon: Icons.support_agent,
      label: 'Support Tickets',
      color: AppColors.error,
      onTap: (context) {
        context.go('/admin/support/tickets');
      },
    ));

    return actions;
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('Student')),
                  DropdownMenuItem(value: 'parent', child: Text('Parent')),
                  DropdownMenuItem(value: 'counselor', child: Text('Counselor')),
                  DropdownMenuItem(value: 'institution', child: Text('Institution')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User creation requires backend integration'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: const Text('Create User'),
          ),
        ],
      ),
    );
  }

  void _showAddInstitutionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Institution'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Institution Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'university', child: Text('University')),
                  DropdownMenuItem(value: 'college', child: Text('College')),
                  DropdownMenuItem(value: 'highschool', child: Text('High School')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Institution creation requires backend integration'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: const Text('Create Institution'),
          ),
        ],
      ),
    );
  }
}

/// Quick Action Model
class QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Function(BuildContext) onTap;

  QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

/// Simplified Quick Actions Provider
/// For use in admin shell to show/hide quick actions
final showQuickActionsProvider = StateProvider<bool>((ref) => true);
