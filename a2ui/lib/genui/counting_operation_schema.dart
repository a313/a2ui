import 'package:a2ui/widgets/maths/counting_operation_widget.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:a2ui/widgets/shared/exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Helper to parse operation string to MathOperation
MathOperation? _parseMathOperation(String? value) {
  if (value == null) return null;
  switch (value.toLowerCase()) {
    case '+':
    case 'add':
      return MathOperation.add;
    case '-':
    case 'subtract':
      return MathOperation.subtract;
    default:
      return null;
  }
}

final _schema = S.object(
  title: 'ExerciseCountingOperationWidget',
  description:
      'A widget for displaying counting operation questions with symbols. Each question shows two groups of symbols and asks the user to fill in the operation equation. Only supports addition (+) and subtraction (-).',
  properties: {
    'title': S.string(description: 'The title of the exercise', minLength: 1),
    'questions': S.list(
      description: 'Array of counting operation questions',
      items: S.object(
        properties: {
          'firstNumber': S.integer(
            description: 'The count of first group symbols',
            minimum: 1,
            maximum: 20,
          ),
          'firstSymbol': S.string(
            description: 'The emoji/symbol for the first group (e.g., 🍎, ⭐)',
            minLength: 1,
          ),
          'operation': S.string(
            description: 'The math operation: + (add) or - (subtract)',
            enumValues: ['+', '-'],
          ),
          'secondNumber': S.integer(
            description: 'The count of second group symbols',
            minimum: 1,
            maximum: 20,
          ),
          'secondSymbol': S.string(
            description: 'The emoji/symbol for the second group (e.g., 🍎, ⭐)',
            minLength: 1,
          ),
          'userFirstNumber': S.integer(
            description: 'User answer for the first number',
          ),
          'userOperation': S.string(
            description: 'User answer for the operation',
          ),
          'userSecondNumber': S.integer(
            description: 'User answer for the second number',
          ),
          'userResult': S.integer(description: 'User answer for the result'),
        },
        required: [
          'firstNumber',
          'firstSymbol',
          'operation',
          'secondNumber',
          'secondSymbol',
        ],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions'],
);

/// CatalogItem cho ExerciseCountingOperationWidget
final exerciseCountingOperationWidgetCatalogItem = CatalogItem(
  name: 'ExerciseCountingOperationWidget',
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": {
            "ExerciseCountingOperationWidget": {
              "title": "Đếm và tính",
              "questions": [
                {"firstNumber": 5, "firstSymbol": "🍎", "operation": "+", "secondNumber": 3, "secondSymbol": "🍎"},
                {"firstNumber": 8, "firstSymbol": "⭐", "operation": "-", "secondNumber": 2, "secondSymbol": "⭐"}
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
            "ExerciseCountingOperationWidget": {
              "title": "Bài tập đếm số",
              "questions": [
                {"firstNumber": 4, "firstSymbol": "🐱", "operation": "+", "secondNumber": 3, "secondSymbol": "🐱", "userFirstNumber": 4, "userOperation": "+", "userSecondNumber": 3, "userResult": 7},
                {"firstNumber": 6, "firstSymbol": "🌸", "operation": "-", "secondNumber": 2, "secondSymbol": "🌸", "userFirstNumber": 6, "userOperation": "-", "userSecondNumber": 2, "userResult": 4}
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
    List<CountingOperationWidget> questions = [];

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

          // Parse firstSymbol
          final firstSymbolValue = questionData['firstSymbol'];
          String? firstSymbol;
          if (firstSymbolValue is String) {
            firstSymbol = firstSymbolValue;
          } else if (firstSymbolValue is Map<String, Object?>) {
            firstSymbol = firstSymbolValue['literalString'] as String?;
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

          // Parse secondNumber
          final secondNumberValue = questionData['secondNumber'];
          int? secondNumber;
          if (secondNumberValue is int) {
            secondNumber = secondNumberValue;
          } else if (secondNumberValue is Map<String, Object?>) {
            final literalStr = secondNumberValue['literalString'] as String?;
            secondNumber = literalStr != null ? int.tryParse(literalStr) : null;
          }

          // Parse secondSymbol
          final secondSymbolValue = questionData['secondSymbol'];
          String? secondSymbol;
          if (secondSymbolValue is String) {
            secondSymbol = secondSymbolValue;
          } else if (secondSymbolValue is Map<String, Object?>) {
            secondSymbol = secondSymbolValue['literalString'] as String?;
          }

          // Parse user answers
          final userFirstNumberValue = questionData['userFirstNumber'];
          int? userFirstNumber;
          if (userFirstNumberValue is int) {
            userFirstNumber = userFirstNumberValue;
          } else if (userFirstNumberValue is Map<String, Object?>) {
            final literalStr = userFirstNumberValue['literalString'] as String?;
            userFirstNumber = literalStr != null
                ? int.tryParse(literalStr)
                : null;
          }

          final userOperationValue = questionData['userOperation'];
          String? userOperationStr;
          if (userOperationValue is String) {
            userOperationStr = userOperationValue;
          } else if (userOperationValue is Map<String, Object?>) {
            userOperationStr = userOperationValue['literalString'] as String?;
          }
          final userOperation = _parseMathOperation(userOperationStr);

          final userSecondNumberValue = questionData['userSecondNumber'];
          int? userSecondNumber;
          if (userSecondNumberValue is int) {
            userSecondNumber = userSecondNumberValue;
          } else if (userSecondNumberValue is Map<String, Object?>) {
            final literalStr =
                userSecondNumberValue['literalString'] as String?;
            userSecondNumber = literalStr != null
                ? int.tryParse(literalStr)
                : null;
          }

          final userResultValue = questionData['userResult'];
          int? userResult;
          if (userResultValue is int) {
            userResult = userResultValue;
          } else if (userResultValue is Map<String, Object?>) {
            final literalStr = userResultValue['literalString'] as String?;
            userResult = literalStr != null ? int.tryParse(literalStr) : null;
          }

          if (firstNumber != null &&
              firstSymbol != null &&
              operation != null &&
              secondNumber != null &&
              secondSymbol != null) {
            questions.add(
              CountingOperationWidget(
                firstNumber: firstNumber,
                firstSymbol: firstSymbol,
                operation: operation,
                secondNumber: secondNumber,
                secondSymbol: secondSymbol,
                userFirstNumber: userFirstNumber,
                userOperation: userOperation,
                userSecondNumber: userSecondNumber,
                userResult: userResult,
                onChangedFirstNumber: (value) {
                  final path = DataPath(
                    '/questions/$questionIndex/userFirstNumber',
                  );
                  context.dataContext.update(path, value);
                },
                onChangedOperation: (value) {
                  final path = DataPath(
                    '/questions/$questionIndex/userOperation',
                  );
                  context.dataContext.update(path, value?.symbol);
                },
                onChangedSecondAnswer: (value) {
                  final path = DataPath(
                    '/questions/$questionIndex/userSecondNumber',
                  );
                  context.dataContext.update(path, value);
                },
                onChangedResultNumber: (value) {
                  final path = DataPath('/questions/$questionIndex/userResult');
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

    return ExerciseWidget<CountingOperationWidget>(
      title: title,
      questions: questions,
    );
  },
);
