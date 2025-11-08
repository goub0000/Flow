import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility Service
/// Provides helper methods and widgets for improved accessibility
class AccessibilityService {
  AccessibilityService._();

  /// Announce message to screen readers
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Create accessible button with semantic labels
  static Widget accessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String label,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: hint,
      child: child,
    );
  }

  /// Create accessible icon button with semantic labels
  static Widget accessibleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
    String? tooltip,
    Color? color,
    double? size,
    bool enabled = true,
  }) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      hint: tooltip ?? label,
      child: IconButton(
        icon: Icon(icon, size: size),
        onPressed: enabled ? onPressed : null,
        tooltip: tooltip ?? label,
        color: color,
      ),
    );
  }

  /// Create accessible text field with semantic labels
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) {
    return Semantics(
      textField: true,
      enabled: enabled,
      label: label,
      hint: hint,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
      ),
    );
  }

  /// Create accessible card with semantic labels
  static Widget accessibleCard({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      button: onTap != null,
      child: child,
    );
  }

  /// Create accessible heading
  static Widget accessibleHeading({
    required String text,
    required TextStyle style,
    HeadingLevel level = HeadingLevel.h1,
  }) {
    return Semantics(
      header: true,
      label: text,
      child: Text(text, style: style),
    );
  }

  /// Create accessible image
  static Widget accessibleImage({
    required String imageUrl,
    required String alt,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Semantics(
      image: true,
      label: alt,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: alt,
      ),
    );
  }

  /// Create accessible link
  static Widget accessibleLink({
    required String text,
    required VoidCallback onTap,
    String? hint,
    TextStyle? style,
  }) {
    return Semantics(
      link: true,
      label: text,
      hint: hint,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: style ??
              const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
        ),
      ),
    );
  }

  /// Create focus scope for keyboard navigation
  static Widget focusScope({
    required Widget child,
    FocusScopeNode? focusNode,
    bool autofocus = false,
  }) {
    return FocusScope(
      node: focusNode,
      child: Focus(
        autofocus: autofocus,
        child: child,
      ),
    );
  }

  /// Skip to main content widget
  static Widget skipToMainContent({
    required GlobalKey mainContentKey,
    required Widget child,
  }) {
    return Column(
      children: [
        _SkipLink(
          targetKey: mainContentKey,
          label: 'Skip to main content',
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// Heading levels for semantic headings
enum HeadingLevel {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
}

/// Skip link widget for keyboard navigation
class _SkipLink extends StatelessWidget {
  final GlobalKey targetKey;
  final String label;

  const _SkipLink({
    required this.targetKey,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      child: InkWell(
        onTap: () {
          final renderObject =
              targetKey.currentContext?.findRenderObject();
          if (renderObject != null) {
            Scrollable.ensureVisible(
              targetKey.currentContext!,
              duration: const Duration(milliseconds: 300),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Focus order widget for custom tab order
class FocusOrder extends InheritedWidget {
  final int order;

  const FocusOrder({
    required this.order,
    required super.child,
    super.key,
  });

  static int? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FocusOrder>()
        ?.order;
  }

  @override
  bool updateShouldNotify(FocusOrder oldWidget) {
    return order != oldWidget.order;
  }
}

/// Accessible data table row
class AccessibleTableRow extends StatelessWidget {
  final List<Widget> cells;
  final int rowIndex;
  final bool isHeader;
  final VoidCallback? onTap;

  const AccessibleTableRow({
    required this.cells,
    required this.rowIndex,
    this.isHeader = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: isHeader
          ? 'Table header row'
          : 'Table row ${rowIndex + 1}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: cells
              .asMap()
              .entries
              .map((entry) => Semantics(
                    label: isHeader
                        ? 'Column ${entry.key + 1} header'
                        : 'Row ${rowIndex + 1}, Column ${entry.key + 1}',
                    child: entry.value,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

/// Live region for dynamic content updates
class LiveRegion extends StatelessWidget {
  final Widget child;
  final String? label;
  final LiveRegionImportance importance;

  const LiveRegion({
    required this.child,
    this.label,
    this.importance = LiveRegionImportance.polite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: label,
      child: child,
    );
  }
}

/// Live region importance levels
enum LiveRegionImportance {
  polite,
  assertive,
}
