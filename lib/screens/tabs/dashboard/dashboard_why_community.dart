import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_settings_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/highlight_text.dart';

class DashboardWhyCommunity extends StatelessWidget {
  const DashboardWhyCommunity({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: Consumer<MemberProvider>(
                  builder: (context, memberViewModel, _) => 
                  OpenContainer(
                    transitionDuration: Duration(milliseconds: 400),
                    clipBehavior: Clip.hardEdge,
                    openBuilder: (context, closedContainer) {
                        return DashboardWhySettingsPage();
                    },
                    openShape: RoundedRectangleBorder(
                      side: BorderSide(color: tertiaryColor, width: 0),
                      borderRadius: BorderRadius.circular(16)),
                    closedShape: RoundedRectangleBorder(
                      side: BorderSide(color: tertiaryColor, width: 0),
                      borderRadius: BorderRadius.circular(16)),
                    openColor: tertiaryColor,
                    middleColor: tertiaryColor,
                    closedColor: tertiaryColor,
                    closedElevation: 0,
                    closedBuilder: (context, openContainer) {
                      return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            child: HighlightText(
                              text: memberViewModel.why.isNotEmpty
                                  ? memberViewModel.why
                                  : "Please input your why to motivate yourself every day.",
                              highlight: "want",
                              style: Theme.of(context).textTheme.headline5!,
                              highlightColor: redColor,
                            ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 125,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: backgroundColor,
                    child: GestureDetector(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.group_outlined),
                            SizedBox(height: 5),
                            Text(
                              "Open community",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
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
