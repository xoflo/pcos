import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_toolkit_details.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class FavouritesToolkits extends StatelessWidget {
  const FavouritesToolkits({
    Key? key,
    required this.toolkits,
    required this.status,
  }) : super(key: key);

  final List<Lesson> toolkits;
  final LoadingStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: S.current.noFavouriteLesson);
      case LoadingStatus.success:
        return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: toolkits.length,
          itemBuilder: (context, item) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                FavouritesToolkitDetails.id,
                arguments: toolkits[item],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HtmlWidget(
                        toolkits[item].title,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Image(
                      image: AssetImage('assets/favorite_toolkit.png'),
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
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
