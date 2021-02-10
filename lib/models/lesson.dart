import 'package:thepcosprotocol_app/constants/lesson_type.dart';

class Lesson {
  final int lessonId;
  final LessonType lessonType;
  final String title;
  final String description;
  Lesson({
    this.lessonId,
    this.lessonType,
    this.title,
    this.description,
  });

  factory Lesson.fromValues(
    final int lessonId,
    final LessonType lessonType,
    final String title,
    final String description,
  ) {
    return Lesson(
      lessonId: lessonId,
      lessonType: lessonType,
      title: title,
      description: description,
    );
  }
}
