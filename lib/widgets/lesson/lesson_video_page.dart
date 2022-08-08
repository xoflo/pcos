import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';

class LessonVideoPage extends StatefulWidget {
  const LessonVideoPage({Key? key}) : super(key: key);

  static const id = "lesson_video_page";

  @override
  State<LessonVideoPage> createState() => _LessonVideoPageState();
}

class _LessonVideoPageState extends State<LessonVideoPage> {
  @override
  Widget build(BuildContext context) {
    final videoUrl = ModalRoute.of(context)?.settings.arguments as String;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => Platform.isIOS ? false : true,
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
                    videoUrl: videoUrl,
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
