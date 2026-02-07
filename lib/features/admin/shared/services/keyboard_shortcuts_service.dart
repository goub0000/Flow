// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard Shortcuts Service
/// Provides global keyboard shortcuts for admin dashboard
class KeyboardShortcutsService {
  static final KeyboardShortcutsService _instance = KeyboardShortcutsService._internal();
  factory KeyboardShortcutsService() => _instance;
  KeyboardShortcutsService._internal();

  final Map<ShortcutKey, VoidCallback> _shortcuts = {};

  /// Register a keyboard shortcut
  void register(ShortcutKey key, VoidCallback callback) {
    _shortcuts[key] = callback;
  }

  /// Unregister a keyboard shortcut
  void unregister(ShortcutKey key) {
    _shortcuts.remove(key);
  }

  /// Handle key event
  bool handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final isCtrlOrCmd = HardwareKeyboard.instance.isMetaPressed ||
        HardwareKeyboard.instance.isControlPressed;
    final isShift = HardwareKeyboard.instance.isShiftPressed;
    final isAlt = HardwareKeyboard.instance.isAltPressed;

    // Check all registered shortcuts
    for (final entry in _shortcuts.entries) {
      final key = entry.key;
      final callback = entry.value;

      if (key.logicalKey == event.logicalKey &&
          key.control == isCtrlOrCmd &&
          key.shift == isShift &&
          key.alt == isAlt) {
        callback();
        return true;
      }
    }

    return false;
  }

  /// Clear all shortcuts
  void clearAll() {
    _shortcuts.clear();
  }

  /// Get all registered shortcuts
  List<ShortcutInfo> getAllShortcuts() {
    return _shortcuts.entries.map((entry) {
      return ShortcutInfo(
        key: entry.key,
        description: entry.key.description,
      );
    }).toList();
  }
}

/// Shortcut Key Definition
class ShortcutKey {
  final LogicalKeyboardKey logicalKey;
  final bool control;
  final bool shift;
  final bool alt;
  final String description;

  const ShortcutKey({
    required this.logicalKey,
    this.control = false,
    this.shift = false,
    this.alt = false,
    required this.description,
  });

  String get displayString {
    final parts = <String>[];
    if (control) parts.add('Ctrl');
    if (shift) parts.add('Shift');
    if (alt) parts.add('Alt');
    parts.add(_getKeyLabel());
    return parts.join(' + ');
  }

  String _getKeyLabel() {
    if (logicalKey == LogicalKeyboardKey.keyK) return 'K';
    if (logicalKey == LogicalKeyboardKey.slash) return '/';
    if (logicalKey == LogicalKeyboardKey.keyN) return 'N';
    if (logicalKey == LogicalKeyboardKey.keyS) return 'S';
    if (logicalKey == LogicalKeyboardKey.keyP) return 'P';
    if (logicalKey == LogicalKeyboardKey.escape) return 'Esc';
    if (logicalKey == LogicalKeyboardKey.question) return '?';
    if (logicalKey == LogicalKeyboardKey.keyF) return 'F';
    if (logicalKey == LogicalKeyboardKey.keyE) return 'E';
    if (logicalKey == LogicalKeyboardKey.keyD) return 'D';
    if (logicalKey == LogicalKeyboardKey.keyH) return 'H';
    return logicalKey.keyLabel;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShortcutKey &&
        other.logicalKey == logicalKey &&
        other.control == control &&
        other.shift == shift &&
        other.alt == alt;
  }

  @override
  int get hashCode {
    return Object.hash(logicalKey, control, shift, alt);
  }
}

/// Shortcut Information
class ShortcutInfo {
  final ShortcutKey key;
  final String description;

  ShortcutInfo({
    required this.key,
    required this.description,
  });
}

/// Predefined Shortcuts
class AdminShortcuts {
  // Global shortcuts
  static const focusSearch = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyK,
    control: true,
    description: 'Focus search bar',
  );

  static const toggleSidebar = ShortcutKey(
    logicalKey: LogicalKeyboardKey.slash,
    control: true,
    description: 'Toggle sidebar',
  );

  static const showHelp = ShortcutKey(
    logicalKey: LogicalKeyboardKey.slash,
    shift: true,
    description: 'Show keyboard shortcuts help',
  );

  static const newItem = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyN,
    control: true,
    description: 'Create new item',
  );

  static const save = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyS,
    control: true,
    description: 'Save changes',
  );

  static const print = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyP,
    control: true,
    description: 'Print current view',
  );

  static const escape = ShortcutKey(
    logicalKey: LogicalKeyboardKey.escape,
    description: 'Close dialog/menu',
  );

  static const refresh = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyF,
    control: true,
    description: 'Refresh data',
  );

  static const exportData = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyE,
    control: true,
    shift: true,
    description: 'Export data',
  );

  static const goToDashboard = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyD,
    control: true,
    alt: true,
    description: 'Go to dashboard',
  );

  static const showQuickActions = ShortcutKey(
    logicalKey: LogicalKeyboardKey.keyH,
    control: true,
    description: 'Show quick actions',
  );
}
