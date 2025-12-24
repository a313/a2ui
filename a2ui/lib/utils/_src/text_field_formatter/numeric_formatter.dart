import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../extensions/string.dart';

class NumericFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;

      final intVal = int.tryParse(newValue.text.onlyNumeric) ?? 0;
      final String newString = NumberFormat.decimalPattern("vi").format(intVal);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: (newString.length - selectionIndexFromTheRight).clamp(
            0,
            9999,
          ),
        ),
      );
    } else {
      return newValue;
    }
  }
}
