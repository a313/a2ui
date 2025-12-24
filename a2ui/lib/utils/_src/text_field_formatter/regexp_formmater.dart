import 'package:flutter/services.dart';

class RegExpFormatter extends TextInputFormatter {
  final String regString;

  RegExpFormatter(this.regString);
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp(regString);
    final oldText = newValue.text;
    final selection = newValue.selection;

    int removedBeforeSelection = 0;
    int cursorPos = selection.baseOffset;
    int diff = 0;
    int i = 0;
    StringBuffer buffer = StringBuffer();

    while (i < oldText.length) {
      final match = regExp.matchAsPrefix(oldText, i);
      if (match != null) {
        if (i < cursorPos) {
          int matchEnd = match.end;
          if (matchEnd <= cursorPos) {
            removedBeforeSelection += matchEnd - i;
          } else {
            removedBeforeSelection += cursorPos - i;
          }
        }
        i = match.end;
      } else {
        buffer.write(oldText[i]);
        i++;
      }
    }
    final filteredText = buffer.toString();
    final newCursorPos = (cursorPos - removedBeforeSelection).clamp(
      0,
      filteredText.length,
    );
    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }
}
