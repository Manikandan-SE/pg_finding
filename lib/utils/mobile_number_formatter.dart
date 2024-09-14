import 'package:flutter/services.dart';

class MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty || (RegExp(r'^[6-9]\d{0,9}$').hasMatch(text))) {
      return newValue;
    }

    return oldValue;
  }
}
