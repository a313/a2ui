import 'package:a2ui/ds/ds_number_input_popup.dart';
import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:a2ui/widgets/shared/number_box.dart';
import 'package:a2ui/widgets/shared/operation_symbol.dart';
import 'package:flutter/material.dart';

enum MathOperation {
  add('+', 'Add'),
  subtract('-', 'Subtract'),
  multiply('×', 'Multiple'),
  divide('÷', 'Divide');

  const MathOperation(this.symbol, this.label);
  final String symbol;
  final String label;
}

class OperationWidget extends StatefulWidget {
  final int firstNumber;
  final int secondNumber;
  final MathOperation operation;
  final int? userAnswer;
  final void Function(int value)? onChanged;

  const OperationWidget({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    required this.operation,
    this.userAnswer,
    this.onChanged,
  });

  @override
  State<OperationWidget> createState() => _OperationWidgetState();
}

class _OperationWidgetState extends State<OperationWidget> {
  int? answer;

  int get correctAnswer {
    switch (widget.operation) {
      case MathOperation.add:
        return widget.firstNumber + widget.secondNumber;
      case MathOperation.subtract:
        return widget.firstNumber - widget.secondNumber;
      case MathOperation.multiply:
        return widget.firstNumber * widget.secondNumber;
      case MathOperation.divide:
        return widget.firstNumber ~/ widget.secondNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NumberBox(number: widget.firstNumber),
        const SizedBox(width: 12),
        OperationSymbol(operation: widget.operation),
        const SizedBox(width: 12),
        NumberBox(number: widget.secondNumber),
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
          userAnswer: answer?.toString(),
          onTap: (position) {
            context.showNumberInputPopup(
              position: position,
              onConfirm: (value) {
                setState(() {
                  answer = value;
                });
                widget.onChanged?.call(value);
              },
            );
          },
        ),
      ],
    );
  }
}
