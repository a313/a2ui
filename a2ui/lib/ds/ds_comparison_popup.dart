import 'package:a2ui/ds/ds_position_popup.dart';
import 'package:a2ui/widgets/maths/comparison_widget.dart';
import 'package:flutter/material.dart';

class DsComparisonPopup extends StatelessWidget {
  final Offset position;
  final ArrowPosition arrowPosition;
  final void Function(ComparisonOperator operator)? onSelect;
  final VoidCallback? onDismiss;

  const DsComparisonPopup({
    super.key,
    required this.position,
    this.arrowPosition = ArrowPosition.top,
    this.onSelect,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return DsPositionPopup(
      targetPosition: position,
      arrowPosition: arrowPosition,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Chọn dấu so sánh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OperatorButton(
                operator: ComparisonOperator.greaterThan,
                onTap: () {
                  onSelect?.call(ComparisonOperator.greaterThan);
                  onDismiss?.call();
                },
              ),
              const SizedBox(width: 12),
              _OperatorButton(
                operator: ComparisonOperator.lessThan,
                onTap: () {
                  onSelect?.call(ComparisonOperator.lessThan);
                  onDismiss?.call();
                },
              ),
              const SizedBox(width: 12),
              _OperatorButton(
                operator: ComparisonOperator.equal,
                onTap: () {
                  onSelect?.call(ComparisonOperator.equal);
                  onDismiss?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OperatorButton extends StatelessWidget {
  final ComparisonOperator operator;
  final VoidCallback onTap;

  const _OperatorButton({required this.operator, required this.onTap});

  Color _getOperatorColor() {
    switch (operator) {
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
    return Material(
      color: _getOperatorColor().withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                operator.symbol,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getOperatorColor(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                operator.label,
                style: TextStyle(fontSize: 12, color: _getOperatorColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show comparison popup
void showDsComparisonPopup({
  required BuildContext context,
  required Offset position,
  ArrowPosition? arrowPosition,
  void Function(ComparisonOperator operator)? onSelect,
  VoidCallback? onDismiss,
}) {
  final overlay = Overlay.of(context);
  final screenSize = MediaQuery.of(context).size;

  final bool isBottomHalf = position.dy > screenSize.height / 2;
  final ArrowPosition finalArrowPosition =
      arrowPosition ??
      (isBottomHalf ? ArrowPosition.bottom : ArrowPosition.top);

  late OverlayEntry overlayEntry;
  bool isRemoved = false;

  void safeRemove() {
    if (!isRemoved) {
      isRemoved = true;
      overlayEntry.remove();
    }
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Backdrop to dismiss
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              safeRemove();
              onDismiss?.call();
            },
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        // Popup
        DsComparisonPopup(
          position: position,
          arrowPosition: finalArrowPosition,
          onSelect: (operator) {
            safeRemove();
            onSelect?.call(operator);
          },
          onDismiss: () {
            safeRemove();
            onDismiss?.call();
          },
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

/// Extension for easy usage
extension DsComparisonPopupExtension on BuildContext {
  void showComparisonPopup({
    required Offset position,
    ArrowPosition? arrowPosition,
    void Function(ComparisonOperator operator)? onSelect,
    VoidCallback? onDismiss,
  }) {
    showDsComparisonPopup(
      context: this,
      position: position,
      arrowPosition: arrowPosition,
      onSelect: onSelect,
      onDismiss: onDismiss,
    );
  }
}
