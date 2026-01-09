import 'package:a2ui/genui/data_context_helper.dart';
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
      'A widget for counting and math operations. '
      'Shows visual symbols (emojis) in groups that students count, then asks them to fill in the complete math equation: [count1] [+/-] [count2] = [result]. '
      'The first group shows symbols normally, the second group shows them crossed out (for subtraction) or normally (for addition). '
      'Only supports addition (+) and subtraction (-) operations.',
  properties: {
    'title': S.string(description: 'The title of the exercise', minLength: 1),
    'finishButtonLabel': S.string(
      description:
          'The label for the finish/submit button. Named "Next Exercise" if this is not the last question, "Finish" if its the last question.',
    ),
    'finishAction': A2uiSchemas.action(
      description: 'The action to perform when the finish button is tapped.',
    ),
    'questions': S.list(
      description:
          'Array of counting operation questions. Each question displays two groups of symbols/emojis for students to count and then complete the math equation.'
          'The question is correct when all of the validation is correct '
          '- userFirstNumber equal firstNumber'
          '- userSecondNumber equal secondNumber'
          '- userOperation equal operation'
          '- userResult equal with the result of (firstNumber operation secondNumber)',
      items: S.object(
        properties: {
          'firstNumber': S.integer(
            description:
                'The count of symbols in the first group (displayed in blue box)',
            minimum: 1,
            maximum: 20,
          ),
          'firstSymbol': S.string(
            description:
                'The emoji/symbol for the first group (e.g., 🍎, ⭐, 🐱, 🌸). This symbol will be repeated firstNumber times.',
            minLength: 1,
          ),
          'operation': S.string(
            description:
                'The math operation between the two groups: + (add) or - (subtract)',
            enumValues: ['+', '-'],
          ),
          'secondNumber': S.integer(
            description:
                'The count of symbols in the second group (displayed in green box for addition, red box with strikethrough for subtraction)',
            minimum: 1,
            maximum: 20,
          ),
          'secondSymbol': S.string(
            description:
                'The emoji/symbol for the second group (e.g., 🍎, ⭐, 🐱, 🌸). This symbol will be repeated secondNumber times.',
            minLength: 1,
          ),
          'userFirstNumber': A2uiSchemas.numberReference(
            description: r"The user\'s answer for counting the first group",
          ),
          'userOperation': A2uiSchemas.stringReference(
            description: r"The user\'s answer for the operation (+/-)",
            enumValues: ["+", "-"],
          ),
          'userSecondNumber': A2uiSchemas.numberReference(
            description: r"The user\'s answer for counting the second group",
          ),
          'userResult': A2uiSchemas.numberReference(
            description: r"The user's answer for the final result",
          ),
        },
        required: [
          'firstNumber',
          'firstSymbol',
          'operation',
          'secondNumber',
          'secondSymbol',
          'userFirstNumber',
          'userOperation',
          'userSecondNumber',
          'userResult',
        ],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions', 'finishAction'],
);

/// CatalogItem cho ExerciseCountingOperationWidget
final exerciseCountingOperationWidgetCatalogItem = CatalogItem(
  name: 'ExerciseCountingOperationWidget',
  dataSchema: _schema,
  widgetBuilder: (context) {
    final exerciseData = _ExerciseCountingOperationData.fromMap(
      context.data as Map<String, Object?>,
    );

    final title = exerciseData.title;
    final finishButtonLabel = exerciseData.finishButtonLabel;
    final finishAction = exerciseData.finishAction;
    final actionName = finishAction?['name'] as String?;
    final List<Object?> contextDefinition =
        (finishAction?['context'] as List<Object?>?) ?? <Object?>[];

    // Parse questions array
    final List<CountingOperationWidget> questions = [];
    for (final entry in exerciseData.questions.asMap().entries) {
      final questionData = _CountingQuestionData.fromMap(entry.value);

      final firstNumber = questionData.firstNumber;
      final firstSymbol = questionData.firstSymbol;
      final operation = questionData.operation;
      final secondNumber = questionData.secondNumber;
      final secondSymbol = questionData.secondSymbol;
      final userFirstNumber = questionData.userFirstNumber;
      final userFirstNumberRef = questionData.userFirstNumberRef;
      final userOperation = questionData.userOperation;
      final userOperationRef = questionData.userOperationRef;
      final userSecondNumber = questionData.userSecondNumber;
      final userSecondNumberRef = questionData.userSecondNumberRef;
      final userResult = questionData.userResult;
      final userResultRef = questionData.userResultRef;

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
              final pathStr = userFirstNumberRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                safeUpdateDataContext(context.dataContext, path, value);
              }
            },
            onChangedOperation: (value) {
              final pathStr = userOperationRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                safeUpdateDataContext(context.dataContext, path, value?.symbol);
              }
            },
            onChangedSecondAnswer: (value) {
              final pathStr = userSecondNumberRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                safeUpdateDataContext(context.dataContext, path, value);
              }
            },
            onChangedResultNumber: (value) {
              final pathStr = userResultRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                safeUpdateDataContext(context.dataContext, path, value);
              }
            },
          ),
        );
      }
    }

    if (title == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExerciseWidget<CountingOperationWidget>(
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

extension type _ExerciseCountingOperationData.fromMap(
  Map<String, Object?> _json
) {
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

extension type _CountingQuestionData.fromMap(Map<String, Object?> _json) {
  int? get firstNumber {
    final value = _json['firstNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalStr = value['literalString'] as String?;
      return literalStr != null ? int.tryParse(literalStr) : null;
    }
    return null;
  }

  String? get firstSymbol {
    final value = _json['firstSymbol'];
    if (value is String) return value;
    if (value is Map<String, Object?>) {
      return value['literalString'] as String?;
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

  int? get secondNumber {
    final value = _json['secondNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalStr = value['literalString'] as String?;
      return literalStr != null ? int.tryParse(literalStr) : null;
    }
    return null;
  }

  String? get secondSymbol {
    final value = _json['secondSymbol'];
    if (value is String) return value;
    if (value is Map<String, Object?>) {
      return value['literalString'] as String?;
    }
    return null;
  }

  JsonMap? get userFirstNumberRef => _json['userFirstNumber'] as JsonMap?;

  int? get userFirstNumber {
    final value = _json['userFirstNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalNum = value['literalNumber'];
      if (literalNum is int) return literalNum;
      if (literalNum is num) return literalNum.toInt();
    }
    return null;
  }

  JsonMap? get userOperationRef => _json['userOperation'] as JsonMap?;

  MathOperation? get userOperation {
    final value = _json['userOperation'];
    String? operationStr;
    if (value is String) {
      operationStr = value;
    } else if (value is Map<String, Object?>) {
      operationStr = value['literalString'] as String?;
    }
    return _parseMathOperation(operationStr);
  }

  JsonMap? get userSecondNumberRef => _json['userSecondNumber'] as JsonMap?;

  int? get userSecondNumber {
    final value = _json['userSecondNumber'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalNum = value['literalNumber'];
      if (literalNum is int) return literalNum;
      if (literalNum is num) return literalNum.toInt();
    }
    return null;
  }

  JsonMap? get userResultRef => _json['userResult'] as JsonMap?;

  int? get userResult {
    final value = _json['userResult'];
    if (value is int) return value;
    if (value is Map<String, Object?>) {
      final literalNum = value['literalNumber'];
      if (literalNum is int) return literalNum;
      if (literalNum is num) return literalNum.toInt();
    }
    return null;
  }
}
