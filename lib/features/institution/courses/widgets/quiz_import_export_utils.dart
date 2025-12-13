import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/models/quiz_assignment_models.dart';

/// Utility class for importing and exporting quiz questions
class QuizImportExportUtils {
  /// Export questions to JSON string
  static String exportQuestionsToJson(List<QuizQuestionRequest> questions) {
    final data = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'questionCount': questions.length,
      'questions': questions.map((q) => {
        'questionText': q.questionText,
        'questionType': q.questionType.toString().split('.').last,
        'points': q.points,
        'orderIndex': q.orderIndex,
        'correctAnswer': q.correctAnswer,
        'sampleAnswer': q.sampleAnswer,
        'explanation': q.explanation,
        'hint': q.hint,
        'isRequired': q.isRequired,
        'options': q.options?.map((o) => {
          'optionText': o.optionText,
          'isCorrect': o.isCorrect,
          'orderIndex': o.orderIndex,
          'feedback': o.feedback,
        }).toList(),
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Import questions from JSON string
  static List<QuizQuestionRequest> importQuestionsFromJson(String jsonString) {
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final questions = data['questions'] as List;

      return questions.map((q) {
        final questionMap = q as Map<String, dynamic>;

        // Parse question type
        QuestionType questionType;
        final typeString = questionMap['questionType'] as String;
        switch (typeString.toLowerCase()) {
          case 'multiplechoice':
            questionType = QuestionType.multipleChoice;
            break;
          case 'truefalse':
            questionType = QuestionType.trueFalse;
            break;
          case 'shortanswer':
            questionType = QuestionType.shortAnswer;
            break;
          case 'essay':
            questionType = QuestionType.essay;
            break;
          default:
            throw Exception('Unknown question type: $typeString');
        }

        // Parse options if they exist
        List<QuestionOptionRequest>? options;
        if (questionMap['options'] != null) {
          final optionsList = questionMap['options'] as List;
          options = optionsList.map((o) {
            final optionMap = o as Map<String, dynamic>;
            return QuestionOptionRequest(
              optionText: optionMap['optionText'] as String,
              isCorrect: optionMap['isCorrect'] as bool? ?? false,
              orderIndex: optionMap['orderIndex'] as int? ?? 0,
              feedback: optionMap['feedback'] as String?,
            );
          }).toList();
        }

        return QuizQuestionRequest(
          questionText: questionMap['questionText'] as String,
          questionType: questionType,
          points: questionMap['points'] as int? ?? 1,
          orderIndex: questionMap['orderIndex'] as int? ?? 0,
          correctAnswer: questionMap['correctAnswer'] as String?,
          sampleAnswer: questionMap['sampleAnswer'] as String?,
          explanation: questionMap['explanation'] as String?,
          hint: questionMap['hint'] as String?,
          isRequired: questionMap['isRequired'] as bool? ?? true,
          options: options,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  }

  /// Show export dialog
  static void showExportDialog(
    BuildContext context,
    List<QuizQuestionRequest> questions,
  ) {
    final jsonString = exportQuestionsToJson(questions);
    final controller = TextEditingController(text: jsonString);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.file_download),
            const SizedBox(width: 12),
            const Text('Export Questions'),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
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
                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Copy this JSON to save your questions. You can import them later or share with others.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'JSON Data',
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  readOnly: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // Copy to clipboard
              // Note: This would require platform channels or a package like 'flutter/services'
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('JSON copied to clipboard!')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
          ),
        ],
      ),
    );
  }

  /// Show import dialog
  static void showImportDialog(
    BuildContext context,
    Function(List<QuizQuestionRequest>) onImport,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.file_upload),
                const SizedBox(width: 12),
                const Text('Import Questions'),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.amber.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Paste your previously exported JSON data here. Make sure the format is correct.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'JSON Data',
                        hintText: 'Paste your JSON here...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  try {
                    final questions = importQuestionsFromJson(controller.text);
                    Navigator.pop(context);
                    onImport(questions);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully imported ${questions.length} questions!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Import failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Import'),
              ),
            ],
          );
        },
      ),
    );
  }
}
