import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_lessons.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_recipes.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_toolkits.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_wikis.dart';

class FavouritesLayout extends StatefulWidget {
  @override
  _FavouritesLayoutState createState() => _FavouritesLayoutState();
}

class _FavouritesLayoutState extends State<FavouritesLayout>
    with TickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: index, length: 4, vsync: this);
    pageController = PageController(initialPage: index);
  }

  Tab generateTab(int itemNumber, String title) => Tab(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: index == itemNumber ? backgroundColor : Colors.white,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: index == itemNumber
                        ? Colors.white
                        : textColor.withOpacity(0.5),
                  ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: primaryColor),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                onTap: (value) {
                  setState(() => index = value);
                  pageController.jumpToPage(value);
                },
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                controller: tabController,
                indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                isScrollable: true,
                tabs: [
                  generateTab(0, S.current.toolkitTitle),
                  generateTab(1, S.current.lessonsTitle),
                  generateTab(2, S.current.wikiTitle),
                  generateTab(3, S.current.recipesTitle),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Consumer<FavouritesProvider>(
                  builder: (context, favouritesProvider, child) {
                    favouritesProvider.fetchToolkitStatus();
                    return PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() => index = value);
                        tabController.index = value;
                      },
                      children: [
                        FavouritesToolkits(
                            favouritesProvider: favouritesProvider),
                        FavouritesLessons(
                            favouritesProvider: favouritesProvider),
                        FavouritesWikis(favouritesProvider: favouritesProvider),
                        FavouritesRecipes(
                            favouritesProvider: favouritesProvider),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
}
