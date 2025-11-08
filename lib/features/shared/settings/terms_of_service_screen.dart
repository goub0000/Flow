import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Terms of Service Screen
///
/// Displays the app's terms of service and usage agreement.
/// Features:
/// - Formatted terms sections
/// - Effective date
/// - Expandable sections
/// - Print/Export options

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share terms of service
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
                    'Flow EdTech Terms of Service',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Effective Date: October 28, 2025',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please read these Terms of Service carefully before using our platform. By accessing or using our services, you agree to be bound by these terms.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Acceptance of Terms
          _buildSection(
            context,
            icon: Icons.handshake,
            title: '1. Acceptance of Terms',
            content: '''By creating an account and using Flow EdTech, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service and our Privacy Policy.

If you do not agree to these terms, you may not access or use our services.

These terms constitute a legally binding agreement between you and Flow EdTech.''',
          ),
          const SizedBox(height: 16),

          // Account Registration
          _buildSection(
            context,
            icon: Icons.person_add,
            title: '2. Account Registration and Eligibility',
            content: '''To use certain features, you must create an account and provide:

• Accurate and complete information
• Valid email address
• Secure password
• Proof of age (must be 13 or older)

You are responsible for:
• Maintaining the confidentiality of your account credentials
• All activities that occur under your account
• Notifying us immediately of any unauthorized access

We reserve the right to refuse service, terminate accounts, or cancel orders at our discretion.''',
          ),
          const SizedBox(height: 16),

          // User Conduct
          _buildSection(
            context,
            icon: Icons.rule,
            title: '3. User Conduct and Responsibilities',
            content: '''You agree not to:

• Violate any laws or regulations
• Infringe on intellectual property rights
• Upload malicious code or viruses
• Harass, abuse, or harm other users
• Impersonate others or provide false information
• Attempt to gain unauthorized access to our systems
• Use automated tools to access our services
• Sell or transfer your account to others
• Post inappropriate or offensive content
• Engage in academic dishonesty or plagiarism

Violation of these terms may result in suspension or termination of your account.''',
          ),
          const SizedBox(height: 16),

          // Intellectual Property
          _buildSection(
            context,
            icon: Icons.copyright,
            title: '4. Intellectual Property Rights',
            content: '''All content on Flow EdTech, including:

• Course materials and lectures
• Text, graphics, logos, and images
• Software and technology
• Trademarks and branding

Is owned by Flow EdTech or its licensors and is protected by copyright, trademark, and other intellectual property laws.

User-Generated Content:
• You retain ownership of content you create
• You grant us a license to use, display, and distribute your content
• You represent that you have rights to any content you upload
• We may remove content that violates these terms

You may not copy, modify, distribute, or create derivative works without our explicit permission.''',
          ),
          const SizedBox(height: 16),

          // Subscriptions and Payments
          _buildSection(
            context,
            icon: Icons.payment,
            title: '5. Subscriptions, Payments, and Refunds',
            content: '''Subscription Plans:
• Pricing is subject to change with notice
• Subscriptions automatically renew unless cancelled
• You can cancel at any time through your account settings
• Cancellation takes effect at the end of the billing period

Payment Terms:
• All fees are in USD unless otherwise stated
• Payment is due at the time of purchase
• We accept major credit cards and other payment methods
• Failed payments may result in service suspension

Refund Policy:
• 7-day money-back guarantee for new subscriptions
• Refunds are processed within 5-10 business days
• Course-specific refund policies may apply
• Contact support@flowedtech.com for refund requests''',
          ),
          const SizedBox(height: 16),

          // Course Access and Content
          _buildSection(
            context,
            icon: Icons.school,
            title: '6. Course Access and Educational Content',
            content: '''Course Enrollment:
• Access is granted upon successful payment
• Courses may have prerequisites or requirements
• Some courses have limited enrollment periods
• Completion certificates are awarded based on performance

Content Availability:
• We strive to maintain continuous access to courses
• Content may be updated or modified without notice
• Some courses may be retired or archived
• No guarantee of specific educational outcomes

Academic Integrity:
• You must complete your own work
• Collaboration is only allowed where explicitly permitted
• Plagiarism and cheating will result in account termination
• Certificates may be revoked for academic misconduct''',
          ),
          const SizedBox(height: 16),

          // Privacy and Data Protection
          _buildSection(
            context,
            icon: Icons.privacy_tip,
            title: '7. Privacy and Data Protection',
            content: '''We are committed to protecting your privacy. Our collection and use of personal information is governed by our Privacy Policy.

By using our services, you consent to:
• Collection of personal and usage data
• Processing data for service provision
• Sharing data as described in our Privacy Policy
• Use of cookies and tracking technologies

Your Rights:
• Access your personal data
• Request data correction or deletion
• Opt-out of marketing communications
• Data portability

See our Privacy Policy for complete details.''',
          ),
          const SizedBox(height: 16),

          // Disclaimers and Limitations
          _buildSection(
            context,
            icon: Icons.warning,
            title: '8. Disclaimers and Limitations of Liability',
            content: '''Services Provided "AS IS":
• No warranty of uninterrupted or error-free service
• No guarantee of specific results or outcomes
• Educational content for informational purposes only
• Not a substitute for professional advice

Limitation of Liability:
• We are not liable for indirect, incidental, or consequential damages
• Maximum liability limited to fees paid in the last 12 months
• No liability for third-party content or actions
• No liability for data loss or service interruptions

You use our services at your own risk.''',
          ),
          const SizedBox(height: 16),

          // Third-Party Services
          _buildSection(
            context,
            icon: Icons.link,
            title: '9. Third-Party Services and Links',
            content: '''Our platform may contain links to third-party websites or integrate with third-party services:

• We do not control third-party content
• We are not responsible for third-party practices
• Third-party terms and privacy policies apply
• Use third-party services at your own risk

Integration examples include:
• Payment processors
• Video hosting platforms
• Analytics services
• Social media platforms''',
          ),
          const SizedBox(height: 16),

          // Termination
          _buildSection(
            context,
            icon: Icons.cancel,
            title: '10. Termination',
            content: '''We may terminate or suspend your account:

• For violation of these terms
• For fraudulent or illegal activity
• For prolonged inactivity
• At our discretion with or without notice

Upon termination:
• Your access to services will cease
• You may lose access to course materials
• Certain provisions survive termination
• Outstanding fees remain due

You may terminate your account at any time through account settings.''',
          ),
          const SizedBox(height: 16),

          // Dispute Resolution
          _buildSection(
            context,
            icon: Icons.gavel,
            title: '11. Dispute Resolution and Arbitration',
            content: '''For any disputes arising from these terms:

Informal Resolution:
• Contact us first to resolve disputes informally
• Email: legal@flowedtech.com
• 30-day period to reach resolution

Arbitration Agreement:
• Disputes resolved through binding arbitration
• Individual basis only (no class actions)
• Governed by American Arbitration Association rules
• Located in Tech City, TC

Exceptions:
• Small claims court disputes
• Intellectual property disputes
• Emergency injunctive relief''',
          ),
          const SizedBox(height: 16),

          // Governing Law
          _buildSection(
            context,
            icon: Icons.location_city,
            title: '12. Governing Law',
            content: '''These Terms are governed by:

• Laws of the State of [Your State]
• United States federal law
• Without regard to conflict of law provisions

Jurisdiction:
• Courts of [Your State]
• Tech City, TC county courts

International Users:
• Additional local laws may apply
• You are responsible for compliance with local laws''',
          ),
          const SizedBox(height: 16),

          // Changes to Terms
          _buildSection(
            context,
            icon: Icons.update,
            title: '13. Changes to Terms of Service',
            content: '''We may modify these terms at any time:

• Changes effective upon posting
• Material changes will be notified via email
• Continued use constitutes acceptance
• You can review current terms anytime

If you do not agree to modified terms:
• Discontinue use of our services
• Contact us to close your account
• No refunds for remaining subscription period''',
          ),
          const SizedBox(height: 16),

          // Contact Information
          _buildSection(
            context,
            icon: Icons.contact_mail,
            title: '14. Contact Information',
            content: '''For questions about these Terms of Service:

General Inquiries:
Email: support@flowedtech.com
Phone: +1 (555) 123-4567

Legal Department:
Email: legal@flowedtech.com

Mailing Address:
Flow EdTech
123 Education Lane
Tech City, TC 12345
United States

Business Hours: Monday-Friday, 9am-5pm EST''',
          ),
          const SizedBox(height: 32),

          // Acceptance Acknowledgment
          Card(
            color: AppColors.success.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'By using Flow EdTech, you acknowledge that you have read and understood these Terms of Service.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
