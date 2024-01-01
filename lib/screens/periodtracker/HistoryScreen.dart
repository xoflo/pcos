import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import '../../controllers/authentication_controller.dart';
import 'GraphScreen.dart';
import 'LogRequestAPI.dart';
import 'package:intl/intl.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen();

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {


  static const cream = Color(0xFFFCEDE0);
  static const green = Color(0xFF00504A);
  static const orange = Color(0xFFFF6600);
  static const sand = Color(0xFFEDB687);
  static const blue = Color(0xFF5B84E0);
  static const pink = Color(0xFFFFC6C2);
  static const red = Color(0xFFFB4A44);


  loadLogRequestAPI() async {
    await Future.delayed(Duration(seconds: 2));
    final result = await GlobalPeriodLogAPI.instance.getStatus();
    return refresher(result);
  }

  refresher(bool result) async {
    if (result == false) {
      return await loadLogRequestAPI();
    } else {
      return result;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(child: Icon(Icons.chevron_left, color: green), onTap: () {
          Navigator.pop(context);
      }),
        title: Text("Cycles History", style: TextStyle(color: green)),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: FutureBuilder(
          future: loadLogRequestAPI(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {

            LogRequestAPI requestAPI = GlobalPeriodLogAPI.instance.logRequestAPI;


            return snapshot.data == true ? ListView.builder(
                itemCount: requestAPI.years.length,
                itemBuilder: (context, i) {

                  print("Test: ${requestAPI.years[i]}");

                  return InkWell(
                    onTap: () {
                      navigateToScreenDetailList("${requestAPI.years[i]}", requestAPI);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: Container(
                        color: green,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${requestAPI.years[i]}", style: TextStyle(fontSize: 50, color: Colors.white)),
                          ],
                        ),
                      ),

                    ),
                  );

                }): Center(
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
                  Text("Retrieving Cycles...", style: TextStyle(color: green),)
                ],
              ),
            );
        }
        ),

      ),
    );
  }



  navigateToScreenDetailList(String year, LogRequestAPI? api) {
    print("CycleTest: ${api!.cyclesInAYear}");

    Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreenDetailList(year: year, cycles: api.cyclesInAYear)));
  }



}


class HistoryScreenDetailList extends StatefulWidget {
  const HistoryScreenDetailList({required this.year, required this.cycles});

  final String year;
  final Map<String, dynamic>? cycles;


  @override
  State<HistoryScreenDetailList> createState() => _HistoryScreenDetailListState();
}

class _HistoryScreenDetailListState extends State<HistoryScreenDetailList> {


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(child: Icon(Icons.chevron_left, color: backgroundColor), onTap: () {
          Navigator.pop(context);
        }),
        title: Text("${widget.year} Cycles", style: TextStyle(color: backgroundColor)),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: widget.cycles!['${widget.year}']!.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text("${DateFormat.MMMMd().format(widget.cycles!['${widget.year}']![i].first.timestamp!)} - ${DateFormat.MMMMd().format(widget.cycles!['${widget.year}']![i].last.timestamp!)}"),
                  subtitle: Text("${widget.cycles!['${widget.year}']![i].first.timestamp!.difference(widget.cycles!['${widget.year}']![i].last.timestamp!).inDays.abs()}-Day Cycle"),
                  onTap: () {
                    navigateToHistoryScreenDetail(widget.cycles!['${widget.year}']![i]);
                  },
                ),
              );

            }),
      ),


    );
  }


  navigateToHistoryScreenDetail(List<PeriodLog> cycle) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GraphScreen(cycle: cycle)));
  }








}



