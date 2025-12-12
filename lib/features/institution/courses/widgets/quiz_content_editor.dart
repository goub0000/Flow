import 'package:flutter/material.dart';
import '../../../../core/models/quiz_assignment_models.dart';

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
  final List<QuizQuestionRequest> _questions = [];
  int? _maxAttempts;
  bool _shuffleQuestions = false;
  bool _showCorrectAnswers = true;

  @override
  void initState() {
    super.initState();
    _timeLimitController = TextEditingController(
      text: widget.initialContent?.timeLimit?.toString() ?? '',
    );
    _passingScoreController = TextEditingController(
      text: widget.initialContent?.passingScore.toString() ?? '70',
    );
    _maxAttempts = widget.initialContent?.maxAttempts;
    _shuffleQuestions = widget.initialContent?.shuffleQuestions ?? false;
    _showCorrectAnswers = widget.initialContent?.showCorrectAnswers ?? true;
  }

  @override
  void dispose() {
    _timeLimitController.dispose();
    _passingScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Content',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildQuizSettings(),
          const SizedBox(height: 24),
          _buildQuestionsSection(),
          const SizedBox(height: 24),
          Row(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
                ...List.generate(5, (i) => i + 1).map((count) {
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
            SwitchListTile(
              title: const Text('Shuffle Questions'),
              subtitle: const Text('Randomize question order for each attempt'),
              value: _shuffleQuestions,
              onChanged: (value) {
                setState(() {
                  _shuffleQuestions = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Show Correct Answers'),
              subtitle: const Text('Show correct answers after submission'),
              value: _showCorrectAnswers,
              onChanged: (value) {
                setState(() {
                  _showCorrectAnswers = value;
                });
              },
            ),
          ],
        ),
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
            const Text(
              'Questions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addQuestion,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Question'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_questions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.quiz, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'No questions added yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(_questions.length, (index) {
            return _buildQuestionCard(index);
          }),
      ],
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text('Q${index + 1}'),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editQuestion(index);
                    } else if (value == 'delete') {
                      setState(() {
                        _questions.removeAt(index);
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(question.type.displayName),
              avatar: Icon(question.type.icon, size: 16),
            ),
            const SizedBox(height: 8),
            Text('Points: ${question.points}'),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    _showQuestionDialog();
  }

  void _editQuestion(int index) {
    _showQuestionDialog(existingQuestion: _questions[index], index: index);
  }

  void _showQuestionDialog({QuizQuestionRequest? existingQuestion, int? index}) {
    final questionController = TextEditingController(
      text: existingQuestion?.questionText ?? '',
    );
    final pointsController = TextEditingController(
      text: existingQuestion?.points.toString() ?? '1',
    );
    final explanationController = TextEditingController(
      text: existingQuestion?.explanation ?? '',
    );
    QuestionType selectedType = existingQuestion?.type ?? QuestionType.multipleChoice;
    final options = List<QuestionOptionRequest>.from(existingQuestion?.options ?? []);
    final correctAnswer = existingQuestion?.correctAnswer;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existingQuestion == null ? 'Add Question' : 'Edit Question'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<QuestionType>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Question Type',
                      border: OutlineInputBorder(),
                    ),
                    items: QuestionType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(type.icon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(type.displayName),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value!;
                        options.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(
                      labelText: 'Question Text',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: pointsController,
                    decoration: const InputDecoration(
                      labelText: 'Points',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  if (selectedType == QuestionType.multipleChoice) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Options:'),
                        TextButton.icon(
                          onPressed: () {
                            setDialogState(() {
                              options.add(QuestionOptionRequest(
                                optionText: '',
                                isCorrect: false,
                                orderIndex: options.length + 1,
                              ));
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Option'),
                        ),
                      ],
                    ),
                    ...List.generate(options.length, (i) {
                      return Card(
                        child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                              hintText: 'Option ${i + 1}',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              options[i] = options[i].copyWith(optionText: value);
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: options[i].isCorrect,
                                onChanged: (value) {
                                  setDialogState(() {
                                    options[i] = options[i].copyWith(isCorrect: value ?? false);
                                  });
                                },
                              ),
                              const Text('Correct'),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setDialogState(() {
                                    options.removeAt(i);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: explanationController,
                    decoration: const InputDecoration(
                      labelText: 'Explanation (Optional)',
                      hintText: 'Explain the correct answer...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (questionController.text.isNotEmpty) {
                  final newQuestion = QuizQuestionRequest(
                    questionText: questionController.text,
                    type: selectedType,
                    points: int.tryParse(pointsController.text) ?? 1,
                    orderIndex: index ?? _questions.length + 1,
                    options: selectedType == QuestionType.multipleChoice ? options : null,
                    correctAnswer: correctAnswer,
                    explanation: explanationController.text.isEmpty
                        ? null
                        : explanationController.text,
                  );

                  setState(() {
                    if (index != null) {
                      _questions[index] = newQuestion;
                    } else {
                      _questions.add(newQuestion);
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(existingQuestion == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one question')),
        );
        return;
      }

      final request = QuizContentRequest(
        timeLimit: _timeLimitController.text.isEmpty
            ? null
            : int.parse(_timeLimitController.text),
        passingScore: int.parse(_passingScoreController.text),
        maxAttempts: _maxAttempts,
        shuffleQuestions: _shuffleQuestions,
        showCorrectAnswers: _showCorrectAnswers,
        questions: _questions,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
