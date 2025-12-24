import 'package:flutter/services.dart';

class SuffixFormatter extends TextInputFormatter {
  final String suffix;

  SuffixFormatter(this.suffix);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (newValue.text.compareTo(oldValue.text) != 0) {
      final newLenght = newValue.text.length;
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      String newString = newValue.text;
      // print('BEFORE: $newString');

      int offset = 0;
      if (newLenght < suffix.length) {
        newString += suffix;
        offset = suffix.length;
      }
      final selOffset = newString.length - selectionIndexFromTheRight - offset;
      // print('AFTER: $newString');
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: selOffset,
        ),
      );
    } else {
      return newValue;
    }
  }
}
