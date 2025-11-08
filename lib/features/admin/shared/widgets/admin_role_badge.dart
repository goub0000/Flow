import 'package:flutter/material.dart';
import '../../../../core/models/admin_user_model.dart';

/// Admin Role Badge - Visual indicator of admin role with icon
class AdminRoleBadge extends StatelessWidget {
  final AdminUser adminUser;
  final bool compact;

  const AdminRoleBadge({
    required this.adminUser,
    this.compact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: adminUser.roleBadgeColor,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        boxShadow: adminUser.isSuperAdmin
            ? [
                BoxShadow(
                  color: adminUser.badgeAccentColor?.withValues(alpha: 0.3) ??
                      Colors.transparent,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            adminUser.roleIcon,
            size: compact ? 14 : 16,
            color: Colors.white,
          ),
          if (!compact) ...[
            const SizedBox(width: 6),
            Text(
              adminUser.roleBadgeText,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 10 : 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
