import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/library/library_previous_module_item.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_page.dart';

class LibraryPreviousModulesKnowledgeItem extends StatefulWidget {
  const LibraryPreviousModulesKnowledgeItem({
    Key? key,
    required this.modulesProvider,
    required this.favouritesProvider,
    required this.item,
  }) : super(key: key);

  final Object item;
  final FavouritesProvider favouritesProvider;
  final ModulesProvider modulesProvider;

  @override
  State<LibraryPreviousModulesKnowledgeItem> createState() =>
      _LibraryPreviousModulesKnowledgeItemState();
}

class _LibraryPreviousModulesKnowledgeItemState
    extends State<LibraryPreviousModulesKnowledgeItem> {
  bool? isFavourite;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    if (isFavourite == null && item is LessonWiki) {
      isFavourite = widget.favouritesProvider.isFavourite(
        FavouriteType.Wiki,
        item.questionId,
      );
    }

    return GestureDetector(
      onTap: () {
        if (item is Module) {
          final lessons =
              widget.modulesProvider.getModuleLessons(item.moduleID);
          Navigator.pushNamed(
            context,
            LibraryPreviousModuleItem.id,
            arguments: lessons,
          );
        } else if (item is LessonWiki) {
          Navigator.pushNamed(
            context,
            LessonWikiPage.id,
            arguments: item,
          ).then((value) {
            if (value is bool) {
              setState(
                () => isFavourite = value,
              );
            }
          });
        }
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: HtmlWidget(
                (item is Module)
                    ? item.title ?? ""
                    : (item is LessonWiki ? item.question ?? "" : ""),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: backgroundColor,
                  fontSize: 18,
                ),
              ),
            ),
            if (item is LessonWiki)
              IconButton(
                onPressed: () {
                  widget.favouritesProvider.addToFavourites(
                    FavouriteType.Wiki,
                    item.questionId,
                  );
                  setState(() {
                    isFavourite = !(isFavourite ?? true);
                  });
                },
                icon: Icon(
                  isFavourite == true ? Icons.favorite : Icons.favorite_outline,
                  color: redColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
