import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  String get dateFormatted => DateFormat('dd/MM/yyyy').format(this);

  String get dateTimeFormatted => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String formatDateWithHour({String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(this);
  }
}
