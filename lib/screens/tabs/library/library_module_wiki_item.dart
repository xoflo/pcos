import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thepcosprotocol_app/models/module.dart';
import 'package:thepcosprotocol_app/models/navigation/library_wiki_arguments.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/screens/tabs/library/library_module_page.dart';
import 'package:thepcosprotocol_app/screens/tabs/library/library_wiki_page.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LibraryModuleWikiItem extends StatefulWidget {
  const LibraryModuleWikiItem({
    Key? key,
    required this.modulesProvider,
    required this.favouritesProvider,
    required this.item,
    required this.isPreviousModules,
  }) : super(key: key);

  final Module item;
  final FavouritesProvider favouritesProvider;
  final ModulesProvider modulesProvider;
  final bool isPreviousModules;

  @override
  State<LibraryModuleWikiItem> createState() => _LibraryModuleWikiItemState();
}

class _LibraryModuleWikiItemState extends State<LibraryModuleWikiItem> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTap: () {
        if (widget.isPreviousModules) {
          final lessons =
              widget.modulesProvider.getModuleLessons(item.moduleID);
          Navigator.pushNamed(
            context,
            LibraryModulePage.id,
            arguments: lessons,
          );
        } else {
          final wikis = widget.modulesProvider.getModuleWikis(item.moduleID);
          Navigator.pushNamed(
            context,
            LibraryWikiPage.id,
            arguments: LibraryWikiArguments(item.title, wikis),
          );
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
                item.title,
                textStyle: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
