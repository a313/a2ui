import 'package:flutter/material.dart';

class AnswerBox extends StatelessWidget {
  final String? userAnswer;
  final String correctAnswer;

  final void Function(Offset position)? onTap;

  const AnswerBox({
    super.key,
    this.onTap,
    this.userAnswer,
    required this.correctAnswer,
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

  bool get isCorrect => userAnswer == correctAnswer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: userAnswer != null
                  ? (isCorrect ? Colors.green : Colors.red)
                  : Colors.grey.shade400,
              width: 2,
            ),
          ),
        ),
        child: Text(
          userAnswer?.toString() ?? '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: userAnswer != null ? Colors.black87 : Colors.grey.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
