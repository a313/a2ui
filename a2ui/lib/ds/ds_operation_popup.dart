import 'package:a2ui/ds/ds_position_popup.dart';
import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:flutter/material.dart';

class DsOperationPopup extends StatelessWidget {
  final Offset position;
  final ArrowPosition arrowPosition;
  final void Function(MathOperation operation)? onSelect;
  final VoidCallback? onDismiss;

  const DsOperationPopup({
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
            'Chọn phép toán',
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
              _OperationButton(
                operation: MathOperation.add,
                onTap: () {
                  onSelect?.call(MathOperation.add);
                  onDismiss?.call();
                },
              ),
              const SizedBox(width: 12),
              _OperationButton(
                operation: MathOperation.subtract,
                onTap: () {
                  onSelect?.call(MathOperation.subtract);
                  onDismiss?.call();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OperationButton(
                operation: MathOperation.multiply,
                onTap: () {
                  onSelect?.call(MathOperation.multiply);
                  onDismiss?.call();
                },
              ),
              const SizedBox(width: 12),
              _OperationButton(
                operation: MathOperation.divide,
                onTap: () {
                  onSelect?.call(MathOperation.divide);
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

class _OperationButton extends StatelessWidget {
  final MathOperation operation;
  final VoidCallback onTap;

  const _OperationButton({required this.operation, required this.onTap});

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
    return Material(
      color: _getOperationColor().withOpacity(0.1),
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
                operation.symbol,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _getOperationColor(),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                operation.label,
                style: TextStyle(fontSize: 12, color: _getOperationColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show operation popup
void showDsOperationPopup({
  required BuildContext context,
  required Offset position,
  ArrowPosition? arrowPosition,
  void Function(MathOperation operation)? onSelect,
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
        GestureDetector(
          onTap: () {
            onDismiss?.call();
            safeRemove();
          },
          child: Container(color: Colors.transparent),
        ),
        DsOperationPopup(
          position: position,
          arrowPosition: finalArrowPosition,
          onSelect: (operation) {
            onSelect?.call(operation);
            safeRemove();
          },
          onDismiss: () {
            onDismiss?.call();
            safeRemove();
          },
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

extension OperationPopupExtension on BuildContext {
  void showOperationPopup({
    required Offset position,
    ArrowPosition? arrowPosition,
    void Function(MathOperation operation)? onSelect,
    VoidCallback? onDismiss,
  }) {
    showDsOperationPopup(
      context: this,
      position: position,
      arrowPosition: arrowPosition,
      onSelect: onSelect,
      onDismiss: onDismiss,
    );
  }
}
