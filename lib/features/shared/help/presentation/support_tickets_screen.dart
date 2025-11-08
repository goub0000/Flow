import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../widgets/help_support_widgets.dart';

/// Support Tickets Screen
///
/// Manage support tickets and track issue resolution.
/// Features:
/// - View open and closed tickets
/// - Create new tickets
/// - View ticket details and messages
/// - Add responses to tickets
/// - Track ticket status
///
/// Backend Integration TODO:
/// - Fetch tickets from API
/// - Submit new tickets
/// - Add messages to tickets
/// - Update ticket status
/// - Upload attachments
/// - Send notifications

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SupportTicket> _mockTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateMockTickets() {
    _mockTickets = [
      SupportTicket(
        id: '1',
        subject: 'Unable to download course videos',
        description:
            'I\'m having trouble downloading videos for offline viewing. The download button doesn\'t seem to work.',
        status: TicketStatus.inProgress,
        priority: TicketPriority.high,
        category: TicketCategory.technical,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        messages: [
          TicketMessage(
            id: '1',
            content:
                'I\'m having trouble downloading videos for offline viewing.',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            isFromSupport: false,
          ),
          TicketMessage(
            id: '2',
            content:
                'Thank you for contacting us. We\'re looking into this issue. Can you tell us which device and app version you\'re using?',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            isFromSupport: true,
            authorName: 'Support Team',
          ),
          TicketMessage(
            id: '3',
            content: 'I\'m using Android 12 on a Samsung Galaxy S21.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            isFromSupport: false,
          ),
        ],
        assignedTo: 'Support Team',
      ),
      SupportTicket(
        id: '2',
        subject: 'Billing question about subscription',
        description:
            'I was charged twice for my monthly subscription. Can you help me get a refund?',
        status: TicketStatus.waitingForResponse,
        priority: TicketPriority.medium,
        category: TicketCategory.billing,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
        messages: [
          TicketMessage(
            id: '4',
            content: 'I was charged twice for my monthly subscription.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isFromSupport: false,
          ),
          TicketMessage(
            id: '5',
            content:
                'We\'ve reviewed your account and found the duplicate charge. A refund has been initiated and should appear in 3-5 business days. Is there anything else we can help you with?',
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
            isFromSupport: true,
            authorName: 'Billing Team',
          ),
        ],
        assignedTo: 'Billing Team',
      ),
      SupportTicket(
        id: '3',
        subject: 'Certificate not generating',
        description:
            'I completed all course requirements but haven\'t received my certificate yet.',
        status: TicketStatus.resolved,
        priority: TicketPriority.medium,
        category: TicketCategory.courses,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        messages: [
          TicketMessage(
            id: '6',
            content: 'I completed all requirements but no certificate.',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            isFromSupport: false,
          ),
          TicketMessage(
            id: '7',
            content:
                'Your certificate has been generated! You can download it from your profile.',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            isFromSupport: true,
            authorName: 'Support Team',
          ),
        ],
        assignedTo: 'Support Team',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Waiting'),
            Tab(text: 'Resolved'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketList(_mockTickets.where((t) =>
              t.status == TicketStatus.open ||
              t.status == TicketStatus.inProgress)),
          _buildTicketList(_mockTickets.where(
              (t) => t.status == TicketStatus.waitingForResponse)),
          _buildTicketList(_mockTickets.where((t) =>
              t.status == TicketStatus.resolved ||
              t.status == TicketStatus.closed)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTicketDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
    );
  }

  Widget _buildTicketList(Iterable<SupportTicket> tickets) {
    final ticketList = tickets.toList();

    if (ticketList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a ticket to get support',
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
      itemCount: ticketList.length,
      itemBuilder: (context, index) {
        return SupportTicketCard(
          ticket: ticketList[index],
          onTap: () => _showTicketDetail(ticketList[index]),
        );
      },
    );
  }

  void _showTicketDetail(SupportTicket ticket) {
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ticket.subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TicketStatusBadge(status: ticket.status),
                      const SizedBox(width: 8),
                      TicketPriorityBadge(priority: ticket.priority),
                      const Spacer(),
                      Text(
                        'Ticket #${ticket.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: ticket.messages.length,
                itemBuilder: (context, index) {
                  return TicketMessageBubble(
                    message: ticket.messages[index],
                  );
                },
              ),
            ),

            // Reply Section
            if (ticket.status != TicketStatus.resolved &&
                ticket.status != TicketStatus.closed)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                  color: Colors.white,
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Message sent!')),
                            );
                            messageController.clear();
                          }
                        },
                        icon: const Icon(Icons.send),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateTicketDialog() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    TicketCategory selectedCategory = TicketCategory.technical;
    TicketPriority selectedPriority = TicketPriority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create Support Ticket'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your issue in detail...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TicketCategory>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: TicketCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(category.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TicketPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: TicketPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedPriority = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support ticket created successfully!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
