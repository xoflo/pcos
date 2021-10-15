import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/wiki_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonWikis extends StatelessWidget {
  final int lessonId;
  final ModulesProvider modulesProvider;
  final int selectedWiki;
  final double width;
  final bool isHorizontal;
  final Function(int) onSelected;
  final Function(ModulesProvider, Question) addToFavourites;

  LessonWikis({
    @required this.lessonId,
    @required this.modulesProvider,
    @required this.selectedWiki,
    @required this.width,
    @required this.isHorizontal,
    @required this.onSelected,
    @required this.addToFavourites,
  });

  void _addToFavourites(final Question wiki) {
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
                style: Theme.of(context).textTheme.headline5,
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
              items: modulesProvider.getLessonWikis(lessonId).map((wiki) {
                return WikiCard(
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
