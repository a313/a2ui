import 'package:a2ui/widgets/maths/operation_widget.dart';
import 'package:flutter/material.dart';

class OperationSymbol extends StatelessWidget {
  final MathOperation operation;

  const OperationSymbol({super.key, required this.operation});

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
