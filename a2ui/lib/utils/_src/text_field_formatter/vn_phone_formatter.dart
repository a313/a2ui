import 'package:flutter/services.dart';

class VietnamPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    String text = newValue.text;

    if (text.isEmpty) {
      return const TextEditingValue(
        text: '+84',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    String filteredText = text.replaceAll(RegExp(r'[^0-9+]'), '');

    if (filteredText.startsWith('0')) {
      filteredText = '+84${filteredText.substring(1)}';
    } else if (!filteredText.startsWith('+84')) {
      filteredText = '+84${filteredText.replaceAll('+84', '')}';
    } else if (filteredText.startsWith('+840')) {
      filteredText = '+84${filteredText.replaceAll('+840', '')}';
    }

    String numberPart = filteredText.substring(3);
    if (numberPart.length > 9) {
      numberPart = numberPart.substring(0, 9);
    }

    int oldSelectionOffset = newValue.selection.baseOffset;
    int numbersBeforeCursor =
        text
            .substring(0, oldSelectionOffset)
            .replaceAll(RegExp(r'[^0-9]'), '')
            .length;

    String formatted = '+84';
    if (numberPart.isNotEmpty) {
      formatted +=
          ' ${numberPart.substring(0, numberPart.length > 2 ? 2 : numberPart.length)}';
    }
    if (numberPart.length > 2) {
      formatted +=
          '-${numberPart.substring(2, numberPart.length > 5 ? 5 : numberPart.length)}';
    }
    if (numberPart.length > 5) {
      formatted += '-${numberPart.substring(5)}';
    }

    int newOffset = '+84'.length;
    int numbersAdded = 0;

    if (numbersBeforeCursor > 0) {
      newOffset++;
      numbersAdded = numbersBeforeCursor;

      if (numbersAdded <= 2) {
        newOffset += numbersAdded;
      } else if (numbersAdded <= 5) {
        newOffset += 3 + (numbersAdded - 2);
      } else {
        newOffset += 7 + (numbersAdded - 5);
      }
    }

    newOffset = newOffset.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
