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

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl.isNotEmpty) {
      BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, widget.videoUrl);

      BetterPlayerConfiguration betterPlayerConfiguration =
          BetterPlayerConfiguration(
        autoPlay: false,
        autoDispose: true,
        looping: false,
        fullScreenByDefault: false,
      );

      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );

      _betterPlayerController.addEventsListener(_setDuration);
    } else if (mounted) {
      setState(() => isVideoAvailable = false);
    }
  }

  void _setDuration(BetterPlayerEvent event) {
    final duration = event.parameters?['duration'] as Duration?;
    if (duration != null && mounted) {
      setState(() {
        isVideoAvailable = true;
        minutes = duration.inMinutes;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose(forceDispose: true);
    _betterPlayerController.removeEventsListener(_setDuration);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isVideoAvailable
            ? () => Navigator.pushNamed(
                  context,
                  LessonVideoPage.id,
                  arguments: widget.videoUrl,
                )
            : null,
        child: Opacity(
          opacity: isVideoAvailable ? 1 : 0.5,
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
                Row(
                  children: [
                    Icon(
                      Icons.play_circle,
                      color: backgroundColor,
                      size: 25,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Watch Video",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: backgroundColor),
                    ),
                  ],
                ),
                if (isVideoAvailable) ...[
                  SizedBox(height: 15),
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: textColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 20,
                            color: textColor.withOpacity(0.8),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "$minutes mins",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: textColor.withOpacity(0.8)),
                          ),
                        ],
                      )
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      );
}
