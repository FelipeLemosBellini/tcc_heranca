import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    var newText = '';
    for (var i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        newText += '.';
      } else if (i == 9) {
        newText += '-';
      }
      newText += text[i];
    }

    final selectionIndex = newText.length;
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
