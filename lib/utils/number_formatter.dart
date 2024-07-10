import 'package:flutter/cupertino.dart';

TextEditingValue floatsOnly(final TextEditingValue oldValue, final TextEditingValue newValue) {
  if (newValue.text.isEmpty || newValue.text == '-') {
    return newValue;
  } else {
// Check if the input can be parsed into an Int and returns the previous input otherwise.
    final double? newVal = double.tryParse(newValue.text);
    if (newVal == null) {
      return oldValue;
    } else {
      return newValue;
    }
  }
}

TextEditingValue positiveFloats(final TextEditingValue oldValue, final TextEditingValue newValue) {
  if (newValue.text.isEmpty) {
    return newValue;
  } else {
// Check if the input can be parsed into an Int and returns the previous input otherwise.
    final double? newVal = double.tryParse(newValue.text);
    if (newVal == null) {
      return oldValue;
    } else {
      return newValue;
    }
  }
}