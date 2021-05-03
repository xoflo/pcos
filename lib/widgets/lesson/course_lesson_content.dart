import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';
import 'package:thepcosprotocol_app/config/flavors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/content_pdf_viewer.dart';

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
        child: HtmlWidget(lessonContent.body),
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
            child: Platform.isIOS
                ? VideoPlayer(
                    screenSize: screenSize,
                    isHorizontal: isHorizontal,
                    storageUrl: _videoStorageUrl,
                    videoName: lessonContent.mediaUrl,
                  )
                : VideoPlayer(
                    screenSize: screenSize,
                    isHorizontal: isHorizontal,
                    storageUrl: _videoStorageUrl,
                    videoName: lessonContent.mediaUrl,
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
        case MediaType.Pdf:
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ContentPdfViewer(
              lessonContent: lessonContent,
              screenSize: screenSize,
              isHorizontal: isHorizontal,
              pdfStorageUrl: FlavorConfig.instance.values.pdfStorageUrl,
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