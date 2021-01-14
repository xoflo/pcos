import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:video_player/video_player.dart' as FlutterVideoPlayer;

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  VideoPlayer({this.videoUrl});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  FlutterVideoPlayer.VideoPlayerController _videoPlayerController;
  String _videoDuration;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = FlutterVideoPlayer.VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );
    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.setLooping(false);
    _videoPlayerController.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        _videoDuration =
            _getVideoDuration(_videoPlayerController.value.duration);
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  String _getVideoDuration(Duration currentPosition) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(currentPosition.inMinutes.remainder(60)).toString()}:${twoDigits(currentPosition.inSeconds.remainder(60)).toString()}";
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.initialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: FlutterVideoPlayer.VideoPlayer(_videoPlayerController),
              ),
              SizedBox(
                height: 15.0,
                child: FlutterVideoPlayer.VideoProgressIndicator(
                  _videoPlayerController,
                  colors: FlutterVideoPlayer.VideoProgressColors(
                    playedColor: secondaryColorLight,
                    bufferedColor: primaryColorLight,
                    backgroundColor: backgroundColor,
                  ),
                  allowScrubbing: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${_getVideoDuration(_videoPlayerController.value.position)} / $_videoDuration"),
                  GestureDetector(
                    onTap: () {
                      if (_videoPlayerController.value.position ==
                          _videoPlayerController.value.duration) {
                        _videoPlayerController.seekTo(Duration(seconds: 0));
                      }
                      _videoPlayerController.value.isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play();
                    },
                    child: Icon(
                      _videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: secondaryColorLight,
                      size: 34,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("display fullscreen");
                    },
                    child: Icon(
                      Icons.fullscreen,
                      color: secondaryColorLight,
                      size: 34,
                    ),
                  ),
                ],
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
          );
  }
}
