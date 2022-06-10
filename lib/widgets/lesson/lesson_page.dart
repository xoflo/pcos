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
import 'package:thepcosprotocol_app/widgets/lesson/lesson_video_page.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_page.dart';
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
  String contentIcon = '';
  String contentType = '';
  String contentUrl = '';
  bool isFavorite = false;

  late ModulesProvider modulesProvider;
  late FavouritesProvider favouritesProvider;

  LessonArguments? args;
  LessonContent? firstLessonContent;
  List<LessonContent>? otherLessonContent;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  List<Widget> _getContentType(List<LessonContent> lessonContent) {
    setState(() {
      lessonContent.forEach((element) {
        switch (element.mediaMimeType) {
          case 'video':
            contentIcon = "assets/lesson_video.png";
            contentType = "Video";
            contentUrl = element.mediaUrl ?? '';
            break;
          case 'audio':
            contentIcon = "assets/lesson_audio.png";
            contentType = "Audio";
            contentUrl = element.mediaUrl ?? '';

            break;
          default:
            contentIcon = "assets/lesson_reading.png";
            contentType = "Reading";
            break;
        }
      });
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
      final lessonContents = args?.lessonContents;
      if (lessonContents?.isNotEmpty == true) {
        firstLessonContent = lessonContents?.first;
        otherLessonContent = lessonContents?.sublist(1, lessonContents.length);
      }

      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Lesson, args?.lesson.lessonID);
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
                          child: Text(
                            args?.lesson.title ?? "",
                            style: TextStyle(
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
                        SizedBox(height: 15),
                        if ((firstLessonContent?.body ?? "").length > 200) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: HtmlWidget(
                              "${firstLessonContent?.body?.substring(0, 200)}...",
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                LessonContentPage.id,
                                arguments: args?.lesson,
                              ).then((value) {
                                if (value is bool) {
                                  setState(() => isFavorite = value);
                                }
                              }),
                              child: Text(
                                "Read More",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ] else if ((firstLessonContent?.body ?? "").length > 0)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: HtmlWidget(
                              firstLessonContent?.body ?? "",
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        if (contentType == 'Video') ...[
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FilledButton(
                                text: "Play Video",
                                icon: Icon(Icons.play_arrow_outlined, size: 18),
                                margin: EdgeInsets.zero,
                                width: 160,
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
                          )
                        ] else if (contentType == 'Audio') ...[
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: SoundPlayer(link: contentUrl),
                          )
                        ],
                        if (args?.lessonWikis.isNotEmpty == true) ...[
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wikis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 20,
                                  ),
                                ),
                                ...args?.lessonWikis
                                        .map(
                                          (element) => GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              LessonWikiPage.id,
                                              arguments: element,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 15),
                                                Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        element.question ?? "",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              backgroundColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        element.answer ?? "",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: textColor
                                                              .withOpacity(0.8),
                                                          height: 1.25,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    []
                              ],
                            ),
                          )
                        ],
                        if (args?.lessonTasks.isNotEmpty == true) ...[
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 20,
                                  ),
                                ),
                                ...args?.lessonTasks
                                        .map(
                                          (element) => GestureDetector(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 15),
                                                Container(
                                                  width: double.maxFinite,
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        element.title ?? "",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              backgroundColor,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: backgroundColor,
                                                        size: 10,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    []
                              ],
                            ),
                          )
                        ],
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
