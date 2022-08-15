import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LessonWikiPage extends StatefulWidget {
  const LessonWikiPage({Key? key}) : super(key: key);

  static const id = "lesson_wiki_page";

  @override
  State<LessonWikiPage> createState() => _LessonWikiPageState();
}

class _LessonWikiPageState extends State<LessonWikiPage> {
  LessonWiki? wiki;

  late FavouritesProvider favouritesProvider;
  late ModulesProvider modulesProvider;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as LessonWikiArguments;

    if (wiki == null) {
      wiki = args.lessonWiki;
      isFavorite =
          favouritesProvider.isFavourite(FavouriteType.Wiki, wiki?.questionId);
    }

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
                  title: "Wikis",
                    closeItem: () => Navigator.pop(context, isFavorite),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    wiki?.question ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.copyWith(color: backgroundColor),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: 20,
                                    color: backgroundColor,
                                  ),
                                  onPressed: () {
                                    favouritesProvider.addToFavourites(
                                        FavouriteType.Wiki, wiki?.questionId);
                                    setState(() => isFavorite = !isFavorite);
                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 15,
                                  ),
                                ),
                                SizedBox(width: 10),
                                HtmlWidget(
                                  modulesProvider.getLessonTitleByQuestionID(
                                      wiki?.questionId ?? -1),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          color: textColor.withOpacity(0.5)),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            HtmlWidget(
                              wiki?.answer ?? "",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: textColor.withOpacity(0.8)),
                            )
                          ],
                        ),
                      ),
                    ),
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