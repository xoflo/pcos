import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

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
    _videoPlayerController.dispose();
    _chewieController.dispose();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    accentIconTheme: IconThemeData(color: secondaryColorLight),
                  ),
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading'),
              ],
            ),
    );
  }
}
