import 'package:flutter/foundation.dart';
import 'package:thepcosprotocol_app/providers/database_provider.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/constants/lesson_type.dart';

class FavouritesProvider with ChangeNotifier {
  final DatabaseProvider dbProvider;

  FavouritesProvider({@required this.dbProvider}) {
    if (dbProvider != null) getDataFromDatabase(dbProvider);
  }

  List<Lesson> _itemsLessons = [];
  LoadingStatus statusLessons = LoadingStatus.empty;

  List<Lesson> get itemsLessons => [..._itemsLessons];

  Future<void> getDataFromDatabase(
    final dbProvider,
  ) async {
    statusLessons = LoadingStatus.loading;

    debugPrint("****************** GET THE LESSON FAVOURITES");

    notifyListeners();
    // You have to check if db is not null, otherwise it will call on create, it should do this on the update (see the ChangeNotifierProxyProvider added on app.dart)
    List<Lesson> lessonFavourites = List<Lesson>();

    final Lesson fave1 = Lesson(
        lessonId: 1,
        lessonType: LessonType.Video,
        title: "This is a lesson",
        description:
            "This lesson is really good, it is a video and you can watch it.");

    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);
    lessonFavourites.add(fave1);

    _itemsLessons = lessonFavourites;

    statusLessons =
        _itemsLessons.isEmpty ? LoadingStatus.empty : LoadingStatus.success;

    notifyListeners();
  }
}
