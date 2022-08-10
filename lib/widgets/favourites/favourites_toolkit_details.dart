import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/sound_player.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_component.dart';

class FavouritesToolkitDetails extends StatefulWidget {
  const FavouritesToolkitDetails({Key? key}) : super(key: key);

  static const id = "favourites_toolkit_details";

  @override
  State<FavouritesToolkitDetails> createState() =>
      _FavouritesToolkitDetailsState();
}

class _FavouritesToolkitDetailsState extends State<FavouritesToolkitDetails> {
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  Widget getContentUrlType(LessonContent content, int tag) {
    switch (content.mediaMimeType?.toLowerCase()) {
      case MediaType.Video:
        return VideoComponent(videoUrl: content.mediaUrl ?? "");
      case MediaType.Audio:
        return SoundPlayer(link: content.mediaUrl ?? "");
      case MediaType.Image:
        return ImageComponent(
          imageUrl: content.mediaUrl?.trim() ?? "",
          tag: 'toolkit_$tag',
        );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final toolkit = ModalRoute.of(context)?.settings.arguments as Lesson;
    final content = modulesProvider.getLessonContent(toolkit.lessonID);

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
                    title: "Toolkits",
                    closeItem: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: HtmlWidget(
                                    toolkit.title,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(
                                            color: textColor.withOpacity(0.8)),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Image(
                                  image:
                                      AssetImage('assets/favorite_toolkit.png'),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            SizedBox(height: 17),
                            ...content
                                .asMap()
                                .map((index, element) {
                                  return MapEntry(
                                    index,
                                    Column(
                                      children: [
                                        HtmlWidget(
                                          element.body ?? "",
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                  color: textColor
                                                      .withOpacity(0.8)),
                                        ),
                                        SizedBox(height: 10),
                                        getContentUrlType(element, index),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                })
                                .values
                                .toList()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
