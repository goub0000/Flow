// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Contact Support Screen
///
/// Allows users to get in touch with support team.
/// Features:
/// - Multiple contact methods
/// - Email support
/// - Live chat
/// - Phone support
/// - Support hours

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _category = 'general';

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Methods
          Text(
            'Get in Touch',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.email, color: AppColors.primary),
                  title: const Text('Email'),
                  subtitle: const Text('support@flowedtech.com'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open email client
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.chat, color: AppColors.success),
                  title: const Text('Live Chat'),
                  subtitle: const Text('Available 24/7'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open live chat
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.phone, color: AppColors.info),
                  title: const Text('Phone'),
                  subtitle: const Text('+1 (555) 123-4567'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Open phone dialer
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Support Hours
          Card(
            color: AppColors.info.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Support Hours',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monday - Friday: 9am - 5pm EST\nWeekends: 10am - 4pm EST',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Contact Form
          Text(
            'Send us a Message',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'general',
                          child: Text('General Inquiry'),
                        ),
                        DropdownMenuItem(
                          value: 'technical',
                          child: Text('Technical Issue'),
                        ),
                        DropdownMenuItem(
                          value: 'billing',
                          child: Text('Billing Question'),
                        ),
                        DropdownMenuItem(
                          value: 'feedback',
                          child: Text('Feedback'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _category = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send),
                        label: const Text('Send Message'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send support message to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully! We\'ll get back to you soon.'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}
