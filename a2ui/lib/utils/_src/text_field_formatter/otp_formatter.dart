import 'dart:math';
import 'package:flutter/services.dart';

class OTPInputFormatter extends TextInputFormatter {
  final int maxLengh;

  OTPInputFormatter({this.maxLengh = 6});

  @override
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newTextBuffer = StringBuffer();
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    int newTextLength = 0;
    if (newValue.text.length > maxLengh) {
      return oldValue;
    }
    newTextLength = min(newValue.text.length, maxLengh);

    if (newTextLength >= 4) {
      newTextBuffer.write(
          '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 3)} ');
      if (newValue.selection.end >= 3) selectionIndex++;
    }
    if (newTextLength >= 7) {
      newTextBuffer.write(
          '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 6)} ');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 10) {
      newTextBuffer.write(
          '${newValue.text.substring(usedSubstringIndex, usedSubstringIndex = 9)} ');
      if (newValue.selection.end >= 9) selectionIndex++;
    }
    if (newTextLength > usedSubstringIndex) {
      newTextBuffer
          .write(newValue.text.substring(usedSubstringIndex, newTextLength));
    }
    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
