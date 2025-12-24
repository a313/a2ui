import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../extensions/string.dart';

class MaxNumberInputFormatter extends TextInputFormatter {
  final int max;
  final VoidCallback? onOverInput;

  MaxNumberInputFormatter(this.max, {this.onOverInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final intVal = int.tryParse(newValue.text.onlyNumeric) ?? 0;
    if (newValue.text.compareTo(oldValue.text) != 0 && intVal > max) {
      onOverInput?.call();
      return oldValue;
    } else {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      final String newString = NumberFormat.decimalPattern("vi").format(intVal);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    }
  }
}
