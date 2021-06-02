import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_lessons_list.dart';
import 'package:thepcosprotocol_app/widgets/favourites/favourites_recipes_list.dart';
import 'package:thepcosprotocol_app/widgets/shared/question_list.dart';

class FavouritesTab extends StatelessWidget {
  final Size screenSize;
  final List<dynamic> favourites;
  final LoadingStatus status;
  final FavouriteType favouriteType;
  final Function(FavouriteType, dynamic) openFavourite;
  final Function(FavouriteType, dynamic, bool) removeFavourite;

  FavouritesTab({
    @required this.screenSize,
    @required this.favourites,
    @required this.status,
    @required this.favouriteType,
    @required this.openFavourite,
    @required this.removeFavourite,
  });

  String _getNoResultsMessage(
      final BuildContext context, final FavouriteType favouriteType) {
    String noResultsMessage = S.of(context).noItemsFound;
    switch (favouriteType) {
      case FavouriteType.Lesson:
        noResultsMessage = S.of(context).noFavouriteLesson;
        break;
      case FavouriteType.KnowledgeBase:
        noResultsMessage = S.of(context).noFavouriteKB;
        break;
      case FavouriteType.Recipe:
        noResultsMessage = S.of(context).noFavouriteRecipe;
        break;
      case FavouriteType.None:
        noResultsMessage = S.of(context).noItemsFound;
        break;
    }
    return noResultsMessage;
  }

  Widget _getContent(
    final BuildContext context,
    final List<dynamic> favourites,
    final FavouriteType favouriteType,
    final double width,
  ) {
    switch (favouriteType) {
      case FavouriteType.Lesson:
        return FavouritesLessonsList(
          lessons: favourites,
          width: width,
          removeFavourite: removeFavourite,
          openFavourite: openFavourite,
        );
      case FavouriteType.KnowledgeBase:
        return QuestionList(
          questions: favourites,
          showIcon: true,
          iconData: Icons.delete,
          iconDataOn: Icons.delete,
          iconAction: removeFavourite,
        );
      case FavouriteType.Recipe:
        return FavouritesRecipesList(
          recipes: favourites,
          width: width,
          removeFavourite: removeFavourite,
          openFavourite: openFavourite,
        );
      case FavouriteType.None:
        return Container();
    }
    return Container();
  }

  Widget _getFavouritesList(final BuildContext context) {
    switch (status) {
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.empty:
        return NoResults(message: _getNoResultsMessage(context, favouriteType));
      case LoadingStatus.success:
        return favourites == null || favourites.length == 0
            ? NoResults(message: _getNoResultsMessage(context, favouriteType))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _getContent(
                  context,
                  favourites,
                  favouriteType,
                  screenSize.width,
                ),
              );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getFavouritesList(context),
        ],
      ),
    );
  }
}
