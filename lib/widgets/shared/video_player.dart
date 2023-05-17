import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:better_player/better_player.dart';
import 'package:path_provider/path_provider.dart';

import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;
import 'package:thepcosprotocol_app/styles/colors.dart';

class VideoPlayer extends StatefulWidget {
  final Size? screenSize;
  final bool? isHorizontal;
  final String? videoUrl;
  final String? videoAsset;
  final bool isFullScreenByDefault;

  final void Function()? videoFinishedCallback;

  VideoPlayer({
    this.screenSize,
    this.isHorizontal,
    this.videoUrl,
    this.videoAsset,
    this.videoFinishedCallback,
    this.isFullScreenByDefault = false,
  });

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  BetterPlayerController? _betterPlayerController;
  bool analyticsPlayEventSent = false;
  bool analyticsFullscreenEventSent = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void dispose() {
    super.dispose();
    _betterPlayerController?.pause();
    _betterPlayerController?.dispose(forceDispose: true);
    _betterPlayerController?.removeEventsListener(_setEventListener);
  }

  Future<void> initializePlayer() async {
    if (widget.videoAsset != null) {
      await _copyAssetToLocal();
    } else if (widget.videoUrl != null) {
      setupPlayerController(null);
    }
  }

  void _setEventListener(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      _betterPlayerController?.setOverriddenAspectRatio(
          _betterPlayerController!.videoPlayerController!.value.aspectRatio);
    } else if (event.betterPlayerEventType ==
        BetterPlayerEventType.openFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      _betterPlayerController?.setOverriddenAspectRatio(
          _betterPlayerController!.videoPlayerController!.value.aspectRatio);
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

  Future<void> _copyAssetToLocal() async {
    try {
      var content = await rootBundle.load("assets/${widget.videoAsset}");
      final directory = await getApplicationSupportDirectory();
      var file = File("${directory.path}/${widget.videoAsset}");
      file.writeAsBytesSync(content.buffer.asUint8List());
      // _loadIntroVideo(file.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> _getFileUrl(String fileName) async {
    final directory = await getApplicationSupportDirectory();
    return "${directory.path}/$fileName";
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
          child: getVideoWidget(),
        ),
      ],
    ));
  }

  Widget getVideoWidget() {
    if (widget.videoAsset != null) {
      return FutureBuilder<String>(
        future: _getFileUrl(widget.videoAsset!),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            if (_betterPlayerController == null)
              setupPlayerController(snapshot);
            return BetterPlayer(controller: _betterPlayerController!);
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return BetterPlayer(controller: _betterPlayerController!);
    }
  }

  void setupPlayerController(AsyncSnapshot<String>? snapshot) async {
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
    if (widget.videoUrl != null) {
      betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, widget.videoUrl ?? "");
    } else if (widget.videoAsset != null) {
      betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          snapshot!.data!.replaceAll(' ', '%20'));
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
    _betterPlayerController?.addEventsListener(_setEventListener);
  }
}
