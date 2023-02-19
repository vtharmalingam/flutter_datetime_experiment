import 'package:flutter/cupertino.dart';
import 'package:timezone/src/date_time.dart';

class MyDateTimePicker extends CupertinoDatePicker {
  MyDateTimePicker({
    required super.onDateTimeChanged,
    required TZDateTime initialDateTime,
    required bool use24hFormat,
  });
}
