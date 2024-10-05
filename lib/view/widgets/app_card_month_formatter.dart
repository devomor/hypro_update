import 'package:flutter/services.dart';

dynamic month; // Extracted month value
dynamic year;

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();

    List<String> parts = string.split('/');

    if (parts.length == 2) {
      month = parts[0]; // Extracted month value
      year = parts[1]; // Extracted year value

      print("Month: $month");
      print("Year: $year");
    } else {
      // Handle invalid input
      print("Invalid input");
    }

    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }

}