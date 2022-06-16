import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_video_page.dart';

class VideoComponent extends StatefulWidget {
  const VideoComponent({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  late BetterPlayerController _betterPlayerController;

  int? minutes;

  bool isVideoAvailable = false;
  bool isVideoFinishedLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl.isNotEmpty) {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, widget.videoUrl);

      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
        autoDispose: true,
      );

      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );

      _betterPlayerController.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          setState(() {
            isVideoAvailable = true;
          });
        }
        final duration = event.parameters?['duration'] as Duration?;
        if (duration != null) {
          setState(() {
            isVideoFinishedLoading = true;
            minutes = duration.inMinutes;
          });
        }
      });
    } else {
      setState(() {
        isVideoAvailable = false;
        isVideoFinishedLoading = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: minutes == null
            ? null
            : () => Navigator.pushNamed(
                  context,
                  LessonVideoPage.id,
                  arguments: widget.videoUrl,
                ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Watch Video",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Image(
                            image: AssetImage('assets/lesson_video.png'),
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Video",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      if (isVideoFinishedLoading)
                        Row(
                          children: [
                            Icon(
                              isVideoAvailable ? Icons.schedule : Icons.warning,
                              size: 20,
                              color: minutes != null
                                  ? textColor.withOpacity(0.8)
                                  : redColor,
                            ),
                            SizedBox(width: 5),
                            Text(
                              isVideoAvailable
                                  ? "$minutes mins"
                                  : "Video unavailable",
                              style: TextStyle(
                                fontSize: 14,
                                color: minutes != null
                                    ? textColor.withOpacity(0.8)
                                    : redColor,
                              ),
                            ),
                          ],
                        )
                      else
                        Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: backgroundColor,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        )
                    ],
                  ),
                  Icon(
                    Icons.play_circle_outline,
                    color: backgroundColor,
                    size: 25,
                  )
                ],
              )
            ],
          ),
        ),
      );
}
