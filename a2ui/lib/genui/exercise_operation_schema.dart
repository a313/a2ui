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
    'finishButtonLabel': S.string(
      description:
          'The label for the finish/submit button. Named "Bài tiếp theo" if this is not the last question, "Hoàn thành" if its the last question.',
    ),
    'finishAction': A2uiSchemas.action(
      description: 'The action to perform when the finish button is tapped.',
    ),
    'questions': S.list(
      description: 'Array of operation questions',
      items: S.object(
        properties: {
          'firstNumber': S.integer(
            description: 'The first number in the operation',
          ),
          'secondNumber': S.integer(
            description: 'The second number in the operation',
          ),
          'operation': S.string(
            description:
                'The math operation: + (add), - (subtract), × (multiply), ÷ (divide)',
            enumValues: ['+', '-', '×', '÷'],
          ),
          'userAnswer': A2uiSchemas.numberReference(
            description: 'The user answer (result)',
          ),
        },
        required: ['firstNumber', 'secondNumber', 'operation', 'userAnswer'],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions', 'finishAction'],
);

/// CatalogItem cho ExerciseOperationWidget
final exerciseOperationWidgetCatalogItem = CatalogItem(
  name: 'ExerciseOperationWidget',
  dataSchema: _schema,
  widgetBuilder: (context) {
    final exerciseData = _ExerciseOperationData.fromMap(
      context.data as Map<String, Object?>,
    );

    final title = exerciseData.title;
    final finishButtonLabel = exerciseData.finishButtonLabel;
    final finishAction = exerciseData.finishAction;
    final actionName = finishAction?['name'] as String?;
    final List<Object?> contextDefinition =
        (finishAction?['context'] as List<Object?>?) ?? <Object?>[];

    // Parse questions array
    final List<OperationWidget> questions = [];
    for (final entry in exerciseData.questions.asMap().entries) {
      final questionData = _QuestionData.fromMap(entry.value);

      final firstNumber = questionData.firstNumber;
      final secondNumber = questionData.secondNumber;
      final operation = questionData.operation;
      final userAnswer = questionData.userAnswer;
      final userAnswerRef = questionData.userAnswerRef;

      if (firstNumber != null && secondNumber != null && operation != null) {
        questions.add(
          OperationWidget(
            firstNumber: firstNumber,
            secondNumber: secondNumber,
            operation: operation,
            userAnswer: userAnswer,
            onChanged: (value) {
              final pathStr = userAnswerRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                context.dataContext.update(path, value);
              }
            },
          ),
        );
      }
    }

    if (title == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExerciseWidget<OperationWidget>(
      title: title,
      questions: questions,
      finishButtonLabel: finishButtonLabel,
      onFinish: actionName != null
          ? () {
              final resolvedContext = resolveContext(
                context.dataContext,
                contextDefinition,
              );
              context.dispatchEvent(
                UserActionEvent(
                  name: actionName,
                  sourceComponentId: context.id,
                  context: resolvedContext,
                ),
              );
            }
          : null,
    );
  },
);

extension type _ExerciseOperationData.fromMap(Map<String, Object?> _json) {
  String? get title {
    final value = _json['title'];
    if (value is String) return value;
    if (value is Map<String, Object?>) {
      return value['literalString'] as String?;
    }
    return null;
  }

  String? get finishButtonLabel {
    final value = _json['finishButtonLabel'];
    if (value is String) return value;
    if (value is Map<String, Object?>) {
      return value['literalString'] as String?;
    }
    return null;
  }

  JsonMap? get finishAction => _json['finishAction'] as JsonMap?;

  List<Map<String, Object?>> get questions {
    final value = _json['questions'];
    if (value is List) {
      return value.cast<Map<String, Object?>>();
    }
    return [];
  }
}

extension type _QuestionData.fromMap(Map<String, Object?> _json) {
  int? get firstNumber {
    final value = _json['firstNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalStr = value['literalString'] as String?;
      return literalStr != null ? int.tryParse(literalStr) : null;
    }
    return null;
  }

  int? get secondNumber {
    final value = _json['secondNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalStr = value['literalString'] as String?;
      return literalStr != null ? int.tryParse(literalStr) : null;
    }
    return null;
  }

  MathOperation? get operation {
    final value = _json['operation'];
    String? operationStr;
    if (value is String) {
      operationStr = value;
    } else if (value is Map<String, Object?>) {
      operationStr = value['literalString'] as String?;
    }
    return _parseMathOperation(operationStr);
  }

  JsonMap? get userAnswerRef => _json['userAnswer'] as JsonMap?;

  int? get userAnswer {
    final value = _json['userAnswer'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalNum = value['literalNumber'];
      if (literalNum is int) return literalNum;
      if (literalNum is num) return literalNum.toInt();
    }
    return null;
  }
}
