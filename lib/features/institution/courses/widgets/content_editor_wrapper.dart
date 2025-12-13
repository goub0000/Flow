import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A professional wrapper widget that provides common functionality for all content editors.
/// Features: auto-save, validation framework, preview toggle, template management,
/// keyboard shortcuts, and consistent UX patterns.
class ContentEditorWrapper extends StatefulWidget {
  /// The title displayed in the header
  final String title;

  /// Optional subtitle or description
  final String? subtitle;

  /// The icon to display in the header
  final IconData icon;

  /// The color theme for this editor
  final Color themeColor;

  /// The main editor content widget
  final Widget editorContent;

  /// The preview content widget (shown in preview mode)
  final Widget previewContent;

  /// Callback when save is requested
  final VoidCallback onSave;

  /// Callback when cancel is requested
  final VoidCallback onCancel;

  /// Callback for auto-save (called every 30 seconds if content changed)
  final VoidCallback? onAutoSave;

  /// Callback to check if content has unsaved changes
  final bool Function() hasUnsavedChanges;

  /// Callback for validation - returns list of error messages
  final List<String> Function() validate;

  /// Whether the content is currently valid
  final bool isValid;

  /// Whether saving is in progress
  final bool isSaving;

  /// Optional keyboard shortcuts map
  final Map<ShortcutActivator, VoidCallback>? shortcuts;

  /// Optional actions to show in the header
  final List<Widget>? headerActions;

  /// Whether to show the preview toggle
  final bool showPreviewToggle;

  /// Whether to enable auto-save
  final bool enableAutoSave;

  /// Auto-save interval in seconds
  final int autoSaveIntervalSeconds;

  /// Save button label
  final String saveButtonLabel;

  /// Optional summary widget to show content stats
  final Widget? summaryWidget;

  const ContentEditorWrapper({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.themeColor = Colors.blue,
    required this.editorContent,
    required this.previewContent,
    required this.onSave,
    required this.onCancel,
    this.onAutoSave,
    required this.hasUnsavedChanges,
    required this.validate,
    this.isValid = true,
    this.isSaving = false,
    this.shortcuts,
    this.headerActions,
    this.showPreviewToggle = true,
    this.enableAutoSave = true,
    this.autoSaveIntervalSeconds = 30,
    this.saveButtonLabel = 'Save Content',
    this.summaryWidget,
  });

  @override
  State<ContentEditorWrapper> createState() => _ContentEditorWrapperState();
}

class _ContentEditorWrapperState extends State<ContentEditorWrapper> {
  bool _isPreviewMode = false;
  bool _showValidationErrors = false;
  Timer? _autoSaveTimer;
  DateTime? _lastAutoSave;

  @override
  void initState() {
    super.initState();
    if (widget.enableAutoSave && widget.onAutoSave != null) {
      _startAutoSaveTimer();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer = Timer.periodic(
      Duration(seconds: widget.autoSaveIntervalSeconds),
      (_) {
        if (widget.hasUnsavedChanges()) {
          widget.onAutoSave?.call();
          setState(() {
            _lastAutoSave = DateTime.now();
          });
        }
      },
    );
  }

  Future<bool> _handleBackNavigation() async {
    if (widget.hasUnsavedChanges()) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              const Text('Unsaved Changes'),
            ],
          ),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave? '
            'Your changes will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Stay'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Discard Changes'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  void _handleSave() {
    final errors = widget.validate();
    if (errors.isEmpty) {
      widget.onSave();
    } else {
      setState(() {
        _showValidationErrors = true;
      });
      _showValidationDialog(errors);
    }
  }

  void _showValidationDialog(List<String> errors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            const Text('Validation Errors'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please fix the following issues before saving:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: errors.map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handleBackNavigation();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): _handleSave,
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
            if (widget.showPreviewToggle) {
              setState(() => _isPreviewMode = !_isPreviewMode);
            }
          },
          ...?widget.shortcuts,
        },
        child: Focus(
          autofocus: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              if (widget.summaryWidget != null) ...[
                widget.summaryWidget!,
                const SizedBox(height: 16),
              ],
              Expanded(
                child: _isPreviewMode
                    ? _buildPreviewPanel()
                    : widget.editorContent,
              ),
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.icon,
            color: widget.themeColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_lastAutoSave != null) ...[
          _buildAutoSaveIndicator(),
          const SizedBox(width: 16),
        ],
        if (widget.showPreviewToggle) ...[
          _buildPreviewToggle(),
          const SizedBox(width: 16),
        ],
        if (widget.headerActions != null) ...widget.headerActions!,
      ],
    );
  }

  Widget _buildAutoSaveIndicator() {
    return Tooltip(
      message: 'Last auto-saved at ${_formatTime(_lastAutoSave!)}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_done, size: 16, color: Colors.green.shade700),
            const SizedBox(width: 6),
            Text(
              'Saved',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildPreviewToggle() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: false,
          label: Text('Edit'),
          icon: Icon(Icons.edit, size: 16),
        ),
        ButtonSegment(
          value: true,
          label: Text('Preview'),
          icon: Icon(Icons.visibility, size: 16),
        ),
      ],
      selected: {_isPreviewMode},
      onSelectionChanged: (Set<bool> newSelection) {
        setState(() {
          _isPreviewMode = newSelection.first;
        });
      },
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Student Preview',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              _buildDevicePreviewSelector(),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: widget.previewContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicePreviewSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDeviceButton(Icons.desktop_windows, 'Desktop', true),
        const SizedBox(width: 8),
        _buildDeviceButton(Icons.tablet, 'Tablet', false),
        const SizedBox(width: 8),
        _buildDeviceButton(Icons.phone_android, 'Mobile', false),
      ],
    );
  }

  Widget _buildDeviceButton(IconData icon, String tooltip, bool isSelected) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          // TODO: Implement device preview switching
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.themeColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? widget.themeColor : Colors.grey.shade300,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected ? widget.themeColor : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Keyboard shortcuts hint
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Ctrl+S to save',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (widget.showPreviewToggle) ...[
                Text(
                  ' | Ctrl+P to preview',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () async {
            final shouldCancel = await _handleBackNavigation();
            if (shouldCancel) {
              widget.onCancel();
            }
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: widget.isSaving ? null : _handleSave,
          icon: widget.isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  widget.isValid ? Icons.save : Icons.warning_amber_rounded,
                  size: 18,
                ),
          label: Text(widget.isSaving ? 'Saving...' : widget.saveButtonLabel),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: widget.isValid ? null : Colors.orange,
          ),
        ),
      ],
    );
  }
}

