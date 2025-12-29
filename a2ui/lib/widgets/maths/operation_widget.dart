import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:a2ui/widgets/shared/number_box.dart';
import 'package:a2ui/widgets/shared/operation_symbol.dart';
import 'package:flutter/material.dart';

enum MathOperation {
  add('+', 'Cộng'),
  subtract('-', 'Trừ'),
  multiply('×', 'Nhân'),
  divide('÷', 'Chia');

  const MathOperation(this.symbol, this.label);
  final String symbol;
  final String label;
}

class OperationWidget extends StatelessWidget {
  final int firstNumber;
  final int secondNumber;
  final MathOperation operation;
  final int? userAnswer;
  final void Function(Offset position)? onTap;
  final bool showAnswer;

  const OperationWidget({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    required this.operation,
    this.userAnswer,
    this.onTap,
    this.showAnswer = false,
  });

  int get correctAnswer {
    switch (operation) {
      case MathOperation.add:
        return firstNumber + secondNumber;
      case MathOperation.subtract:
        return firstNumber - secondNumber;
      case MathOperation.multiply:
        return firstNumber * secondNumber;
      case MathOperation.divide:
        return firstNumber ~/ secondNumber;
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
        OperationSymbol(operation: operation),
        const SizedBox(width: 12),
        NumberBox(number: secondNumber),
        const SizedBox(width: 12),
        Text(
          '=',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 12),
        AnswerBox(
          correctAnswer: correctAnswer.toString(),
          showAnswer: showAnswer,
          userAnswer: userAnswer?.toString(),
          onTap: onTap,
        ),
      ],
    );
  }
}
