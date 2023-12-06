import 'dart:convert';
import 'package:converter/converter.dart';

class PeriodLog {
  bool? temperatureToggle;
  double? temperatureF;
  double? temperatureC;
  int? cervicalMucus;
  int? sexualIntercourse;
  int? period;
  int? periodSpotting;
  int? progesterone;
  int? energy;
  List<int>? symptoms;
  List<int>? moods;
  DateTime? timestamp;

  List<Map<String, dynamic>> _entries = [];
  String date = DateTime.now().toString();

  PeriodLog(
      this.temperatureToggle,
      this.temperatureF,
      this.temperatureC,
      this.cervicalMucus,
      this.sexualIntercourse,
      this.period,
      this.periodSpotting,
      this.progesterone,
      this.energy,
      this.symptoms,
      this.moods,
      this.timestamp
      );

  factory PeriodLog.fromJSON(dynamic json) {

    return PeriodLog(
        null,
        json[0]['trackerValue'], // TEMPF
        json[1]['trackerValue'], // TEMPC
        json[2]['trackerValue'], // CM
        json[3]['trackerValue'], // SI
        json[4]['trackerValue'], // PRD
        json[5]['trackerValue'], // PRDS
        json[6]['trackerValue'], // PGS
        json[7]['trackerValue'], // ENR
        json[8]['trackerValue'], // SYMP
        json[9]['trackerValue'], // MOOD
        DateTime.parse(json[0]['trackerDateUTC']) //
    );
  }

  List<Map<String, dynamic>> toJSON() {
    _generatePostRequestBody();
    return _entries;
  }

  _generatePostRequestBody() {
    _generateTemperatureInBothUnits();

    if (temperatureF != null) {
      _entries.add({
        "TrackerName": "TEMPF",
        "TrackerValue": temperatureF,
        "TrackerDateUTC": "$date"
      });
    }

    if (temperatureC != null) {
      _entries.add({
        "TrackerName": "TEMPC",
        "TrackerValue": temperatureC,
        "TrackerDateUTC": "$date"
      });
    }

    if (cervicalMucus != null) {
      _entries.add({
        "TrackerName": "CM",
        "TrackerValue": cervicalMucus,
        "TrackerDateUTC": "$date"
      });
    }

    if (sexualIntercourse != null) {
      _entries.add({
        "TrackerName": "SI",
        "TrackerValue": sexualIntercourse,
        "TrackerDateUTC": "$date"
      });
    }

    if (period != null) {
      _entries.add({
        "TrackerName": "PRD",
        "TrackerValue": period,
        "TrackerDateUTC": "$date"
      });
    }

    if (periodSpotting != null) {
      _entries.add({
        "TrackerName": "PRDS",
        "TrackerValue": periodSpotting,
        "TrackerDateUTC": "$date"
      });
    }

    if (progesterone != null) {
      _entries.add({
        "TrackerName": "PGS",
        "TrackerValue": progesterone,
        "TrackerDateUTC": "$date"
      });
    }

    if (energy != null) {
      _entries.add({
        "TrackerName": "ENR",
        "TrackerValue": energy,
        "TrackerDateUTC": "$date"
      });
    }

    if (symptoms != null) {
      for (int i = 0; i < symptoms!.length; i++) {

        _entries.add({
          "TrackerName": "SYMP",
          "TrackerValue": symptoms![i],
          "TrackerDateUTC": "$date"
        });

      }
    }

    if (moods != null) {
      for (int i = 0; i < moods!.length; i++) {

        _entries.add({
          "TrackerName": "MOOD",
          "TrackerValue": moods![i],
          "TrackerDateUTC": "$date"
        });

      }
    }

  }


  _generateTemperatureInBothUnits() {
    if (temperatureToggle == false) {
      final c = Temperature(temperatureC!, 'C');
      temperatureF = c.valueIn('F').toDouble();
    } else {
      final f = Temperature(temperatureF!, 'F');
      temperatureF = f.valueIn('C').toDouble();
    }
  }

}