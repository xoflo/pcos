import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_video_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/sound_player.dart';

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

  @override
  Widget build(BuildContext context) {
    final toolkit = ModalRoute.of(context)?.settings.arguments as Lesson;
    final content = modulesProvider.getLessonContent(toolkit.lessonID);

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => false,
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
                            ...content.map((element) {
                              return Column(
                                children: [
                                  HtmlWidget(
                                    element.body ?? "",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.copyWith(
                                            color: textColor.withOpacity(0.8)),
                                  ),
                                  SizedBox(height: 10),
                                  if (element.mediaMimeType == MediaType.Image)
                                    Image.network(element.mediaUrl ?? "")
                                  else if (element.mediaMimeType ==
                                      MediaType.Video)
                                    FilledButton(
                                      text: "Play Video",
                                      icon: Icon(Icons.play_arrow_outlined,
                                          size: 18),
                                      margin: EdgeInsets.zero,
                                      width: 160,
                                      isRoundedButton: true,
                                      foregroundColor: Colors.white,
                                      backgroundColor: backgroundColor,
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        LessonVideoPage.id,
                                        arguments: element.mediaUrl,
                                      ),
                                    )
                                  else if (element.mediaMimeType ==
                                      MediaType.Audio)
                                    SoundPlayer(link: element.mediaUrl ?? ""),
                                  SizedBox(height: 10),
                                ],
                              );
                            }).toList()
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
