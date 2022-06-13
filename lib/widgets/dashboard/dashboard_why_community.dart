import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/highlight_text.dart';

class DashboardWhyCommunity extends StatelessWidget {
  const DashboardWhyCommunity({Key? key, required this.yourWhy})
      : super(key: key);

  final String yourWhy;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: yourWhy.isEmpty
            ? null
            : Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: tertiaryColor,
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: yourWhy.isEmpty
                              ? null
                              : HighlightText(
                                  text: yourWhy,
                                  highlight: "want",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  highlightColor: Colors.red,
                                )),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: backgroundColor,
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
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
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      );
}
