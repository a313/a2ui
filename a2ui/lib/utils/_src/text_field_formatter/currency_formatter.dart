import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../extensions/string.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final int maxAmount;
  final Function? onOver;
  final int? multipleOf;
  final int? maxWithdraw;
  final Function? onOverWithdraw;

  CurrencyInputFormatter({
    this.maxAmount = -1,
    this.multipleOf = 1,
    this.onOver,
    this.maxWithdraw,
    this.onOverWithdraw,
  });

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
      if (maxAmount > 0 && (intVal * multipleOf!) > maxAmount) {
        onOver?.call();
        return oldValue;
      }
      if (maxWithdraw != null) {
        if (intVal > maxWithdraw!) {
          onOverWithdraw?.call();
          return oldValue;
        }
      }
      final String newString = NumberFormat.decimalPattern("vi").format(intVal);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
