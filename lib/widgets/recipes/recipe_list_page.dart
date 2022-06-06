import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  static const id = "recipes_list_page";

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  Widget build(BuildContext context) {
    final List<LessonRecipe> recipes =
        ModalRoute.of(context)?.settings.arguments as List<LessonRecipe>;

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
                showDivider: true,
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(
                    recipes.length,
                    (index) {
                      final recipe = recipes[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                recipe.thumbnail ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment(1, 0.8),
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7)
                                    ],
                                    tileMode: TileMode.clamp,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 20,
                              child: Text(
                                recipe.title ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    growable: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
