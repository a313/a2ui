import 'package:a2ui/widgets/maths/exercise_comparison_widget.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Schema định nghĩa cho ExerciseComparisonWidget
final exerciseComparisonWidgetSchema = S.object(
  title: 'ExerciseComparisonWidget',
  description:
      'A widget for displaying a set of comparison questions with a title. Each question compares two numbers with operators (<, >, =)',
  properties: {
    'title': S.string(description: 'The title of the exercise', minLength: 1),
    'questions': S.list(
      description: 'Array of comparison questions',
      items: S.object(
        properties: {
          'firstNumber': S.integer(
            description: 'The first number to compare',
            minimum: 0,
            maximum: 100,
          ),
          'secondNumber': S.integer(
            description: 'The second number to compare',
            minimum: 0,
            maximum: 100,
          ),
          'showAnswer': S.boolean(
            description: 'Whether to show the correct answer for this question',
          ),
        },
        required: ['firstNumber', 'secondNumber'],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions'],
);

/// CatalogItem cho ExerciseComparisonWidget
final exerciseComparisonWidgetCatalogItem = CatalogItem(
  name: 'ExerciseComparisonWidget',
  dataSchema: exerciseComparisonWidgetSchema,
  widgetBuilder: (context) {
    final data = context.data as Map<String, Object?>?;

    // Parse title
    final titleValue = data?['title'];
    String? title;
    if (titleValue is String) {
      title = titleValue;
    } else if (titleValue is Map<String, Object?>) {
      title = titleValue['literalString'] as String?;
    }

    // Parse questions array
    final questionsValue = data?['questions'];
    List<ComparisonQuestion> questions = [];

    if (questionsValue is List) {
      for (final questionData in questionsValue) {
        if (questionData is Map<String, Object?>) {
          // Parse firstNumber
          final firstNumberValue = questionData['firstNumber'];
          int? firstNumber;
          if (firstNumberValue is int) {
            firstNumber = firstNumberValue;
          } else if (firstNumberValue is Map<String, Object?>) {
            final literalStr = firstNumberValue['literalString'] as String?;
            firstNumber = literalStr != null ? int.tryParse(literalStr) : null;
          }

          // Parse secondNumber
          final secondNumberValue = questionData['secondNumber'];
          int? secondNumber;
          if (secondNumberValue is int) {
            secondNumber = secondNumberValue;
          } else if (secondNumberValue is Map<String, Object?>) {
            final literalStr = secondNumberValue['literalString'] as String?;
            secondNumber = literalStr != null ? int.tryParse(literalStr) : null;
          }

          // Parse showAnswer
          final showAnswerValue = questionData['showAnswer'];
          bool showAnswer = false;
          if (showAnswerValue is bool) {
            showAnswer = showAnswerValue;
          } else if (showAnswerValue is Map<String, Object?>) {
            final literalStr = showAnswerValue['literalString'] as String?;
            showAnswer = literalStr == 'true';
          }

          if (firstNumber != null && secondNumber != null) {
            questions.add(
              ComparisonQuestion(
                firstNumber: firstNumber,
                secondNumber: secondNumber,
                showAnswer: showAnswer,
              ),
            );
          }
        }
      }
    }

    if (title == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExerciseComparisonWidget(title: title, questions: questions);
  },
);
