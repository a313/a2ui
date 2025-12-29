import 'package:a2ui/utils/util.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:flutter/material.dart';

class CountingOperationWidget extends StatelessWidget {
  final int firstNumber;
  final String firstSymbol;
  final MathOperation operation;
  final int secondNumber;
  final String secondSymbol;

  ///User answer
  final int? userFirstAnswer;
  final MathOperation? userOperationAnswer;
  final int? userSecondAnswer;
  final int? userFinalAnswer;
  final void Function(Offset position)? onTapFirstAnswer;
  final void Function(Offset position)? onTapOperationAnswer;
  final void Function(Offset position)? onTapSecondAnswer;
  final void Function(Offset position)? onTapFinalAnswer;
  final bool showAnswer;

  const CountingOperationWidget({
    super.key,
    required this.firstNumber,
    required this.firstSymbol,
    required this.operation,
    required this.secondNumber,
    required this.secondSymbol,
    this.userFirstAnswer,
    this.userOperationAnswer,
    this.userSecondAnswer,
    this.userFinalAnswer,
    this.onTapFirstAnswer,
    this.onTapOperationAnswer,
    this.onTapSecondAnswer,
    this.onTapFinalAnswer,
    this.showAnswer = false,
  }) : assert(
         operation == MathOperation.add || operation == MathOperation.subtract,
         'CountingOperationWidget only supports addition (+) and subtraction (-) operations',
       );

  int get result {
    switch (operation) {
      case MathOperation.add:
        return firstNumber + secondNumber;
      case MathOperation.subtract:
        return (firstNumber - secondNumber).abs();
      case MathOperation.multiply:
        return firstNumber * secondNumber;
      case MathOperation.divide:
        return firstNumber ~/ secondNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Question - Hiển thị các biểu tượng
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nhóm 1
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                  ),
                  child: Text(
                    firstSymbol * firstNumber,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Nhóm 2
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: operation == MathOperation.subtract
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: operation == MathOperation.subtract
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    secondSymbol * secondNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      decoration: operation == MathOperation.subtract
                          ? TextDecoration.lineThrough
                          : null,
                      decorationThickness: 2,
                      decorationColor: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        sizedBoxH12,
        const SizedBox(height: 8),
        //Answer - Phép toán cần điền
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnswerBox(
              onTap: onTapFirstAnswer,
              correctAnswer: firstNumber.toString(),
              showAnswer: showAnswer,
              userAnswer: userFirstAnswer?.toString(),
            ),
            const SizedBox(width: 12),
            AnswerBox(
              onTap: onTapOperationAnswer,
              correctAnswer: operation.symbol,
              showAnswer: showAnswer,
              userAnswer: userOperationAnswer?.symbol,
            ),
            const SizedBox(width: 12),
            AnswerBox(
              onTap: onTapSecondAnswer,
              correctAnswer: secondNumber.toString(),
              showAnswer: showAnswer,
              userAnswer: userSecondAnswer?.toString(),
            ),
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
              onTap: onTapFinalAnswer,
              correctAnswer: result.toString(),
              showAnswer: showAnswer,
              userAnswer: userFinalAnswer?.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
