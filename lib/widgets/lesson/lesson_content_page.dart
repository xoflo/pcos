import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

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

  late FavouritesProvider favouritesProvider;
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      lesson = ModalRoute.of(context)?.settings.arguments as Lesson;
      lessonContent = modulesProvider.getLessonContent(lesson?.lessonID ?? -1);

      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Lesson, lesson?.lessonID);
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isFavorite);
        return false;
      },
      child: Scaffold(
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
                    closeItem: () => Navigator.pop(context, isFavorite),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (lesson?.imageUrl.isNotEmpty == true)
                            Image.network(
                              lesson?.imageUrl ?? "",
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    lesson?.title ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: textColor.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
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
                          ...lessonContent
                                  ?.map(
                                    (element) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: HtmlWidget(
                                        element.body ?? "",
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              []
                        ],
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
