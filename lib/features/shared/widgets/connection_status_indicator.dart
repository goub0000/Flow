/// Connection Status Indicator Widget
/// Shows the current real-time connection status with visual feedback

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/enhanced_realtime_service.dart';
import '../../../core/l10n_extension.dart';

/// Connection status indicator widget that shows real-time connection state
class ConnectionStatusIndicator extends ConsumerWidget {
  final bool showText;
  final bool showInAppBar;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? connectingColor;
  final double iconSize;

  const ConnectionStatusIndicator({
    Key? key,
    this.showText = true,
    this.showInAppBar = false,
    this.activeColor,
    this.inactiveColor,
    this.connectingColor,
    this.iconSize = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(realtimeConnectionStatusProvider);

    return connectionStatus.when(
      data: (status) => _buildIndicator(context, status),
      loading: () => _buildIndicator(context, ConnectionStatus.connecting),
      error: (_, __) => _buildIndicator(context, ConnectionStatus.error),
    );
  }

  Widget _buildIndicator(BuildContext context, ConnectionStatus status) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Determine colors
    final activeColorFinal = activeColor ?? Colors.green;
    final inactiveColorFinal = inactiveColor ?? Colors.red;
    final connectingColorFinal = connectingColor ?? Colors.orange;

    // Build content based on status
    Widget content;
    switch (status) {
      case ConnectionStatus.connected:
        content = _buildConnectedIndicator(activeColorFinal, isDarkMode, context);
        break;
      case ConnectionStatus.connecting:
        content = _buildConnectingIndicator(connectingColorFinal, isDarkMode, context);
        break;
      case ConnectionStatus.disconnected:
        content = _buildDisconnectedIndicator(inactiveColorFinal, isDarkMode, context);
        break;
      case ConnectionStatus.error:
        content = _buildErrorIndicator(inactiveColorFinal, isDarkMode, context);
        break;
    }

    // Wrap in tooltip for additional information
    return Tooltip(
      message: _getTooltipMessage(status, context),
      child: content,
    );
  }

  Widget _buildConnectedIndicator(Color color, bool isDarkMode, BuildContext context) {
    if (showInAppBar) {
      return _buildAppBarIndicator(
        icon: Icons.circle,
        color: color,
        text: showText ? context.l10n.connectionStatusLive : null,
        backgroundColor: color.withOpacity(0.1),
      );
    }

    return _buildChipIndicator(
      icon: Icons.circle,
      color: color,
      text: showText ? context.l10n.connectionStatusLive : null,
      backgroundColor: color.withOpacity(isDarkMode ? 0.2 : 0.1),
    );
  }

  Widget _buildConnectingIndicator(Color color, bool isDarkMode, BuildContext context) {
    if (showInAppBar) {
      return _buildAppBarIndicator(
        icon: null,
        color: color,
        text: showText ? context.l10n.connectionStatusConnecting : null,
        backgroundColor: color.withOpacity(0.1),
        showProgress: true,
      );
    }

    return _buildChipIndicator(
      icon: null,
      color: color,
      text: showText ? context.l10n.connectionStatusConnecting : null,
      backgroundColor: color.withOpacity(isDarkMode ? 0.2 : 0.1),
      showProgress: true,
    );
  }

  Widget _buildDisconnectedIndicator(Color color, bool isDarkMode, BuildContext context) {
    if (showInAppBar) {
      return _buildAppBarIndicator(
        icon: Icons.circle,
        color: color,
        text: showText ? context.l10n.connectionStatusOffline : null,
        backgroundColor: color.withOpacity(0.1),
      );
    }

    return _buildChipIndicator(
      icon: Icons.circle,
      color: color,
      text: showText ? context.l10n.connectionStatusOffline : null,
      backgroundColor: color.withOpacity(isDarkMode ? 0.2 : 0.1),
    );
  }

  Widget _buildErrorIndicator(Color color, bool isDarkMode, BuildContext context) {
    if (showInAppBar) {
      return _buildAppBarIndicator(
        icon: Icons.error_outline,
        color: color,
        text: showText ? context.l10n.connectionStatusError : null,
        backgroundColor: color.withOpacity(0.1),
      );
    }

    return _buildChipIndicator(
      icon: Icons.error_outline,
      color: color,
      text: showText ? context.l10n.connectionStatusError : null,
      backgroundColor: color.withOpacity(isDarkMode ? 0.2 : 0.1),
    );
  }

