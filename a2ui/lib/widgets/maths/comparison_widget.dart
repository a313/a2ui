import 'package:a2ui/ds/ds_comparison_popup.dart';
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

class ComparisonWidget extends StatefulWidget {
  final int firstNumber;
  final int secondNumber;
  final ComparisonOperator? initAnswer;
  final void Function(ComparisonOperator)? onChanged;

  const ComparisonWidget({
    super.key,
    required this.firstNumber,
    required this.secondNumber,
    this.initAnswer,
    this.onChanged,
  });

  @override
  State<ComparisonWidget> createState() => _ComparisonWidgetState();
}

class _ComparisonWidgetState extends State<ComparisonWidget> {
  ComparisonOperator? answer;

  ComparisonOperator get correctAnswer {
    if (widget.firstNumber > widget.secondNumber) {
      return ComparisonOperator.greaterThan;
    } else if (widget.firstNumber < widget.secondNumber) {
      return ComparisonOperator.lessThan;
    } else {
      return ComparisonOperator.equal;
    }
  }

  @override
  void initState() {
    answer = widget.initAnswer;
    super.initState();
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
        AnswerBox(
          correctAnswer: correctAnswer.symbol,
          userAnswer: answer?.symbol,
          onTap: (position) {
            context.showComparisonPopup(
              position: position,
              onSelect: (operator) {
                setState(() {
                  answer = operator;
                });
                widget.onChanged?.call(operator);
              },
            );
          },
        ),
        const SizedBox(width: 12),
        NumberBox(number: widget.secondNumber),
      ],
    );
  }
}
