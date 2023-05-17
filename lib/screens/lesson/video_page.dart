import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';

class VideoPage extends StatefulWidget {
  static const id = "video_page";

  final String? videoUrl;
  final String? videoAsset;
  final bool? isFullScreenByDefault;

  final void Function()? videoFinishedCallback;

  VideoPage({
    this.videoUrl,
    this.videoAsset,
    this.isFullScreenByDefault,
    this.videoFinishedCallback,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  VideoPlayer(
                    screenSize: size,
                    isHorizontal: false,
                    videoUrl: widget.videoUrl?.trim(),
                    videoAsset: widget.videoAsset?.trim(),
                    isFullScreenByDefault: widget.isFullScreenByDefault ?? false,
                    videoFinishedCallback: widget.videoFinishedCallback,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
