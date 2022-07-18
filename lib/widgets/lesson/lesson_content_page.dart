import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/sound_player.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_component.dart';

class LessonContentPage extends StatefulWidget {
  const LessonContentPage({Key? key}) : super(key: key);

  static const id = "lesson_content_page";

  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  Lesson? lesson;
  List<LessonContent>? lessonContent;
  bool isFavorite = false;

  PageController? controller;

  int activePage = 0;

  late FavouritesProvider favouritesProvider;
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  List<Widget> getContentUrlType(LessonContent? content) {
    switch (content?.mediaMimeType?.toLowerCase()) {
      case MediaType.Video:
        return [
          SizedBox(height: 20),
          VideoComponent(videoUrl: content?.mediaUrl ?? "")
        ];
      case MediaType.Audio:
        return [
          SizedBox(height: 20),
          SoundPlayer(link: content?.mediaUrl ?? "")
        ];
      case MediaType.Image:
        return [
          SizedBox(height: 20),
          ImageComponent(imageUrl: content?.mediaUrl?.trim() ?? "")
        ];
    }
    return [];
  }

  List<Widget> generateIndicators() => List<Widget>.generate(
        lessonContent?.length ?? 0,
        (index) => Container(
          margin: const EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: activePage == index
                ? selectedIndicatorColor
                : unselectedIndicatorColor,
            shape: BoxShape.circle,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      lesson = ModalRoute.of(context)?.settings.arguments as Lesson;
      lessonContent = modulesProvider.getLessonContent(lesson?.lessonID ?? -1);

      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Lesson, lesson?.lessonID);
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
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: "Lesson",
                  closeItem: () => Navigator.pop(context),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: HtmlWidget(
                          lesson?.title ?? "",
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_outline,
                          size: 20,
                          color: redColor,
                        ),
                        onPressed: () {
                          favouritesProvider.addToFavourites(
                              FavouriteType.Lesson, lesson?.lessonID);
                          setState(() => isFavorite = !isFavorite);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: lessonContent?.length,
                    pageSnapping: true,
                    onPageChanged: (page) => setState(() => activePage = page),
                    itemBuilder: (context, index) {
                      final content = lessonContent?[index];
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HtmlWidget(
                                content?.title ?? "",
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(height: 20),
                              HtmlWidget(
                                content?.body ?? "",
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.8),
                                ),
                              ),
                              ...getContentUrlType(content),
                              if (content?.summary?.isNotEmpty == true) ...[
                                SizedBox(height: 20),
                                HtmlWidget(
                                  content?.summary ?? "",
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.8),
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if ((lessonContent?.length ?? 0) > 1) ...[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: generateIndicators(),
                  ),
                ],
                SizedBox(height: 25)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
