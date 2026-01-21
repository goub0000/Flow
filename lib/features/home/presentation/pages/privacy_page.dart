import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Privacy Policy page
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Privacy Policy'),
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
                  'Privacy Policy',
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
                  title: '1. Information We Collect',
                  content: '''
We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This may include:

- Personal information (name, email, phone number)
- Educational information (grades, test scores, preferences)
- Account credentials
- Communication preferences
- Usage data and analytics
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '2. How We Use Your Information',
                  content: '''
We use the information we collect to:

- Provide, maintain, and improve our services
- Match you with suitable universities and programs
- Send you relevant notifications and updates
- Respond to your inquiries and support requests
- Analyze usage patterns to improve user experience
- Comply with legal obligations
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '3. Information Sharing',
                  content: '''
We may share your information with:

- Universities and institutions you express interest in
- Counselors you choose to connect with
- Parents/guardians (with your consent)
- Service providers who assist our operations
- Legal authorities when required by law

We do not sell your personal information to third parties.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '4. Data Security',
                  content: '''
We implement industry-standard security measures to protect your data:

- Encryption of data in transit and at rest
- Regular security audits and assessments
- Access controls and authentication
- Secure data centers with SOC 2 compliance
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '5. Your Rights',
                  content: '''
You have the right to:

- Access your personal data
- Correct inaccurate information
- Delete your account and data
- Export your data in a portable format
- Opt out of marketing communications
- Withdraw consent at any time
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '6. Cookies and Tracking',
                  content: '''
We use cookies and similar technologies to:

- Keep you signed in
- Remember your preferences
- Analyze site traffic and usage
- Improve our services

You can manage cookie preferences in your account settings.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '7. Children\'s Privacy',
                  content: '''
Our services are intended for users aged 13 and older. We do not knowingly collect information from children under 13. If you believe we have collected information from a child under 13, please contact us.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '8. Changes to This Policy',
                  content: '''
We may update this privacy policy from time to time. We will notify you of any significant changes by posting the new policy on this page and updating the "Last updated" date.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '9. Contact Us',
                  content: '''
If you have questions about this privacy policy, please contact us at:

Email: privacy@flowedtech.com
Address: Accra, Ghana
                  ''',
                ),

                const SizedBox(height: 32),

                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Contact Privacy Team'),
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
}
