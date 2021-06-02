import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';
import 'package:thepcosprotocol_app/widgets/lesson/content_pdf_viewer.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class CourseLessonContent extends StatefulWidget {
  final LessonContent lessonContent;
  final Size screenSize;
  final bool isHorizontal;
  final double tabBarHeight;
  final bool isPaged;

  CourseLessonContent({
    @required this.lessonContent,
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.tabBarHeight,
    @required this.isPaged,
  });

  @override
  _CourseLessonContentState createState() => _CourseLessonContentState();
}

class _CourseLessonContentState extends State<CourseLessonContent> {
  bool isDownloading = false;

  Widget _getTitle(BuildContext context) {
    if (widget.lessonContent.title.length > 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.lessonContent.title,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  Widget _getBody(BuildContext context) {
    if (widget.lessonContent.body.length > 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(widget.lessonContent.body),
      );
    }
    return Container();
  }

  Widget _getMedia(BuildContext context) {
    final bool displayMedia = widget.lessonContent.mediaUrl.length > 0 &&
        widget.lessonContent.mediaMimeType.length > 0;
    if (displayMedia) {
      switch (widget.lessonContent.mediaMimeType.toLowerCase()) {
        case MediaType.Video:
        case MediaType.Audio:
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Platform.isIOS
                ? VideoPlayer(
                    screenSize: widget.screenSize,
                    isHorizontal: widget.isHorizontal,
                    videoUrl: widget.lessonContent.mediaUrl,
                  )
                : VideoPlayer(
                    screenSize: widget.screenSize,
                    isHorizontal: widget.isHorizontal,
                    videoUrl: widget.lessonContent.mediaUrl,
                  ),
          );
        case MediaType.Image:
          final bool isDownloadable = widget.lessonContent.mediaUrl
              .toLowerCase()
              .contains("images/lessons/downloadable");
          return Column(
            children: [
              FullScreenWidget(
                child: FadeInImage.memoryNetwork(
                  alignment: Alignment.center,
                  placeholder: kTransparentImage,
                  image: widget.lessonContent.mediaUrl,
                  fit: BoxFit.fitWidth,
                  width: double.maxFinite,
                ),
              ),
              isDownloadable
                  ? ColorButton(
                      isUpdating: isDownloading,
                      label: S.of(context).downloadToDevice,
                      onTap: () {
                        setState(() {
                          isDownloading = true;
                        });
                        _downloadImage(context, widget.lessonContent.mediaUrl);
                      },
                      width: 200,
                    )
                  : Container(),
            ],
          );
        case MediaType.Pdf:
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ContentPdfViewer(
              lessonContent: widget.lessonContent,
            ),
          );
      }
    }
    return Container();
  }

  void _downloadImage(
      final BuildContext context, final String sourceUrl) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(sourceUrl);

      setState(() {
        isDownloading = false;
      });

      if (imageId == null) {
        showFlushBar(context, S.of(context).downloadFailed,
            S.of(context).downloadFailedMsg,
            backgroundColor: Colors.white,
            borderColor: primaryColorLight,
            primaryColor: primaryColor);
        return;
      }

      // Below is a method of obtaining saved image information.
      final String path = await ImageDownloader.findPath(imageId);
      final String downloadMessage = Platform.isIOS
          ? S.of(context).downloadSuccessMsgiOS
          : S.of(context).downloadSuccessMsg;

      showFlushBar(context, S.of(context).downloadSuccess, downloadMessage,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColor,
          displayDuration: 10);
      ImageDownloader.open(path);
    } on PlatformException catch (error) {
      showFlushBar(context, S.of(context).downloadFailed,
          S.of(context).downloadFailedMsg,
          backgroundColor: Colors.white,
          borderColor: primaryColorLight,
          primaryColor: primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPaged
        ? SizedBox(
            height: widget.tabBarHeight - 51,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _getTitle(context),
                  _getBody(context),
                  _getMedia(context),
                ],
              ),
            ),
          )
        : Column(
            children: [
              _getTitle(context),
              _getBody(context),
              _getMedia(context),
            ],
          );
  }
}
