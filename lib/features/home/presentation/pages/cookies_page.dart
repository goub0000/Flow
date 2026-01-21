import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import '../widgets/dynamic_page_wrapper.dart';

/// Cookie Policy page - fetches content from CMS
class CookiesPage extends ConsumerWidget {
  const CookiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicPageWrapper(
      pageSlug: 'cookies',
      fallbackTitle: 'Cookie Policy',
      builder: (context, content) => _buildDynamicPage(context, content),
      fallbackBuilder: (context) => _buildStaticPage(context),
    );
  }

  Widget _buildDynamicPage(BuildContext context, PublicPageContent content) {
    final theme = Theme.of(context);
    final sections = content.getSections();
    final lastUpdated = content.getString('last_updated');

    return FooterPageScaffold(
      title: content.title,
      subtitle: content.subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lastUpdated.isNotEmpty) ...[
            Text(
              'Last updated: $lastUpdated',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
          ],
          ContentSectionsWidget(sections: sections),
          const SizedBox(height: 24),

          // Cookie Types Table (dynamic if available)
          if (content.getList('cookie_types').isNotEmpty) ...[
            Text(
              'Types of Cookies We Use',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDynamicCookieTable(theme, content.getList('cookie_types')),
            const SizedBox(height: 32),
          ],

          // Manage preferences CTA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.cookie, size: 40, color: AppColors.primary),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Cookie Preferences',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Customize which cookies you allow',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => context.go('/settings/cookies'),
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Contact
          Center(
            child: Column(
              children: [
                Text(
                  'Questions about cookies?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact us at privacy@flowedtech.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCookieTable(ThemeData theme, List<dynamic> cookieTypes) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTableRow(theme, 'Cookie Type', 'Purpose', 'Duration', isHeader: true),
          ...cookieTypes.map((cookie) {
            final c = cookie as Map<String, dynamic>;
            return _buildTableRow(
              theme,
              c['type']?.toString() ?? '',
              c['purpose']?.toString() ?? '',
              c['duration']?.toString() ?? '',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Cookie Policy'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cookie Policy',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Last updated: January 2026',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  title: 'What Are Cookies?',
                  content: '''
Cookies are small text files that are stored on your device when you visit a website. They help the website remember information about your visit, like your preferred language and other settings, which can make your next visit easier.

We use cookies and similar technologies to provide, protect, and improve our services.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: 'How We Use Cookies',
                  content: '''
We use different types of cookies for various purposes:

**Essential Cookies**
These cookies are necessary for the website to function properly. They enable basic features like page navigation, secure access to protected areas, and remembering your login state.

**Performance Cookies**
These cookies help us understand how visitors interact with our website. They collect information about page visits, time spent on pages, and any error messages encountered.

**Functionality Cookies**
These cookies enable enhanced functionality and personalization, such as remembering your preferences, language settings, and customizations.

**Analytics Cookies**
We use analytics cookies to analyze website traffic and optimize the user experience. This data helps us improve our services.
                  ''',
                ),

                const SizedBox(height: 24),

                // Cookie Types Table
                Text(
                  'Types of Cookies We Use',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildCookieTable(theme),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  title: 'Managing Your Cookie Preferences',
                  content: '''
You have several options for managing cookies:

**Browser Settings**
Most web browsers allow you to control cookies through their settings. You can set your browser to refuse cookies, delete existing cookies, or alert you when cookies are being sent.

**Our Cookie Settings**
You can manage your cookie preferences for our platform by visiting Settings > Cookie Preferences in your account.

**Opt-Out Links**
For analytics and advertising cookies, you can opt out through industry opt-out mechanisms.

Note: Disabling certain cookies may impact your experience and limit some features of our platform.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: 'Third-Party Cookies',
                  content: '''
Some cookies are placed by third-party services that appear on our pages. We do not control these cookies.

Third-party services we use that may place cookies include:
• Supabase (Authentication)
• Sentry (Error Tracking)
• Analytics services

Please refer to the privacy policies of these services for more information about their cookie practices.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: 'Updates to This Policy',
                  content: '''
We may update this Cookie Policy from time to time. When we make changes, we will update the "Last updated" date at the top of this page.

We encourage you to review this policy periodically to stay informed about our use of cookies.
                  ''',
                ),

                const SizedBox(height: 24),

                // Manage preferences CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cookie, size: 40, color: AppColors.primary),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manage Cookie Preferences',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Customize which cookies you allow',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.go('/settings/cookies'),
                        child: const Text('Manage'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Contact
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Questions about cookies?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contact us at privacy@flowedtech.com',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookieTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTableRow(theme, 'Cookie Type', 'Purpose', 'Duration', isHeader: true),
          _buildTableRow(theme, 'Session', 'Authentication', 'Session'),
          _buildTableRow(theme, 'Preferences', 'User settings', '1 year'),
          _buildTableRow(theme, 'Analytics', 'Usage statistics', '2 years'),
          _buildTableRow(theme, 'Security', 'Fraud prevention', '1 year'),
        ],
      ),
    );
  }

  Widget _buildTableRow(ThemeData theme, String col1, String col2, String col3,
      {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHeader ? AppColors.primary.withOpacity(0.1) : null,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              col1,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              col2,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
                color: isHeader ? null : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              col3,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
                color: isHeader ? null : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
