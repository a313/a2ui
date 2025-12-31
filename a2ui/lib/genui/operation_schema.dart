import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:a2ui/widgets/shared/exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Helper to parse userAnswer string to MathOperation
MathOperation? _parseMathOperation(String? value) {
  if (value == null) return null;
  switch (value.toLowerCase()) {
    case '+':
    case 'add':
      return MathOperation.add;
    case '-':
    case 'subtract':
      return MathOperation.subtract;
    case '×':
    case 'x':
    case '*':
    case 'multiply':
      return MathOperation.multiply;
    case '÷':
    case '/':
    case 'divide':
      return MathOperation.divide;
    default:
      return null;
  }
}

final _schema = S.object(
  title: 'ExerciseOperationWidget',
  description:
      'A widget for displaying a set of math operation questions with a title. Each question has two numbers and an operation (+, -, ×, ÷) where the user needs to find the result.',
  properties: {
    'title': S.string(description: 'The title of the exercise', minLength: 1),
    'questions': S.list(
      description: 'Array of operation questions',
      items: S.object(
        properties: {
          'firstNumber': S.integer(
            description: 'The first number in the operation',
            minimum: 0,
            maximum: 100,
          ),
          'secondNumber': S.integer(
            description: 'The second number in the operation',
            minimum: 0,
            maximum: 100,
          ),
          'operation': S.string(
            description:
                'The math operation: + (add), - (subtract), × (multiply), ÷ (divide)',
            enumValues: ['+', '-', '×', '÷'],
          ),
          'userAnswer': S.integer(description: 'The user answer (result)'),
        },
        required: ['firstNumber', 'secondNumber', 'operation'],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions'],
);

/// CatalogItem cho ExerciseOperationWidget
final exerciseOperationWidgetCatalogItem = CatalogItem(
  name: 'ExerciseOperationWidget',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ExerciseOperationWidget": {
              "title": "Phép tính cơ bản",
              "questions": [
                {"firstNumber": 5, "secondNumber": 3, "operation": "+"},
                {"firstNumber": 10, "secondNumber": 4, "operation": "-"},
                {"firstNumber": 6, "secondNumber": 2, "operation": "×"}
              ]
            }
          }
        }
      ]
    ''',
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ExerciseOperationWidget": {
              "title": "Bài tập phép tính",
              "questions": [
                {"firstNumber": 8, "secondNumber": 2, "operation": "+", "userAnswer": 10},
                {"firstNumber": 15, "secondNumber": 7, "operation": "-", "userAnswer": 8},
                {"firstNumber": 4, "secondNumber": 5, "operation": "×", "userAnswer": 20}
              ]
            }
          }
        }
      ]
    ''',
  ],
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
    List<OperationWidget> questions = [];

    if (questionsValue is List) {
      for (final entry in questionsValue.asMap().entries) {
        final questionIndex = entry.key;
        final questionData = entry.value;
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

          // Parse operation
          final operationValue = questionData['operation'];
          String? operationStr;
          if (operationValue is String) {
            operationStr = operationValue;
          } else if (operationValue is Map<String, Object?>) {
            operationStr = operationValue['literalString'] as String?;
          }
          final operation = _parseMathOperation(operationStr);

          // Parse userAnswer
          final userAnswerValue = questionData['userAnswer'];
          int? userAnswer;
          if (userAnswerValue is int) {
            userAnswer = userAnswerValue;
          } else if (userAnswerValue is Map<String, Object?>) {
            final literalStr = userAnswerValue['literalString'] as String?;
            userAnswer = literalStr != null ? int.tryParse(literalStr) : null;
          }

          if (firstNumber != null &&
              secondNumber != null &&
              operation != null) {
            questions.add(
              OperationWidget(
                firstNumber: firstNumber,
                secondNumber: secondNumber,
                operation: operation,
                userAnswer: userAnswer,
                onChanged: (value) {
                  // Update userAnswer in dataContext
                  final path = DataPath('/questions/$questionIndex/userAnswer');
                  context.dataContext.update(path, value);
                },
              ),
            );
          }
        }
      }
    }

    if (title == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExerciseWidget<OperationWidget>(title: title, questions: questions);
  },
);
