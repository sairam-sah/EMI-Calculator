import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter{
    final NumberFormat _formatter = NumberFormat('#,###');

    @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters.
    String numericString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numericString.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
    // Parse the string to integer.
    int? number = int.tryParse(numericString);
    if (number == null) {
      return newValue;
    }
    
    // Format the number with commas.
    String formatted = _formatter.format(number);
    
    // Return the formatted text with the cursor at the end.
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
