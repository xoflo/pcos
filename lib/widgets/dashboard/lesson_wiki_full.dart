import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class LessonWikiFull extends StatelessWidget {
  final BuildContext parentContext;
  final LessonWiki wiki;
  final bool isFavourite;
  final Function closeWiki;

  LessonWikiFull({
    @required this.parentContext,
    @required this.wiki,
    @required this.isFavourite,
    @required this.closeWiki,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    if (this.wiki == null) {
      return Container();
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                item: this.wiki,
                favouriteType: FavouriteType.Wiki,
                title: S.of(context).lessonWiki,
                isFavourite: this.wiki.isFavorite,
                closeItem: this.closeWiki,
                onAction: () {},
              ),
              Container(
                width: screenSize.width,
                height: screenSize.height - 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: screenSize.width,
                        child: HtmlWidget(this.wiki.question),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: screenSize.width,
                        child: HtmlWidget(this.wiki.answer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
