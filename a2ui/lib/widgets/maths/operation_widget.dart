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
        _OperationSymbol(operation: operation),
        const SizedBox(width: 12),
        _NumberBox(number: secondNumber),
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
        _AnswerBox(
          answer: showAnswer ? correctAnswer : userAnswer,
          backgroundColor: _getAnswerColor(),
          showCorrectAnswer: showAnswer && userAnswer != null && !isCorrect,
          correctAnswer: correctAnswer,
          onTap: onTap,
        ),
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

class _OperationSymbol extends StatelessWidget {
  final MathOperation operation;

  const _OperationSymbol({required this.operation});

  Color _getOperationColor() {
    switch (operation) {
      case MathOperation.add:
        return Colors.green;
      case MathOperation.subtract:
        return Colors.orange;
      case MathOperation.multiply:
        return Colors.purple;
      case MathOperation.divide:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      operation.symbol,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: _getOperationColor(),
      ),
    );
  }
}

class _AnswerBox extends StatelessWidget {
  final int? answer;
  final Color backgroundColor;
  final bool showCorrectAnswer;
  final int correctAnswer;
  final void Function(Offset position)? onTap;

  const _AnswerBox({
    required this.answer,
    required this.backgroundColor,
    this.showCorrectAnswer = false,
    required this.correctAnswer,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: answer != null
                  ? (answer == correctAnswer ? Colors.green : Colors.red)
                  : Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
        child: Text(
          answer?.toString() ?? '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: answer != null ? Colors.black87 : Colors.grey.shade400,
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
