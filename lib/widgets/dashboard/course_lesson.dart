import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/widgets/shared/dialog_header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/widgets/shared/video_player_chewie.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';

class CourseLesson extends StatelessWidget {
  final Lesson lesson;
  final Function closeLesson;
  final Function(dynamic, bool) addToFavourites;

  CourseLesson(
      {@required this.lesson,
      @required this.closeLesson,
      @required this.addToFavourites});

  final String staticHtmlContent =
      "<div><h3>Why a high protein breakfast?</h3><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'><strong>Protein is a good blood sugar stabilizer</strong>. Especially if you're eating carbohydrates. It's insulin's job to take that up and open the lock of the cell.</span></span></span></p><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'>If you’re eating mainly carbohydrates at breakfast, you may find that you have hangry attacks or are shaky and hungry an hour or so after eating. Even with this small change, you likely won’t continue to feel like you need to continually graze.</span></span></span></p><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'><strong>Your body craves sugar when your blood sugar gets low</strong>. It knows that sugar brings blood sugars up very quickly. Carbohydrates like potatoes and bread are all made from sugar molecules, but they take a lot longer to break down. </span></span></span></p><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'>But sugar in the form of glucose that you get in sweets or chocolate <strong>crosses the gut barrier into our blood very quickly</strong> and can raise our blood sugar up very quickly. If we keep our blood sugar stable from the start of the day, then it means we're not having those peaks and troughs.</span></span></span></p><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'>Protein is very <strong>satiating</strong>, meaning that we're not particularly hungry until well after we’ve eaten and that's absolutely fine. What it also means is that our <strong>insulin has longer to come down</strong> and glucagon (our fat burning hormone) has time to rise, which means we can actually <strong>use some of our stored fat for energy</strong>.</span></span></span></p><p><span style='font-size:11pt'><span style='font-family:Arial'><span style='color:#000000'>All you need to do at the moment is to try to hit that protein goal at breakfast - nothing else!</span></span></span></p></div>";

  double _getTabBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height - (kToolbarHeight + 20);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);

    return Container(
      height: _getTabBarHeight(context),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DialogHeader(
                screenSize: screenSize,
                item: lesson,
                favouriteType: FavouriteType.Lesson,
                title: "Breakfast",
                isFavourite: false,
                closeItem: closeLesson,
                addToFavourites: addToFavourites,
              ),
              Text(
                "Changing your breakfast",
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: VideoPlayerChewie(
                  screenSize: screenSize,
                  isHorizontal: isHorizontal,
                  videoUrl:
                      "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4",
                  //"https://pcosprotocolstorage.blob.core.windows.net/media/videos/Changing_your_breakfast.mp4",
                  //"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                  //"https://pcosprotocolstorage.blob.core.windows.net/media/videos/Lunch__and_Dinner.mp4",
                ),
              ),
              Html(data: staticHtmlContent),
            ],
          ),
        ),
      ),
    );
  }
}
