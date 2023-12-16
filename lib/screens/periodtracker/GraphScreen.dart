import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'LogHandler.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen({required this.cycle});

   List<PeriodLog>? cycle = [];

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  String dateNow = '';


  bool tempToggle = false;
  bool rotateToggle = false;

  int lengthInDays = 0;


  static const cream = Color(0xFFFCEDE0);
  static const green = Color(0xFF00504A);
  static const orange = Color(0xFFFF6600);
  static const sand = Color(0xFFEDB687);
  static const blue = Color(0xFF5B84E0);
  static const pink = Color(0xFFFFC6C2);
  static const red = Color(0xFFFB4A44);


  buildBody() async {

    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void initState() {
    lengthInDays = widget.cycle!.first.timestamp!.compareTo(widget.cycle!.last.timestamp!).abs();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onboardingBackground,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(child: Icon(Icons.chevron_left, color: green), onTap: () {
          Navigator.pop(context);
        }),
        title: Text("${DateFormat.MMMMd().format(widget.cycle!.first.timestamp!)} - ${DateFormat.MMMMd().format(widget.cycle!.last.timestamp!)}", style: TextStyle(color: green)),
      ),
      body: FutureBuilder(
        future: buildBody(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {


        return snapshot.connectionState == ConnectionState.done ?  Container(
          child: Center(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      title(),
                      graph(),
                      toggleTemperature(),
                      toggleOrientation(),
                      dataSheet(0),
                      exportGraph()
                    ],
                  )
              ),
            ),
          ),
        ) : Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: green,
            ),
          ),
        );
      },
      )
    );
  }
  
  exportGraph() {
    ScreenshotController controller = ScreenshotController();
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final thisSheet = dataSheet(1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: Container(
        height: 30,
        child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => green)),
            onPressed: () async {

          final image = await controller.captureFromWidget(Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height:40),
                  title(),
                  graph(),
                  Container(
                    height: 500,
                    width: 125 * widget.cycle!.length.toDouble(),
                    child: thisSheet,
                  )
                ],
              )), delay: Duration(seconds: 2), pixelRatio: pixelRatio, context: context, targetSize: Size(125 * widget.cycle!.length.toDouble(), 1200));
          final result = await ImageGallerySaver.saveImage(image);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Graph saved to Photos')));

        }
        , child: Text("Export Graph to Photos")),
      ),
    );
  }
  
  toggleTemperature() {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => sand)),
        onPressed: () {
          setState(() {
            tempToggle = !tempToggle;
          });
        }, child: Text("Temperature (${tempToggle == false ? 'Celsius' : 'Fahrenheit'})"));
  }
  
  toggleOrientation() {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) => sand)),

        onPressed: (){
          setState(() {
            rotateToggle == false ? SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
            ]) : SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp]);

            rotateToggle = !rotateToggle;
          });
        }, child: Text("${rotateToggle == false ? 'Landscape View' : 'Portrait View'}"));
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text("Cycle Graph", style: TextStyle(fontSize: 40, color: green),),
        )
      ],
    );
  }

  Widget graph() {

    List<FlSpot> spots = [];

    // For each day of the cycle length, check PeriodLog to assign to a day of the cycle length.

    for (int i = 0; i < widget.cycle!.length; i++) {

      print("C: ${widget.cycle![i].temperatureC}");
      print("F: ${widget.cycle![i].temperatureF}");
      spots.add(FlSpot(i.toDouble() + 1, tempToggle == false ? widget.cycle![i].temperatureC! : widget.cycle![i].temperatureF!));

    }






    final border = FlBorderData(show: false);

    final grid =
        FlGridData(drawHorizontalLine: true, drawVerticalLine: true);

    final titles = FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: Text("Cycle Log Days", style: TextStyle(color: green)),
            sideTitles: SideTitles(
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: meta.formattedValue.contains('.') ? Text(
                      "",
                      style: TextStyle(color: Colors.grey),
                    ) : Text(
                      meta.formattedValue,
                      style: TextStyle(color: Colors.grey),
                    ));
                },
                showTitles: true,
                reservedSize: 25)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          axisNameWidget: Text("°C", style: TextStyle(color: green)),
            axisNameSize: 25,
            sideTitles: SideTitles(
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    fitInside: SideTitleFitInsideData(enabled: true, axisPosition: 1, parentAxisSize: 1, distanceFromEdge: 1),
                    axisSide: meta.axisSide,
                    child: meta.formattedValue.contains('.') ? Text(
                      "",
                      style: TextStyle(color: Colors.grey),
                    ) : Text(
                  meta.formattedValue,
                  style: TextStyle(color: Colors.grey),
                  ));
                },
                showTitles: true,
                reservedSize: 35)));

    /*
    Container(
          height: 400,
          width: 100,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, i) {
                return Container(
                    color: i == 0
                        ? cream
                        : i == 1
                        ? Colors.grey
                        : i == 2
                        ? red
                        : Colors.white,
                    height: 130,
                    width: 40,
                    child: Center(
                      child: Text(i == 0
                          ? "Has\nCervical\nMucus"
                          : i == 1
                          ? "None"
                          : i == 2
                          ? "Menstruation"
                          : "none", textAlign: TextAlign.center,),
                    ));
              }),
        ),
     */


    return Container(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 400,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 370,
                  width: widget.cycle!.length.toDouble() * 125,
                  child: LineChart(
                      LineChartData(

                          lineTouchData: LineTouchData(enabled: false),
                          borderData: border,
                          gridData: grid,
                          titlesData: titles,
                          minX: 1,
                          maxX: widget.cycle!.length.toDouble(),
                          minY: tempToggle == false ? 34 : 93.2,
                          maxY: tempToggle == false ? 39 : 102.2,
                          lineBarsData: [
                            LineChartBarData(
                                spots: spots,
                                show: true,
                                color: green,
                                dotData: FlDotData(
                                    getDotPainter: (
                                        FlSpot spot,
                                        double xPercentage,
                                        LineChartBarData bar,
                                        int index, {
                                          double? size,
                                        }) {
                                      return FlDotCirclePainter(
                                        radius: size,
                                        color: green,
                                        strokeColor: Colors.white,
                                      );
                                    }

                                )

                            )
                          ])),
                )),
          ),
        ),
      ),
    );
  }

  Widget dataSheet(int forExport) {

    print("line1");



    final logHandler = LogHandler();

    List<DataColumn> columnTitle = [
      DataColumn(label: Text('Log Days')),
    ];

    List<DataRow> rowTitle = [

      DataRow(cells: [
        DataCell(Text("Date", textScaleFactor: 0.8,)),
      ]),
      DataRow(cells: [
        DataCell(Text("Sexual Intercourse", textScaleFactor: 0.8,)),
      ]),
      DataRow(cells: [
        DataCell(Text("Period", textScaleFactor: 0.8)),
      ]),
      DataRow(cells: [
        DataCell(Text("Progesterone", textScaleFactor: 0.8)),
      ]),
      DataRow(cells: [
        DataCell(Text("Moods", textScaleFactor: 0.8)),
      ]),
      DataRow(cells: [
        DataCell(Text("Symptoms", textScaleFactor: 0.8)),
      ]),
      DataRow(cells: [
        DataCell(Text("Energy Levels", textScaleFactor: 0.8)),
      ]),
      DataRow(cells: [
        DataCell(Text("Cervical Mucus", textScaleFactor: 0.8)),
      ]),
    ];


    List<DataColumn> columnData = [];

    for (int i = 0; i < widget.cycle!.length; i++) {

      print("line2");

      columnData.add(DataColumn(label: Text('${i+1}', style: TextStyle(fontWeight: FontWeight.w400))));
    }


    List<DataRow> rowData = [
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
      DataRow(cells: []),
    ];



    print("line3");

    for (int x = 0; x < widget.cycle!.length; x++) {

      DateTime date = widget.cycle![x].timestamp!;
      final cycleDayTimestamp = DateFormat('yyyy-MM-dd').format(date);

      PeriodLog log = widget.cycle![x];

      final logTimestamp = DateFormat('yyyy-MM-dd').format(log.timestamp!);

      print("logTime: ${logTimestamp}");
      print("cycleDaysTime: $cycleDayTimestamp");

      if (logTimestamp == cycleDayTimestamp) {



        print("line4");
        print(DateFormat.MMMd().format(log.timestamp!));

        // 0 Month & Day
        rowData[0].cells.add(DataCell(Text('${DateFormat.MMMd().format(log.timestamp!)}', style: TextStyle(fontSize: 10),),));

        // 1 Cervical Mucus
        rowData[7].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleCM(forExport, log.cervicalMucus!),
        )));

        // 2 Sexual Intercourse
        rowData[1].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleSI(forExport, log.sexualIntercourse!),
        )));

        // 3 Period
        rowData[2].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handlePeriod(forExport, log.period!, log.periodSpotting!),
        )));

        // 4 Progesterone
        rowData[3].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleProgesterone(forExport, log.progesterone!),
        )));

        // 5 Moods
        rowData[4].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleMood(forExport, log.moods!),
        )));

        // 6 Symptoms
        rowData[5].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleSymptoms(forExport, log.symptoms!),
        )));

        // 7 Energy Levels
        rowData[6].cells.add(DataCell(Container(
          height: 5,
          width: 5,
          child: logHandler.handleEnr(forExport, log.energy!),
        )));


      } else {


        rowData[0].cells.add(DataCell(Container(
            height: 5,
            width: 5,
            child: Text('${DateFormat.MMMd().format(log.timestamp!)}'
            )),
        ));
        rowData[1].cells.add(DataCell(Text("")));
        rowData[2].cells.add(DataCell(Text("")));
        rowData[3].cells.add(DataCell(Text("")));
        rowData[4].cells.add(DataCell(Text("")));
        rowData[5].cells.add(DataCell(Text("")));
        rowData[6].cells.add(DataCell(Text("")));
        rowData[7].cells.add(DataCell(Text("")));
      }
    }


    print("COLUMNDATA:");
    print(columnData.length);

    print("ROWDATA:");
    print("1: ${rowData[0].cells.length}");
    print("2: ${rowData[1].cells.length}");
    print("3: ${rowData[2].cells.length}");
    print("4: ${rowData[3].cells.length}");
    print("5: ${rowData[4].cells.length}");
    print("6: ${rowData[5].cells.length}");
    print("7: ${rowData[6].cells.length}");
    print("8: ${rowData[7].cells.length}");



    print("line5");

    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [

          Container(
            width: 120,
            child: DataTable(columns: columnTitle, rows: rowTitle),
          ),

          ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: Container(
                width: forExport == 1 ? 800 : 250,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 20,
                        columns: columnData, rows: rowData)),
              )),


        ],
      ),
    );


  }

}




