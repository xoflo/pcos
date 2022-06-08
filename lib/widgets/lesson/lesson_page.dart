import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/models/lesson_content.dart';
import 'package:thepcosprotocol_app/models/navigation/lesson_arguments.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key? key}) : super(key: key);

  static const id = "lesson_page";

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  String contentIcon = '';
  String contentType = '';
  List<Widget> getType(List<LessonContent> lessonContent) {
    setState(() {
      lessonContent.forEach((element) {
        switch (element.mediaMimeType) {
          case 'video':
            contentIcon = "assets/lesson_video.png";
            contentType = "Video";
            break;
          case 'audio':
            contentIcon = "assets/lesson_audio.png";
            contentType = "Audio";
            break;
          default:
            contentIcon = "assets/lesson_reading.png";
            contentType = "Reading";
            break;
        }
      });
    });

    return [
      Image(
        image: AssetImage(contentIcon),
        width: 20,
        height: 20,
        color: textColor.withOpacity(0.5),
      ),
      SizedBox(width: 5),
      Text(
        contentType,
        style: TextStyle(
          fontSize: 14,
          color: textColor.withOpacity(0.8),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as LessonArguments;
    final lessonContents = args.lessonContents;
    final firstLessonContent = lessonContents.first;
    final otherLessonContent = lessonContents.sublist(1, lessonContents.length);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 12.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: "Lesson",
                  closeItem: () => Navigator.pop(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (args.lesson.imageUrl.isNotEmpty)
                          Image.network(
                            args.lesson.imageUrl,
                            width: double.maxFinite,
                            height: 200,
                            fit: BoxFit.cover,
                            color: Colors.black,
                          )
                        else
                          Container(
                            width: double.maxFinite,
                            height: 200,
                            color: Colors.black,
                          ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            args.lesson.title,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: getType(args.lessonContents),
                                  ),
                                  SizedBox(width: 15),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 20,
                                            color: textColor.withOpacity(0.5),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "5 mins",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: HtmlWidget(
                            firstLessonContent.body ?? "",
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                        if (otherLessonContent.first.body?.isNotEmpty == true)
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              child: Text(
                                "Read More",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        if (contentType == 'Video') ...[
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FilledButton(
                                text: "Play Video",
                                icon: Icon(Icons.play_arrow_outlined, size: 18),
                                margin: EdgeInsets.zero,
                                width: 160,
                                isRoundedButton: true,
                                foregroundColor: Colors.white,
                                backgroundColor: backgroundColor,
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                        if (args.lessonWikis.isNotEmpty) ...[
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wikis",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 20,
                                  ),
                                ),
                                ...args.lessonWikis
                                    .map(
                                      (element) => GestureDetector(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Container(
                                              width: double.maxFinite,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    element.question ?? "",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: backgroundColor,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    element.answer ?? "",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: textColor
                                                          .withOpacity(0.8),
                                                      height: 1.25,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          )
                        ],
                        if (args.lessonTasks.isNotEmpty) ...[
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 20,
                                  ),
                                ),
                                ...args.lessonTasks
                                    .map(
                                      (element) => GestureDetector(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Container(
                                              width: double.maxFinite,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    element.title ?? "",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: backgroundColor,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: backgroundColor,
                                                    size: 10,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()
                              ],
                            ),
                          )
                        ],
                      ],
                    ),
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
