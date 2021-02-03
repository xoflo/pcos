import 'package:intl/intl.dart';

class DateTimeUtils {
  static String shortDate(String countryCode, DateTime dateTime) {
    final String dateFormat = countryCode == "US" ? "MM-dd-yyyy" : "dd-MM-yyyy";
    return DateFormat(dateFormat).format(dateTime.toLocal());
  }

  static String mediumDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime.toLocal());
  }

  static String longDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime.toLocal());
  }

  static String shortDayMonth(DateTime dateTime) {
    return DateFormat('dd MMM').format(dateTime.toLocal());
  }

  static String longDayMonth(DateTime dateTime) {
    return DateFormat('dd MMMM').format(dateTime.toLocal());
  }

  static String shortMonth(DateTime dateTime) {
    return DateFormat('MMM').format(dateTime.toLocal());
  }

  static String longMonth(DateTime dateTime) {
    return DateFormat('MMMM').format(dateTime.toLocal());
  }

  static String shortDay(DateTime dateTime) {
    return DateFormat('EEE').format(dateTime.toLocal());
  }

  static String longDay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime.toLocal());
  }

  static String year(DateTime dateTime) {
    return DateFormat('yyyy').format(dateTime.toLocal());
  }

  static int convertMillisecondsToMinutes(final int millSeconds) {
    return (millSeconds / 60000000).round();
  }
}
