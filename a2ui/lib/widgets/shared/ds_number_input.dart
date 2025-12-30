import 'package:a2ui/widgets/shared/ds_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable number input widget with increment/decrement buttons.
class DsNumberInput extends StatefulWidget {
  const DsNumberInput({
    super.key,
    required this.value,
    this.min,
    this.max,
    required this.onChanged,
    this.textFieldWidth = 60,
  });

  final int value;
  final int? min;
  final int? max;
  final void Function(int) onChanged;
  final double textFieldWidth;

  @override
  State<DsNumberInput> createState() => _DsNumberInputState();
}

class _DsNumberInputState extends State<DsNumberInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(DsNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _clampValue(int value) {
    if (widget.min != null && value < widget.min!) {
      return widget.min!;
    }
    if (widget.max != null && value > widget.max!) {
      return widget.max!;
    }
    return value;
  }

  void _increment() {
    final newValue = _clampValue(widget.value + 1);
    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }
  }

  void _decrement() {
    final newValue = _clampValue(widget.value - 1);
    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }
  }

  void _onTextChanged(String text) {
    final parsed = int.tryParse(text);
    if (parsed != null) {
      final newValue = _clampValue(parsed);
      widget.onChanged(newValue);
    }
  }

  void _onTextSubmitted(String text) {
    final parsed = int.tryParse(text);
    if (parsed != null) {
      final newValue = _clampValue(parsed);
      widget.onChanged(newValue);
      _controller.text = newValue.toString();
    } else {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final canDecrement = widget.min == null || widget.value > widget.min!;
    final canIncrement = widget.max == null || widget.value < widget.max!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DsIconButton(
          icon: Icons.remove,
          onPressed: canDecrement ? _decrement : null,
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: widget.textFieldWidth,
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            onChanged: _onTextChanged,
            onSubmitted: _onTextSubmitted,
          ),
        ),
        const SizedBox(width: 4),
        DsIconButton(
          icon: Icons.add,
          onPressed: canIncrement ? _increment : null,
        ),
      ],
    );
  }
}
