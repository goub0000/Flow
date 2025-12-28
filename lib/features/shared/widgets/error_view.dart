import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final String? customMessage;
  final bool showDetails;
  final IconData? customIcon;
  final StackTrace? stackTrace;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.customMessage,
    this.showDetails = false,
    this.customIcon,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorInfo = _parseError(error);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: errorInfo.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                customIcon ?? errorInfo.icon,
                size: 48,
                color: errorInfo.color,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              errorInfo.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error Message
            Text(
              customMessage ?? errorInfo.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),

            // Technical Details (Debug Mode Only)
            if ((kDebugMode || showDetails) && error.toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: Text(
                  'Technical Details',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      _getTechnicalDetails(),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Retry Button
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: FilledButton.styleFrom(
                    backgroundColor: errorInfo.color,
                    foregroundColor: Colors.white,
                  ),
                ),

                // Additional Actions based on error type
                if (errorInfo.secondaryAction != null) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: errorInfo.secondaryAction!.onPressed,
                    child: Text(errorInfo.secondaryAction!.label),
                  ),
                ],
              ],
            ),

            // Help Text
            if (errorInfo.helpText != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorInfo.helpText!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTechnicalDetails() {
    final buffer = StringBuffer();
    buffer.writeln('Error Type: ${error.runtimeType}');
    buffer.writeln('Error Message: $error');

    if (stackTrace != null && kDebugMode) {
      buffer.writeln('\nStack Trace:');
      buffer.writeln(stackTrace.toString().split('\n').take(10).join('\n'));
    }

    return buffer.toString();
  }

  ErrorInfo _parseError(Object error) {
    final errorString = error.toString().toLowerCase();

    // Network Errors
    if (errorString.contains('socketexception') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return ErrorInfo(
        title: 'Connection Error',
        message: 'Unable to connect to our servers. Please check your internet connection and try again.',
        icon: Icons.wifi_off,
        color: AppColors.warning,
        helpText: 'Make sure you have a stable internet connection. If the problem persists, our servers might be temporarily unavailable.',
        secondaryAction: null,
      );
    }

    // Authentication Errors
    if (errorString.contains('401') ||
        errorString.contains('403') ||
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden') ||
        errorString.contains('authentication')) {
      return ErrorInfo(
        title: 'Authentication Required',
        message: 'Your session has expired or you don\'t have permission to access this content.',
        icon: Icons.lock_outline,
        color: AppColors.error,
        helpText: 'Try logging out and logging back in to refresh your session.',
        secondaryAction: ErrorAction(
          label: 'Sign Out',
          onPressed: () {
            // TODO: Implement sign out navigation
          },
        ),
      );
    }

    // Not Found Errors
    if (errorString.contains('404') ||
        errorString.contains('not found')) {
      return ErrorInfo(
        title: 'Content Not Found',
        message: 'The content you\'re looking for doesn\'t exist or has been moved.',
        icon: Icons.search_off,
        color: AppColors.info,
        helpText: 'The item may have been deleted or you may not have access to view it.',
        secondaryAction: null,
      );
    }

    // Server Errors
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('server error') ||
        errorString.contains('internal')) {
      return ErrorInfo(
        title: 'Server Error',
        message: 'Something went wrong on our end. We\'re working to fix it.',
        icon: Icons.cloud_off,
        color: AppColors.error,
        helpText: 'This is a temporary issue. Please try again in a few minutes.',
        secondaryAction: null,
      );
    }

    // Rate Limit Errors
    if (errorString.contains('429') ||
        errorString.contains('rate limit') ||
        errorString.contains('too many requests')) {
      return ErrorInfo(
        title: 'Too Many Requests',
        message: 'You\'ve made too many requests. Please wait a moment before trying again.',
        icon: Icons.timer_off,
        color: AppColors.warning,
        helpText: 'To prevent abuse, we limit the number of requests. Please wait a few seconds before retrying.',
        secondaryAction: null,
      );
    }

    // Validation Errors
    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return ErrorInfo(
        title: 'Validation Error',
        message: 'Some information appears to be incorrect or missing. Please check your input and try again.',
        icon: Icons.error_outline,
        color: AppColors.warning,
        helpText: 'Make sure all required fields are filled correctly.',
        secondaryAction: null,
      );
    }

    // Permission Errors
    if (errorString.contains('permission') ||
        errorString.contains('access denied')) {
      return ErrorInfo(
        title: 'Access Denied',
        message: 'You don\'t have permission to access this content.',
        icon: Icons.block,
        color: AppColors.error,
        helpText: 'Contact your administrator if you believe you should have access.',
        secondaryAction: null,
      );
    }

    // Generic Error
    return ErrorInfo(
      title: 'Something Went Wrong',
      message: 'An unexpected error occurred. Please try again.',
      icon: Icons.error_outline,
      color: AppColors.error,
      helpText: 'If this problem continues, please contact support.',
      secondaryAction: null,
    );
  }
}

class ErrorInfo {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String? helpText;
  final ErrorAction? secondaryAction;

  ErrorInfo({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.helpText,
    this.secondaryAction,
  });
}

class ErrorAction {
  final String label;
  final VoidCallback onPressed;

  ErrorAction({
    required this.label,
    required this.onPressed,
  });
}

// Convenience widget for inline error displays
class InlineErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  final String? customMessage;

  const InlineErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              customMessage ?? 'Failed to load data',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}