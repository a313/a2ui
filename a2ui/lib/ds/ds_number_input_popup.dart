import 'package:a2ui/ds/ds_position_popup.dart';
import 'package:flutter/material.dart';

class DsNumberInputPopup extends StatefulWidget {
  final Offset position;
  final ArrowPosition arrowPosition;
  final void Function(int value)? onConfirm;
  final VoidCallback? onDismiss;
  final int? initialValue;

  const DsNumberInputPopup({
    super.key,
    required this.position,
    this.arrowPosition = ArrowPosition.top,
    this.onConfirm,
    this.onDismiss,
    this.initialValue,
  });

  @override
  State<DsNumberInputPopup> createState() => _DsNumberInputPopupState();
}

class _DsNumberInputPopupState extends State<DsNumberInputPopup> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue?.toString() ?? '';
  }

  void _onNumberTap(int number) {
    setState(() {
      _currentValue += number.toString();
    });
  }

  void _onDeleteTap() {
    if (_currentValue.isNotEmpty) {
      setState(() {
        _currentValue = _currentValue.substring(0, _currentValue.length - 1);
      });
    }
  }

  void _onConfirmTap() {
    if (_currentValue.isNotEmpty) {
      widget.onConfirm?.call(int.parse(_currentValue));
      // Không gọi onDismiss vì onConfirm đã handle việc đóng popup
    }
  }

  @override
  Widget build(BuildContext context) {
    return DsPositionPopup(
      targetPosition: widget.position,
      arrowPosition: widget.arrowPosition,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display area
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              _currentValue.isEmpty ? '' : _currentValue,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          // Number pad
          SizedBox(
            width: 200,
            child: Column(
              children: [
                // Row 1: 1, 2, 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NumberButton(number: 1, onTap: () => _onNumberTap(1)),
                    _NumberButton(number: 2, onTap: () => _onNumberTap(2)),
                    _NumberButton(number: 3, onTap: () => _onNumberTap(3)),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 2: 4, 5, 6
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NumberButton(number: 4, onTap: () => _onNumberTap(4)),
                    _NumberButton(number: 5, onTap: () => _onNumberTap(5)),
                    _NumberButton(number: 6, onTap: () => _onNumberTap(6)),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 3: 7, 8, 9
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NumberButton(number: 7, onTap: () => _onNumberTap(7)),
                    _NumberButton(number: 8, onTap: () => _onNumberTap(8)),
                    _NumberButton(number: 9, onTap: () => _onNumberTap(9)),
                  ],
                ),
                const SizedBox(height: 8),

                // Row 4: Clear, 0, Delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NumberButton(number: 0, onTap: () => _onNumberTap(0)),

                    _ActionButton(
                      icon: Icons.backspace_outlined,
                      color: Colors.orange,
                      onTap: _onDeleteTap,
                    ),
                    _ActionButton(
                      icon: Icons.check,
                      color: Colors.green,
                      onTap: _currentValue.isNotEmpty ? _onConfirmTap : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final int number;
  final VoidCallback onTap;

  const _NumberButton({required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

/// Helper function to show number input popup
void showDsNumberInputPopup({
  required BuildContext context,
  required Offset position,
  ArrowPosition? arrowPosition,
  void Function(int value)? onConfirm,
  VoidCallback? onDismiss,
  int? initialValue,
  int maxDigits = 3,
}) {
  final overlay = Overlay.of(context);
  final screenSize = MediaQuery.of(context).size;

  ArrowPosition finalArrowPosition =
      arrowPosition ?? _determineArrowPosition(position, screenSize);

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
        DsNumberInputPopup(
          position: position,
          arrowPosition: finalArrowPosition,
          onConfirm: (value) {
            safeRemove();
            onConfirm?.call(value);
          },
          onDismiss: () {
            safeRemove();
            onDismiss?.call();
          },
          initialValue: initialValue,
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

ArrowPosition _determineArrowPosition(Offset position, Size screenSize) {
  return position.dy < screenSize.height / 2
      ? ArrowPosition.top
      : ArrowPosition.bottom;
}

/// Extension for easy usage
extension DsNumberInputPopupExtension on BuildContext {
  void showNumberInputPopup({
    required Offset position,
    ArrowPosition? arrowPosition,
    void Function(int value)? onConfirm,
    VoidCallback? onDismiss,
    int? initialValue,
  }) {
    showDsNumberInputPopup(
      context: this,
      position: position,
      arrowPosition: arrowPosition,
      onConfirm: onConfirm,
      onDismiss: onDismiss,
      initialValue: initialValue,
    );
  }
}
