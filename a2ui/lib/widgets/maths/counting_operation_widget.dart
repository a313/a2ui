import 'package:a2ui/ds/ds_number_input_popup.dart';
import 'package:a2ui/ds/ds_operation_popup.dart';
import 'package:a2ui/utils/util.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:a2ui/widgets/shared/answer_box.dart';
import 'package:flutter/material.dart';

class CountingOperationWidget extends StatefulWidget {
  final int firstNumber;
  final String firstSymbol;
  final MathOperation operation;
  final int secondNumber;
  final String secondSymbol;

  ///User answer
  final int? userFirstNumber;
  final MathOperation? userOperation;
  final int? userSecondNumber;
  final int? userResult;
  final void Function(int? number)? onChangedFirstNumber;
  final void Function(MathOperation? operation)? onChangedOperation;
  final void Function(int? number)? onChangedSecondAnswer;
  final void Function(int? number)? onChangedResultNumber;

  const CountingOperationWidget({
    super.key,
    required this.firstNumber,
    required this.firstSymbol,
    required this.operation,
    required this.secondNumber,
    required this.secondSymbol,
    this.userFirstNumber,
    this.userOperation,
    this.userSecondNumber,
    this.userResult,
    this.onChangedFirstNumber,
    this.onChangedOperation,
    this.onChangedSecondAnswer,
    this.onChangedResultNumber,
  }) : assert(
         operation == MathOperation.add || operation == MathOperation.subtract,
         'CountingOperationWidget only supports addition (+) and subtraction (-) operations',
       );

  @override
  State<CountingOperationWidget> createState() =>
      _CountingOperationWidgetState();
}

class _CountingOperationWidgetState extends State<CountingOperationWidget> {
  int? userFirstAnswer;
  MathOperation? userOperationAnswer;
  int? userSecondAnswer;
  int? userResultAnswer;

  int get result {
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
                    widget.firstSymbol * widget.firstNumber,
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
                    color: widget.operation == MathOperation.subtract
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.operation == MathOperation.subtract
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    widget.secondSymbol * widget.secondNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      decoration: widget.operation == MathOperation.subtract
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
              onTap: (position) {
                context.showNumberInputPopup(
                  position: position,
                  onConfirm: (value) {
                    setState(() {
                      userFirstAnswer = value;
                    });
                    widget.onChangedFirstNumber?.call(value);
                  },
                );
              },
              correctAnswer: widget.firstNumber.toString(),
              userAnswer: userFirstAnswer?.toString(),
            ),
            const SizedBox(width: 12),
            AnswerBox(
              onTap: (position) {
                context.showOperationPopup(
                  position: position,
                  onSelect: (operation) {
                    setState(() {
                      userOperationAnswer = operation;
                    });
                    widget.onChangedOperation?.call(operation);
                  },
                );
              },
              correctAnswer: widget.operation.symbol,

              userAnswer: userOperationAnswer?.symbol,
            ),
            const SizedBox(width: 12),
            AnswerBox(
              onTap: (position) {
                context.showNumberInputPopup(
                  position: position,
                  onConfirm: (value) {
                    setState(() {
                      userSecondAnswer = value;
                    });
                    widget.onChangedSecondAnswer?.call(value);
                  },
                );
              },
              correctAnswer: widget.secondNumber.toString(),
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
              onTap: (position) {
                context.showNumberInputPopup(
                  position: position,
                  onConfirm: (value) {
                    setState(() {
                      userResultAnswer = value;
                    });
                    widget.onChangedResultNumber?.call(value);
                  },
                );
              },
              correctAnswer: result.toString(),
              userAnswer: userResultAnswer?.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
