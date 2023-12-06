import 'package:http/http.dart' as http;
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'dart:convert';
import '../../controllers/authentication_controller.dart';

class LogRequestAPI {
  
  

  final _dateNow = DateTime.now().toString();
  List<Map<String, dynamic>> _entries = [];


  List<PeriodLog> _responses = [];

  retrieveRequest() async {

    final url = 'https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/periodtracker/search';
    final uri = Uri.parse(url);

    print(_dateNow);
    _generateRequests();


    for (int i = 0; i < _entries.length; i++) {
      Map<String, dynamic> body = _entries[i];


      try {
        await AuthenticationController().getAccessToken().then((realToken) async {
          print(realToken);

          final response = await http.post(uri, body: jsonEncode(body), headers: {
            "Authorization": "Bearer $realToken",
            "Content-Type" : "application/json"
          }
          );

          if (response.statusCode == 200) {
            print('POST Success');
            _responses.add(PeriodLog.fromJSON(jsonDecode(response.body)['payload'][0]));
            print(response.headers);
            print('Response: ${response.headers}');
          } else {
            print("Failed to make POST");
            print(response.body);
            print(response.headers);
            print(response.bodyBytes);
            print(response.reasonPhrase);
          }
        });
      } catch (e) {
        print(e);
        return;
      }
    }


    _responses.sort((a,b) => a.timestamp!.compareTo(b.timestamp!));
    
    return _responses;

  }


  _generateRequests() {
    _entries.add({
      "TrackerName" : "TEMPF",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "TEMPC",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "CM",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "SI",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "PRD",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "PRDS",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "PGS",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "ENR",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "SYMP",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });


    _entries.add({
      "TrackerName" : "MOOD",
      "DateFromUTC": "2023-11-14 13:00:00",
      "DateToUTC": "$_dateNow"
    });

    return _entries;

  }
  
  
  
  getYears() async {

    List<int> allLogYears = [];
    List<int> years = [];

    for (int i = 0; i < _responses.length; i++) {
      allLogYears.add(_responses[i].timestamp!.year);
    }

    years = allLogYears.toSet().toList();
    await Future.delayed(Duration(seconds: 2));

    return years;
  }

  getResponsesByYear() async {

    List<Map<String, List<PeriodLog>>> responsesByYear = [];
    List<int> years = await getYears();


    for (int i = 0; i < years.length; i++) {

      List<PeriodLog> results = [];

      _responses.forEach((log) {

        if (log.timestamp!.year == years[i]) {
          results.add(log);
        }

      });

      responsesByYear.add({"${years[i]}": results});
    }

    await Future.delayed(Duration(seconds: 3));
    return responsesByYear;


  }

  getResponsesByMonths() async {
    List<Map<String,
        List<PeriodLog>>> responsesByYearFunc = getResponsesByYear();
    List<int> years = await getYears();

    List<Map<String, dynamic>> responsesInMonthByYear = [];


    for (int i = 0; i < years.length; i++) {
      List<PeriodLog> logs = responsesByYearFunc[years[i]].values.first;


      List<Map<String, List<PeriodLog>>> months = [];


      for (int x = 1; x < 13; x++) {

        final dynamic result = logs.where((response) => response.timestamp!.month == x);

        String month = '';

        switch (x) {
          case 1:
          month = 'January';
          break;
          case 2:
            month = 'February';
            break;
          case 3:
            month = 'March';
            break;
          case 4:
            month = 'April';
            break;
          case 5:
            month = 'May';
            break;
          case 6:
            month = 'June';
            break;
          case 7:
            month = 'July';
            break;
          case 8:
            month = 'August';
            break;
          case 9:
            month = 'September';
            break;
          case 10:
            month = 'October';
            break;
          case 11:
            month = 'November';
            break;
          case 12:
            month = 'December';
            break;

        };


        months.add({
          '$month': result,
        });
      }

      responsesInMonthByYear.add({
        '${years[i]}' : months
      });

    }

    return responsesInMonthByYear;


  }


  getCyclesInAYear() async {
    List<Map<String,
        List<PeriodLog>>> responsesByYearFunc = getResponsesByYear();
    List<int> years = await getYears();


    for (int i = 0; i < years.length; i++) {
      List<PeriodLog> logs = responsesByYearFunc[years[i]].values.first;

      for (int x = 0; x < logs.length; x++) {

        if (logs[x].timestamp!.difference(logs[x+1].timestamp!) < Duration(days: 7)) {
        }
      }

    }
  }

  
  
  
}