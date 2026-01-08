import 'package:a2ui/genui/data_context_helper.dart';
import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:a2ui/widgets/shared/exercise_widget.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// Helper to parse userAnswer string to ComparisonOperator
ComparisonOperator? _parseComparisonOperator(String? value) {
  if (value == null) return null;
  switch (value.toLowerCase()) {
    case '>':
      return ComparisonOperator.greaterThan;
    case '<':
      return ComparisonOperator.lessThan;
    case '=':
      return ComparisonOperator.equal;
    default:
      return null;
  }
}

final _schema = S.object(
  title: 'ExerciseComparisonWidget',
  description:
      'A widget for displaying a set of comparison questions with a title. '
      'Each question compares two numbers with operators (<, >, =)',
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
      description:
          'Array of comparison questions'
          'The user answer is correct if the comparison between firstNumber and secondNumber is correct',
      items: S.object(
        properties: {
          'firstNumber': S.integer(description: 'The first number to compare'),
          'secondNumber': S.integer(
            description: 'The second number to compare',
          ),
          'userAnswer': A2uiSchemas.stringReference(
            description: 'The user answer for each question',
            enumValues: ['<', '>', '='],
          ),
        },
        required: ['firstNumber', 'secondNumber', 'userAnswer'],
      ),
      minItems: 1,
    ),
  },
  required: ['title', 'questions', 'finishAction'],
);

/// CatalogItem cho ExerciseComparisonWidget
final exerciseComparisonWidgetCatalogItem = CatalogItem(
  name: 'ExerciseComparisonWidget',
  dataSchema: _schema,
  widgetBuilder: (context) {
    final exerciseData = _ExerciseComparisonData.fromMap(
      context.data as Map<String, Object?>,
    );

    final title = exerciseData.title;
    final finishButtonLabel = exerciseData.finishButtonLabel;
    final finishAction = exerciseData.finishAction;
    final actionName = finishAction?['name'] as String?;
    final List<Object?> contextDefinition =
        (finishAction?['context'] as List<Object?>?) ?? <Object?>[];

    // Parse questions array
    final List<ComparisonWidget> questions = [];
    for (final entry in exerciseData.questions.asMap().entries) {
      final questionData = _ComparisonQuestionData.fromMap(entry.value);

      final firstNumber = questionData.firstNumber;
      final secondNumber = questionData.secondNumber;
      final userAnswer = questionData.userAnswer;
      final userAnswerRef = questionData.userAnswerRef;

      if (firstNumber != null && secondNumber != null) {
        questions.add(
          ComparisonWidget(
            firstNumber: firstNumber,
            secondNumber: secondNumber,
            initAnswer: userAnswer,
            onChanged: (operator) {
              // Update userAnswer in dataContext using path from reference if available
              final pathStr = userAnswerRef?['path'] as String?;
              if (pathStr != null) {
                final path = DataPath(pathStr);
                safeUpdateDataContext(
                  context.dataContext,
                  path,
                  operator.symbol,
                );
              }
            },
          ),
        );
      }
    }

    if (title == null || questions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExerciseWidget<ComparisonWidget>(
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

extension type _ExerciseComparisonData.fromMap(Map<String, Object?> _json) {
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

extension type _ComparisonQuestionData.fromMap(Map<String, Object?> _json) {
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

  JsonMap? get userAnswerRef => _json['userAnswer'] as JsonMap?;

  ComparisonOperator? get userAnswer {
    final value = _json['userAnswer'];
    String? answerStr;
    if (value is String) {
      answerStr = value;
    } else if (value is Map<String, Object?>) {
      answerStr = value['literalString'] as String?;
    }
    return _parseComparisonOperator(answerStr);
  }
}
