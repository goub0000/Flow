// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/models/quiz_assignment_models.dart';

/// A professional quiz content editor for creating college-grade assessments.
/// Supports multiple choice, true/false, short answer, and essay questions
/// with comprehensive validation and preview functionality.
class QuizContentEditor extends StatefulWidget {
  final QuizContent? initialContent;
  final Function(QuizContentRequest) onSave;

  const QuizContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<QuizContentEditor> createState() => _QuizContentEditorState();
}

class _QuizContentEditorState extends State<QuizContentEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _timeLimitController;
  late TextEditingController _passingScoreController;
  late TextEditingController _instructionsController;
  final List<QuizQuestionRequest> _questions = [];
  int? _maxAttempts;
  bool _shuffleQuestions = false;
  bool _showCorrectAnswers = true;
  bool _showFeedbackImmediately = true;

  @override
  void initState() {
    super.initState();
    _timeLimitController = TextEditingController(
      text: widget.initialContent?.timeLimitMinutes?.toString() ?? '',
    );
    _passingScoreController = TextEditingController(
      text: widget.initialContent?.passingScore.toString() ?? '70',
    );
    _instructionsController = TextEditingController(
      text: widget.initialContent?.instructions ?? '',
    );
    _maxAttempts = widget.initialContent?.maxAttempts;
    _shuffleQuestions = widget.initialContent?.shuffleQuestions ?? false;
    _showCorrectAnswers = widget.initialContent?.showCorrectAnswers ?? true;
    _showFeedbackImmediately = widget.initialContent?.showFeedback ?? true;

    // Load existing questions if editing
    if (widget.initialContent?.questions != null) {
      for (final q in widget.initialContent!.questions!) {
        _questions.add(_convertToRequest(q));
      }
    }
  }

  QuizQuestionRequest _convertToRequest(QuizQuestion question) {
    return QuizQuestionRequest(
      questionText: question.questionText,
      questionType: question.questionType,
      points: question.points,
      orderIndex: question.orderIndex,
      correctAnswer: question.correctAnswer,
      sampleAnswer: question.sampleAnswer,
      explanation: question.explanation,
      hint: question.hint,
      isRequired: question.isRequired,
      options: question.options
          ?.map((o) => QuestionOptionRequest(
                optionText: o.optionText,
                isCorrect: o.isCorrect,
                orderIndex: o.orderIndex,
                feedback: o.feedback,
              ))
          .toList(),
    );
  }

  @override
  void dispose() {
    _timeLimitController.dispose();
    _passingScoreController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  int get _totalPoints {
    return _questions.fold(0, (sum, q) => sum + (q.points ?? 1));
  }

  int get _validQuestionCount {
    return _questions.where((q) => _isQuestionValid(q)).length;
  }

  bool _isQuestionValid(QuizQuestionRequest question) {
    if (question.questionText.trim().isEmpty) return false;
    if ((question.points ?? 1) <= 0) return false;

    switch (question.questionType) {
      case QuestionType.multipleChoice:
        final options = question.options ?? [];
        if (options.length < 2) return false;
        final correctCount = options.where((o) => o.isCorrect == true).length;
        if (correctCount != 1) return false;
        if (options.any((o) => o.optionText.trim().isEmpty)) return false;
        return true;

      case QuestionType.trueFalse:
        final options = question.options ?? [];
        if (options.length != 2) return false;
        final correctCount = options.where((o) => o.isCorrect == true).length;
        return correctCount == 1;

      case QuestionType.shortAnswer:
        return question.correctAnswer?.trim().isNotEmpty == true;

      case QuestionType.essay:
        // Essay questions don't require correct answer (manual grading)
        return true;
    }
  }

  String _getQuestionValidationMessage(QuizQuestionRequest question) {
    if (question.questionText.trim().isEmpty) {
      return 'Question text is required';
    }
    if ((question.points ?? 1) <= 0) {
      return 'Points must be greater than 0';
    }

    switch (question.questionType) {
      case QuestionType.multipleChoice:
        final options = question.options ?? [];
        if (options.length < 2) return 'At least 2 options required';
        final correctCount = options.where((o) => o.isCorrect == true).length;
        if (correctCount == 0) return 'Select one correct answer';
        if (correctCount > 1) return 'Only one correct answer allowed';
        if (options.any((o) => o.optionText.trim().isEmpty)) {
          return 'All options must have text';
        }
        return '';

      case QuestionType.trueFalse:
        final options = question.options ?? [];
        if (options.length != 2) return 'True/False options not configured';
        final correctCount = options.where((o) => o.isCorrect == true).length;
        if (correctCount != 1) return 'Select the correct answer (True or False)';
        return '';

      case QuestionType.shortAnswer:
        if (question.correctAnswer?.trim().isEmpty != false) {
          return 'Correct answer is required';
        }
        return '';

      case QuestionType.essay:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildQuizSettings(),
          const SizedBox(height: 24),
          _buildQuestionsSection(),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quiz Content Editor',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        _buildQuizSummary(),
      ],
    );
  }

  Widget _buildQuizSummary() {
    final isValid = _questions.isNotEmpty &&
        _questions.every((q) => _isQuestionValid(q));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValid ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            size: 20,
            color: isValid ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            '$_validQuestionCount/${_questions.length} questions valid',
            style: TextStyle(
              color: isValid ? Colors.green.shade700 : Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.star,
            size: 18,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '$_totalPoints points',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSettings() {
    return Card(
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: const Icon(Icons.settings),
          title: const Text(
            'Quiz Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions field
                  TextFormField(
                    controller: _instructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Quiz Instructions',
                      hintText: 'Provide instructions for students taking this quiz...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info_outline),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Time and Score settings
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _timeLimitController,
                          decoration: const InputDecoration(
                            labelText: 'Time Limit (minutes)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.timer),
                            helperText: 'Leave empty for no time limit',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final minutes = int.tryParse(value);
                              if (minutes == null || minutes <= 0) {
                                return 'Enter a valid number';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _passingScoreController,
                          decoration: const InputDecoration(
                            labelText: 'Passing Score (%)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.check_circle),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final score = int.tryParse(value);
                            if (score == null || score < 0 || score > 100) {
                              return 'Must be 0-100';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Max attempts
                  DropdownButtonFormField<int?>(
                    value: _maxAttempts,
                    decoration: const InputDecoration(
                      labelText: 'Maximum Attempts',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.replay),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Unlimited'),
                      ),
                      ...List.generate(10, (i) => i + 1).map((count) {
                        return DropdownMenuItem(
                          value: count,
                          child: Text('$count attempt${count > 1 ? 's' : ''}'),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _maxAttempts = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Toggle options
                  _buildSettingSwitch(
                    title: 'Shuffle Questions',
                    subtitle: 'Randomize question order for each attempt',
                    icon: Icons.shuffle,
                    value: _shuffleQuestions,
                    onChanged: (value) {
                      setState(() {
                        _shuffleQuestions = value;
                      });
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Show Correct Answers',
                    subtitle: 'Display correct answers after submission',
                    icon: Icons.visibility,
                    value: _showCorrectAnswers,
                    onChanged: (value) {
                      setState(() {
                        _showCorrectAnswers = value;
                      });
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Show Feedback Immediately',
                    subtitle: 'Show feedback after each question vs. at the end',
                    icon: Icons.feedback,
                    value: _showFeedbackImmediately,
                    onChanged: (value) {
                      setState(() {
                        _showFeedbackImmediately = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Questions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_questions.length}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            _buildAddQuestionButton(),
          ],
        ),
        const SizedBox(height: 12),
        if (_questions.isEmpty)
          _buildEmptyQuestionsState()
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions.length,
            onReorder: _reorderQuestions,
            itemBuilder: (context, index) {
              return _buildQuestionCard(index, key: ValueKey(_questions[index]));
            },
          ),
      ],
    );
  }

  Widget _buildAddQuestionButton() {
    return PopupMenuButton<QuestionType>(
      onSelected: (type) => _showQuestionDialog(questionType: type),
      itemBuilder: (context) => QuestionType.values.map((type) {
        return PopupMenuItem(
          value: type,
          child: Row(
            children: [
              Icon(type.icon, size: 20, color: _getQuestionTypeColor(type)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type.displayName),
                  Text(
                    _getQuestionTypeDescription(type),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
      child: ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Question'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  String _getQuestionTypeDescription(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return 'Select one correct answer';
      case QuestionType.trueFalse:
        return 'True or False answer';
      case QuestionType.shortAnswer:
        return 'Auto-graded text response';
      case QuestionType.essay:
        return 'Manual grading required';
    }
  }

  Color _getQuestionTypeColor(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return Colors.blue;
      case QuestionType.trueFalse:
        return Colors.green;
      case QuestionType.shortAnswer:
        return Colors.orange;
      case QuestionType.essay:
        return Colors.purple;
    }
  }

  Widget _buildEmptyQuestionsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No questions added yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Add Question" to create your first question',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: QuestionType.values.map((type) {
                return ActionChip(
                  avatar: Icon(type.icon, size: 18),
                  label: Text(type.displayName),
                  onPressed: () => _showQuestionDialog(questionType: type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _reorderQuestions(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _questions.removeAt(oldIndex);
      _questions.insert(newIndex, item);

      // Update order indices
      for (int i = 0; i < _questions.length; i++) {
        _questions[i] = _questions[i].copyWith(orderIndex: i + 1);
      }
    });
  }

  Widget _buildQuestionCard(int index, {Key? key}) {
    final question = _questions[index];
    final isValid = _isQuestionValid(question);
    final validationMessage = _getQuestionValidationMessage(question);
    final typeColor = _getQuestionTypeColor(question.questionType);

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isValid ? Colors.grey.shade200 : Colors.red.shade200,
          width: isValid ? 1 : 2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  question.questionText.isEmpty
                      ? '(No question text)'
                      : question.questionText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: question.questionText.isEmpty
                        ? Colors.grey.shade400
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isValid)
                Tooltip(
                  message: validationMessage,
                  child: Icon(
                    Icons.error,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildQuestionChip(
                  icon: question.questionType.icon,
                  label: question.questionType.displayName,
                  color: typeColor,
                ),
                _buildQuestionChip(
                  icon: Icons.star,
                  label: '${question.points ?? 1} pts',
                  color: Colors.amber.shade700,
                ),
                if (question.hint?.isNotEmpty == true)
                  _buildQuestionChip(
                    icon: Icons.lightbulb_outline,
                    label: 'Has hint',
                    color: Colors.blue.shade700,
                  ),
                _buildCorrectAnswerChip(question),
              ],
            ),
          ),
          trailing: ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview section
                  _buildQuestionPreview(question),
                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showQuestionPreviewDialog(question),
                        icon: const Icon(Icons.preview, size: 18),
                        label: const Text('Preview'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _editQuestion(index),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _duplicateQuestion(index),
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Duplicate'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _confirmDeleteQuestion(index),
                        icon: Icon(Icons.delete, size: 18, color: Colors.red.shade400),
                        label: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswerChip(QuizQuestionRequest question) {
    String label;
    Color color;

    switch (question.questionType) {
      case QuestionType.multipleChoice:
        final correctOptions = question.options
            ?.where((o) => o.isCorrect == true)
            .map((o) => o.optionText)
            .toList();
        if (correctOptions?.isNotEmpty == true) {
          final text = correctOptions!.first;
          label = 'Answer: ${text.length > 15 ? '${text.substring(0, 15)}...' : text}';
          color = Colors.green.shade700;
        } else {
          label = 'No correct answer';
          color = Colors.red.shade700;
        }
        break;

      case QuestionType.trueFalse:
        final correctOption = question.options?.firstWhere(
          (o) => o.isCorrect == true,
          orElse: () => QuestionOptionRequest(optionText: ''),
        );
        if (correctOption?.optionText.isNotEmpty == true) {
          label = 'Answer: ${correctOption!.optionText}';
          color = Colors.green.shade700;
        } else {
          label = 'No answer selected';
          color = Colors.red.shade700;
        }
        break;

      case QuestionType.shortAnswer:
        if (question.correctAnswer?.isNotEmpty == true) {
          final text = question.correctAnswer!;
          label = 'Answer: ${text.length > 15 ? '${text.substring(0, 15)}...' : text}';
          color = Colors.green.shade700;
        } else {
          label = 'No correct answer';
          color = Colors.red.shade700;
        }
        break;

      case QuestionType.essay:
        label = 'Manual grading';
        color = Colors.purple.shade700;
        break;
    }

    return _buildQuestionChip(
      icon: Icons.check_circle_outline,
      label: label,
      color: color,
    );
  }

  Widget _buildQuestionPreview(QuizQuestionRequest question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPreviewContent(question),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(QuizQuestionRequest question) {
    switch (question.questionType) {
      case QuestionType.multipleChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.options?.isNotEmpty == true)
              ...question.options!.asMap().entries.map((entry) {
                final option = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        option.isCorrect == true
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 20,
                        color: option.isCorrect == true
                            ? Colors.green
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option.optionText.isEmpty ? '(Empty option)' : option.optionText,
                          style: TextStyle(
                            color: option.optionText.isEmpty
                                ? Colors.grey.shade400
                                : null,
                          ),
                        ),
                      ),
                      if (option.isCorrect == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Correct',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            if (question.options?.isEmpty != false)
              Text(
                'No options added',
                style: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              ),
          ],
        );

      case QuestionType.trueFalse:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...['True', 'False'].map((optionText) {
              final isCorrect = question.options?.any(
                (o) => o.optionText == optionText && o.isCorrect == true,
              ) ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: isCorrect ? Colors.green : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Text(optionText),
                    if (isCorrect) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Correct',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        );

      case QuestionType.shortAnswer:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Student answer field',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 8),
            if (question.correctAnswer?.isNotEmpty == true)
              Row(
                children: [
                  Icon(Icons.check, size: 16, color: Colors.green.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Expected: ${question.correctAnswer}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
          ],
        );

      case QuestionType.essay:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Student essay response area...',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.edit_note, size: 16, color: Colors.purple.shade700),
                const SizedBox(width: 4),
                Text(
                  'Requires manual grading',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  void _editQuestion(int index) {
    _showQuestionDialog(
      existingQuestion: _questions[index],
      index: index,
    );
  }

  void _duplicateQuestion(int index) {
    final original = _questions[index];
    final duplicate = original.copyWith(
      orderIndex: _questions.length + 1,
    );
    setState(() {
      _questions.add(duplicate);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question duplicated')),
    );
  }

  void _confirmDeleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _questions.removeAt(index);
                // Update order indices
                for (int i = 0; i < _questions.length; i++) {
                  _questions[i] = _questions[i].copyWith(orderIndex: i + 1);
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showQuestionPreviewDialog(QuizQuestionRequest question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(question.questionType.icon, color: _getQuestionTypeColor(question.questionType)),
            const SizedBox(width: 8),
            Text('Preview: ${question.questionType.displayName}'),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Question text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${question.points ?? 1} points',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.questionText.isEmpty
                            ? '(No question text)'
                            : question.questionText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Hint if available
                if (question.hint?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, size: 20, color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hint: ${question.hint}',
                            style: TextStyle(color: Colors.amber.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Student view
                Text(
                  'Student View:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPreviewContent(question),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showQuestionDialog({
    QuizQuestionRequest? existingQuestion,
    int? index,
    QuestionType? questionType,
  }) {
    final questionController = TextEditingController(
      text: existingQuestion?.questionText ?? '',
    );
    final pointsController = TextEditingController(
      text: existingQuestion?.points?.toString() ?? '1',
    );
    final explanationController = TextEditingController(
      text: existingQuestion?.explanation ?? '',
    );
    final hintController = TextEditingController(
      text: existingQuestion?.hint ?? '',
    );
    final correctAnswerController = TextEditingController(
      text: existingQuestion?.correctAnswer ?? '',
    );
    final sampleAnswerController = TextEditingController(
      text: existingQuestion?.sampleAnswer ?? '',
    );

    QuestionType selectedType = existingQuestion?.questionType ??
        questionType ??
        QuestionType.multipleChoice;

    // Initialize options based on question type
    List<QuestionOptionRequest> options = [];
    if (existingQuestion?.options != null) {
      options = List.from(existingQuestion!.options!);
    } else if (selectedType == QuestionType.trueFalse) {
      // Auto-create True/False options
      options = [
        QuestionOptionRequest(optionText: 'True', isCorrect: false, orderIndex: 1),
        QuestionOptionRequest(optionText: 'False', isCorrect: false, orderIndex: 2),
      ];
    }

    bool caseSensitive = false; // For short answer

    // Create text controllers for options (for multiple choice)
    final optionControllers = <TextEditingController>[];
    for (final option in options) {
      optionControllers.add(TextEditingController(text: option.optionText));
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Helper function to update option text
          void updateOptionText(int i, String value) {
            if (i < options.length) {
              options[i] = options[i].copyWith(optionText: value);
            }
          }

          // Helper function to add option
          void addOption() {
            setDialogState(() {
              options.add(QuestionOptionRequest(
                optionText: '',
                isCorrect: false,
                orderIndex: options.length + 1,
              ));
              optionControllers.add(TextEditingController());
            });
          }

          // Helper function to remove option
          void removeOption(int i) {
            setDialogState(() {
              options.removeAt(i);
              optionControllers[i].dispose();
              optionControllers.removeAt(i);
              // Update order indices
              for (int j = 0; j < options.length; j++) {
                options[j] = options[j].copyWith(orderIndex: j + 1);
              }
            });
          }

          // Helper function to toggle correct answer
          void toggleCorrect(int i, bool? value) {
            setDialogState(() {
              if (selectedType == QuestionType.multipleChoice) {
                // For MC, only one correct answer
                for (int j = 0; j < options.length; j++) {
                  options[j] = options[j].copyWith(isCorrect: j == i && value == true);
                }
              } else {
                // For T/F, toggle the selected one
                for (int j = 0; j < options.length; j++) {
                  options[j] = options[j].copyWith(isCorrect: j == i);
                }
              }
            });
          }

          return AlertDialog(
            title: Row(
              children: [
                Icon(selectedType.icon, color: _getQuestionTypeColor(selectedType)),
                const SizedBox(width: 8),
                Text(existingQuestion == null ? 'Add Question' : 'Edit Question'),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Type selector
                    DropdownButtonFormField<QuestionType>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Question Type',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(selectedType.icon),
                      ),
                      items: QuestionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(type.icon, size: 20, color: _getQuestionTypeColor(type)),
                              const SizedBox(width: 8),
                              Text(type.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                          // Reset options based on new type
                          if (selectedType == QuestionType.trueFalse) {
                            for (final c in optionControllers) {
                              c.dispose();
                            }
                            optionControllers.clear();
                            options = [
                              QuestionOptionRequest(optionText: 'True', isCorrect: false, orderIndex: 1),
                              QuestionOptionRequest(optionText: 'False', isCorrect: false, orderIndex: 2),
                            ];
                            for (final option in options) {
                              optionControllers.add(TextEditingController(text: option.optionText));
                            }
                          } else if (selectedType == QuestionType.multipleChoice) {
                            // Keep existing options or clear if from T/F
                            if (options.length == 2 &&
                                options[0].optionText == 'True' &&
                                options[1].optionText == 'False') {
                              for (final c in optionControllers) {
                                c.dispose();
                              }
                              optionControllers.clear();
                              options = [];
                            }
                          } else {
                            // Short answer or essay - clear options
                            for (final c in optionControllers) {
                              c.dispose();
                            }
                            optionControllers.clear();
                            options = [];
                          }
                        });
                      },
                    ),

                    // Type-specific info box
                    const SizedBox(height: 12),
                    _buildQuestionTypeInfoBox(selectedType),

                    const SizedBox(height: 16),

                    // Question text
                    TextFormField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        labelText: 'Question Text *',
                        hintText: 'Enter your question here...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Question text is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Points
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: pointsController,
                            decoration: const InputDecoration(
                              labelText: 'Points *',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.star),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final points = int.tryParse(value);
                              if (points == null || points <= 0) {
                                return 'Must be > 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: hintController,
                            decoration: const InputDecoration(
                              labelText: 'Hint (Optional)',
                              hintText: 'Help for students...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lightbulb_outline),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Type-specific fields
                    if (selectedType == QuestionType.multipleChoice) ...[
                      _buildMultipleChoiceSection(
                        options: options,
                        optionControllers: optionControllers,
                        onAddOption: addOption,
                        onRemoveOption: removeOption,
                        onToggleCorrect: toggleCorrect,
                        onUpdateText: updateOptionText,
                      ),
                    ] else if (selectedType == QuestionType.trueFalse) ...[
                      _buildTrueFalseSection(
                        options: options,
                        onToggleCorrect: toggleCorrect,
                      ),
                    ] else if (selectedType == QuestionType.shortAnswer) ...[
                      _buildShortAnswerSection(
                        correctAnswerController: correctAnswerController,
                        caseSensitive: caseSensitive,
                        onCaseSensitiveChanged: (value) {
                          setDialogState(() {
                            caseSensitive = value ?? false;
                          });
                        },
                        sampleAnswerController: sampleAnswerController,
                      ),
                    ] else if (selectedType == QuestionType.essay) ...[
                      _buildEssaySection(
                        sampleAnswerController: sampleAnswerController,
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Explanation
                    TextFormField(
                      controller: explanationController,
                      decoration: const InputDecoration(
                        labelText: 'Explanation (Optional)',
                        hintText: 'Explain the correct answer...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.school),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Dispose controllers
                  for (final c in optionControllers) {
                    c.dispose();
                  }
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Validate
                  if (questionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Question text is required')),
                    );
                    return;
                  }

                  final points = int.tryParse(pointsController.text) ?? 1;
                  if (points <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Points must be greater than 0')),
                    );
                    return;
                  }

                  // Type-specific validation
                  String? validationError;
                  switch (selectedType) {
                    case QuestionType.multipleChoice:
                      if (options.length < 2) {
                        validationError = 'At least 2 options are required';
                      } else if (options.where((o) => o.isCorrect == true).length != 1) {
                        validationError = 'Exactly one correct answer is required';
                      } else if (options.any((o) => o.optionText.trim().isEmpty)) {
                        validationError = 'All options must have text';
                      }
                      break;

                    case QuestionType.trueFalse:
                      if (options.where((o) => o.isCorrect == true).length != 1) {
                        validationError = 'Select the correct answer (True or False)';
                      }
                      break;

                    case QuestionType.shortAnswer:
                      if (correctAnswerController.text.trim().isEmpty) {
                        validationError = 'Correct answer is required for auto-grading';
                      }
                      break;

                    case QuestionType.essay:
                      // No validation needed - manual grading
                      break;
                  }

                  if (validationError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(validationError)),
                    );
                    return;
                  }

                  // Build the question
                  List<QuestionOptionRequest>? finalOptions;
                  if (selectedType == QuestionType.multipleChoice ||
                      selectedType == QuestionType.trueFalse) {
                    finalOptions = options;
                  }

                  final newQuestion = QuizQuestionRequest(
                    questionText: questionController.text.trim(),
                    questionType: selectedType,
                    points: points,
                    orderIndex: index ?? _questions.length + 1,
                    options: finalOptions,
                    correctAnswer: selectedType == QuestionType.shortAnswer
                        ? correctAnswerController.text.trim()
                        : null,
                    sampleAnswer: (selectedType == QuestionType.shortAnswer ||
                            selectedType == QuestionType.essay) &&
                            sampleAnswerController.text.trim().isNotEmpty
                        ? sampleAnswerController.text.trim()
                        : null,
                    explanation: explanationController.text.trim().isEmpty
                        ? null
                        : explanationController.text.trim(),
                    hint: hintController.text.trim().isEmpty
                        ? null
                        : hintController.text.trim(),
                  );

                  setState(() {
                    if (index != null) {
                      _questions[index] = newQuestion;
                    } else {
                      _questions.add(newQuestion);
                    }
                  });

                  // Dispose controllers
                  for (final c in optionControllers) {
                    c.dispose();
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: Text(existingQuestion == null ? 'Add Question' : 'Update Question'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionTypeInfoBox(QuestionType type) {
    String title;
    String description;
    IconData icon;
    Color color;

    switch (type) {
      case QuestionType.multipleChoice:
        title = 'Multiple Choice';
        description = 'Students select one correct answer from several options. Auto-graded.';
        icon = Icons.radio_button_checked;
        color = Colors.blue;
        break;
      case QuestionType.trueFalse:
        title = 'True/False';
        description = 'Students choose between True or False. Auto-graded.';
        icon = Icons.check_box_outlined;
        color = Colors.green;
        break;
      case QuestionType.shortAnswer:
        title = 'Short Answer';
        description = 'Students type a brief response. Auto-graded based on expected answer.';
        icon = Icons.short_text;
        color = Colors.orange;
        break;
      case QuestionType.essay:
        title = 'Essay';
        description = 'Students write a detailed response. Requires manual grading.';
        icon = Icons.notes;
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceSection({
    required List<QuestionOptionRequest> options,
    required List<TextEditingController> optionControllers,
    required VoidCallback onAddOption,
    required Function(int) onRemoveOption,
    required Function(int, bool?) onToggleCorrect,
    required Function(int, String) onUpdateText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Answer Options',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Text(
                  '(Select one as correct)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: onAddOption,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Option'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (options.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Add at least 2 options',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ...options.asMap().entries.map((entry) {
            final i = entry.key;
            final option = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: option.isCorrect == true ? true : null,
                      onChanged: (value) => onToggleCorrect(i, value),
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionControllers[i],
                        decoration: InputDecoration(
                          hintText: 'Option ${i + 1}',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onChanged: (value) => onUpdateText(i, value),
                      ),
                    ),
                    if (option.isCorrect == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Correct',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400, size: 20),
                      onPressed: () => onRemoveOption(i),
                    ),
                  ],
                ),
              ),
            );
          }),

        // Validation message
        if (options.length < 2)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'At least 2 options required',
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        if (options.length >= 2 && options.where((o) => o.isCorrect == true).isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Select one option as the correct answer',
              style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTrueFalseSection({
    required List<QuestionOptionRequest> options,
    required Function(int, bool?) onToggleCorrect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select the Correct Answer',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTrueFalseOption(
                label: 'True',
                isSelected: options.isNotEmpty && options[0].isCorrect == true,
                onTap: () => onToggleCorrect(0, true),
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTrueFalseOption(
                label: 'False',
                isSelected: options.length > 1 && options[1].isCorrect == true,
                onTap: () => onToggleCorrect(1, true),
                color: Colors.red,
              ),
            ),
          ],
        ),
        if (options.where((o) => o.isCorrect == true).isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Please select the correct answer',
              style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTrueFalseOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha:0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? color : Colors.grey.shade400,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                'Correct Answer',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShortAnswerSection({
    required TextEditingController correctAnswerController,
    required bool caseSensitive,
    required ValueChanged<bool?> onCaseSensitiveChanged,
    required TextEditingController sampleAnswerController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_fix_high, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This question will be auto-graded based on the correct answer',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: correctAnswerController,
          decoration: const InputDecoration(
            labelText: 'Correct Answer *',
            hintText: 'Enter the expected answer for grading',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.check),
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Case Sensitive'),
          subtitle: Text(
            'If checked, student answer must match exact capitalization',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          value: caseSensitive,
          onChanged: onCaseSensitiveChanged,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: sampleAnswerController,
          decoration: InputDecoration(
            labelText: 'Sample Answer (Instructor Reference)',
            hintText: 'Optional: Detailed answer for grading reference',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.school),
            helperText: 'This is only visible to instructors',
            helperStyle: TextStyle(color: Colors.grey.shade600),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildEssaySection({
    required TextEditingController sampleAnswerController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.edit_note, color: Colors.purple.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This question requires manual grading by the instructor',
                  style: TextStyle(fontSize: 12, color: Colors.purple.shade700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: sampleAnswerController,
          decoration: InputDecoration(
            labelText: 'Sample Answer (Instructor Reference)',
            hintText: 'Provide an ideal answer for grading reference...',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.school),
            alignLabelWithHint: true,
            helperText: 'This is only visible to instructors',
            helperStyle: TextStyle(color: Colors.grey.shade600),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        Text(
          'Grading Tips:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        ...['Consider using a rubric for consistent grading',
           'Look for key concepts and supporting evidence',
           'Provide constructive feedback to students'].map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _saveContent,
          icon: const Icon(Icons.save),
          label: const Text('Save Quiz Content'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      // Validate questions exist
      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please add at least one question'),
            backgroundColor: Colors.red.shade400,
          ),
        );
        return;
      }

      // Validate all questions are valid
      final invalidQuestions = _questions.asMap().entries
          .where((e) => !_isQuestionValid(e.value))
          .toList();

      if (invalidQuestions.isNotEmpty) {
        final messages = invalidQuestions.map((e) {
          return 'Q${e.key + 1}: ${_getQuestionValidationMessage(e.value)}';
        }).join('\n');

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text('Validation Errors'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please fix the following issues:'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    messages,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final request = QuizContentRequest(
        instructions: _instructionsController.text.isEmpty
            ? null
            : _instructionsController.text,
        timeLimitMinutes: _timeLimitController.text.isEmpty
            ? null
            : int.parse(_timeLimitController.text),
        passingScore: double.parse(_passingScoreController.text),
        maxAttempts: _maxAttempts,
        shuffleQuestions: _shuffleQuestions,
        showCorrectAnswers: _showCorrectAnswers,
        showFeedback: _showFeedbackImmediately,
        questions: _questions,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
