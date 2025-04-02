import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  String get dateFormatted => DateFormat('dd/MM/yyyy').format(this);
}
