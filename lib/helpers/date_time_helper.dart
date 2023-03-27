import 'package:intl/intl.dart';

extension DateTimeHelper on DateTime {
  String get toCustomString {
    return DateFormat("hh:mm a (yyyy/M/dd)").format(this).replaceAll('AM', 'ص').replaceAll('PM', 'م');
  }
}