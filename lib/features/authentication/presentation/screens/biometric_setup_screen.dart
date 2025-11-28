import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Biometric Authentication Setup Screen
///
/// Allows users to enable/disable biometric authentication (fingerprint/face ID).
/// Provides fallback to password authentication.
///
/// Backend Integration TODO:
/// ```dart
/// // Add to pubspec.yaml:
/// // local_auth: ^2.1.7
///
/// import 'package:local_auth/local_auth.dart';
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// class BiometricAuthService {
///   final LocalAuthentication _auth = LocalAuthentication();
///
///   /// Check if device supports biometric authentication
///   Future<bool> isDeviceSupported() async {
///     return await _auth.isDeviceSupported();
///   }
///
///   /// Check if biometrics are available (enrolled)
///   Future<bool> canCheckBiometrics() async {
///     return await _auth.canCheckBiometrics;
///   }
///
///   /// Get available biometric types
///   Future<List<BiometricType>> getAvailableBiometrics() async {
///     return await _auth.getAvailableBiometrics();
///   }
///
///   /// Authenticate using biometrics
///   Future<bool> authenticate() async {
///     try {
///       return await _auth.authenticate(
///         localizedReason: 'Please authenticate to access Flow',
///         options: const AuthenticationOptions(
///           stickyAuth: true,
///           biometricOnly: false, // Allow fallback to PIN/password
///         ),
///       );
///     } catch (e) {
///       print('Error during authentication: $e');
///       return false;
///     }
///   }
///
///   /// Check if biometric is enabled in preferences
///   Future<bool> isBiometricEnabled() async {
///     final prefs = await SharedPreferences.getInstance();
///     return prefs.getBool('biometric_enabled') ?? false;
///   }
///
///   /// Save biometric preference
///   Future<void> setBiometricEnabled(bool enabled) async {
///     final prefs = await SharedPreferences.getInstance();
///     await prefs.setBool('biometric_enabled', enabled);
///   }
/// }
///
/// // Usage in login flow:
/// final biometricService = BiometricAuthService();
/// if (await biometricService.isBiometricEnabled()) {
///   final authenticated = await biometricService.authenticate();
///   if (authenticated) {
///     // Log user in automatically
///   }
/// }
/// ```

class BiometricSetupScreen extends ConsumerStatefulWidget {
  final bool isSetup; // true = first-time setup, false = settings page

  const BiometricSetupScreen({
    super.key,
    this.isSetup = false,
  });

  @override
  ConsumerState<BiometricSetupScreen> createState() =>
      _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends ConsumerState<BiometricSetupScreen>
    with SingleTickerProviderStateMixin {
  bool _isDeviceSupported = true;
  bool _areBiometricsAvailable = true;
  bool _isBiometricEnabled = false;
  bool _isLoading = false;
  BiometricType _availableBiometricType = BiometricType.fingerprint;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initBiometrics();
    _setupAnimation();
  }

  void _setupAnimation() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initBiometrics() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Integrate with actual biometric service
      // final service = BiometricAuthService();
      // final isSupported = await service.isDeviceSupported();
      // final canCheck = await service.canCheckBiometrics();
      // final availableBiometrics = await service.getAvailableBiometrics();
      // final isEnabled = await service.isBiometricEnabled();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - device supports fingerprint
      final isSupported = true;
      final canCheck = true;
      final availableBiometrics = [BiometricType.fingerprint];
      final isEnabled = false;

