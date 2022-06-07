import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/navigation/recipe_method_tips_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/datetime_utils.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_method_tips_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({Key? key}) : super(key: key);

  static const id = "recipe_details_page";

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  LessonRecipe? recipe;
  bool isFavorite = false;
  late FavouritesProvider favouritesProvider;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  String get difficultyText {
    switch (recipe?.difficulty) {
      case 1:
        return S.current.recipeDifficultyEasy;
      case 2:
        return S.current.recipeDifficultyMedium;
      case 3:
        return S.current.recipeDifficultyHard;
    }
    return "";
  }

  Color get difficultyColor {
    switch (recipe?.difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.redAccent;
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      recipe = ModalRoute.of(context)?.settings.arguments as LessonRecipe;
      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Recipe, recipe?.recipeId);
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
                  title: "Lesson Recipe",
                  closeItem: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          recipe?.thumbnail ?? "",
                          width: double.maxFinite,
                          height: 360,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  recipe?.title ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  favouritesProvider.addToFavourites(
                                      FavouriteType.Recipe, recipe?.recipeId);
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
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Divider(
                                thickness: 1,
                                height: 1,
                                color: textColor.withOpacity(0.5),
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Serves",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text("${recipe?.servings}")
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Duration",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(DateTimeUtils
                                                  .convertMillisecondsToMinutes(
                                                      recipe?.duration ?? 0)
                                              .toString() +
                                          " " +
                                          S.current.minutesShort)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Difficulty",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: textColor.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(difficultyText)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Divider(
                                thickness: 1,
                                height: 1,
                                color: textColor.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        if (recipe?.description?.isNotEmpty == true) ...[
                          SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: HtmlWidget(recipe?.description ?? ""),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 10),
                              HtmlWidget(
                                recipe?.ingredients ?? "",
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: textColor.withOpacity(0.8),
                                  height: 1.25,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RecipeMethodTipsPage.id,
                              arguments: RecipeMethodTipsArguments(
                                false,
                                recipe?.method ?? "",
                              ),
                            ),
                            child: Column(
                              children: [
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: textColor.withOpacity(0.5),
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Method"),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: secondaryColor,
                                    )
                                  ],
                                ),
                                SizedBox(height: 25),
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RecipeMethodTipsPage.id,
                              arguments: RecipeMethodTipsArguments(
                                true,
                                recipe?.tips ?? "",
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tips"),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: secondaryColor,
                                    )
                                  ],
                                ),
                                SizedBox(height: 25),
                                Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
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
