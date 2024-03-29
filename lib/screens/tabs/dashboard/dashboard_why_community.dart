import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_why_settings_page.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

import '../../../controllers/authentication_controller.dart';
import '../../../screens/community/extension.dart';
import '../../community/home_community.dart';

class DashboardWhyCommunity extends StatefulWidget {
  const DashboardWhyCommunity({Key? key}) : super(key: key);

  @override
  State<DashboardWhyCommunity> createState() => _DashboardWhyCommunityState();
}

class _DashboardWhyCommunityState extends State<DashboardWhyCommunity> {
  StreamUser? _streamUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_streamUser == null) {
      setupStream();
    }
  }

  Future setupStream() async {
    final _client = context.client;

    final authenticationController = new AuthenticationController();
    final String streamIoUserToken =
        await authenticationController.getStreamIOToken();
    if (streamIoUserToken.isNotEmpty) {
      JWT decodedToken = JWT.decode(streamIoUserToken);

      final userName = await authenticationController.getUsername();
      final userData = {'user_name': userName ?? ''};

      _streamUser = await _client.setUser(
        User(id: decodedToken.payload['user_id'], data: userData),
        Token(streamIoUserToken),
      );
    }
  }

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
                  onTap: () {
                    final streamUser = this._streamUser;
                    if (streamUser != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => HomeCommunity(
                                    currentUser: streamUser,
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
