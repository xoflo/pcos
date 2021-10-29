import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';

class LessonWikiFull extends StatefulWidget {
  final LessonWiki wiki;
  final Function closeWiki;
  final Function(LessonWiki) addToFavourites;

  LessonWikiFull({
    @required this.wiki,
    @required this.closeWiki,
    @required this.addToFavourites,
  });

  @override
  _LessonWikiFullState createState() => _LessonWikiFullState();
}

class _LessonWikiFullState extends State<LessonWikiFull> {
  void _addToFavourites(final dynamic wiki, final bool add) async {
    widget.addToFavourites(wiki);
    setState(() {
      widget.wiki.isFavorite = !widget.wiki.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    if (widget.wiki == null) {
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
                item: widget.wiki,
                favouriteType: FavouriteType.Wiki,
                title: S.of(context).lessonWiki,
                isFavourite: widget.wiki.isFavorite,
                closeItem: widget.closeWiki,
                addToFavourites: _addToFavourites,
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
                        child: HtmlWidget(widget.wiki.question),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: screenSize.width,
                        child: HtmlWidget(widget.wiki.answer),
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
