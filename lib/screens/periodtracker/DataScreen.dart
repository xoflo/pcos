import 'dart:convert';
import 'dart:ui';
import 'package:thepcosprotocol_app/constants/secure_storage_keys.dart'
    as SecureStorageKeys;
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/LogRequestAPI.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/controllers/authentication_controller.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DataScreen extends StatefulWidget {
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  bool temperatureToggle = false;
  double tempValue = 0;
  TextEditingController tempController = TextEditingController();
  int cervicalMucusToggle = 0;
  int sexualIntercourseToggle = 0;
  int periodTrackingLogToggle = 0;
  int periodSpottingToggle = 0;

  List<int> symptomsToggle = [10];
  List<int> moodsToggle = [9];

  int energyTrackingToggle = 0;
  int progesteroneToggle = 0;

  final token = SecureStorageKeys.ACCESS_TOKEN;

  static const cream = Color(0xFFFCEDE0);
  static const green = Color(0xFF00504A);
  static const orange = Color(0xFFFF6600);
  static const sand = Color(0xFFEDB687);
  static const blue = Color(0xFF5B84E0);
  static const pink = Color(0xFFFFC6C2);
  static const red = Color(0xFFFB4A44);

  // List<Color> pallete = [orange, sand, blue, red, green];

  String dateNowDisplay = '';
  DateTime? dateSelected;


  @override
  void initState() {
    final DateTime now = DateTime.now();
    dateSelected = now;
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    dateNowDisplay = formatter.format(now);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onboardingBackground,
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.chevron_left, color: green)),
          backgroundColor: primaryColor,
          title: Text('Data Log', style: TextStyle(color: green))),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              dateTime(),
              temperature(),
              cervicalMucus(),
              sexualIntercourse(),
              periodTrackingLog(),
              progesteroneLog(),
              symptomTracking(),
              moodTracking(),
              energyTrackingLog()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveLog();
        },
        child: Icon(Icons.check),
        backgroundColor: red,
      ),
    );
  }

  saveLog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm Log Date?",
                      style: TextStyle(color: red),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Existing log on date will be overwritten",
                      style: TextStyle(color: Colors.grey),
                      textScaleFactor: 0.8,
                    ),
                  ],
                ),
              ),
              content: Container(
                height: 150,
                width: 100,
                child: Column(
                  children: [
                    Center(
                      child: InkWell(
                        child: Container(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            backgroundColor: pink,
                            child: Icon(
                              Icons.check,
                              color: red,
                              size: 30,
                            ),
                          ),
                        ),
                        onTap: () async {

                          Navigator.pop(context);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Container(
                                  height: 150,
                                  width: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: CircularProgressIndicator(
                                            color: green,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text("Updating Cycles...",
                                            style: TextStyle(color: green),
                                            textScaleFactor: 0.9)
                                      ],
                                    ),
                                  ),
                                ),
                              ));

                          await clearLogByDate();
                          print("ClearDate");
                          await recordLog();
                          print("RecordDate");
                          Navigator.pop(context);
                          GlobalPeriodLogAPI.instance.logRequestAPI.setStatus(false);
                          GlobalPeriodLogAPI.instance.logRequestAPI.initAPI();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: red,
                              content: Text(
                                "Log Successful",
                                style: TextStyle(color: Colors.white),
                              )));
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('$dateNowDisplay', style: TextStyle(color: red), textScaleFactor: 1.2)
                  ],
                ),
              ),
            ));
  }

  clearLog() {
    setState(() {
      temperatureToggle = false;
      cervicalMucusToggle = 0;
      sexualIntercourseToggle = 0;
      periodTrackingLogToggle = 0;
      periodSpottingToggle = 0;
      energyTrackingToggle = 0;
      progesteroneToggle = 0;
    });
  }

  Widget dateTime() {
    return InkWell(
      child: Text(
        '$dateNowDisplay',
        style: TextStyle(color: red, fontWeight: FontWeight.w700),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Container(
                    height: 150,
                    width: 150,
                    child: StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                      return ScrollDatePicker(
                        minimumDate: DateTime.utc(2000, 1, 1),
                        maximumDate: DateTime.utc(2060, 1, 1),
                        selectedDate: DateTime.parse("$dateSelected"),
                        locale: Locale('en'),
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            dateSelected = value;
                            print(dateSelected);
                            final DateFormat formatter =
                            DateFormat('dd MMMM yyyy');
                            dateNowDisplay = formatter.format(value);
                          });
                        },
                      );
                    },),
                  ),
              actions: [
                TextButton(onPressed: () {
                  this.setState(() {});
                  Navigator.pop(context);
                }, child: Text("Done", style: TextStyle(color: green),))
              ],
                ));
      },
    );
  }

  Widget temperature() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Temperature",
              style: TextStyle(fontSize: 40, color: green),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 150,
                  child: TextField(
                    controller: tempController,
                    onChanged: (value) {
                      try {
                        tempValue = double.parse(value);
                      } catch(e) {
                        tempValue = 0;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Value must be number"), backgroundColor: red));
                      }

                    },
                    maxLength: 7,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: green),
                      ),
                      hintText:
                          'ex: ${temperatureToggle == false ? 97.00 : 36.4}',
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Container(
                  height: 100,
                  width: 120,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        temperatureToggle = !temperatureToggle;
                      });
                    },
                    child: Card(
                      color: green,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              temperatureToggle == false ? "°F" : '°C',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 5),
                            Text(
                              temperatureToggle == false
                                  ? "Fahrenheit"
                                  : 'Celsius',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget cervicalMucus() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cervical Fluid",
                  style: TextStyle(fontSize: 40, color: green),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              backgroundColor: Colors.grey,
                              content: Container(
                                  width: 200,
                                  height: 200,
                                  child: Text(
                                      "Cervical fluid is not present, or is thick or creamy for most of your cycle (enter as 'no cervical fluid'). However, just before ovulation,\nor when our body is trying to ovulate this becomes wet, slippery and egg white consistency (enter as 'Have Cervical Fluid').")),
                            ));
                  },
                  child: Tooltip(
                    height: 40,
                    textAlign: TextAlign.center,
                    message:
                        "Cervical fluid is not present, or is thick or creamy for most of your cycle (enter as 'no cervical fluid'). However, just before ovulation,\nor when our body is trying to ovulate this becomes wet, slippery and egg white consistency (enter as 'Have Cervical Fluid').",
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.question_mark,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 60,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, i) {
                        return Container(
                          height: 60,
                          width: 150,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                cervicalMucusToggle = i;
                              });
                            },
                            child: Card(
                              color: i == cervicalMucusToggle ? green : cream,
                              child: Center(
                                  child: Text(
                                i == 0
                                    ? 'No Cervical Fluid'
                                    : i == 1
                                        ? 'Have Cervical Fluid'
                                        : 'None',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: cervicalMucusToggle == i
                                        ? cream
                                        : green),
                              )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget sexualIntercourse() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Sexual Intercourse",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 45, color: green),
            ),
            SizedBox(height: 20),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: Container(
                height: 130,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 80,
                      width: 80,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            sexualIntercourseToggle = i;
                          });
                        },
                        child: Card(
                          color: i == sexualIntercourseToggle ? green : cream,
                          child: Center(
                              child: Text(
                            i == 0
                                ? 'None'
                                : i == 1
                                    ? 'Protected'
                                    : i == 2
                                        ? 'Unprotected'
                                        : i == 3
                                            ? 'Insemination'
                                            : i == 4
                                                ? 'Withdrawal'
                                                : 'None',
                            style: TextStyle(
                                color: sexualIntercourseToggle == i
                                    ? cream
                                    : green),
                          )),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 160, crossAxisCount: 3),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget periodTrackingLog() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Period",
              style: TextStyle(fontSize: 40, color: green),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, i) {
                        return Container(
                          height: 30,
                          width: 80,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                periodTrackingLogToggle = i;
                              });
                            },
                            child: Card(
                              color:
                                  i == periodTrackingLogToggle ? green : cream,
                              child: Center(
                                  child: Text(
                                i == 0
                                    ? 'None'
                                    : i == 1
                                        ? 'Light'
                                        : i == 2
                                            ? 'Medium'
                                            : i == 3
                                                ? 'Heavy'
                                                : 'None',
                                style: TextStyle(
                                    color: periodTrackingLogToggle == i
                                        ? cream
                                        : green),
                              )),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      activeColor: red,
                      hoverColor: pink,
                      value: periodSpottingToggle == 0 ? false : true,
                      onChanged: (result) {
                        setState(() {
                          if (periodSpottingToggle == 0) {
                            periodSpottingToggle = 1;
                          } else {
                            periodSpottingToggle = 0;
                          }
                        });
                      }),
                  SizedBox(width: 10),
                  Text("Spotting",
                      style: TextStyle(
                          color: periodSpottingToggle == false ? pink : red,
                          fontSize: 15))
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget progesteroneLog() {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Progesterone Supplementation",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35, color: green),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, i) {
                      return Container(
                        height: 30,
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              progesteroneToggle = i;
                            });
                          },
                          child: Card(
                            color: i == progesteroneToggle ? green : cream,
                            child: Center(
                                child: Text(
                              i == 0
                                  ? 'No'
                                  : i == 1
                                      ? 'Yes'
                                      : 'None',
                              style: TextStyle(
                                  color:
                                      progesteroneToggle == i ? cream : green),
                            )),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          )
        ],
      );
    });
  }

  Widget symptomTracking() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Symptoms",
              style: TextStyle(fontSize: 40, color: green),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 340,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 9,
                      itemBuilder: (context, i) {
                        return Container(
                          height: 200,
                          width: 480,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (symptomsToggle.contains(i)) {
                                  symptomsToggle.remove(i);
                                  if (symptomsToggle.isEmpty) {
                                    symptomsToggle.add(10);
                                  }
                                } else {
                                  symptomsToggle.add(i);
                                  if (symptomsToggle.isNotEmpty) {
                                    symptomsToggle.remove(10);
                                  }
                                }
                              });
                            },
                            child: Card(
                              color: symptomsToggle.contains(i) ? green : cream,
                              child: Center(
                                  // Cramps, Breast Pain, Mood Changes, Irritability,Constipation, Diarrhea, Headache, Acne
                                  child: Text(
                                i == 0
                                    ? 'Cramps'
                                    : i == 1
                                        ? 'Breast Pain'
                                        : i == 2
                                            ? 'Mood Changes'
                                            : i == 3
                                                ? 'Irritability'
                                                : i == 4
                                                    ? 'Constipation'
                                                    : i == 5
                                                        ? 'Diarrhea'
                                                        : i == 6
                                                            ? 'Headache'
                                                            : i == 7
                                                                ? 'Acne'
                                                                : i == 8
                                                                    ? 'Bloating'
                                                                    : 'None',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: symptomsToggle.contains(i)
                                        ? cream
                                        : green),
                              )),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 110, crossAxisCount: 3),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  moodTracking() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          height: 400,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Moods",
                style: TextStyle(fontSize: 40, color: green),
              ),
              SizedBox(height: 20),
              Container(
                height: 300,
                width: 350,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  itemBuilder: (context, i) {
                    return Container(
                      height: 100,
                      width: 130,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (moodsToggle.contains(i)) {
                              moodsToggle.remove(i);
                              if (moodsToggle.isEmpty) {
                                moodsToggle.add(9);
                              }
                            } else {
                              moodsToggle.add(i);
                              if (moodsToggle.isNotEmpty) {
                                moodsToggle.remove(9);
                              }
                            }
                          });
                        },
                        child: Card(
                          color: moodsToggle.contains(i) ? green : cream,
                          child: Center(
                              // Cramps, Breast Pain, Mood Changes, Irritability,Constipation, Diarrhea, Headache, Acne
                              child: Text(
                            i == 0
                                ? '${Emoji.all()[59]} Anxious'
                                : i == 1
                                    ? '${Emoji.all()[71]} Apathetic'
                                    : i == 2
                                        ? '${Emoji.all()[30]} Chilled'
                                        : i == 3
                                            ? '${Emoji.all()[14]} Contented'
                                            : i == 4
                                                ? '${Emoji.all()[50]} Angry'
                                                : i == 5
                                                    ? '${Emoji.all()[1]} Happy'
                                                    : i == 6
                                                        ? '${Emoji.all()[34]} Irritable'
                                                        : i == 7
                                                            ? '${Emoji.all()[46]} Sad'
                                                            : i == 8
                                                                ? '${Emoji.all()[62]} Stressed'
                                                                : 'None',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: moodsToggle.contains(i) ? cream : green),
                          )),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 55, crossAxisCount: 2),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget energyTrackingLog() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          children: [
            Text(
              "Energy Levels",
              style: TextStyle(fontSize: 40, color: green),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, i) {
                  return Container(
                    height: 100,
                    width: 120,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          energyTrackingToggle = i;
                        });
                      },
                      child: Card(
                        color: i == energyTrackingToggle ? green : cream,
                        child: Center(
                            child: Text(
                          i == 0
                              ? 'Exhausted'
                              : i == 1
                                  ? 'Fatigued'
                                  : i == 2
                                      ? 'Flat'
                                      : i == 3
                                          ? 'Mediocre'
                                          : i == 4
                                              ? 'Reasonably Energetic'
                                              : i == 5
                                                  ? 'Energetic'
                                                  : 'None',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: energyTrackingToggle == i ? cream : green),
                        )),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150, crossAxisCount: 3),
              ),
            ),
            SizedBox(height: 60),
          ],
        );
      },
    );
  }

  recordLog() async {
    final url =
        'https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/periodtracker/record';

    final uri = Uri.parse(url);

    PeriodLog log = PeriodLog(
        temperatureToggle,
        temperatureToggle == false ? tempValue : null,
        temperatureToggle == true ? tempValue : null,
        cervicalMucusToggle,
        sexualIntercourseToggle,
        periodTrackingLogToggle,
        periodSpottingToggle,
        progesteroneToggle,
        energyTrackingToggle,
        symptomsToggle,
        moodsToggle,
        dateSelected);

    List<Map<String, dynamic>> body = log.toJSON();

    try {
      await AuthenticationController().getAccessToken().then((realToken) async {
        print(realToken);

        final response = await http.post(uri, body: jsonEncode(body), headers: {
          "Authorization": "Bearer $realToken",
          "Content-Type": "application/json"
        });

        if (response.statusCode == 200) {
          print('POST Success');
          print(response.body);
          print(response.headers);
          print('Response: ${response.headers}');
          clearLog();
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

  clearLogByDate() async {
    final from = dateSelected;
    final to = dateSelected!
        .add(Duration(hours: 23))
        .add(Duration(minutes: 59))
        .add(Duration(seconds: 59));

    print("to: $from");
    print("to: $to");

    List<Map<String, dynamic>> bodies = [
      {"TrackerName": "TEMPF", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "TEMPC", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "CM", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "SI", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "PRD", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "PRDS", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "PGS", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "ENR", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "SYMP", "DateFromUTC": "$from", "DateToUTC": "$to"},
      {"TrackerName": "MOOD", "DateFromUTC": "$from", "DateToUTC": "$to"},
    ];

    final url =
        'https://z-pcos-protocol-api-as-ae-pr.azurewebsites.net/api/periodtracker/bydaterange';

    final uri = Uri.parse(url);

    try {
      await AuthenticationController().getAccessToken().then((realToken) async {
        print(realToken);

        for (int i = 0; i < bodies.length; i++) {
          final response = await http.delete(uri,
              body: jsonEncode(bodies[i]),
              headers: {
                "Authorization": "Bearer $realToken",
                "Content-Type": "application/json"
              });

          if (response.statusCode == 200) {
            print('POST Success');
            print(response.body);
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
      });
    } catch (e) {
      print(e);
      return;
    }
  }
}
