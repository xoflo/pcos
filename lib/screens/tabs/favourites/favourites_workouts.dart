import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/image_view_item.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

import '../../../models/navigation/workout_details_page_arguments.dart';
import '../workouts/workout_details_page.dart';

class FavouritesWorkouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    favouritesProvider.fetchWorkoutsStatus(notifyListener: false);

    return LoaderOverlay(
      indicatorPosition: Alignment.center,
      loadingStatusNotifier: favouritesProvider,
      height: double.maxFinite,
      emptyMessage: S.current.noFavouriteWorkout,
      overlayBackgroundColor: Colors.transparent,
      child: GridView.count(
        padding: EdgeInsets.all(10),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(
          favouritesProvider.workouts.length,
          (index) {
            final workout = favouritesProvider.workouts[index];

            return ImageViewItem(
              thumbnail: workout.imageUrl,
              onViewPressed: () => WorkoutDetailsPage(args: WorkoutDetailsPageArguments(workout)),
              onViewClosed: () => Provider.of<FavouritesProvider>(context, listen: false).fetchWorkoutsStatus(),
              title: workout.title
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
