import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_component.dart';

import '../../../models/navigation/workout_details_page_arguments.dart';

class WorkoutDetailsPage extends StatefulWidget {
  const WorkoutDetailsPage({Key? key, this.args}) : super(key: key);

  static const id = "workout_details_page";

  final WorkoutDetailsPageArguments? args;

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  WorkoutDetailsPageArguments? args;
  bool isFavorite = false;
  late FavouritesProvider favouritesProvider;

  @override
  void initState() {
    super.initState();
    favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
  }

  String get difficultyText {
    // switch (args?.workout.difficulty) {
    //   case 1:
    //     return S.current.recipeDifficultyEasy;
    //   case 2:
    //     return S.current.recipeDifficultyMedium;
    //   case 3:
    //     return S.current.recipeDifficultyHard;
    // }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args = widget.args;
      isFavorite = favouritesProvider.isFavourite(
          FavouriteType.Workout, args?.workout.workoutID);
    }

    List<String> tags = args?.workout.tags?.isNotEmpty == true
        ? (args?.workout.tags?.split(",") ?? [])
        : [];

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => !Platform.isIOS,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageComponent(
                                  imageUrl: args?.workout.imageUrl ?? ""),
                              if (tags.isNotEmpty) ...[
                                SizedBox(height: 30),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: tags
                                        .where((element) => element.isNotEmpty)
                                        .toList()
                                        .map(
                                          (tag) => Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    textColor.withOpacity(0.5),
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
                                      child: HtmlWidget(
                                        args?.workout.title ?? "",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        favouritesProvider.addToFavourites(
                                            FavouriteType.Workout,
                                            args?.workout.workoutID);
                                        setState(
                                            () => isFavorite = !isFavorite);
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
                              // RecipeDetailsStatsComponent(
                              //   duration: args?.workout.minsToComplete,
                              //   servings: args?.recipe.servings,
                              //   difficulty: difficultyText,
                              // ),
                              if (args?.workout.description?.isNotEmpty ==
                                  true) ...[
                                SizedBox(height: 25),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: HtmlWidget(
                                    args?.workout.description ?? "",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          height: 1.5,
                                          color: textColor.withOpacity(0.8),
                                        ),
                                  ),
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
                                      args?.workout.description ?? "",
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            height: 1.5,
                                            color: textColor.withOpacity(0.8),
                                          ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              
                            ],
                          ),
                          
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
