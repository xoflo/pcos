import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    DateTime today = DateTime.now();
    return Column(
      children: [
        Text(DateTimeUtils.shortDate(myLocale.countryCode, today)),
        Text(DateTimeUtils.mediumDate(today)),
        Text(DateTimeUtils.longDate(today)),
        Text(DateTimeUtils.shortDay(today)),
        Text(DateTimeUtils.longDay(today)),
        Text(DateTimeUtils.shortDayMonth(today)),
        Text(DateTimeUtils.longDayMonth(today)),
        Text(DateTimeUtils.shortMonth(today)),
        Text(DateTimeUtils.longMonth(today)),
        Text(DateTimeUtils.year(today)),
      ],
    );
  }
}
