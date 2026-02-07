// ignore_for_file: prefer_final_fields, unnecessary_getters_setters

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../data/knowledge_base/faqs.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/api/api_config.dart';

/// Provider for the chatbot service
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ChatbotService(authService: authService);
});

/// Service for handling chatbot logic and responses
class ChatbotService {
  final AuthService? authService;
  final FAQDatabase _faqDatabase = FAQDatabase();
  final Random _random = Random();

  String? _currentConversationId;
  bool _useApi = true;

  ChatbotService({this.authService});

  /// Get current conversation ID
  String? get currentConversationId => _currentConversationId;

  /// Set conversation ID (for resuming conversations)
  set currentConversationId(String? id) => _currentConversationId = id;

  /// Process user message and generate bot response
  Future<ChatMessage> processMessage(String userMessage, {Map<String, dynamic>? context}) async {
    // Try API first if available and user is authenticated
    if (_useApi && authService != null) {
      final token = authService!.accessToken;
      if (token != null) {
        try {
          final response = await _sendMessageToApi(userMessage, context);
          if (response != null) {
            return response;
          }
        } catch (e) {
          // API failed, fall back to local processing
        }
      }
    }

    // Fallback to local processing
    return _processMessageLocally(userMessage);
  }

  /// Send message to backend API
  Future<ChatMessage?> _sendMessageToApi(String message, Map<String, dynamic>? context) async {
    final token = authService?.accessToken;
    if (token == null) return null;

    final baseUrl = ApiConfig.baseUrl;
    final uri = Uri.parse('$baseUrl/api/v1/chatbot/messages');

    final body = {
      'message': message,
      'conversation_id': _currentConversationId,
      'context': context ?? {},
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Update conversation ID for future messages
      _currentConversationId = data['conversation_id'];

      return ChatMessage.fromApiResponse(data);
    }

    return null;
  }

