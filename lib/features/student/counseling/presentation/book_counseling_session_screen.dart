import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n_extension.dart';
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
  DateTime _currentMonth = DateTime.now();
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
    final endDate = startDate.add(const Duration(days: 60)); // Load 60 days of availability

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
        title: Text(context.l10n.studentCounselingBookSession),
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
              context.l10n.studentCounselingSelectDate,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDatePicker(),
            const SizedBox(height: 24),

            // Time slots
            Text(
              context.l10n.studentCounselingSelectTime,
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
              context.l10n.studentCounselingSessionType,
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
              context.l10n.studentCounselingTopicOptional,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                hintText: context.l10n.studentCounselingTopicHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              context.l10n.studentCounselingDetailsOptional,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: context.l10n.studentCounselingDetailsHint,
                border: const OutlineInputBorder(),
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
                    : Text(context.l10n.studentCounselingBookSession),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation header
          _buildCalendarHeader(),
          // Day of week headers
          _buildWeekdayHeaders(),
          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _canGoPreviousMonth()
                ? () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  }
                : null,
          ),
          GestureDetector(
            onTap: _showMonthPicker,
            child: Text(
              DateFormat('MMMM yyyy').format(_currentMonth),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _canGoNextMonth()
                ? () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  bool _canGoPreviousMonth() {
    final now = DateTime.now();
    return _currentMonth.year > now.year ||
        (_currentMonth.year == now.year && _currentMonth.month > now.month);
  }

  bool _canGoNextMonth() {
    final maxDate = DateTime.now().add(const Duration(days: 60));
    return _currentMonth.year < maxDate.year ||
        (_currentMonth.year == maxDate.year &&
            _currentMonth.month < maxDate.month);
  }

  void _showMonthPicker() async {
    final now = DateTime.now();
    final maxDate = now.add(const Duration(days: 60));

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: maxDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _currentMonth = DateTime(picked.year, picked.month);
        _selectedSlot = null;
      });
    }
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: weekdays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final maxDate = now.add(const Duration(days: 60));

    // Get first day of month and calculate offset
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    // Calculate total cells needed (including padding)
    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - startWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                // Empty cell
                return const Expanded(child: SizedBox(height: 44));
              }

              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isSelected = _selectedDate.day == date.day &&
                  _selectedDate.month == date.month &&
                  _selectedDate.year == date.year;
              final isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;
              final isPast = date.isBefore(today);
              final isFuture = date.isAfter(maxDate);
              final isDisabled = isPast || isFuture;

              return Expanded(
                child: GestureDetector(
                  onTap: isDisabled
                      ? null
                      : () {
                          setState(() {
                            _selectedDate = date;
                            _selectedSlot = null;
                          });
                        },
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isDisabled
                              ? Colors.grey[400]
                              : isSelected
                                  ? Colors.white
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
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
            context.l10n.studentCounselingSessionSummary,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            context.l10n.studentCounselingCounselor,
            widget.counselor.name,
          ),
          _buildSummaryRow(
            context.l10n.studentCounselingDate,
            DateFormat('EEEE, MMMM d, y').format(_selectedSlot!.start),
          ),
          _buildSummaryRow(
            context.l10n.studentCounselingTime,
            '${DateFormat('h:mm a').format(_selectedSlot!.start)} - ${DateFormat('h:mm a').format(_selectedSlot!.end)}',
          ),
          _buildSummaryRow(
            context.l10n.studentCounselingType,
            _selectedType.displayName,
          ),
          if (_topicController.text.isNotEmpty)
            _buildSummaryRow(
              context.l10n.studentCounselingTopic,
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
        SnackBar(
          content: Text(context.l10n.studentCounselingBookedSuccess),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref.read(studentCounselingProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? context.l10n.studentCounselingBookFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
