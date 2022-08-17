import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/dashboard_lesson_locked_component.dart';

class DashboardLessonCarouselItemCard extends StatelessWidget {
  const DashboardLessonCarouselItemCard({
    Key? key,
    this.onTapCard,
    required this.isUnlocked,
    this.showCompletedTag = false,
    this.showCompleteLesson = false,
    required this.title,
    this.subtitle,
    this.duration,
    required this.asset,
    required this.assetSize,
  }) : super(key: key);

  final Function()? onTapCard;
  final bool isUnlocked;
  final bool showCompletedTag;
  final bool showCompleteLesson;
  final String title;
  final String? subtitle;
  final String? duration;
  final String asset;
  final Size assetSize;

  @override
  Widget build(BuildContext context) {
    final double unlockedOpacity = isUnlocked ? 1 : 0.5;
    return GestureDetector(
      onTap: onTapCard,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: lessonBackgroundColor.withOpacity(unlockedOpacity),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
                      "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                          (title) +
                          "</p>",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: backgroundColor),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 10),
                      Text(
                        subtitle ?? "",
                        style: TextStyle(
                          color: textColor.withOpacity(isUnlocked ? 0.8 : 0.5),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                    ] else
                      SizedBox(height: 30),
                    if (showCompleteLesson)
                      DashboardLessonLockedComponent(
                          title: "Complete the lesson")
                    else if (showCompletedTag)
                      Container(
                        decoration: BoxDecoration(
                          color: completedBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Text(
                          "Completed",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    else if (duration != null)
                      Row(
                        children: [
                          Icon(Icons.schedule, color: textColor, size: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            duration ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                    color: textColor
                                        .withOpacity(isUnlocked ? 0.8 : 0.5)),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: unlockedOpacity,
              child: Image(
                image: AssetImage(asset),
                width: assetSize.width,
                height: assetSize.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
