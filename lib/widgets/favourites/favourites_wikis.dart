import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesWikis extends StatefulWidget {
  const FavouritesWikis({Key? key, required this.favouritesProvider})
      : super(key: key);

  final FavouritesProvider favouritesProvider;

  @override
  State<FavouritesWikis> createState() => _FavouritesWikisState();
}

class _FavouritesWikisState extends State<FavouritesWikis> {
  @override
  Widget build(BuildContext context) {
    switch (widget.favouritesProvider.status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteLesson);
      case LoadingStatus.success:
        return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: widget.favouritesProvider.lessonWikis.length,
          itemBuilder: (context, item) {
            final wiki = widget.favouritesProvider.lessonWikis[item];

            final isFavoriteLesson = widget.favouritesProvider.isFavourite(
              FavouriteType.Wiki,
              wiki.questionId,
            );

            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                LessonWikiPage.id,
                arguments: wiki,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HtmlWidget(
                            wiki.question ?? "",
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: backgroundColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        IconButton(
                          onPressed: () {
                            widget.favouritesProvider.addToFavourites(
                              FavouriteType.Wiki,
                              wiki.questionId,
                            );
                          },
                          icon: Icon(
                            isFavoriteLesson
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: redColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      wiki.answer ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.8),
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
