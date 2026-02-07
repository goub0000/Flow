// ignore_for_file: null_check_on_nullable_type_parameter

import 'package:flutter/material.dart';
import 'error_boundary.dart';
import '../error_handler.dart';

/// Safe Widget Wrapper - Wraps widgets with error boundary and logging
///
/// Usage:
/// ```dart
/// SafeWidget(
///   child: YourPotentiallyFailingWidget(),
///   fallback: Text('Failed to load'),
/// )
/// ```
class SafeWidget extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final bool logErrors;

  const SafeWidget({
    required this.child,
    this.fallback,
    this.logErrors = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      onError: (error, stackTrace) {
        if (logErrors) {
          ErrorHandler.handleError(
            error,
            stackTrace,
            context: 'SafeWidget',
          );
        }
      },
      errorBuilder: fallback != null
          ? (error, stackTrace) => fallback!
          : null,
      child: child,
    );
  }
}

/// Safe Future Builder - FutureBuilder with error handling
class SafeFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SafeFutureBuilder({
    required this.future,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        if (snapshot.hasError) {
          ErrorHandler.handleError(
            snapshot.error!,
            StackTrace.current,
            context: 'SafeFutureBuilder',
          );

          return errorWidget ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load data',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}

/// Safe Stream Builder - StreamBuilder with error handling
class SafeStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SafeStreamBuilder({
    required this.stream,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        if (snapshot.hasError) {
          ErrorHandler.handleError(
            snapshot.error!,
            StackTrace.current,
            context: 'SafeStreamBuilder',
          );

          return errorWidget ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Stream error',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
        }

        if (!snapshot.hasData) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }

        return builder(context, snapshot.data!);
      },
    );
  }
}
