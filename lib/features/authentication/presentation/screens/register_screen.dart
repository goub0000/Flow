import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/auth_error_mapper.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserRole? _selectedRole;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  AuthErrorType? _errorType;
  String _password = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _errorType = null;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await ref.read(authProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            displayName: _nameController.text.trim(),
            role: _selectedRole!,
          );

      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.error != null) {
          // Parse error type from the error message
          final errorInfo = AuthErrorMapper.mapError(authState.error);
          setState(() {
            _errorMessage = authState.error;
            _errorType = errorInfo.errorType;
          });
        }
        // If successful, router will automatically redirect to dashboard
        // via the redirect logic in app_router.dart (lines 151-155)
      }
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
        _errorType = null;
      });
    }
  }

  Widget _buildErrorWidget() {
    if (_errorMessage == null) return const SizedBox.shrink();

    final showLoginHint = _errorType == AuthErrorType.emailAlreadyExists;
    final showForgotPasswordHint = _errorType == AuthErrorType.emailAlreadyExists;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _clearError,
                child: Icon(
                  Icons.close,
                  color: AppColors.error.withValues(alpha: 0.7),
                  size: 18,
                ),
              ),
            ],
          ),
          if (showLoginHint) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 32),
                TextButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login, size: 16),
                  label: const Text('Login Instead'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                if (showForgotPasswordHint) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => context.push('/forgot-password'),
                    icon: const Icon(Icons.lock_reset, size: 16),
                    label: const Text('Reset Password'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use canPop to check if there's something to pop, otherwise go to home
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Circular Logo
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surface,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Join Flow',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your educational journey',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Error display widget
                _buildErrorWidget(),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: Validators.fullName,
                  enabled: !authState.isLoading,
                  onChanged: (_) => _clearError(),
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                  enabled: !authState.isLoading,
                  onChanged: (_) => _clearError(),
                ),
                const SizedBox(height: 16),

                // Role Selection
                DropdownButtonFormField<UserRole>(
                  initialValue: UserRole.student,
                  decoration: const InputDecoration(
                    labelText: 'I am a...',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  items: UserRole.values.where((role) => !role.isAdmin).map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.getRoleColor(UserRoleHelper.getRoleName(role)),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(role.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: authState.isLoading ? null : (_) {},
                  onSaved: (role) {
                    _selectedRole = role;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: Validators.password,
                  enabled: !authState.isLoading,
                  onChanged: (value) {
                    _clearError();
                    setState(() => _password = value);
                  },
                ),
                const SizedBox(height: 8),

                // Password strength indicator
                _PasswordStrengthIndicator(password: _password),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  enabled: !authState.isLoading,
                  onChanged: (_) => _clearError(),
                ),
                const SizedBox(height: 32),

                // Register Button
                ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleRegister,
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.textOnPrimary,
                            ),
                          ),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.go('/login'),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Live password strength meter with requirement checklist.
class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const _PasswordStrengthIndicator({required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final checks = _checks;
    final passed = checks.where((c) => c.met).length;
    final strength = passed / checks.length; // 0.0 – 1.0

    final Color barColor;
    final String label;
    if (strength <= 0.25) {
      barColor = AppColors.error;
      label = 'Weak';
    } else if (strength <= 0.5) {
      barColor = Colors.orange;
      label = 'Fair';
    } else if (strength < 1.0) {
      barColor = Colors.amber;
      label = 'Good';
    } else {
      barColor = AppColors.success;
      label = 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bar + label
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: strength,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.outlineVariant,
                  color: barColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: barColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Requirement checklist
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: checks
              .map((c) => _RequirementChip(label: c.label, met: c.met, theme: theme))
              .toList(),
        ),
      ],
    );
  }

  List<_Check> get _checks => [
        _Check('8+ characters', password.length >= 8),
        _Check('Uppercase', password.contains(RegExp(r'[A-Z]'))),
        _Check('Lowercase', password.contains(RegExp(r'[a-z]'))),
        _Check('Number', password.contains(RegExp(r'[0-9]'))),
      ];
}

class _Check {
  final String label;
  final bool met;
  const _Check(this.label, this.met);
}

class _RequirementChip extends StatelessWidget {
  final String label;
  final bool met;
  final ThemeData theme;

  const _RequirementChip({
    required this.label,
    required this.met,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: met ? AppColors.success : theme.colorScheme.outlineVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: met
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
