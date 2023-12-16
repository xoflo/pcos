import 'package:http/http.dart' as http;
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'dart:convert';
import '../../controllers/authentication_controller.dart';


class GlobalPeriodLogAPI {

  GlobalPeriodLogAPI._init();

  // Singleton instance variable
  static final GlobalPeriodLogAPI _instance = GlobalPeriodLogAPI._init();

  // Getter to access the instance
  static GlobalPeriodLogAPI get instance => _instance;

  // Add properties or methods for your Singleton
  LogRequestAPI logRequestAPI = LogRequestAPI();

  init() async {
    if (logRequestAPI.initStatus == false) {
      await logRequestAPI.initAPI();
    }
    return;

  }

  Future<bool> getStatus() async {
    return logRequestAPI.initStatus;
  }
}




class LogRequestAPI {
  List<PeriodLog> responses = [];
  List<int> years = [];
  Map<String, List<PeriodLog>>? responsesByYear;
  Map<String, dynamic>? responsesInYearByMonth;
  Map<String, dynamic>? cyclesInAYear;
  String? token = '';

  String dateNow = DateTime.now().toUtc().toString();

  bool initStatus = false;

  Future<void> initAPI() async {
    token = await AuthenticationController().getAccessToken();
    print(token);

    try {
      await _retrieveRequest().then((value) async {
        await _getYears().then((value) async {
          await _getResponsesByYear().then((value) async {
            await _getCyclesInAYear();
            initStatus = true;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  deleteData() async {
    final url =
        'https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/periodtracker/2';
    final uri = Uri.parse(url);

    final response = await http.delete(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      print('DELETE Success');

      print(jsonDecode(response.body)['payload'][0]);

      print(response.headers);
      print('Response: ${response.headers}');
    } else {
      print("Failed to make DELETE");
      print(response.body);
      print(response.headers);
      print(response.bodyBytes);
      print(response.reasonPhrase);
    }
  }

  Future<void> _retrieveRequest() async {
    List<PeriodLog> responsesHere = [];
    List<DateTime> datesOfRecord = [];

    try {
      final url =
          'https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/periodtracker/search';
      final uri = Uri.parse(url);

      print('Line1');
      List<Map<String, dynamic>> _entries = _generateRequests(
          DateTime.parse("2023-12-16 00:00:00"), DateTime.now());

      print("Line2");

      for (int i = 0; i < _entries.length; i++) {
        print("first _entries: ${_entries[i]}");

        final response = await http.post(uri,
            body: jsonEncode(_entries[i]),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json"
            });

        if (response.statusCode == 200) {
          print('POST Success');

          final List<dynamic> result =
              await jsonDecode(response.body)['payload'];

          print(result);

          result.forEach((element) {
            print(element['trackerDateUTC']);
            datesOfRecord.add(DateTime.parse(element['trackerDateUTC']));
          });

          print(await jsonDecode(response.body));
          print(response.headers);
          print('Response: ${response.headers}');
        } else {
          print("Failed to make POST");
          print(response.body);
          print(response.headers);
          print(response.bodyBytes);
          print(response.reasonPhrase);
        }
      }

      print("Line3");

      print("datesOfRecord: $datesOfRecord");

      List<DateTime> logDates = datesOfRecord.toSet().toList();

      print("logDates: $logDates");

      for (int i = 0; i < logDates.length; i++) {
        print("inside forLoop logDates: ${logDates[i]}");

        List<Map<String, dynamic>> results = [];

        List<Map<String, dynamic>> _entries =
            _generateRequests(logDates[i], logDates[i]);

        _entries.forEach((entry) async {
          print("second_entry $entry");

          final response = await http.post(uri,
              body: jsonEncode(entry),
              headers: {
                "Authorization": "Bearer $token",
                "Content-Type": "application/json"
              });

          if (response.statusCode == 200) {
            print('POST Success');

            final List<dynamic> result = await jsonDecode(response.body)['payload'];

            print(result);

            for (int z = 0; z < result.length; z++) {

              results.add(result[z]);
            }

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

        await Future.delayed(Duration(seconds: 2));

        print("Line4");

        PeriodLog periodLogFromJSON = await PeriodLog.fromJSON(results);

        responsesHere.add(periodLogFromJSON);
      }

      responsesHere.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

      responses = responsesHere;

      print("Line 5");

      print(responses);
    } catch (e) {
      print(e);
    }
  }

  _generateRequests(DateTime from, DateTime to) {
    List<Map<String, dynamic>> _entries = [];

    _entries.add(
        {"TrackerName": "TEMPF", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "TEMPC", "DateFromUTC": "$from", "DateToUTC": "$to"});



    _entries
        .add({"TrackerName": "CM", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries
        .add({"TrackerName": "SI", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "PRD", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "PRDS", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "PGS", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "ENR", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "SYMP", "DateFromUTC": "$from", "DateToUTC": "$to"});

    _entries.add(
        {"TrackerName": "MOOD", "DateFromUTC": "$from", "DateToUTC": "$to"});

    return _entries;
  }

  Future<void> _getYears() async {
    print("getYearsStart");

    List<int> allLogYears = [];

    for (int i = 0; i < responses.length; i++) {
      allLogYears.add(responses[i].timestamp!.year);
    }

    years = allLogYears.toSet().toList();

    return;
  }

  Future<void> _getResponsesByYear() async {
    print("GetResponsesByYearStart");

    Map<String, List<PeriodLog>> responsesByYearHere = {};

    for (int i = 0; i < years.length; i++) {
      print(years[i]);

      List<PeriodLog> results = [];

      responses.forEach((log) {
        if (log.timestamp!.year == years[i]) {
          print(log.timestamp!.year);
          results.add(log);
        }
      });

      Map<String, List<PeriodLog>> newYear = {"${years[i]}": results};

      responsesByYearHere.addEntries(newYear.entries);
    }

    print("Line 1");

    responsesByYear = responsesByYearHere;

    print(responsesByYear);

    return;
  }

  Future<void> _getResponsesByMonths() async {
    print("getResponsesByMonthsStart");

    Map<String, dynamic> responsesInYearByMonthHere = {};
    print("line1");

    print("years: ${years}");

    for (int i = 0; i < years.length; i++) {
      List<PeriodLog>? logs = responsesByYear!["${years[0]}"];
      print("line2");

      dynamic months = [];

      for (int x = 1; x < 13; x++) {
        final dynamic result =
            logs?.where((response) => response.timestamp!.month == x).toList();

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
        }

        months.add({
          '$month': result,
        });
      }

      final newYearWithMonths = {"${years[i]}": months};

      responsesInYearByMonthHere.addEntries(newYearWithMonths.entries);

      print("line3");
    }

    responsesInYearByMonth = responsesInYearByMonthHere;

    print(responsesInYearByMonth);
  }

  _getCyclesInAYear() async {
    print("getCyclesInAYearStart");

    Map<String, List<List<PeriodLog>>> cyclesInAYearHere = {};

    print("line1");
    for (int i = 0; i < years.length; i++) {
      List<PeriodLog>? logs = responsesByYear?["${years[i]}"];

      print("logs: $logs");

      print("logsLength: ${logs?.length}");

      int? length = logs?.length;

      List<PeriodLog> cycles = [];

      print("line2");
      print(length);

      for (int z = 0; z < length!; z++) {
        print("period: ${logs![z].period}");
        print(z);
        if (logs[z].period != 0) {
          print("periodNotZero: ${logs[z].period}");
          cycles.add(logs[z]);
        }
      }

      List<List<PeriodLog>> listOfCycles = [];

      List<PeriodLog>? ongoingCycle = [];

      print("line3");
      for (int y = 0; y < cycles.length; y++) {
        print("insideLoop: ${cycles[y].timestamp}");

        try {

          print("Bool: ${cycles[y].timestamp!.compareTo(cycles[y + 1].timestamp!) > 6}");



          if (cycles[y].timestamp!.compareTo(cycles[y + 1].timestamp!) >= 7) {

            ongoingCycle.clear();

            List<PeriodLog>? newCycle = logs
                ?.where((log) => log.timestamp!.isBefore(cycles[y].timestamp!))
                .toList();


            newCycle?.add(cycles[y]);
            listOfCycles.add(newCycle!);
          } else {

            print("else");


            print("Line2");
            ongoingCycle.add(cycles[y]);
            print("Line5");

          }

        } catch(e) {

          ongoingCycle.add(cycles[y]);
        }

      }

      print("Line6");
      listOfCycles.add(ongoingCycle);
      print("Line7");

      await Future.delayed(Duration(seconds: 4));

      print("ListOfCycles: $listOfCycles");

      Map<String, List<List<PeriodLog>>> newYearWithCycles = {
        '${years[i]}': listOfCycles
      };

      print("line4");
      cyclesInAYearHere.addEntries(newYearWithCycles.entries);
    }

    print(cyclesInAYearHere);

    cyclesInAYear = cyclesInAYearHere;
    await Future.delayed(Duration(seconds: 2));

    print("line5");

    print(cyclesInAYear);

    return;
  }
}