  /// Submit feedback for a message
  Future<bool> submitFeedback(String messageId, MessageFeedback feedback, {String? comment}) async {
    if (authService == null) return false;

    final token = authService!.accessToken;
    if (token == null) return false;

    try {
      final baseUrl = ApiConfig.baseUrl;
      final uri = Uri.parse('$baseUrl/api/v1/chatbot/messages/$messageId/feedback');

      final body = {
        'feedback': feedback == MessageFeedback.helpful ? 'helpful' : 'not_helpful',
        if (comment != null) 'comment': comment,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Escalate conversation to human support
  Future<bool> escalateToHuman({String? reason}) async {
    if (_currentConversationId == null || authService == null) {
      return false;
    }

    final token = authService!.accessToken;
    if (token == null) return false;

    try {
      final baseUrl = ApiConfig.baseUrl;
      final uri = Uri.parse('$baseUrl/api/v1/chatbot/conversations/$_currentConversationId/escalate');

      final body = {
        'reason': reason ?? 'user_request',
        'priority': 'normal',
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Load conversation history
  Future<List<ChatMessage>> loadConversationHistory(String conversationId) async {
    if (authService == null) return [];

    final token = authService!.accessToken;
    if (token == null) return [];

    try {
      final baseUrl = ApiConfig.baseUrl;
      final uri = Uri.parse('$baseUrl/api/v1/chatbot/conversations/$conversationId/messages');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final messages = (data['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList();
        _currentConversationId = conversationId;
        return messages;
      }
    } catch (e) {
      // Failed to load history
    }

    return [];
  }

  /// Start a new conversation
  void startNewConversation() {
    _currentConversationId = null;
  }

  /// Process message locally (fallback)
  Future<ChatMessage> _processMessageLocally(String userMessage) async {
    // Simulate processing delay for more natural feel
    await Future.delayed(const Duration(milliseconds: 500));

    final cleanedMessage = _preprocessMessage(userMessage);

    // Handle greetings
    if (_isGreeting(cleanedMessage)) {
      return _getGreeting();
    }

    // Handle help requests
    if (_isHelpRequest(cleanedMessage)) {
      return _getHelpMessage();
    }

    // Handle goodbye
    if (_isGoodbye(cleanedMessage)) {
      return _getGoodbyeMessage();
    }

    // Handle thanks
    if (_isThanks(cleanedMessage)) {
      return _getThanksResponse();
    }

    // Try to find FAQ match
    final faq = _faqDatabase.findMatch(cleanedMessage);
    if (faq != null) {
      return ChatMessage.bot(
        content: faq.answer,
        quickActions: faq.followUpActions,
      );
    }

    // Fallback response
    return _getFallbackResponse();
  }

  /// Process quick action
  ChatMessage processQuickAction(String action) {
    switch (action) {
      case 'about_flow':
      case 'about':
        return ChatMessage.bot(
          content: 'Flow is an all-in-one EdTech platform that connects '
              'students, institutions, parents, counselors, and recommenders. '
              'We help streamline the education journey from application to graduation.',
          quickActions: [
            const QuickAction(id: '1', label: 'Features', action: 'features'),
            const QuickAction(id: '2', label: 'Get Started', action: 'register'),
          ],
        );

      case 'features':
        return ChatMessage.bot(
          content: 'Flow offers:\n\n'
              '✓ Application Management\n'
              '✓ Progress Tracking\n'
              '✓ Document Storage\n'
              '✓ Messaging & Collaboration\n'
              '✓ Course Resources\n'
              '✓ Analytics & Reports',
          quickActions: [
            const QuickAction(id: '1', label: 'Pricing', action: 'pricing'),
            const QuickAction(id: '2', label: 'Sign Up', action: 'register'),
          ],
        );

      case 'pricing':
        return ChatMessage.bot(
          content: 'Our pricing plans:\n\n'
              '• Free Plan - Basic features\n'
              '• Student - \$9.99/month\n'
              '• Institution - Custom\n'
              '• Parent - \$4.99/month\n\n'
              'All plans include 30-day free trial!',
          quickActions: [
            const QuickAction(id: '1', label: 'Start Free Trial', action: 'register'),
            const QuickAction(id: '2', label: 'Compare Plans', action: 'compare_plans'),
          ],
        );

      case 'register':
      case 'get_started':
      case 'register_student':
        return ChatMessage.bot(
          content: 'Great! Ready to get started? Click the button below to begin registration.',
          quickActions: [
            const QuickAction(id: '1', label: 'Register Now →', action: 'navigate_register'),
          ],
        );

      case 'student_info':
        return ChatMessage.bot(
          content: 'As a student, you can:\n\n'
              '• Find and apply to schools\n'
              '• Track application status\n'
              '• Manage documents\n'
              '• Connect with counselors\n'
              '• Monitor your progress',
          quickActions: [
            const QuickAction(id: '1', label: 'Register as Student', action: 'register_student'),
            const QuickAction(id: '2', label: 'Learn More', action: 'features'),
          ],
        );

      case 'parent_info':
        return ChatMessage.bot(
          content: 'As a parent, you can:\n\n'
              '• Monitor your children\'s progress\n'
              '• Receive updates and alerts\n'
              '• Communicate with schools\n'
              '• Access academic reports\n'
              '• Support their journey',
          quickActions: [
            const QuickAction(id: '1', label: 'Register as Parent', action: 'register'),
            const QuickAction(id: '2', label: 'Other User Types', action: 'user_types'),
          ],
        );

      case 'user_types':
        return ChatMessage.bot(
          content: 'Flow serves:\n\n'
              '• Students - Find opportunities\n'
              '• Institutions - Manage applicants\n'
              '• Parents - Monitor progress\n'
              '• Counselors - Guide students\n'
              '• Recommenders - Write references\n\n'
              'Which describes you best?',
          quickActions: [
            const QuickAction(id: '1', label: 'Student', action: 'student_info'),
            const QuickAction(id: '2', label: 'Parent', action: 'parent_info'),
            const QuickAction(id: '3', label: 'Other', action: 'help'),
          ],
        );

      case 'help':
      case 'menu':
        return _getHelpMessage();

      case 'support':
      case 'email_support':
        return ChatMessage.bot(
          content: 'You can reach our support team:\n\n'
              '📧 Email: support@flow.com\n'
              '📞 Phone: +254 XXX XXX XXX\n'
              '⏰ Hours: Mon-Fri, 8 AM - 8 PM EAT\n\n'
              'Or continue chatting here!',
          quickActions: [
            const QuickAction(id: '1', label: 'Back to Menu', action: 'menu'),
          ],
        );

      case 'talk_to_human':
      case 'escalate':
        escalateToHuman(reason: 'user_request');
        return ChatMessage.bot(
          content: 'I\'m connecting you with a human agent. '
              'Please wait a moment while we find someone to assist you.',
          quickActions: [],
        );

      default:
        return _getFallbackResponse();
    }
  }

  /// Get initial greeting message
  ChatMessage getInitialGreeting() {
    return ChatMessage.bot(
      content: 'Hi! 👋 I\'m the Flow Assistant. How can I help you today?',
      quickActions: [
        const QuickAction(id: '1', label: 'What is Flow?', action: 'about_flow'),
        const QuickAction(id: '2', label: 'Get Started', action: 'register'),
        const QuickAction(id: '3', label: 'Pricing', action: 'pricing'),
        const QuickAction(id: '4', label: 'Features', action: 'features'),
      ],
    );
  }

  // Private helper methods

  String _preprocessMessage(String message) {
    return message.trim().toLowerCase();
  }

  bool _isGreeting(String message) {
    final greetings = ['hi', 'hello', 'hey', 'greetings', 'good morning', 'good afternoon', 'good evening'];
    return greetings.any((greeting) => message.contains(greeting));
  }

  bool _isHelpRequest(String message) {
    final helpKeywords = ['help', 'assist', 'support', 'menu', 'options'];
    return helpKeywords.any((keyword) => message.contains(keyword));
  }

  bool _isGoodbye(String message) {
    final goodbyes = ['bye', 'goodbye', 'see you', 'later', 'exit', 'quit'];
    return goodbyes.any((goodbye) => message.contains(goodbye));
  }

  bool _isThanks(String message) {
    final thankWords = ['thank', 'thanks', 'appreciate', 'grateful'];
    return thankWords.any((word) => message.contains(word));
  }

  ChatMessage _getGreeting() {
    final greetings = [
      'Hello! 👋 How can I assist you today?',
      'Hi there! Welcome to Flow. What can I help you with?',
      'Hey! Great to see you. What would you like to know?',
    ];

    return ChatMessage.bot(
      content: greetings[_random.nextInt(greetings.length)],
      quickActions: [
        const QuickAction(id: '1', label: 'About Flow', action: 'about_flow'),
        const QuickAction(id: '2', label: 'Features', action: 'features'),
        const QuickAction(id: '3', label: 'Get Started', action: 'register'),
      ],
    );
  }

  ChatMessage _getHelpMessage() {
    return ChatMessage.bot(
      content: 'I can help you with:\n\n'
          '• Understanding Flow\'s features\n'
          '• Registration guidance\n'
          '• Pricing information\n'
          '• User types and roles\n'
          '• Technical support\n\n'
          'What would you like to know?',
      quickActions: [
        const QuickAction(id: '1', label: 'Features', action: 'features'),
        const QuickAction(id: '2', label: 'Register', action: 'register'),
        const QuickAction(id: '3', label: 'Pricing', action: 'pricing'),
        const QuickAction(id: '4', label: 'Support', action: 'support'),
      ],
    );
  }

  ChatMessage _getGoodbyeMessage() {
    final goodbyes = [
      'Thanks for chatting! Feel free to return anytime. Have a great day! 👋',
      'Goodbye! Don\'t hesitate to come back if you have more questions. 😊',
      'See you later! We\'re here 24/7 whenever you need help. 👋',
    ];

    return ChatMessage.bot(
      content: goodbyes[_random.nextInt(goodbyes.length)],
    );
  }

  ChatMessage _getThanksResponse() {
    final responses = [
      'You\'re welcome! Is there anything else I can help you with? 😊',
      'Happy to help! Let me know if you have more questions. 👍',
      'My pleasure! Feel free to ask if you need anything else. ✨',
    ];

    return ChatMessage.bot(
      content: responses[_random.nextInt(responses.length)],
      quickActions: [
        const QuickAction(id: '1', label: 'Main Menu', action: 'menu'),
        const QuickAction(id: '2', label: 'Register', action: 'register'),
      ],
    );
  }

  ChatMessage _getFallbackResponse() {
    return ChatMessage.bot(
      content: 'I\'m not sure I understand that question. Could you rephrase it, '
          'or choose from these options?',
      quickActions: [
        const QuickAction(id: '1', label: 'Main Menu', action: 'menu'),
        const QuickAction(id: '2', label: 'Talk to Human', action: 'talk_to_human'),
        const QuickAction(id: '3', label: 'Browse FAQs', action: 'help'),
      ],
    );
  }
}
