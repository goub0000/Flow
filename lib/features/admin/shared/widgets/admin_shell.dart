import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../providers/admin_auth_provider.dart';
import '../services/keyboard_shortcuts_service.dart';
import 'admin_sidebar.dart';
import 'admin_top_bar.dart';
import 'admin_quick_actions.dart';
import 'keyboard_shortcuts_dialog.dart';

/// Admin Shell - Main container for all admin pages
/// Provides consistent layout with sidebar and top bar
class AdminShell extends ConsumerStatefulWidget {
  final Widget child;

  const AdminShell({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  final _keyboardShortcuts = KeyboardShortcutsService();

  @override
  void initState() {
    super.initState();
    _registerKeyboardShortcuts();
  }

  @override
  void dispose() {
    _keyboardShortcuts.clearAll();
    super.dispose();
  }

  void _registerKeyboardShortcuts() {
    // Show keyboard shortcuts help (Shift + ?)
    _keyboardShortcuts.register(
      AdminShortcuts.showHelp,
      () {
        KeyboardShortcutsDialog.show(context);
      },
    );

    // Go to dashboard
    _keyboardShortcuts.register(
      AdminShortcuts.goToDashboard,
      () {
        context.go('/admin');
      },
    );

    // Refresh
    _keyboardShortcuts.register(
      AdminShortcuts.refresh,
      () {
        // Trigger page refresh - implementation depends on page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adminSharedRefreshing)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminUser = ref.watch(currentAdminUserProvider);

    // If not authenticated as admin, show error
    if (adminUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.adminSharedAdminAccessRequired,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.adminSharedPleaseSignInWithAdmin,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (event) {
        _keyboardShortcuts.handleKeyEvent(event);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Main layout
            Row(
              children: [
                // Sidebar - collapsible navigation
                Semantics(
                  label: context.l10n.adminSharedAdminNavigationSidebar,
                  namesRoute: true,
                  child: AdminSidebar(adminUser: adminUser),
                ),

                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Top bar with user info and actions
                      Semantics(
                        label: context.l10n.adminSharedAdminToolbar,
                        child: AdminTopBar(adminUser: adminUser),
                      ),

                      // Page content
                      Expanded(
                        child: Semantics(
                          label: context.l10n.adminSharedMainContent,
                          child: Container(
                            color: AppColors.background,
                            child: widget.child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Quick Actions Floating Toolbar
            AdminQuickActions(adminUser: adminUser),
          ],
        ),
      ),
    );
  }
}
