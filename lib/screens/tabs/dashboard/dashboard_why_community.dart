import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_settings_page.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/preferences_controller.dart';
import '../../lesson/video_page.dart';
import '/constants/shared_preferences_keys.dart' as SharedPreferencesKeys;

class DashboardWhyCommunity extends StatelessWidget {
  const DashboardWhyCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OpenContainer(
              transitionDuration: Duration(milliseconds: 400),
              clipBehavior: Clip.hardEdge,
              openBuilder: (context, closedContainer) =>
                  DashboardWhySettingsPage(),
              openShape: RoundedRectangleBorder(
                  side: BorderSide(color: tertiaryColor, width: 0),
                  borderRadius: BorderRadius.circular(16)),
              closedShape: RoundedRectangleBorder(
                  side: BorderSide(color: tertiaryColor, width: 0),
                  borderRadius: BorderRadius.circular(16)),
              openColor: tertiaryColor,
              middleColor: tertiaryColor,
              closedColor: tertiaryColor,
              // Closed elevation cannot be exactly 0 because it will hide
              // the card when user goes to another screen or tab. This is
              // most likely a bug on the library itself
              closedElevation: 0.00001,
              closedBuilder: (context, openContainer) => Container(
                height: 125,
                alignment: Alignment.center,
                padding: EdgeInsets.all(12.5),
                child: memberProvider.loadingStatus == LoadingStatus.loading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: PcosLoadingSpinner(),
                      )
                    : AutoSizeText(
                        memberProvider.why.isNotEmpty
                            ? memberProvider.why
                            : "Please input your why to motivate yourself every day.",
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  onTap: () async {
                    // TODO: put discordUrl and discord tutorial url in another place.
                    final discordUrl = 'https://discord.gg/U3zQQypbFW';
                    final hasViewed = await PreferencesController().getBool(
                        SharedPreferencesKeys.HAS_VIEWED_DISCORD_TUTORIAL);
                    if (hasViewed) {
                      launchUrl(Uri.parse(discordUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      PreferencesController().saveBool(
                          SharedPreferencesKeys.HAS_VIEWED_DISCORD_TUTORIAL,
                          true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => VideoPage(
                                    videoAsset: 'discord_tutorial.mp4',
                                    isFullScreenByDefault: true,
                                    videoFinishedCallback: () {
                                      launchUrl(
                                          Uri.parse(discordUrl),
                                          mode: LaunchMode.externalApplication);
                                    },
                                  ))));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.group_outlined),
                        SizedBox(height: 5),
                        FittedBox(
                          child: Text("Open \ncommunity",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                              maxLines: 2),
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
