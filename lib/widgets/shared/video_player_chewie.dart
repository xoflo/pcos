import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class VideoPlayerChewie extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final String videoUrl;

  VideoPlayerChewie({
    this.screenSize,
    this.isHorizontal,
    this.videoUrl,
  });

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
    if (widget.isHorizontal) {
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

    try {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    } catch (ex) {
      //do nothing, just handle possible chewie dispose exception
    }

    super.dispose();
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
      deviceOrientationsAfterFullScreen: widget.isHorizontal
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp],
      materialProgressColors: ChewieProgressColors(
          playedColor: secondaryColor,
          handleColor: secondaryColor,
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
    final double loadingHeight = ((widget.screenSize.width - 20) / 16) * 9;

    return Center(
      child: _chewieController != null &&
              _chewieController.videoPlayerController.value.initialized
          ? Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor: Colors.grey.shade200,
                    primaryIconTheme: IconThemeData(color: secondaryColor),
                    iconTheme: IconThemeData(color: secondaryColor),
                  ),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
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
                    color: primaryColor,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PcosLoadingSpinner(),
                    SizedBox(height: 20),
                    Text(S.of(context).loadingVideo),
                  ],
                ),
              ),
            ),
    );
  }
}