      if (mounted) {
        setState(() {
          _isDeviceSupported = isSupported;
          _areBiometricsAvailable = canCheck && availableBiometrics.isNotEmpty;
          _isBiometricEnabled = isEnabled;
          if (availableBiometrics.isNotEmpty) {
            _availableBiometricType = availableBiometrics.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking biometrics: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Enable biometric
      await _enableBiometric();
    } else {
      // Disable biometric
      await _disableBiometric();
    }
  }

  Future<void> _enableBiometric() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Authenticate user first
      // final service = BiometricAuthService();
      // final authenticated = await service.authenticate();

      // Simulate authentication
      await Future.delayed(const Duration(seconds: 1));
      final authenticated = true; // Change to false to test failure

      if (authenticated) {
        // TODO: Save preference
        // await service.setBiometricEnabled(true);

        if (mounted) {
          setState(() {
            _isBiometricEnabled = true;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication enabled successfully'),
              backgroundColor: AppColors.success,
            ),
          );

          if (widget.isSetup) {
            // Complete setup, navigate to next screen
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                context.go('/student/dashboard'); // Or appropriate dashboard
              }
            });
          }
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _disableBiometric() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Save preference
      // final service = BiometricAuthService();
      // await service.setBiometricEnabled(false);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isBiometricEnabled = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication disabled'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isSetup ? 'Setup Biometric' : 'Biometric Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isSetup
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login');
                  }
                },
              ),
      ),
      body: _isLoading && !_isDeviceSupported
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: !_isDeviceSupported
                    ? _buildUnsupportedView(theme)
                    : !_areBiometricsAvailable
                        ? _buildNotEnrolledView(theme)
                        : _buildBiometricSetupView(theme),
              ),
            ),
    );
  }

  Widget _buildBiometricSetupView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Animated Biometric Icon
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isBiometricEnabled ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: (_isBiometricEnabled
                            ? AppColors.success
                            : AppColors.primary)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getBiometricIcon(),
                    size: 70,
                    color: _isBiometricEnabled
                        ? AppColors.success
                        : AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          widget.isSetup
              ? 'Enable Biometric Login'
              : 'Biometric Authentication',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          _getBiometricDescription(),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Toggle Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isBiometricEnabled
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.border,
              width: _isBiometricEnabled ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (_isBiometricEnabled
                          ? AppColors.success
                          : AppColors.primary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getBiometricIcon(),
                  color: _isBiometricEnabled
                      ? AppColors.success
                      : AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Use ${_getBiometricTypeName()}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isBiometricEnabled ? 'Enabled' : 'Disabled',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _isBiometricEnabled
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isBiometricEnabled,
                onChanged: _isLoading ? null : _toggleBiometric,
                activeColor: AppColors.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Benefits Section
        if (!_isBiometricEnabled) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security, color: AppColors.info, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Why use biometric?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBenefitItem(Icons.speed, 'Faster login experience'),
                const SizedBox(height: 12),
                _buildBenefitItem(Icons.lock, 'More secure than passwords'),
                const SizedBox(height: 12),
                _buildBenefitItem(
                    Icons.fingerprint, 'Unique to you - cannot be copied'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Security Note
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Note',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your biometric data stays on your device and is never shared with Flow or third parties.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (widget.isSetup) ...[
          const SizedBox(height: 32),
          // Skip Button for setup flow
          TextButton(
            onPressed: _isLoading
                ? null
                : () => context.go('/student/dashboard'),
            child: const Text('Skip for now'),
          ),
        ],
      ],
    );
  }

  Widget _buildUnsupportedView(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.block,
            size: 50,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Not Supported',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your device does not support biometric authentication.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
          child: const Text('Go Back'),
        ),
      ],
    );
  }

  Widget _buildNotEnrolledView(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 60),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            size: 50,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No Biometrics Enrolled',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.warning,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Please enroll your fingerprint or face ID in your device settings first.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Open device settings
            // OpenSettings.openSecuritySettings();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please open Settings > Security > Biometrics'),
              ),
            );
          },
          icon: const Icon(Icons.settings),
          label: const Text('Open Settings'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
          child: const Text('Go Back'),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.info, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getBiometricIcon() {
    switch (_availableBiometricType) {
      case BiometricType.face:
        return Icons.face;
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.iris:
        return Icons.remove_red_eye;
      default:
        return Icons.fingerprint;
    }
  }

  String _getBiometricTypeName() {
    switch (_availableBiometricType) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris Recognition';
      default:
        return 'Biometric';
    }
  }

  String _getBiometricDescription() {
    if (_isBiometricEnabled) {
      return 'Your ${_getBiometricTypeName().toLowerCase()} is currently being used to secure your account. You can sign in quickly and securely.';
    } else {
      return 'Use your ${_getBiometricTypeName().toLowerCase()} to sign in quickly and securely without entering your password.';
    }
  }
}

/// Enum for biometric types (mock - replace with local_auth BiometricType)
enum BiometricType {
  face,
  fingerprint,
  iris,
}
