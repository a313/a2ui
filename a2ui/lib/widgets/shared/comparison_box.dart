import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:flutter/material.dart';

class ComparisonBox extends StatelessWidget {
  final ComparisonOperator? operator;
  final Color backgroundColor;
  final ComparisonOperator correctOperator;
  final void Function(Offset position)? onTap;

  const ComparisonBox({
    super.key,
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
