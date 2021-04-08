import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player_chewie.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';

class CourseLessonContent extends StatelessWidget {
  final LessonContent lessonContent;
  final Size screenSize;
  final bool isHorizontal;

  CourseLessonContent({
    @required this.lessonContent,
    @required this.screenSize,
    @required this.isHorizontal,
  });

  final String _videoStorageUrl = FlavorConfig.instance.values.videoStorageUrl;
  final String _imageStorageUrl = FlavorConfig.instance.values.imageStorageUrl;

  Widget _getTitle(BuildContext context) {
    if (lessonContent.title.length > 0) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          lessonContent.title,
          style:
              Theme.of(context).textTheme.headline6.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  Widget _getBody(BuildContext context) {
    if (lessonContent.body.length > 0) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Html(
          data: lessonContent.body,
        ),
      );
    }
    return Container();
  }

  Widget _getMedia(BuildContext context) {
    final bool displayMedia = lessonContent.mediaUrl.length > 0 &&
        lessonContent.mediaMimeType.length > 0;
    if (displayMedia) {
      switch (lessonContent.mediaMimeType.toLowerCase()) {
        case MediaType.Video:
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: VideoPlayerChewie(
              screenSize: screenSize,
              isHorizontal: isHorizontal,
              videoUrl: "$_videoStorageUrl${lessonContent.mediaUrl}",
            ),
          );
        case MediaType.Image:
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeInImage.memoryNetwork(
              alignment: Alignment.center,
              placeholder: kTransparentImage,
              image: "$_imageStorageUrl${lessonContent.mediaUrl}",
              fit: BoxFit.fitWidth,
              width: double.maxFinite,
              height: 220,
            ),
          );
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getTitle(context),
        _getBody(context),
        _getMedia(context),
      ],
    );
  }
}
