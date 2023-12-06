import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/periodLog.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import '../../controllers/authentication_controller.dart';
import 'GraphScreen.dart';
import 'LogRequestAPI.dart';


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

  final requestAPI = LogRequestAPI();

  List<PeriodLog> responses = [];
  List<int>? years;

  @override
  void initState() {
    initRequestAPI();
    super.initState();
  }


  initRequestAPI() async {
    responses = await requestAPI.retrieveRequest();
    years = await requestAPI.getYears();
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
        child: ListView.builder(
          itemCount: years!.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  navigateToScreenDetailList("${years![i]}");
                },
                child: Card(
                  elevation: 5,
                  child: Container(
                    color: green,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${years![i]}", style: TextStyle(fontSize: 50, color: Colors.white)),
                      ],
                    ),
                  ),

                ),
              );

            }),

      ),
    );
  }



  navigateToScreenDetailList(String year) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreenDetailList(year: year)));
  }



}


class HistoryScreenDetailList extends StatefulWidget {
  const HistoryScreenDetailList({required this.year});

  final String year;

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
            itemCount: 1,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text("October 1 - October 17"),
                  subtitle: Text("4-Day Period"),
                  onTap: () {
                    navigateToHistoryScreenDetail();
                  },
                ),
              );

            }),
      ),
    );
  }


  navigateToHistoryScreenDetail() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => GraphScreen(cycleDate: 'October 1 - October 17', periodDuration: '4-Day Period',)));
  }








}



