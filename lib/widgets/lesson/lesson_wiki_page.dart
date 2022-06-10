import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
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
    if (wiki == null) {
      wiki = ModalRoute.of(context)?.settings.arguments as LessonWiki;
      isFavorite =
          favouritesProvider.isFavourite(FavouriteType.Wiki, wiki?.questionId);
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
                  title: "Wikis",
                  closeItem: () => Navigator.pop(context),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: backgroundColor,
                                  ),
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
                                    FavouriteType.Wiki,
                                    wiki?.questionId,
                                    moduleId: wiki?.moduleId,
                                    lessonId: wiki?.lessonId,
                                  );
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
                                modulesProvider.getLessonTitleByLessonID(
                                    wiki?.lessonId ?? -1),
                                textStyle: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          HtmlWidget(
                            wiki?.answer ?? "",
                            textStyle: TextStyle(
                              color: textColor.withOpacity(0.8),
                              fontSize: 16,
                            ),
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
    );
  }
}
