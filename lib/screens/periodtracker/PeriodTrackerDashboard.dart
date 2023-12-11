import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/GraphScreen.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/HistoryScreen.dart';
import 'package:thepcosprotocol_app/screens/periodtracker/LogRequestAPI.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'DataScreen.dart';


class PeriodTrackerDashboard extends StatefulWidget {
  const PeriodTrackerDashboard({
    required this.currentUser,
    Key? key,
  }) : super(key: key);


  final StreamUser currentUser;

  @override
  State<PeriodTrackerDashboard> createState() => _PeriodTrackerDashboardState();
}

class _PeriodTrackerDashboardState extends State<PeriodTrackerDashboard> {



  @override
  void initState() {

    print(widget.currentUser.data);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: onboardingBackground,
      appBar: AppBar(
        title: Text("Period Tracker", style: TextStyle(color: backgroundColor)),
        leading: Icon(Icons.chevron_left, color: backgroundColor),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                        color: backgroundColor,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DataScreen()));
                          },
                          child: Container(
                            height: 100,
                            width: 250,
                            child: Center(
                              child: Text("Log Data", textAlign: TextAlign.center,style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: onboardingBackground,
                                fontSize: 30,
                              ),),
                            ),
                          ),
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                        color: backgroundColor,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen() ));
                          },
                          child: Container(
                            height: 100,
                            width: 250,
                            child: Center(
                              child: Text("Period History", textAlign: TextAlign.center ,style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: onboardingBackground,
                                fontSize: 30,
                              ),),
                            ),
                          ),
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                        ),
                        color: backgroundColor,
                        child: GestureDetector(
                          onTap: () {
                           // Navigator.push(context, MaterialPageRoute(builder: (_) => GraphScreen(cycleDate: '', periodDuration: '') ));
                          },
                          child: Container(
                            height: 100,
                            width: 250,
                            child: Center(
                              child: Text("Tracker Graph", textAlign: TextAlign.center,style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: onboardingBackground,
                                fontSize: 30,
                              ),),
                            ),
                          ),
                        ),
                      ),

                      /*
                      Container(
                        width: 200,
                        height: 100,
                        child: ElevatedButton(
                          child: Text("Delete"),
                          onPressed: () {
                            LogRequestAPI request = LogRequestAPI();
                            request.deleteData();
                          },
                        ),
                      )
                       */
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  }
}
