import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/lesson/video_page.dart';

class VideoComponent extends StatefulWidget {
  const VideoComponent({Key? key, required this.videoUrl}) : super(key: key);

  final String videoUrl;

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => 
              VideoPage(
                videoUrl: widget.videoUrl,
              )
            ))
          ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
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
        ),
      );
}
