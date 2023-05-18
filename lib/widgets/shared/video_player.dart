import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class VideoPlayer extends StatefulWidget {
  final Size? screenSize;
  final bool? isHorizontal;
  final String? videoUrl;
  final String? localVideoFileUrl;
  final bool isFullScreenByDefault;

  final void Function()? videoFinishedCallback;

  VideoPlayer({
    this.screenSize,
    this.isHorizontal,
    this.videoUrl,
    this.localVideoFileUrl,
    this.videoFinishedCallback,
    this.isFullScreenByDefault = false,
  });

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late BetterPlayerController _betterPlayerController;
  bool analyticsPlayEventSent = false;
  bool analyticsFullscreenEventSent = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void dispose() {
    super.dispose();
    _betterPlayerController.pause();
    _betterPlayerController.dispose(forceDispose: true);
    _betterPlayerController.removeEventsListener(_setEventListener);
  }

  Future<void> initializePlayer() async {
    setupPlayerController();
  }

  void _setEventListener(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      _betterPlayerController.setOverriddenAspectRatio(
          _betterPlayerController.videoPlayerController!.value.aspectRatio);
    } else if (event.betterPlayerEventType ==
        BetterPlayerEventType.openFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _betterPlayerController.setOverriddenAspectRatio(
          _betterPlayerController.videoPlayerController!.value.aspectRatio);
    } else if (event.betterPlayerEventType ==
        BetterPlayerEventType.hideFullscreen) {
      if (widget.isHorizontal == true) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    } else if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
      if (widget.videoFinishedCallback != null) widget.videoFinishedCallback!();
    }

    if (event.betterPlayerEventType == BetterPlayerEventType.play &&
        !analyticsPlayEventSent) {
      analytics.logEvent(
        name: Analytics.ANALYTICS_VIDEO_PLAY,
        parameters: {Analytics.ANALYTICS_PARAMETER_VIDEO_NAME: widget.videoUrl},
      );
      setState(() {
        analyticsPlayEventSent = true;
      });
    } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.openFullscreen &&
        !analyticsFullscreenEventSent) {
      analytics.logEvent(
        name: Analytics.ANALYTICS_VIDEO_FULLSCREEN,
        parameters: {Analytics.ANALYTICS_PARAMETER_VIDEO_NAME: widget.videoUrl},
      );
      setState(() {
        analyticsFullscreenEventSent = true;
      });
    }
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

  void setupPlayerController() async {
    List<DeviceOrientation> fullscreenOrientations = [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ];
    List<DeviceOrientation> normalOrientations = widget.isHorizontal == true
        ? [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]
        : [DeviceOrientation.portraitUp];

    BetterPlayerDataSource? betterPlayerDataSource;
    final videoUrl = widget.videoUrl;
    final localVideoFileUrl = widget.localVideoFileUrl;
    if (videoUrl != null) {
      betterPlayerDataSource =
          BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoUrl);
    } else if (localVideoFileUrl != null) {
      betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file, localVideoFileUrl);
    }

    BetterPlayerControlsConfiguration betterPlayerControlsConfiguration =
        BetterPlayerControlsConfiguration(
      textColor: secondaryColor,
      iconsColor: secondaryColor,
      controlBarColor: Colors.black.withOpacity(0.4),
      progressBarPlayedColor: secondaryColor,
      progressBarHandleColor: secondaryColor,
      progressBarBackgroundColor: Colors.white,
      progressBarBufferedColor: primaryColorLight,
      enableOverflowMenu: false,
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      autoDispose: true,
      looping: false,
      fullScreenByDefault: widget.isFullScreenByDefault,
      controlsConfiguration: betterPlayerControlsConfiguration,
      deviceOrientationsOnFullScreen: fullscreenOrientations,
      deviceOrientationsAfterFullScreen: normalOrientations,
      autoDetectFullscreenDeviceOrientation: true,
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: betterPlayerDataSource,
    );

    // //add analytics events for play and fullscreen
    _betterPlayerController.addEventsListener(_setEventListener);
  }
}
