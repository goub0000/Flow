import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Help Center page with FAQs and support resources
class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<Map<String, String>> _faqs = [
    {
      'category': 'Getting Started',
      'question': 'How do I create an account?',
      'answer':
          'Click the "Sign Up" button on the homepage. Enter your email, create a password, and select your role (Student, Parent, Counselor, or Institution). Verify your email to complete registration.',
    },
    {
      'category': 'Getting Started',
      'question': 'What roles are available on Flow?',
      'answer':
          'Flow supports multiple user roles: Students (for those seeking education guidance), Parents (to monitor and support their children), Counselors (education professionals), and Institutions (universities and colleges).',
    },
    {
      'category': 'University Search',
      'question': 'How does the university recommendation work?',
      'answer':
          'Our AI-powered recommendation engine analyzes your academic profile, preferences, and goals to suggest universities that best match your criteria. The more information you provide, the better the recommendations.',
    },
    {
      'category': 'University Search',
      'question': 'Can I filter universities by specific criteria?',
      'answer':
          'Yes! You can filter by location, tuition range, acceptance rate, program type, ranking, and more. Use the advanced filters on the university search page.',
    },
    {
      'category': 'Applications',
      'question': 'How do I track my applications?',
      'answer':
          'Go to your Student Dashboard and click on "Applications". You can see all your submitted applications, their status, and any required actions.',
    },
    {
      'category': 'Applications',
      'question': 'Can my parents see my application status?',
      'answer':
          'Yes, if you link your parent\'s account. Parents can view application status and academic progress through their Parent Portal.',
    },
    {
      'category': 'Account',
      'question': 'How do I reset my password?',
      'answer':
          'Click "Forgot Password" on the login page, enter your email, and follow the instructions sent to your inbox.',
    },
    {
      'category': 'Account',
      'question': 'How do I update my profile information?',
      'answer':
          'Go to Settings > Profile and update your personal information, academic details, and preferences.',
    },
    {
      'category': 'Counseling',
      'question': 'How do I connect with a counselor?',
      'answer':
          'Browse available counselors in the Counseling section, view their profiles and specializations, and request a session. You can also be matched automatically based on your needs.',
    },
    {
      'category': 'Counseling',
      'question': 'Are counseling sessions free?',
      'answer':
          'Some counselors offer free initial consultations. Pricing varies by counselor. Check individual counselor profiles for their rates and availability.',
    },
  ];

  List<String> get _categories {
    final cats = _faqs.map((f) => f['category']!).toSet().toList();
    return ['All', ...cats];
  }

  List<Map<String, String>> get _filteredFaqs {
    return _faqs.where((faq) {
      final matchesCategory = _selectedCategory == 'All' || faq['category'] == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
          faq['question']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          faq['answer']!.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: const Text('Help Center'),
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
                  'How can we help?',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for help...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 24),

                // Quick Links
                Text(
                  'Quick Links',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildQuickLink(context, theme, Icons.school, 'University Search', '/universities'),
                    _buildQuickLink(context, theme, Icons.person, 'My Profile', '/profile'),
                    _buildQuickLink(context, theme, Icons.settings, 'Settings', '/settings'),
                    _buildQuickLink(context, theme, Icons.mail, 'Contact Support', '/contact'),
                  ],
                ),

                const SizedBox(height: 32),

                // Categories
                Text(
                  'Categories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories.map((cat) {
                    final isSelected = cat == _selectedCategory;
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // FAQs
                Text(
                  'Frequently Asked Questions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                ..._filteredFaqs.map((faq) => _buildFaqItem(theme, faq)),

                if (_filteredFaqs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Still need help?
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.support_agent, size: 48, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Still need help?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Our support team is here to assist you",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.go('/contact'),
                        icon: const Icon(Icons.mail),
                        label: const Text('Contact Support'),
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

  Widget _buildQuickLink(
      BuildContext context, ThemeData theme, IconData icon, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(ThemeData theme, Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          faq['question']!,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          faq['category']!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
          ),
        ),
        children: [
          Text(
            faq['answer']!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
