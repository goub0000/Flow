import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../widgets/help_support_widgets.dart';

/// FAQ Screen
///
/// Displays frequently asked questions organized by category.
/// Features:
/// - Expandable FAQ items
/// - Category filtering
/// - Search functionality
/// - Helpfulness feedback
/// - Popular questions
///
/// Backend Integration TODO:
/// - Fetch FAQs from API
/// - Implement search
/// - Track helpfulness votes
/// - Sort by popularity

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<FAQItem> _mockFAQs = [];
  List<FAQItem> _filteredFAQs = [];
  String? _expandedId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _generateMockFAQs();
    _filteredFAQs = _mockFAQs;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockFAQs() {
    _mockFAQs = const [
      // Getting Started
      FAQItem(
        id: '1',
        question: 'How do I create an account?',
        answer:
            'To create an account, click on the "Sign Up" button on the homepage. Fill in your details including email, password, and basic information. You\'ll receive a verification email to activate your account.',
        categoryId: '1',
        helpfulCount: 245,
      ),
      FAQItem(
        id: '2',
        question: 'How do I enroll in a course?',
        answer:
            'Browse our course catalog, select a course you\'re interested in, and click the "Enroll" button. Free courses are immediately accessible, while paid courses require payment before access.',
        categoryId: '1',
        helpfulCount: 189,
      ),

      // Account
      FAQItem(
        id: '3',
        question: 'How do I reset my password?',
        answer:
            'Click on "Forgot Password" on the login screen. Enter your registered email address, and we\'ll send you a password reset link. Click the link and follow the instructions to set a new password.',
        categoryId: '2',
        helpfulCount: 312,
      ),
      FAQItem(
        id: '4',
        question: 'Can I change my email address?',
        answer:
            'Yes, go to Settings > Account > Edit Profile. Update your email address and verify it through the confirmation email we send you.',
        categoryId: '2',
        helpfulCount: 156,
      ),

      // Courses
      FAQItem(
        id: '5',
        question: 'Can I access courses offline?',
        answer:
            'Yes! Download course videos when connected to WiFi. Go to the course page and tap the download icon next to each lesson. Downloaded content is available in the "My Downloads" section.',
        categoryId: '3',
        helpfulCount: 423,
      ),
      FAQItem(
        id: '6',
        question: 'How do I get a course certificate?',
        answer:
            'Complete all course requirements including lectures, assignments, and the final exam. Once you pass with the minimum required score, your certificate will be automatically generated and available in your profile.',
        categoryId: '3',
        helpfulCount: 567,
      ),
      FAQItem(
        id: '7',
        question: 'Can I get a refund for a course?',
        answer:
            'We offer a 30-day money-back guarantee. If you\'re not satisfied with a course, request a refund within 30 days of purchase. Go to Settings > Billing > Purchase History and select "Request Refund".',
        categoryId: '3',
        helpfulCount: 298,
      ),

      // Payments
      FAQItem(
        id: '8',
        question: 'What payment methods do you accept?',
        answer:
            'We accept credit/debit cards (Visa, Mastercard), M-Pesa, and bank transfers. All payments are securely processed.',
        categoryId: '4',
        helpfulCount: 201,
      ),
      FAQItem(
        id: '9',
        question: 'How do subscriptions work?',
        answer:
            'Subscriptions give you unlimited access to all courses. Choose monthly or annual plans. Your subscription auto-renews unless cancelled. You can cancel anytime from Settings > Subscriptions.',
        categoryId: '4',
        helpfulCount: 178,
      ),

      // Technical
      FAQItem(
        id: '10',
        question: 'The app is crashing. What should I do?',
        answer:
            'Try these steps: 1) Clear app cache in Settings, 2) Update to the latest version, 3) Restart your device, 4) Reinstall the app if the problem persists. Contact support if issues continue.',
        categoryId: '5',
        helpfulCount: 145,
      ),
      FAQItem(
        id: '11',
        question: 'Videos won\'t play. How do I fix this?',
        answer:
            'Check your internet connection. Try switching between WiFi and mobile data. Clear app cache or try a different browser if using web. Ensure you have the latest app version installed.',
        categoryId: '5',
        helpfulCount: 234,
      ),

      // Mobile App
      FAQItem(
        id: '12',
        question: 'Is there a mobile app available?',
        answer:
            'Yes! Download the Flow app from Google Play Store (Android) or App Store (iOS). The mobile app offers all features including offline downloads and progress syncing.',
        categoryId: '6',
        helpfulCount: 389,
      ),
    ];
  }

  void _filterFAQs() {
    setState(() {
      _filteredFAQs = _mockFAQs.where((faq) {
        if (_searchController.text.isEmpty) return true;

        final searchLower = _searchController.text.toLowerCase();
        return faq.question.toLowerCase().contains(searchLower) ||
            faq.answer.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.helpFaqTitle),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: context.l10n.helpFaqAll),
            Tab(text: context.l10n.helpFaqGettingStarted),
            Tab(text: context.l10n.helpFaqAccount),
            Tab(text: context.l10n.helpFaqCourses),
            Tab(text: context.l10n.helpFaqPayments),
            Tab(text: context.l10n.helpFaqTechnical),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.helpSearchFaqs,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterFAQs();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) => _filterFAQs(),
            ),
          ),

          // FAQ List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFAQList(_filteredFAQs),
                _buildFAQList(
                    _filteredFAQs.where((f) => f.categoryId == '1').toList()),
                _buildFAQList(
                    _filteredFAQs.where((f) => f.categoryId == '2').toList()),
                _buildFAQList(
                    _filteredFAQs.where((f) => f.categoryId == '3').toList()),
                _buildFAQList(
                    _filteredFAQs.where((f) => f.categoryId == '4').toList()),
                _buildFAQList(
                    _filteredFAQs.where((f) => f.categoryId == '5').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(List<FAQItem> faqs) {
    if (faqs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.helpNoFaqsFound,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.helpTryDifferentSearch,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        final isExpanded = _expandedId == faq.id;

        return FAQItemWidget(
          faq: faq.copyWith(isExpanded: isExpanded),
          onTap: () {
            setState(() {
              _expandedId = isExpanded ? null : faq.id;
            });
          },
          onHelpful: () {
            setState(() {
              final mainIndex = _mockFAQs.indexWhere((f) => f.id == faq.id);
              if (mainIndex != -1) {
                _mockFAQs[mainIndex] = faq.copyWith(
                  helpfulCount: faq.helpfulCount + 1,
                );
                _filterFAQs();
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.helpThanksForFeedback),
                duration: Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
