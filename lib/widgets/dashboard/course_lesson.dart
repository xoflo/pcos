import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/card_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player_chewie.dart';

class CourseLesson extends StatelessWidget {
  final int lessonId;
  final Function closeLesson;

  CourseLesson({this.lessonId, this.closeLesson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 1.0,
        top: 1.0,
        right: 1.0,
      ),
      child: SizedBox.expand(
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CardHeader(
                  itemId: lessonId,
                  favouriteType: FavouriteType.Lesson,
                  title: "A test lesson",
                  isFavourite: false,
                  closeItem: closeLesson,
                ),
                Text("Lesson Id=${lessonId}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: VideoPlayerChewie(
                    videoUrl:
                        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                    //"https://pcosprotocolstorage.blob.core.windows.net/media/videos/Lunch__and_Dinner.mp4",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
