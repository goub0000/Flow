import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Privacy Policy Screen
///
/// Displays the app's privacy policy and data handling practices.
/// Features:
/// - Formatted policy sections
/// - Last updated date
/// - Expandable sections
/// - Print/Export options

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon'),
                ),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            color: AppColors.primary.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flow EdTech Privacy Policy',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: October 28, 2025',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This Privacy Policy describes how Flow EdTech collects, uses, and protects your personal information.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Information We Collect
          _buildSection(
            context,
            icon: Icons.info,
            title: '1. Information We Collect',
            content: '''We collect information that you provide directly to us, including:

• Personal Information: Name, email address, phone number, and profile information
• Educational Data: Course enrollments, grades, assignments, and learning progress
• Usage Data: How you interact with our platform, including pages visited and features used
• Device Information: Device type, operating system, and browser information
• Location Data: General location information to provide relevant content

We collect this information when you:
• Create an account or update your profile
• Enroll in courses or complete assignments
• Communicate with us or other users
• Use our services and features''',
          ),
          const SizedBox(height: 16),

          // How We Use Information
          _buildSection(
            context,
            icon: Icons.settings,
            title: '2. How We Use Your Information',
            content: '''We use the information we collect to:

• Provide and improve our educational services
• Personalize your learning experience
• Process your enrollments and track your progress
• Communicate with you about courses, updates, and support
• Analyze usage patterns to enhance our platform
• Ensure security and prevent fraud
• Comply with legal obligations
• Send promotional materials (with your consent)

We do not sell your personal information to third parties.''',
          ),
          const SizedBox(height: 16),

          // Information Sharing
          _buildSection(
            context,
            icon: Icons.share,
            title: '3. Information Sharing and Disclosure',
            content: '''We may share your information in the following circumstances:

• Educational Institutions: With schools or institutions you're affiliated with
• Instructors: Course instructors can see your progress and submissions
• Service Providers: Third-party providers who assist in operating our platform
• Legal Requirements: When required by law or to protect our rights
• Business Transfers: In connection with a merger or acquisition
• With Your Consent: When you explicitly authorize sharing

We require all third parties to respect the security of your data and treat it in accordance with the law.''',
          ),
          const SizedBox(height: 16),

          // Data Security
          _buildSection(
            context,
            icon: Icons.security,
            title: '4. Data Security',
            content: '''We implement appropriate technical and organizational measures to protect your information:

• Encryption of data in transit and at rest
• Regular security assessments and audits
• Access controls and authentication measures
• Secure data storage and backup systems
• Employee training on data protection

However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.''',
          ),
          const SizedBox(height: 16),

          // Your Rights
          _buildSection(
            context,
            icon: Icons.verified_user,
            title: '5. Your Rights and Choices',
            content: '''You have the following rights regarding your personal information:

• Access: Request a copy of your personal data
• Correction: Update or correct inaccurate information
• Deletion: Request deletion of your personal data
• Portability: Receive your data in a portable format
• Opt-Out: Unsubscribe from marketing communications
• Restriction: Limit how we process your data

To exercise these rights, contact us at privacy@flowedtech.com.''',
          ),
          const SizedBox(height: 16),

          // Cookies and Tracking
          _buildSection(
            context,
            icon: Icons.cookie,
            title: '6. Cookies and Tracking Technologies',
            content: '''We use cookies and similar technologies to:

• Remember your preferences and settings
• Authenticate your account
• Analyze platform usage and performance
• Provide personalized content and recommendations

You can control cookies through your browser settings. However, disabling cookies may limit some functionality.''',
          ),
          const SizedBox(height: 16),

          // Children's Privacy
          _buildSection(
            context,
            icon: Icons.child_care,
            title: '7. Children\'s Privacy',
            content: '''Our services are intended for users 13 years and older. For users under 18:

• Parental consent may be required
• Additional protections are in place
• Special handling of educational records (FERPA compliance)

We do not knowingly collect information from children under 13 without parental consent.''',
          ),
          const SizedBox(height: 16),

          // International Data Transfers
          _buildSection(
            context,
            icon: Icons.public,
            title: '8. International Data Transfers',
            content: '''Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place, including:

• Standard contractual clauses
• Adequacy decisions by relevant authorities
• Your explicit consent when required''',
          ),
          const SizedBox(height: 16),

          // Changes to Policy
          _buildSection(
            context,
            icon: Icons.update,
            title: '9. Changes to This Privacy Policy',
            content: '''We may update this Privacy Policy from time to time. We will:

• Notify you of material changes via email or platform notification
• Update the "Last Updated" date at the top of this policy
• Obtain your consent for significant changes if required by law

Your continued use of our services after changes constitutes acceptance of the updated policy.''',
          ),
          const SizedBox(height: 16),

          // Contact Information
          _buildSection(
            context,
            icon: Icons.contact_mail,
            title: '10. Contact Us',
            content: '''If you have questions or concerns about this Privacy Policy or our data practices, please contact us:

Email: privacy@flowedtech.com
Phone: +1 (555) 123-4567
Address: Flow EdTech, 123 Education Lane, Tech City, TC 12345

Data Protection Officer: dpo@flowedtech.com''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
