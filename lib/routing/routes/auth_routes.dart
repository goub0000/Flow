import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/email_verification_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/biometric_setup_screen.dart';
import '../../features/home/presentation/modern_home_screen.dart';
import '../../features/shared/widgets/public_shell.dart';
// Footer pages
import '../../features/home/presentation/pages/about_page.dart';
import '../../features/home/presentation/pages/contact_page.dart';
import '../../features/home/presentation/pages/privacy_page.dart';
import '../../features/home/presentation/pages/terms_page.dart';
import '../../features/home/presentation/pages/careers_page.dart';
import '../../features/home/presentation/pages/press_page.dart';
import '../../features/home/presentation/pages/partners_page.dart';
import '../../features/home/presentation/pages/help_center_page.dart';
import '../../features/home/presentation/pages/docs_page.dart';
import '../../features/home/presentation/pages/api_docs_page.dart';
import '../../features/home/presentation/pages/community_page.dart';
import '../../features/home/presentation/pages/blog_page.dart';
import '../../features/home/presentation/pages/compliance_page.dart';
import '../../features/home/presentation/pages/cookies_page.dart';
import '../../features/home/presentation/pages/data_protection_page.dart';
import '../../features/home/presentation/pages/mobile_apps_page.dart';

/// Authentication and public routes
List<RouteBase> authRoutes = [
  // Home route — has its own custom AppBar, stays outside the shell
  GoRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => const ModernHomeScreen(),
  ),

  // Authentication routes — no navbar needed
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

  // Public sub-pages wrapped in PublicShell for consistent navigation
  ShellRoute(
    builder: (context, state, child) => PublicShell(child: child),
    routes: [
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsPage(),
      ),
      GoRoute(
        path: '/careers',
        name: 'careers',
        builder: (context, state) => const CareersPage(),
      ),
      GoRoute(
        path: '/press',
        name: 'press',
        builder: (context, state) => const PressPage(),
      ),
      GoRoute(
        path: '/partners',
        name: 'partners',
        builder: (context, state) => const PartnersPage(),
      ),
      GoRoute(
        path: '/help',
        name: 'help',
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: '/docs',
        name: 'docs',
        builder: (context, state) => const DocsPage(),
      ),
      GoRoute(
        path: '/api-docs',
        name: 'api-docs',
        builder: (context, state) => const ApiDocsPage(),
      ),
      GoRoute(
        path: '/community',
        name: 'community',
        builder: (context, state) => const CommunityPage(),
      ),
      GoRoute(
        path: '/blog',
        name: 'blog',
        builder: (context, state) => const BlogPage(),
      ),
      GoRoute(
        path: '/compliance',
        name: 'compliance',
        builder: (context, state) => const CompliancePage(),
      ),
      GoRoute(
        path: '/cookies',
        name: 'cookies',
        builder: (context, state) => const CookiesPage(),
      ),
      GoRoute(
        path: '/data-protection',
        name: 'data-protection',
        builder: (context, state) => const DataProtectionPage(),
      ),
      GoRoute(
        path: '/mobile-apps',
        name: 'mobile-apps',
        builder: (context, state) => const MobileAppsPage(),
      ),
    ],
  ),
];
