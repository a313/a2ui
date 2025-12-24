import 'dart:math';
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  PhoneInputFormatter({this.code = "VN"});

  final String code;

  @override
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newTextBuffer = StringBuffer();
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    int newTextLength = newValue.text.length;
    if (code == "VN") {
      final int hasZero = newValue.text.startsWith("0") ? 1 : 0;
      final int maxLengh = 9 + hasZero;
      newTextLength = min(newValue.text.length, maxLengh);

      if (newTextLength >= 4 + hasZero) {
        newTextBuffer.write(
            '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 3 + hasZero)} ');
        if (newValue.selection.end >= 3 + hasZero) selectionIndex++;
      }
      if (newTextLength >= 7 + hasZero) {
        newTextBuffer.write(
            '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 6 + hasZero)} ');
        if (newValue.selection.end >= 6 + hasZero) selectionIndex++;
      }
    } else {
      final int hasZero = newValue.text.startsWith("0") ? 1 : 0;
      final int maxLengh = 13 + hasZero;
      newTextLength = min(newValue.text.length, maxLengh);
      if (newTextLength >= 4 + hasZero) {
        newTextBuffer.write(
            '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 3 + hasZero)} ');
        if (newValue.selection.end >= 3 + hasZero) selectionIndex++;
      }
      if (newTextLength >= 7 + hasZero) {
        newTextBuffer.write(
            '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 6 + hasZero)} ');
        if (newValue.selection.end >= 6 + hasZero) selectionIndex++;
      }

      if (newTextLength >= 11 + hasZero) {
        newTextBuffer.write(
            '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 9 + hasZero)} ');
        if (newValue.selection.end >= 10 + hasZero) selectionIndex++;
      }
    }
    if (newTextLength > usedSubstringIndex) {
      newTextBuffer
          .write(newValue.text.substring(usedSubstringIndex, newTextLength));
    }
    return TextEditingValue(
        text: newTextBuffer.toString(),
        selection: TextSelection.collapsed(
            offset: min(selectionIndex, newTextBuffer.length)));
  }
}
