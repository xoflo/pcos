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
  List<int>? symptoms = [];
  List<int>? moods = [];
  DateTime? timestamp;

  List<Map<String, dynamic>> _entries = [];

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

  factory PeriodLog.fromJSON(List<Map<String, dynamic>> json) {

    double? tempf;
    double? tempc;
    int? cm;
    int? si;
    int? prd;
    int? prds;
    int? pgs;
    int? enr;
    List<int>? symp = [];
    List<int>? mood = [];



    for (int i = 0; i < json.length; i++) {

      if (json[i]['trackerName'] == 'TEMPF') {
        tempf = json[i]['trackerValue'];
        print("TempF: $tempf");
      }
      if (json[i]['trackerName'] == 'TEMPC') {
        tempc = json[i]['trackerValue'];
        print("TempC: $tempc");
      }
      if (json[i]['trackerName'] == 'CM') {
        double result = json[i]['trackerValue'];
        cm = result.toInt();
      }
      if (json[i]['trackerName'] == 'SI') {
        double result = json[i]['trackerValue'];
        si = result.toInt();
      }
      if (json[i]['trackerName'] == 'PRD') {
        double result = json[i]['trackerValue'];
        prd = result.toInt();
      }
      if (json[i]['trackerName'] == 'PRDS') {
        double result = json[i]['trackerValue'];
        prds = result.toInt();
      }
      if (json[i]['trackerName'] == 'PGS') {
        double result = json[i]['trackerValue'];
        pgs = result.toInt();
      }
      if (json[i]['trackerName'] == 'ENR') {
        enr = json[i]['trackerValue'].toInt();
      }
      if (json[i]['trackerName'] == 'SYMP') {
        double result = json[i]['trackerValue'];
        final toAdd = result.toInt();
        symp.add(toAdd);
      }
      if (json[i]['trackerName'] == 'MOOD') {
        double result = json[i]['trackerValue'];
        final toAdd = result.toInt();
        mood.add(toAdd);
      }

    }

    final realTimestamp = DateTime.parse(json[0]['trackerDateUTC']);

    return PeriodLog(
        null,
        tempf, // TEMPF
        tempc, // TEMPC
        cm, // CM
        si, // SI
        prd, // PRD
        prds, // PRDS
        pgs, // PGS
        enr, // ENR
        symp, // SYMP
        mood, // MOOD
        realTimestamp  //
    );
  }

  List<Map<String, dynamic>> toJSON() {
    _generateTemperatureInBothUnits();
    _generatePostRequestBody();
    return _entries;
  }

  _generatePostRequestBody() {

    if (temperatureF != null) {
      _entries.add({
        "TrackerName": "TEMPF",
        "TrackerValue": temperatureF,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (temperatureC != null) {
      _entries.add({
        "TrackerName": "TEMPC",
        "TrackerValue": temperatureC,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (cervicalMucus != null) {
      _entries.add({
        "TrackerName": "CM",
        "TrackerValue": cervicalMucus,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (sexualIntercourse != null) {
      _entries.add({
        "TrackerName": "SI",
        "TrackerValue": sexualIntercourse,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (period != null) {
      _entries.add({
        "TrackerName": "PRD",
        "TrackerValue": period,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (periodSpotting != null) {
      _entries.add({
        "TrackerName": "PRDS",
        "TrackerValue": periodSpotting,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (progesterone != null) {
      _entries.add({
        "TrackerName": "PGS",
        "TrackerValue": progesterone,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (energy != null) {
      _entries.add({
        "TrackerName": "ENR",
        "TrackerValue": energy,
        "TrackerDateUTC": "$timestamp"
      });
    }

    if (symptoms != null) {
      for (int i = 0; i < symptoms!.length; i++) {

        _entries.add({
          "TrackerName": "SYMP",
          "TrackerValue": symptoms![i],
          "TrackerDateUTC": "$timestamp"
        });

      }
    }

    if (moods != null) {
      for (int i = 0; i < moods!.length; i++) {

        _entries.add({
          "TrackerName": "MOOD",
          "TrackerValue": moods![i],
          "TrackerDateUTC": "$timestamp"
        });

      }
    }

  }


  _generateTemperatureInBothUnits() {
    if (temperatureF == null) {
      final c = Temperature(temperatureC!, 'C');
      temperatureF = c.valueIn('F').toDouble();
    }

    if (temperatureC == null) {
      final f = Temperature(temperatureF!, 'F');
      temperatureC = f.valueIn('C').toDouble();
    }

  }

}