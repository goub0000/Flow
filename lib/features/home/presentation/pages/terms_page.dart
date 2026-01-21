import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Terms of Service page
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Terms of Service'),
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
                  'Terms of Service',
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
                  title: '1. Acceptance of Terms',
                  content: '''
By accessing or using Flow EdTech ("the Service"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our Service.

These terms apply to all users, including students, parents, counselors, and institutions.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '2. Description of Service',
                  content: '''
Flow EdTech provides an educational technology platform that:

- Connects students with universities and programs
- Provides AI-powered university recommendations
- Facilitates communication between students, parents, and counselors
- Tracks university applications
- Offers educational resources and guidance
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '3. User Accounts',
                  content: '''
To use certain features, you must create an account. You agree to:

- Provide accurate and complete information
- Maintain the security of your account credentials
- Notify us immediately of any unauthorized access
- Take responsibility for all activities under your account
- Not share your account with others
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '4. User Conduct',
                  content: '''
You agree not to:

- Use the Service for any unlawful purpose
- Harass, abuse, or harm other users
- Submit false or misleading information
- Attempt to gain unauthorized access to systems
- Interfere with the proper operation of the Service
- Scrape or collect data without permission
- Impersonate others or misrepresent your identity
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '5. Content and Intellectual Property',
                  content: '''
- You retain ownership of content you submit
- By submitting content, you grant us a license to use it for providing our services
- All Flow EdTech branding, logos, and content are our property
- You may not use our intellectual property without permission
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '6. University Information',
                  content: '''
- We strive to provide accurate university information
- University data may change without notice
- We are not responsible for decisions made based on our information
- Always verify information directly with universities
- Recommendations are suggestions, not guarantees of admission
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '7. Payments and Refunds',
                  content: '''
- Some features may require payment
- Prices are listed in your local currency where possible
- Payments are processed securely through our payment partners
- Refund policies vary by service type
- Contact support for refund requests
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '8. Termination',
                  content: '''
- You may close your account at any time
- We may suspend or terminate accounts that violate these terms
- Upon termination, your right to use the Service ceases
- Some provisions survive termination
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '9. Disclaimers',
                  content: '''
THE SERVICE IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

We do not guarantee admission to any university or program.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '10. Limitation of Liability',
                  content: '''
TO THE MAXIMUM EXTENT PERMITTED BY LAW, FLOW EDTECH SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES ARISING FROM YOUR USE OF THE SERVICE.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '11. Changes to Terms',
                  content: '''
We may modify these terms at any time. Continued use of the Service after changes constitutes acceptance of the new terms. We will notify you of significant changes.
                  ''',
                ),

                _buildSection(
                  theme,
                  title: '12. Contact',
                  content: '''
For questions about these terms, contact us at:

Email: legal@flowedtech.com
Address: Accra, Ghana
                  ''',
                ),

                const SizedBox(height: 32),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.gavel,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'By using Flow, you agree to these terms',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
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
}