/// A collapsible section widget for organizing editor content
class EditorSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;
  final String? subtitle;

  const EditorSection({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    required this.child,
    this.initiallyExpanded = true,
    this.trailing,
    this.subtitle,
  });

  @override
  State<EditorSection> createState() => _EditorSectionState();
}

class _EditorSectionState extends State<EditorSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.iconColor ?? Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: widget.child,
            ),
          ],
        ],
      ),
    );
  }
}

/// A helper widget for displaying field validation status
class FieldValidationIndicator extends StatelessWidget {
  final bool isValid;
  final String? errorMessage;
  final String? successMessage;

  const FieldValidationIndicator({
    super.key,
    required this.isValid,
    this.errorMessage,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isValid && successMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            size: 14,
            color: isValid ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isValid ? (successMessage ?? '') : (errorMessage ?? 'Invalid'),
            style: TextStyle(
              fontSize: 12,
              color: isValid ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A toggle switch with label and description
class LabeledSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const LabeledSwitch({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        secondary: icon != null
            ? Icon(icon, color: iconColor ?? Theme.of(context).primaryColor)
            : null,
        title: Text(title),
        subtitle: subtitle != null
            ? Text(subtitle!, style: TextStyle(color: Colors.grey.shade600))
            : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

/// A chip selector for multiple option selection
class ChipSelector<T> extends StatelessWidget {
  final List<T> options;
  final List<T> selectedOptions;
  final String Function(T) labelBuilder;
  final IconData? Function(T)? iconBuilder;
  final Color? Function(T)? colorBuilder;
  final ValueChanged<T> onToggle;
  final bool multiSelect;

  const ChipSelector({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.labelBuilder,
    this.iconBuilder,
    this.colorBuilder,
    required this.onToggle,
    this.multiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        final color = colorBuilder?.call(option) ?? Theme.of(context).primaryColor;
        final icon = iconBuilder?.call(option);

        return FilterChip(
          selected: isSelected,
          label: Text(labelBuilder(option)),
          avatar: icon != null ? Icon(icon, size: 18) : null,
          selectedColor: color.withOpacity(0.2),
          checkmarkColor: color,
          onSelected: (_) => onToggle(option),
        );
      }).toList(),
    );
  }
}

/// A duration input widget with hours, minutes, seconds
class DurationInput extends StatefulWidget {
  final Duration? initialDuration;
  final ValueChanged<Duration> onChanged;
  final bool showHours;
  final bool showSeconds;
  final String label;

  const DurationInput({
    super.key,
    this.initialDuration,
    required this.onChanged,
    this.showHours = true,
    this.showSeconds = true,
    this.label = 'Duration',
  });

  @override
  State<DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends State<DurationInput> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    final duration = widget.initialDuration ?? Duration.zero;
    _hoursController = TextEditingController(
      text: duration.inHours.toString(),
    );
    _minutesController = TextEditingController(
      text: (duration.inMinutes % 60).toString(),
    );
    _secondsController = TextEditingController(
      text: (duration.inSeconds % 60).toString(),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _updateDuration() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    widget.onChanged(Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (widget.showHours) ...[
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _hoursController,
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _updateDuration(),
                ),
              ),
              const SizedBox(width: 8),
              const Text(':', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
            ],
            SizedBox(
              width: 70,
              child: TextField(
                controller: _minutesController,
                decoration: const InputDecoration(
                  labelText: 'Min',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateDuration(),
              ),
            ),
            if (widget.showSeconds) ...[
              const SizedBox(width: 8),
              const Text(':', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: _secondsController,
                  decoration: const InputDecoration(
                    labelText: 'Sec',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => _updateDuration(),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
