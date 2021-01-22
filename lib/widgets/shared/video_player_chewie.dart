import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class VideoPlayerChewie extends StatefulWidget {
  final String videoUrl;

  VideoPlayerChewie({this.videoUrl});

  @override
  _VideoPlayerChewieState createState() => _VideoPlayerChewieState();
}

class _VideoPlayerChewieState extends State<VideoPlayerChewie> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    try {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    } catch (ex) {
      //do nothing, just handle possible chewie dispose exception
    }

    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    if (isHorizontal) {
      //iPad
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      //phone
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    super.dispose();
  }

  bool _isHorizontal(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DeviceUtils.isHorizontalWideScreen(
        screenSize.width, screenSize.height);
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      allowPlaybackSpeedChanging: false,
      deviceOrientationsAfterFullScreen: _isHorizontal(context)
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp],
      materialProgressColors: ChewieProgressColors(
          playedColor: secondaryColorLight,
          handleColor: secondaryColorLight,
          backgroundColor: Colors.white,
          bufferedColor: backgroundColor),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double loadingHeight = ((screenSize.width - 20) / 16) * 9;

    return Center(
      child: _chewieController != null &&
              _chewieController.videoPlayerController.value.initialized
          ? Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor: Colors.grey.shade200,
                    primaryIconTheme: IconThemeData(color: secondaryColorLight),
                    iconTheme: IconThemeData(color: secondaryColorLight),
                  ),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColorDark,
                        ),
                      ),
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              height: loadingHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColorDark,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: backgroundColor,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColorDark),
                    ),
                    SizedBox(height: 20),
                    Text(S.of(context).loadingVideo),
                  ],
                ),
              ),
            ),
    );
  }
}
