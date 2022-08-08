import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_recipe_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/recipe_method_tips_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details_stats_component.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_method_tips_component.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_method_tips_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({Key? key}) : super(key: key);

  static const id = "recipe_details_page";

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  LessonRecipeArguments? args;
  bool isFavorite = false;
  late FavouritesProvider favouritesProvider;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  String get difficultyText {
    switch (args?.recipe.difficulty) {
      case 1:
        return S.current.recipeDifficultyEasy;
      case 2:
        return S.current.recipeDifficultyMedium;
      case 3:
        return S.current.recipeDifficultyHard;
    }
    return "";
  }

  bool get isFromLessonsPage => args?.isFromLessonsPage ?? true;

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args =
          ModalRoute.of(context)?.settings.arguments as LessonRecipeArguments;
      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Recipe, args?.recipe.recipeId);
    }

    List<String> tags = args?.recipe.tags?.isNotEmpty == true
        ? (args?.recipe.tags?.split(",") ?? [])
        : [];

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => Platform.isIOS ? false : true,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: isFromLessonsPage ? 12.0 : 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isFromLessonsPage)
                    Header(
                      title: "Lesson Recipe",
                      closeItem: () => Navigator.pop(context),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageComponent(
                                  imageUrl: args?.recipe.thumbnail ?? ""),
                              if (tags.isNotEmpty) ...[
                                SizedBox(height: 30),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: tags
                                        .map(
                                          (tag) => Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: textColor.withOpacity(0.5),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24)),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            child: Text(
                                              tag,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.copyWith(
                                                      color: textColor
                                                          .withOpacity(0.5)),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                              SizedBox(height: 25),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        args?.recipe.title ?? "",
                                        style:
                                            Theme.of(context).textTheme.headline1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        favouritesProvider.addToFavourites(
                                            FavouriteType.Recipe,
                                            args?.recipe.recipeId);
                                        setState(() => isFavorite = !isFavorite);
                                      },
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: backgroundColor,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              RecipeDetailsStatsComponent(
                                duration: args?.recipe.duration,
                                servings: args?.recipe.servings,
                                difficulty: difficultyText,
                              ),
                              if (args?.recipe.description?.isNotEmpty ==
                                  true) ...[
                                SizedBox(height: 25),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child:
                                      HtmlWidget(args?.recipe.description ?? ""),
                                )
                              ],
                              SizedBox(height: 25),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ingredients",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    SizedBox(height: 10),
                                    HtmlWidget(
                                      args?.recipe.ingredients ?? "",
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            height: 1.25,
                                            color: textColor.withOpacity(0.8),
                                          ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              if (args?.recipe.method?.isNotEmpty == true)
                                RecipeMethodTipsComponent(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    RecipeMethodTipsPage.id,
                                    arguments: RecipeMethodTipsArguments(
                                      false,
                                      args?.recipe.method ?? "",
                                    ),
                                  ),
                                title: "Method",
                                  isBottomDividerVisible:
                                      args?.recipe.tips?.isEmpty == true,
                                ),
                              if (args?.recipe.tips?.isNotEmpty == true)
                                RecipeMethodTipsComponent(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    RecipeMethodTipsPage.id,
                                    arguments: RecipeMethodTipsArguments(
                                      true,
                                      args?.recipe.tips ?? "",
                                    ),
                                  ),
                                  title: "Tips",
                                  isBottomDividerVisible: true,
                                ),
                              SizedBox(height: 25),
                            ],
                          ),
                          if (!isFromLessonsPage)
                            Positioned(
                              left: 15,
                              top: 15,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                            ),
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
