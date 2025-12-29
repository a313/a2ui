import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:flutter/material.dart';

class ExerciseComparisonWidget extends StatelessWidget {
  final String title;
  final List<ComparisonQuestion> questions;

  const ExerciseComparisonWidget({
    super.key,
    required this.title,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16, width: double.infinity),
        // Questions
        Wrap(
          spacing: 32,
          runSpacing: 16,
          alignment: .end,
          runAlignment: .end,
          children: questions.map((q) {
            return ComparisonWidget(
              firstNumber: q.firstNumber,
              secondNumber: q.secondNumber,
              showAnswer: q.showAnswer,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ComparisonQuestion {
  final int firstNumber;
  final int secondNumber;
  final bool showAnswer;

  const ComparisonQuestion({
    required this.firstNumber,
    required this.secondNumber,
    this.showAnswer = false,
  });
}
