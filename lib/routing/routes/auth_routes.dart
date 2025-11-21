import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/email_verification_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/biometric_setup_screen.dart';
import '../../features/home/presentation/modern_home_screen.dart';

/// Authentication and public routes
List<RouteBase> authRoutes = [
  // Home route
  GoRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => const ModernHomeScreen(),
  ),

  // Authentication routes
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/forgot-password',
    name: 'forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/email-verification',
    name: 'email-verification',
    builder: (context, state) {
      final email = state.uri.queryParameters['email'] ?? '';
      return EmailVerificationScreen(
        email: email,
        onVerified: () {
          // Navigate to onboarding after verification
          context.go('/onboarding');
        },
      );
    },
  ),
  GoRoute(
    path: '/onboarding',
    name: 'onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: '/biometric-setup',
    name: 'biometric-setup',
    builder: (context, state) {
      final isSetup = state.uri.queryParameters['setup'] == 'true';
      return BiometricSetupScreen(isSetup: isSetup);
    },
  ),
];