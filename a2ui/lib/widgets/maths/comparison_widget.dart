import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:a2ui/widgets/shared/number_box.dart';
import 'package:flutter/material.dart';

enum ComparisonOperator {
  greaterThan('>', 'Lớn hơn'),
  lessThan('<', 'Nhỏ hơn'),
  equal('=', 'Bằng');

  const ComparisonOperator(this.symbol, this.label);
  final String symbol;
  final String label;
}

class ComparisonWidget extends StatelessWidget {
  final int firstNumber;
  final int secondNumber;
  final ComparisonOperator? userAnswer;
  final void Function(Offset position)? onTap;
  final bool showAnswer;

  const ComparisonWidget({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    this.userAnswer,
    this.onTap,
    this.showAnswer = false,
  });

  ComparisonOperator get correctAnswer {
    if (firstNumber > secondNumber) {
      return ComparisonOperator.greaterThan;
    } else if (firstNumber < secondNumber) {
      return ComparisonOperator.lessThan;
    } else {
      return ComparisonOperator.equal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NumberBox(number: firstNumber),
        const SizedBox(width: 12),
        AnswerBox(
          correctAnswer: correctAnswer.symbol,
          showAnswer: showAnswer,
          userAnswer: userAnswer?.symbol,
          onTap: onTap,
        ),
        const SizedBox(width: 12),
        NumberBox(number: secondNumber),
      ],
    );
  }
}
