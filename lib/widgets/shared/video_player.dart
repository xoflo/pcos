import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/styles/colors.dart';

class VideoPlayer extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final String storageUrl;
  final String videoName;

  VideoPlayer({
    this.screenSize,
    this.isHorizontal,
    this.storageUrl,
    this.videoName,
  });

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController _betterPlayerController;
  bool analyticsPlayEventSent = false;
  bool analyticsFullscreenEventSent = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    final String videoUrl = "${widget.storageUrl}${widget.videoName}";
    BetterPlayerDataSource betterPlayerDataSource =
        BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoUrl);

    BetterPlayerControlsConfiguration betterPlayerControlsConfiguration =
        BetterPlayerControlsConfiguration(
      textColor: secondaryColor,
      iconsColor: secondaryColor,
      controlBarColor: Colors.grey.shade200,
      progressBarPlayedColor: secondaryColor,
      progressBarHandleColor: secondaryColor,
      progressBarBackgroundColor: Colors.white,
      progressBarBufferedColor: primaryColorLight,
      enableOverflowMenu: false,
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: false,
      autoDispose: true,
      looping: false,
      fullScreenByDefault: false,
      controlsConfiguration: betterPlayerControlsConfiguration,
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    //add analytics events for play and fullscreen
    _betterPlayerController.addEventsListener((event) {
      debugPrint(
          "***************** BETTER PLAY event: ${event.betterPlayerEventType}");
      if (event.betterPlayerEventType == BetterPlayerEventType.play &&
          !analyticsPlayEventSent) {
        analytics.logEvent(
          name: Analytics.ANALYTICS_VIDEO_PLAY,
          parameters: {
            Analytics.ANALYTICS_PARAMETER_VIDEO_NAME: widget.videoName
          },
        );
        setState(() {
          analyticsPlayEventSent = true;
        });
      } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.openFullscreen &&
          !analyticsFullscreenEventSent) {
        analytics.logEvent(
          name: Analytics.ANALYTICS_VIDEO_FULLSCREEN,
          parameters: {
            Analytics.ANALYTICS_PARAMETER_VIDEO_NAME: widget.videoName
          },
        );
        setState(() {
          analyticsFullscreenEventSent = true;
        });
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
            ),
          ),
          child: BetterPlayer(controller: _betterPlayerController),
        ),
      ],
    ));
  }
}