  Widget _buildChipIndicator({
    IconData? icon,
    required Color color,
    String? text,
    required Color backgroundColor,
    bool showProgress = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Chip(
        avatar: showProgress
            ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            : icon != null
                ? Icon(icon, size: iconSize, color: color)
                : null,
        label: text != null
            ? Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              )
            : const SizedBox.shrink(),
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: text != null ? 4 : 0,
          vertical: 0,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildAppBarIndicator({
    IconData? icon,
    required Color color,
    String? text,
    required Color backgroundColor,
    bool showProgress = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showProgress)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          else if (icon != null)
            Icon(icon, size: iconSize, color: color),
          if (text != null) ...[
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTooltipMessage(ConnectionStatus status, BuildContext context) {
    switch (status) {
      case ConnectionStatus.connected:
        return context.l10n.connectionStatusTooltipConnected;
      case ConnectionStatus.connecting:
        return context.l10n.connectionStatusTooltipConnecting;
      case ConnectionStatus.disconnected:
        return context.l10n.connectionStatusTooltipDisconnected;
      case ConnectionStatus.error:
        return context.l10n.connectionStatusTooltipError;
    }
  }
}

/// Animated connection status indicator with pulse effect
class AnimatedConnectionStatusIndicator extends ConsumerStatefulWidget {
  final bool showText;
  final double size;

  const AnimatedConnectionStatusIndicator({
    Key? key,
    this.showText = true,
    this.size = 24,
  }) : super(key: key);

  @override
  ConsumerState<AnimatedConnectionStatusIndicator> createState() =>
      _AnimatedConnectionStatusIndicatorState();
}

class _AnimatedConnectionStatusIndicatorState
    extends ConsumerState<AnimatedConnectionStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = ref.watch(realtimeConnectionStatusProvider);

    return connectionStatus.when(
      data: (status) => _buildAnimatedIndicator(context, status),
      loading: () => _buildAnimatedIndicator(context, ConnectionStatus.connecting),
      error: (_, __) => _buildAnimatedIndicator(context, ConnectionStatus.error),
    );
  }

  Widget _buildAnimatedIndicator(BuildContext context, ConnectionStatus status) {
    Color color;
    IconData icon;
    bool shouldAnimate = false;

    switch (status) {
      case ConnectionStatus.connected:
        color = Colors.green;
        icon = Icons.wifi;
        shouldAnimate = true;
        break;
      case ConnectionStatus.connecting:
        color = Colors.orange;
        icon = Icons.sync;
        shouldAnimate = true;
        break;
      case ConnectionStatus.disconnected:
        color = Colors.grey;
        icon = Icons.wifi_off;
        shouldAnimate = false;
        break;
      case ConnectionStatus.error:
        color = Colors.red;
        icon = Icons.error_outline;
        shouldAnimate = false;
        break;
    }

    if (!shouldAnimate) {
      _animationController.stop();
    } else if (!_animationController.isAnimating) {
      _animationController.repeat();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect for connected state
            if (status == ConnectionStatus.connected && shouldAnimate)
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Container(
                    width: widget.size * _scaleAnimation.value,
                    height: widget.size * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3 * (2 - _scaleAnimation.value)),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            // Main icon
            Icon(
              icon,
              size: widget.size,
              color: color,
            ),
          ],
        ),
        if (widget.showText) ...[
          const SizedBox(height: 4),
          Text(
            _getStatusText(status, context),
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  String _getStatusText(ConnectionStatus status, BuildContext context) {
    switch (status) {
      case ConnectionStatus.connected:
        return context.l10n.connectionStatusLive;
      case ConnectionStatus.connecting:
        return context.l10n.connectionStatusConnectingShort;
      case ConnectionStatus.disconnected:
        return context.l10n.connectionStatusOffline;
      case ConnectionStatus.error:
        return context.l10n.connectionStatusError;
    }
  }
}

/// Minimal connection dot indicator
class ConnectionDotIndicator extends ConsumerWidget {
  final double size;
  final bool showAnimation;

  const ConnectionDotIndicator({
    Key? key,
    this.size = 8,
    this.showAnimation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(realtimeConnectionStatusProvider);

    return connectionStatus.when(
      data: (status) => _buildDot(status),
      loading: () => _buildDot(ConnectionStatus.connecting),
      error: (_, __) => _buildDot(ConnectionStatus.error),
    );
  }

  Widget _buildDot(ConnectionStatus status) {
    Color color;
    bool shouldPulse = false;

    switch (status) {
      case ConnectionStatus.connected:
        color = Colors.green;
        shouldPulse = showAnimation;
        break;
      case ConnectionStatus.connecting:
        color = Colors.orange;
        shouldPulse = true;
        break;
      case ConnectionStatus.disconnected:
        color = Colors.grey;
        shouldPulse = false;
        break;
      case ConnectionStatus.error:
        color = Colors.red;
        shouldPulse = false;
        break;
    }

    if (shouldPulse) {
      return _PulsingDot(color: color, size: size);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Pulsing dot animation widget
class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}