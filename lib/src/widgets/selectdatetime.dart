import 'package:flutter/material.dart';

Future<DateTime?> selectDate(BuildContext context, DateTime initialDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    initialDatePickerMode: DatePickerMode.day,
    firstDate: DateTime(2015),
    lastDate: DateTime(2101),
  );

  return picked;
}

Future<TimeOfDay> selectTime(
    BuildContext context, TimeOfDay initialTime) async {
  final selected = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? Container(),
      );
    },
  );

  return selected ?? initialTime;
}
