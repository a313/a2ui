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

  bool get isCorrect => userAnswer == correctAnswer;

  Color _getAnswerColor() {
    if (userAnswer == null) return Colors.grey.shade300;
    return isCorrect ? Colors.green.shade100 : Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _NumberBox(number: firstNumber),
        const SizedBox(width: 12),
        _ComparisonBox(
          operator: showAnswer ? correctAnswer : userAnswer,
          backgroundColor: _getAnswerColor(),
          correctOperator: correctAnswer,
          onTap: onTap,
        ),
        const SizedBox(width: 12),
        _NumberBox(number: secondNumber),
        if (userAnswer != null) ...[
          const SizedBox(width: 12),
          _ResultFeedback(isCorrect: isCorrect),
        ],
      ],
    );
  }
}

class _NumberBox extends StatelessWidget {
  final int number;

  const _NumberBox({required this.number});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$number',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _ComparisonBox extends StatelessWidget {
  final ComparisonOperator? operator;
  final Color backgroundColor;
  final ComparisonOperator correctOperator;
  final void Function(Offset position)? onTap;

  const _ComparisonBox({
    required this.operator,
    required this.backgroundColor,
    required this.correctOperator,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Trả về vị trí chính giữa của ô đáp án
    final popupPosition = Offset(
      position.dx + size.width / 2,
      position.dy + size.height / 2,
    );

    onTap!(popupPosition);
  }

  Color _getOperatorColor(ComparisonOperator op) {
    switch (op) {
      case ComparisonOperator.greaterThan:
        return Colors.blue;
      case ComparisonOperator.lessThan:
        return Colors.orange;
      case ComparisonOperator.equal:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: operator != null
                  ? (operator == correctOperator ? Colors.green : Colors.red)
                  : Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
        child: Text(
          operator?.symbol ?? '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: operator != null
                ? _getOperatorColor(operator!)
                : Colors.grey.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResultFeedback extends StatelessWidget {
  final bool isCorrect;

  const _ResultFeedback({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isCorrect ? Icons.check_circle : Icons.cancel,
      color: isCorrect ? Colors.green : Colors.red,
      size: 28,
    );
  }
}
