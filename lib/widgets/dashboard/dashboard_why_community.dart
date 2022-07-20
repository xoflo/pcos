import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_why_settings_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/highlight_text.dart';

class DashboardWhyCommunity extends StatefulWidget {
  const DashboardWhyCommunity({Key? key, required this.yourWhy})
      : super(key: key);

  final String yourWhy;

  @override
  State<DashboardWhyCommunity> createState() => _DashboardWhyCommunityState();
}

class _DashboardWhyCommunityState extends State<DashboardWhyCommunity> {
  // This is a variable that can be changed after updating the why.
  String localWhy = "";

  @override
  Widget build(BuildContext context) {
    if (localWhy.isEmpty) {
      localWhy = widget.yourWhy;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                DashboardWhySettingsPage.id,
              ).then((value) {
                if (value is String) {
                  setState(() => localWhy = value);
                }
              }),
              child: Container(
                height: 135,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: tertiaryColor,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    child: HighlightText(
                      text: localWhy.isNotEmpty
                          ? localWhy
                          : "Please input your why to motivate yourself every day.",
                      highlight: "want",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.5,
                      ),
                      highlightColor: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 135,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: backgroundColor,
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.group_outlined),
                        SizedBox(height: 5),
                        Text(
                          "Open community",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
