import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final riddleSchema = S.object(
  properties: {
    'question': S.string(description: 'The question part of a riddle.'),
    'answer': S.string(description: 'The answer part of a riddle.'),
  },
  required: ['question', 'answer'],
);

final riddleCard = CatalogItem(
  name: 'RiddleCard',
  dataSchema: riddleSchema,
  widgetBuilder: (context) {
    final data = context.data as Map<String, Object?>?;

    // Parse question
    final questionValue = data?['question'];
    String? question;
    if (questionValue is String) {
      question = questionValue;
    } else if (questionValue is Map<String, Object?>) {
      question = questionValue['literalString'] as String?;
    }

    // Parse answer
    final answerValue = data?['answer'];
    String? answer;
    if (answerValue is String) {
      answer = answerValue;
    } else if (answerValue is Map<String, Object?>) {
      answer = answerValue['literalString'] as String?;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(border: Border.all()),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question ?? ''),
          const SizedBox(height: 8.0),
          Text(answer ?? ''),
        ],
      ),
    );
  },
);
