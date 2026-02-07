import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Contact page with contact form and information - fetches content from CMS
class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _ContactStaticContent();
  }
}

class _ContactStaticContent extends StatefulWidget {
  const _ContactStaticContent();

  @override
  State<_ContactStaticContent> createState() => _ContactStaticContentState();
}

class _ContactStaticContentState extends State<_ContactStaticContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // TODO: Implement actual form submission to backend
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.contactPageSuccessMessage),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(context.l10n.contactPageTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  context.l10n.contactPageGetInTouch,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.contactPageSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Contact info cards and form
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 700) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildContactInfo(theme)),
                          const SizedBox(width: 32),
                          Expanded(flex: 2, child: _buildContactForm(theme)),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildContactInfo(theme),
                        const SizedBox(height: 32),
                        _buildContactForm(theme),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(ThemeData theme) {
    return Column(
      children: [
        _buildContactCard(
          theme,
          icon: Icons.email,
          title: context.l10n.contactPageEmail,
          content: context.l10n.contactPageEmailValue,
          subtitle: context.l10n.contactPageEmailReply,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          theme,
          icon: Icons.location_on,
          title: context.l10n.contactPageOffice,
          content: context.l10n.contactPageOfficeValue,
          subtitle: context.l10n.contactPageOfficeRegion,
        ),
        const SizedBox(height: 16),
        _buildContactCard(
          theme,
          icon: Icons.access_time,
          title: context.l10n.contactPageHours,
          content: context.l10n.contactPageHoursValue,
          subtitle: context.l10n.contactPageHoursTimezone,
        ),
      ],
    );
  }

  Widget _buildContactCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String content,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  content,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
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

  Widget _buildContactForm(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contactPageSendMessage,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n.contactPageYourName,
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.contactPageNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: context.l10n.contactPageEmailAddress,
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.contactPageEmailRequired;
                }
                if (!value.contains('@')) {
                  return context.l10n.contactPageEmailInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Subject field
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: context.l10n.contactPageSubject,
                prefixIcon: Icon(Icons.subject),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.contactPageSubjectRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Message field
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: context.l10n.contactPageMessage,
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.contactPageMessageRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.contactPageSendButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
