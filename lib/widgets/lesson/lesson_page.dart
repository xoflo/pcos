import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_content_page.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_plan_component.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_task_component.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_video_page.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/sound_player.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  static const id = "lesson_page";

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  String contentIcon = 'assets/lesson_reading.png';
  String contentType = 'Reading';
  String contentUrl = '';
  bool isFavorite = false;
  bool hasContents = false;

  late ModulesProvider modulesProvider;
  late FavouritesProvider favouritesProvider;

  LessonArguments? args;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  List<Widget> _getContentType(List<LessonContent> lessonContent) {
    setState(() {
      for (final content in lessonContent) {
        switch (content.mediaMimeType) {
          case 'video':
            contentIcon = "assets/lesson_video.png";
            contentType = "Video";
            contentUrl = content.mediaUrl ?? '';
            break;
          case 'audio':
            contentIcon = "assets/lesson_audio.png";
            contentType = "Audio";
            contentUrl = content.mediaUrl ?? '';

            break;
          default:
            contentIcon = "assets/lesson_reading.png";
            contentType = "Reading";
            break;
        }
      }
    });

    return [
      Image(
        image: AssetImage(contentIcon),
        width: 20,
        height: 20,
        color: textColor.withOpacity(0.5),
      ),
      SizedBox(width: 5),
      Text(
        contentType,
        style: TextStyle(
          fontSize: 14,
          color: textColor.withOpacity(0.8),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args = ModalRoute.of(context)?.settings.arguments as LessonArguments;
      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Lesson, args?.lesson.lessonID);

      for (final content in args?.lessonContents ?? []) {
        if (content.body.isNotEmpty) {
          hasContents = true;
          break;
        }
      }
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: "Lesson",
                  closeItem: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (args?.lesson.imageUrl.isNotEmpty == true)
                          Image.network(
                            args?.lesson.imageUrl ?? "",
                            width: double.maxFinite,
                            height: 200,
                            fit: BoxFit.cover,
                            color: Colors.black,
                          )
                        else
                          Container(
                            width: double.maxFinite,
                            height: 200,
                            color: Colors.white,
                            child: Center(
                              child: Image(
                                image: AssetImage('assets/logo_pink.png'),
                                fit: BoxFit.contain,
                                width: 100,
                                height: 50,
                              ),
                            ),
                          ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: HtmlWidget(
                            args?.lesson.title ?? "",
                            textStyle: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: _getContentType(
                                        args?.lessonContents ?? []),
                                  ),
                                  SizedBox(width: 15),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 20,
                                            color: textColor.withOpacity(0.5),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "5 mins",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  favouritesProvider.addToFavourites(
                                    FavouriteType.Lesson,
                                    args?.lesson.lessonID,
                                  );
                                  setState(() => isFavorite = !isFavorite);
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  size: 20,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        LessonPlanComponent(
                          lessonContents: args?.lessonContents ?? [],
                          lessonWikis: args?.lessonWikis ?? [],
                          lessonTasks: args?.lessonTasks ?? [],
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: HtmlWidget(
                            args?.lesson.introduction ?? "",
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: textColor.withOpacity(0.8),
                            ),
                            isSelectable: true,
                          ),
                        ),
                        if (hasContents) ...[
                          SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: FilledButton(
                              text: "READ MORE",
                              icon: Icon(Icons.play_arrow_outlined, size: 18),
                              margin: EdgeInsets.zero,
                              width: 180,
                              isRoundedButton: true,
                              foregroundColor: Colors.white,
                              backgroundColor: backgroundColor,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                LessonContentPage.id,
                                arguments: args?.lesson,
                              ).then((value) {
                                if (value is bool) {
                                  setState(() => isFavorite = value);
                                }
                              }),
                            ),
                          ),
                        ],
                        if (contentType == 'Video') ...[
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: FilledButton(
                              text: "PLAY VIDEO",
                              icon: Icon(Icons.play_arrow_outlined, size: 18),
                              margin: EdgeInsets.zero,
                              width: 180,
                              isRoundedButton: true,
                              foregroundColor: Colors.white,
                              backgroundColor: backgroundColor,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                LessonVideoPage.id,
                                arguments: contentUrl,
                              ),
                            ),
                          ),
                        ] else if (contentType == 'Audio') ...[
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: SoundPlayer(link: contentUrl),
                          )
                        ],
                        if (args?.lessonWikis.isNotEmpty == true)
                          LessonWikiComponent(
                              lessonWikis: args?.lessonWikis ?? []),
                        if (args?.lessonTasks.isNotEmpty == true)
                          LessonTaskComponent(
                              lessonTasks: args?.lessonTasks ?? []),
                        SizedBox(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            thickness: 1,
                            height: 1,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: FilledButton(
                            text: "Complete Lesson",
                            icon: Icon(Icons.check_circle_outline),
                            margin: EdgeInsets.zero,
                            foregroundColor: Colors.white,
                            backgroundColor: backgroundColor,
                            onPressed: () {
                              final bool setModuleComplete = modulesProvider
                                      .currentModuleLessons.last.lessonID ==
                                  args?.lesson.lessonID;

                              modulesProvider
                                  .setLessonAsComplete(
                                    args?.lesson.lessonID ?? -1,
                                    args?.lesson.moduleID ?? -1,
                                    setModuleComplete,
                                  )
                                  .then((value) => Navigator.pop(context));
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
