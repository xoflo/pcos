import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thepcosprotocol_app/models/question.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/wiki_card.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class LessonWikis extends StatelessWidget {
  final List<Question> wikiItems;
  final int selectedWiki;
  final double width;
  final bool isHorizontal;
  final Function(int) onSelected;
  final Function(Question) openWiki;

  LessonWikis({
    @required this.wikiItems,
    @required this.selectedWiki,
    @required this.width,
    @required this.isHorizontal,
    @required this.onSelected,
    @required this.openWiki,
  });

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
              padding: const EdgeInsets.all(4.0),
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
                height: 200,
                enableInfiniteScroll: false,
                viewportFraction: isHorizontal ? 0.50 : 0.92,
                initialPage: selectedWiki,
                onPageChanged: (index, reason) {
                  onSelected(index);
                },
              ),
              items: wikiItems.map((wiki) {
                return Builder(
                  builder: (BuildContext context) {
                    return WikiCard(
                      wiki: wiki,
                      openWiki: openWiki,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
