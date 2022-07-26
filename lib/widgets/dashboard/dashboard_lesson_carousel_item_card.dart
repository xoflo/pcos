import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/dashboard_lesson_locked_component.dart';

class DashboardLessonCarouselItemCard extends StatelessWidget {
  const DashboardLessonCarouselItemCard({
    Key? key,
    this.onTapCard,
    required this.isUnlocked,
    this.showCompletedTag = false,
    this.showCompleteLesson = false,
    required this.title,
    this.subtitle,
    required this.duration,
    required this.asset,
    required this.assetSize,
  }) : super(key: key);

  final Function()? onTapCard;
  final bool isUnlocked;
  final bool showCompletedTag;
  final bool showCompleteLesson;
  final String title;
  final String? subtitle;
  final String duration;
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: backgroundColor.withOpacity(unlockedOpacity),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showCompletedTag) ...[
                          SizedBox(width: 15),
                          Container(
                            decoration: BoxDecoration(
                              color: completedBackgroundColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Text(
                              "Completed",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 10),
                      HtmlWidget(
                        subtitle ?? "",
                        textStyle: TextStyle(
                          color: textColor.withOpacity(isUnlocked ? 0.8 : 0.5),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                    ] else
                      SizedBox(height: 30),
                    if (showCompleteLesson) ...[
                      DashboardLessonLockedComponent(
                          title: "Complete the lesson")
                    ] else
                      Row(
                        children: [
                          Icon(Icons.schedule, color: textColor, size: 15),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            duration,
                            style: TextStyle(
                              color:
                                  textColor.withOpacity(isUnlocked ? 0.8 : 0.5),
                              fontSize: 14,
                            ),
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
