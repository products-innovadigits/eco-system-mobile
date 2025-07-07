import 'package:flutter/material.dart';

class DatePickerHelper {
  static Future<void> showDatePickerDialog(
      BuildContext context, Function(String) onDateSelected,
      {DateTime? initialDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      onDateSelected(
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}");
    }
  }
}
