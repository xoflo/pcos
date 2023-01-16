import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/constants/media_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/carousel_page_indicator.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';
import 'package:thepcosprotocol_app/widgets/shared/sound_player.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_component.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LessonContentPage extends StatelessWidget {
  static const id = "lesson_content_page";

  final activePage = ValueNotifier(0);
  final isFavorite = ValueNotifier(false);

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

  @override
  Widget build(BuildContext context) {
    final favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    final modulesProvider =
        Provider.of<ModulesProvider>(context, listen: false);

    final lesson = ModalRoute.of(context)?.settings.arguments as Lesson?;
    final lessonContent =
        modulesProvider.getLessonContent(lesson?.lessonID ?? -1);

    final pageController = PageController(initialPage: 0);

    isFavorite.value =
        favouritesProvider.isFavourite(FavouriteType.Lesson, lesson?.lessonID);

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: SafeArea(
          bottom: false,
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
                            textStyle: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        IconButton(
                          icon: ValueListenableBuilder<bool>(
                            valueListenable: isFavorite,
                            builder: (context, value, child) => Icon(
                              value ? Icons.favorite : Icons.favorite_outline,
                              size: 20,
                              color: redColor,
                            ),
                          ),
                          onPressed: () {
                            favouritesProvider.addToFavourites(
                                FavouriteType.Lesson, lesson?.lessonID);
                            isFavorite.value = !isFavorite.value;
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: lessonContent.length,
                      pageSnapping: true,
                      onPageChanged: (page) => activePage.value = page,
                      itemBuilder: (context, index) {
                        final content = lessonContent[index];
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HtmlWidget(
                                  content.title ?? "",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(color: backgroundColor),
                                ),
                                SizedBox(height: 20),
                                HtmlWidget(
                                  content.body ?? "",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        color: textColor.withOpacity(0.8),
                                        height: 1.5,
                                      ),
                                  onTapUrl: (link) => launchUrlString(link,
                                      mode: LaunchMode.externalApplication),
                                ),
                                ...getContentUrlType(content),
                                if (content.summary?.isNotEmpty == true) ...[
                                  SizedBox(height: 20),
                                  HtmlWidget(
                                    content.summary ?? "",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: textColor.withOpacity(0.8),
                                          height: 1.5,
                                        ),
                                    onTapUrl: (link) => launchUrlString(link,
                                        mode: LaunchMode.externalApplication),
                                  )
                                ],
                                if (index == lessonContent.length - 1) ...[
                                  SizedBox(height: 20),
                                  FilledButton(
                                    text: "Go back to lesson page",
                                    width: 275,
                                    icon: Icon(Icons.arrow_back_ios),
                                    margin: EdgeInsets.zero,
                                    foregroundColor: Colors.white,
                                    backgroundColor: backgroundColor,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  SizedBox(height: 40)
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (lessonContent.length > 1) ...[
                    SizedBox(height: 20),
                    ValueListenableBuilder<int>(
                      valueListenable: activePage,
                      builder: (context, value, child) => CarouselPageIndicator(
                        numberOfPages: lessonContent.length,
                        activePage: activePage,
                      ),
                    )
                  ],
                  SizedBox(height: 75)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
