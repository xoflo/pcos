import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';

import '../../utils/file_utils.dart';

class VideoPage extends StatefulWidget {
  static const id = "video_page";

  final String? videoUrl;
  final String? videoAsset;
  final bool? isHorizontal;
  final bool? isFullScreenByDefault;

  final void Function()? videoFinishedCallback;

  VideoPage({
    this.videoUrl,
    this.videoAsset,
    this.isHorizontal,
    this.isFullScreenByDefault,
    this.videoFinishedCallback,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Header(
                    title: "Video",
                    closeItem: () => Navigator.pop(context),
                  ),
                  getVideoWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getVideoWidget() {
    final size = MediaQuery.of(context).size;
    if (widget.videoAsset != null) {
      return FutureBuilder<String>(
        future: getFileUrl(widget.videoAsset!),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            return getVideoPlayer(size, snapshot.data);
          } else {
            return const SizedBox();
          }
        },
      );
    } else {
      return getVideoPlayer(size, null);
    }
  }

  VideoPlayer getVideoPlayer(Size size, String? videoAssetFilename) {
    return VideoPlayer(
      screenSize: size,
      isHorizontal: widget.isHorizontal ?? true,
      videoUrl: widget.videoUrl?.trim(),
      videoAsset: videoAssetFilename,
      isFullScreenByDefault: widget.isFullScreenByDefault ?? false,
      videoFinishedCallback: widget.videoFinishedCallback,
    );
  }
}
