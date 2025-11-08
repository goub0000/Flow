import '../../domain/models/chat_message.dart';

/// FAQ knowledge base for the chatbot
class FAQDatabase {
  static final FAQDatabase _instance = FAQDatabase._internal();
  factory FAQDatabase() => _instance;
  FAQDatabase._internal();

  /// Find matching FAQ based on user input
  FAQ? findMatch(String userInput) {
    final lowercaseInput = userInput.toLowerCase().trim();

    for (final faq in _faqs) {
      for (final keyword in faq.keywords) {
        if (lowercaseInput.contains(keyword.toLowerCase())) {
          return faq;
        }
      }
    }

    return null;
  }

  /// Get all FAQs by category
  List<FAQ> getByCategory(String category) {
    return _faqs.where((faq) => faq.category == category).toList();
  }

  /// Get all categories
  List<String> get categories {
    return _faqs.map((faq) => faq.category).toSet().toList();
  }
}

/// FAQ model
class FAQ {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final String category;
  final List<QuickAction>? followUpActions;

  const FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.category,
    this.followUpActions,
  });
}

/// FAQ database
final List<FAQ> _faqs = [
  // GENERAL
  FAQ(
    id: 'general_1',
    question: 'What is Flow?',
    answer: 'Flow is an all-in-one EdTech platform that connects students, '
        'institutions, parents, counselors, and recommenders for seamless '
        'education management. We help students find opportunities, manage '
        'applications, track progress, and achieve their academic goals.',
    keywords: ['what is flow', 'about flow', 'what is this', 'tell me about'],
    category: 'general',
    followUpActions: [
      QuickAction(id: '1', label: 'Features', action: 'features'),
      QuickAction(id: '2', label: 'Get Started', action: 'register'),
    ],
  ),

  FAQ(
    id: 'general_2',
    question: 'Who can use Flow?',
    answer: 'Flow serves 5 main user types:\n\n'
        '• Students - Find schools, manage applications\n'
        '• Institutions - Manage applicants and programs\n'
        '• Parents - Monitor children\'s progress\n'
        '• Counselors - Guide students effectively\n'
        '• Recommenders - Write recommendations\n\n'
        'Which one are you?',
    keywords: ['who can use', 'user types', 'who is this for', 'target audience'],
    category: 'general',
    followUpActions: [
      QuickAction(id: '1', label: 'I\'m a Student', action: 'student_info'),
      QuickAction(id: '2', label: 'I\'m a Parent', action: 'parent_info'),
      QuickAction(id: '3', label: 'Other', action: 'user_types'),
    ],
  ),

  // FEATURES
  FAQ(
    id: 'features_1',
    question: 'What features does Flow have?',
    answer: 'Flow offers comprehensive features:\n\n'
        '✓ Application Management\n'
        '✓ Progress Tracking & Analytics\n'
        '✓ Document Management\n'
        '✓ Messaging & Collaboration\n'
        '✓ Course & Resource Library\n'
        '✓ Counseling Sessions\n'
        '✓ Recommendations System\n'
        '✓ Parent Monitoring Tools',
    keywords: ['features', 'what can', 'capabilities', 'functions', 'what does it do'],
    category: 'features',
    followUpActions: [
      QuickAction(id: '1', label: 'See Demo', action: 'demo'),
      QuickAction(id: '2', label: 'Pricing', action: 'pricing'),
    ],
  ),

  FAQ(
    id: 'features_2',
    question: 'Can I track my application status?',
    answer: 'Yes! Flow provides real-time application tracking. You can '
        'monitor the status of all your applications in one dashboard, '
        'receive notifications about updates, and see exactly where each '
        'application stands in the review process.',
    keywords: ['track application', 'application status', 'monitor progress', 'check status'],
    category: 'features',
  ),

  // REGISTRATION
  FAQ(
    id: 'register_1',
    question: 'How do I sign up?',
    answer: 'Getting started is easy!\n\n'
        '1. Click "Get Started" button\n'
        '2. Choose your user type\n'
        '3. Fill in your information\n'
        '4. Verify your email\n'
        '5. Complete your profile\n\n'
        'Would you like to start now?',
    keywords: ['sign up', 'register', 'create account', 'join', 'get started'],
    category: 'registration',
    followUpActions: [
      QuickAction(id: '1', label: 'Register Now', action: 'register'),
      QuickAction(id: '2', label: 'Learn More', action: 'about'),
    ],
  ),

  FAQ(
    id: 'register_2',
    question: 'Is registration free?',
    answer: 'Yes! Creating an account on Flow is completely free. You can '
        'explore the platform, browse opportunities, and access basic features '
        'at no cost. Premium features are available with our paid plans.',
    keywords: ['free', 'registration cost', 'sign up cost', 'account cost'],
    category: 'registration',
  ),

  // PRICING
  FAQ(
    id: 'pricing_1',
    question: 'How much does Flow cost?',
    answer: 'Flow offers flexible pricing plans:\n\n'
        '• Free Plan - Basic features\n'
        '• Student Plan - \$9.99/month\n'
        '• Institution Plan - Custom pricing\n'
        '• Parent Plan - \$4.99/month\n\n'
        'All plans include a 30-day free trial!',
    keywords: ['price', 'cost', 'pricing', 'how much', 'plans', 'subscription'],
    category: 'pricing',
    followUpActions: [
      QuickAction(id: '1', label: 'View Plans', action: 'pricing'),
      QuickAction(id: '2', label: 'Start Free Trial', action: 'register'),
    ],
  ),

  FAQ(
    id: 'pricing_2',
    question: 'Is there a free trial?',
    answer: 'Yes! We offer a 30-day free trial for all paid plans. No credit '
        'card required to start. You can cancel anytime during the trial period '
        'with no charges.',
    keywords: ['free trial', 'trial', 'try free', 'test'],
    category: 'pricing',
  ),

  // STUDENTS
  FAQ(
    id: 'student_1',
    question: 'How can students use Flow?',
    answer: 'As a student, you can:\n\n'
        '• Search and discover schools\n'
        '• Submit and track applications\n'
        '• Upload and organize documents\n'
        '• Message counselors and institutions\n'
        '• Track your academic progress\n'
        '• Get personalized recommendations',
    keywords: ['student', 'students can', 'for students'],
    category: 'students',
    followUpActions: [
      QuickAction(id: '1', label: 'Register as Student', action: 'register_student'),
      QuickAction(id: '2', label: 'See Demo', action: 'demo'),
    ],
  ),

  // INSTITUTIONS
  FAQ(
    id: 'institution_1',
    question: 'How do institutions use Flow?',
    answer: 'Institutions can:\n\n'
        '• Manage applicant pipeline\n'
        '• Create and publish programs\n'
        '• Review applications efficiently\n'
        '• Communicate with applicants\n'
        '• Track enrollment metrics\n'
        '• Generate reports',
    keywords: ['institution', 'school', 'university', 'college'],
    category: 'institutions',
  ),

  // PARENTS
  FAQ(
    id: 'parent_1',
    question: 'What can parents do on Flow?',
    answer: 'Parents can:\n\n'
        '• Monitor children\'s progress\n'
        '• Receive updates and alerts\n'
        '• View application status\n'
        '• Communicate with counselors\n'
        '• Access academic reports\n'
        '• Support their children\'s journey',
    keywords: ['parent', 'parents can', 'for parents', 'guardian'],
    category: 'parents',
  ),

  // SUPPORT
  FAQ(
    id: 'support_1',
    question: 'How do I get help?',
    answer: 'We\'re here to help! You can:\n\n'
        '• Use this chat for instant answers\n'
        '• Email: support@flow.com\n'
        '• Visit our Help Center\n'
        '• Check our FAQ section\n'
        '• Schedule a call with our team',
    keywords: ['help', 'support', 'contact', 'assistance', 'problem'],
    category: 'support',
    followUpActions: [
      QuickAction(id: '1', label: 'Email Support', action: 'email_support'),
      QuickAction(id: '2', label: 'Help Center', action: 'help_center'),
    ],
  ),

  FAQ(
    id: 'support_2',
    question: 'What are your support hours?',
    answer: 'Our support team is available:\n\n'
        '• Monday - Friday: 8 AM - 8 PM EAT\n'
        '• Saturday: 9 AM - 5 PM EAT\n'
        '• Sunday: Closed\n\n'
        'This chatbot is available 24/7 for instant answers!',
    keywords: ['support hours', 'when available', 'operating hours', 'contact hours'],
    category: 'support',
  ),

  // TECHNICAL
  FAQ(
    id: 'technical_1',
    question: 'What devices does Flow work on?',
    answer: 'Flow works on all modern devices:\n\n'
        '• Desktop (Windows, Mac, Linux)\n'
        '• Mobile (iOS, Android)\n'
        '• Tablet (iPad, Android tablets)\n'
        '• Web browsers (Chrome, Safari, Firefox, Edge)\n\n'
        'Your data syncs across all devices!',
    keywords: ['devices', 'platform', 'mobile', 'desktop', 'compatible'],
    category: 'technical',
  ),

  FAQ(
    id: 'technical_2',
    question: 'Is my data secure?',
    answer: 'Absolutely! We take security seriously:\n\n'
        '✓ End-to-end encryption\n'
        '✓ GDPR compliant\n'
        '✓ Regular security audits\n'
        '✓ Secure data centers\n'
        '✓ Two-factor authentication\n\n'
        'Your privacy and data security are our top priorities.',
    keywords: ['secure', 'security', 'safe', 'privacy', 'data protection'],
    category: 'technical',
  ),

  // COUNSELORS
  FAQ(
    id: 'counselor_1',
    question: 'How do counselors use Flow?',
    answer: 'Counselors can:\n\n'
        '• Manage student profiles\n'
        '• Schedule counseling sessions\n'
        '• Track student progress\n'
        '• Provide guidance and recommendations\n'
        '• Collaborate with institutions\n'
        '• Generate progress reports',
    keywords: ['counselor', 'counselors can', 'for counselors', 'advisor'],
    category: 'counselors',
  ),

  // RECOMMENDERS
  FAQ(
    id: 'recommender_1',
    question: 'How does the recommendation system work?',
    answer: 'Recommenders can:\n\n'
        '• Receive recommendation requests\n'
        '• Write and submit recommendations\n'
        '• Track recommendation status\n'
        '• Manage multiple students\n'
        '• Use templates for efficiency\n\n'
        'Students can easily request recommendations through the platform.',
    keywords: ['recommendation', 'recommender', 'reference', 'letter of recommendation'],
    category: 'recommenders',
  ),
];
