import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class DashboardLessonCarouselItemCard extends StatelessWidget {
  const DashboardLessonCarouselItemCard({
    Key? key,
    this.onTapCard,
    required this.isLocked,
    this.showCompletedTag = false,
    required this.title,
    this.subtitle,
    required this.duration,
    required this.asset,
    required this.assetSize,
  }) : super(key: key);

  final Function()? onTapCard;
  final bool isLocked;
  final bool showCompletedTag;
  final String title;
  final String? subtitle;
  final String duration;
  final String asset;
  final Size assetSize;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: isLocked ? 1 : 0.5,
        child: GestureDetector(
          onTap: onTapCard,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: lessonBackgroundColor,
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
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
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
                              color: textColor.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                        ] else
                          SizedBox(height: 30),
                        Row(
                          children: [
                            Icon(Icons.schedule, color: textColor, size: 15),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              duration,
                              style: TextStyle(
                                color: textColor.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Image(
                  image: AssetImage(asset),
                  width: assetSize.width,
                  height: assetSize.height,
                ),
              ],
            ),
          ),
        ),
      );
}
