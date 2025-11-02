import 'package:flutter/services.dart';

typedef StringMaskFormatter = String Function(String rawDigits);

typedef MaskValidator = bool Function(String rawDigits);

class MaskedInputFormatter extends TextInputFormatter {
  final StringMaskFormatter maskFormatter;
  final MaskValidator? validator;
  final int? maxLength;

  MaskedInputFormatter({
    required this.maskFormatter,
    this.validator,
    this.maxLength,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (maxLength != null && digits.length > maxLength!) {
      digits = digits.substring(0, maxLength!);
    }
    final formatted = maskFormatter(digits);
    final selectionIndex = formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
