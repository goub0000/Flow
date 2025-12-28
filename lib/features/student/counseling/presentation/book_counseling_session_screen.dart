import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/counseling/models/counseling_models.dart';
import '../../../shared/counseling/widgets/counseling_widgets.dart';
import '../../providers/student_counseling_provider.dart';

/// Screen for booking a counseling session
class BookCounselingSessionScreen extends ConsumerStatefulWidget {
  final CounselorInfo counselor;

  const BookCounselingSessionScreen({
    super.key,
    required this.counselor,
  });

  @override
  ConsumerState<BookCounselingSessionScreen> createState() =>
      _BookCounselingSessionScreenState();
}

class _BookCounselingSessionScreenState
    extends ConsumerState<BookCounselingSessionScreen> {
  DateTime _selectedDate = DateTime.now();
  BookingSlot? _selectedSlot;
  SessionType _selectedType = SessionType.general;
  final _topicController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableSlots();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableSlots() async {
    final startDate = DateTime.now();
    final endDate = startDate.add(const Duration(days: 14));

    await ref.read(studentCounselingProvider.notifier).loadAvailableSlots(
          counselorId: widget.counselor.id,
          startDate: startDate,
          endDate: endDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentCounselingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Counselor info
            CounselorCard(
              counselor: widget.counselor,
              showBookButton: false,
              compact: true,
            ),
            const SizedBox(height: 24),

            // Date picker
            Text(
              'Select Date',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDatePicker(),
            const SizedBox(height: 24),

            // Time slots
            Text(
              'Select Time',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              TimeSlotPicker(
                slots: state.availableSlots,
                selectedSlot: _selectedSlot,
                onSlotSelected: (slot) {
                  setState(() => _selectedSlot = slot);
                },
                selectedDate: _selectedDate,
              ),
            const SizedBox(height: 24),

            // Session type
            Text(
              'Session Type',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SessionType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedType = type),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Topic
            Text(
              'Topic (Optional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: const InputDecoration(
                hintText: 'What would you like to discuss?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Additional Details (Optional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Any additional information for your counselor...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSlot == null || _isLoading
                    ? null
                    : _bookSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Book Session'),
              ),
            ),
            const SizedBox(height: 16),

            // Summary
            if (_selectedSlot != null) _buildSummary(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final dates = List.generate(14, (i) => now.add(Duration(days: i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate.day == date.day &&
              _selectedDate.month == date.month &&
              _selectedDate.year == date.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _selectedSlot = null; // Reset slot selection
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Session Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Counselor',
            widget.counselor.name,
          ),
          _buildSummaryRow(
            'Date',
            DateFormat('EEEE, MMMM d, y').format(_selectedSlot!.start),
          ),
          _buildSummaryRow(
            'Time',
            '${DateFormat('h:mm a').format(_selectedSlot!.start)} - ${DateFormat('h:mm a').format(_selectedSlot!.end)}',
          ),
          _buildSummaryRow(
            'Type',
            _selectedType.displayName,
          ),
          if (_topicController.text.isNotEmpty)
            _buildSummaryRow(
              'Topic',
              _topicController.text,
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookSession() async {
    if (_selectedSlot == null) return;

    setState(() => _isLoading = true);

    final request = BookSessionRequest(
      counselorId: widget.counselor.id,
      scheduledStart: _selectedSlot!.start,
      sessionType: _selectedType,
      topic: _topicController.text.isEmpty ? null : _topicController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
    );

    final session = await ref
        .read(studentCounselingProvider.notifier)
        .bookSession(request);

    setState(() => _isLoading = false);

    if (session != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session booked successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref.read(studentCounselingProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to book session'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
