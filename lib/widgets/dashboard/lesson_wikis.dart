import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/wiki_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonWikis extends StatelessWidget {
  final Size screenSize;
  final int lessonId;
  final List<LessonWiki> lessonWikis;
  final ModulesProvider modulesProvider;
  final int selectedWiki;
  final double width;
  final bool isHorizontal;
  final Function(int) onSelected;
  final Function(ModulesProvider, LessonWiki) addToFavourites;

  LessonWikis({
    @required this.screenSize,
    @required this.lessonId,
    @required this.lessonWikis,
    @required this.modulesProvider,
    @required this.selectedWiki,
    @required this.width,
    @required this.isHorizontal,
    @required this.onSelected,
    @required this.addToFavourites,
  });

  void _addToFavourites(final LessonWiki wiki) {
    this.addToFavourites(this.modulesProvider, wiki);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                S.of(context).lessonWiki,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 260,
                enableInfiniteScroll: false,
                viewportFraction: isHorizontal ? 0.50 : 0.92,
                initialPage: selectedWiki,
                onPageChanged: (index, reason) {
                  onSelected(index);
                },
              ),
              items: lessonWikis.map((wiki) {
                return WikiCard(
                  screenSize: screenSize,
                  wiki: wiki,
                  addToFavourites: _addToFavourites,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
