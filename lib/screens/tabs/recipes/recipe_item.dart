import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_recipe_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/recipes/recipe_details_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/blank_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecipeItem extends StatefulWidget {
  const RecipeItem({
    Key? key,
    required this.recipe,
    this.isFromLesson = true,
  }) : super(key: key);

  final bool isFromLesson;
  final LessonRecipe recipe;

  @override
  State<RecipeItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  bool canLaunchUrl = false;

  @override
  void initState() {
    super.initState();

    setCanLaunch();
  }

  void setCanLaunch() async {
    final canLaunchThumbnail =
        await canLaunchUrlString(widget.recipe.thumbnail ?? "");
    setState(() => canLaunchUrl = canLaunchThumbnail);
  }

  @override
  Widget build(BuildContext context) => OpenContainer(
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onClosed: (_) => Provider.of<FavouritesProvider>(context, listen: false)
            .fetchRecipesStatus(),
        closedColor: Colors.transparent,
        closedElevation: 0,
        openBuilder: (context, action) => RecipeDetailsPage(
            args: LessonRecipeArguments(widget.isFromLesson, widget.recipe)),
        closedBuilder: (context, action) => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.recipe.thumbnail?.isNotEmpty == true &&
                            canLaunchUrl
                        ? Image.network(
                            widget.recipe.thumbnail ?? "",
                            key: GlobalKey(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => BlankImage(),
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: PcosLoadingSpinner(),
                              );
                            },
                          )
                        : BlankImage(),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    child: HtmlWidget(
                      "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                          (widget.recipe.title ?? "") +
                          "</p>",
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
