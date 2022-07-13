import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/screens/notifications/notification_settings.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class Header extends StatelessWidget {
  final String? title;
  final Function? closeItem;
  final bool showDivider;
  final bool isAllSelected;
  final Function()? onToggleSelectAll;
  final int unreadCount;
  final Function()? onToggleMarkAsRead;
  final int? questionNumber;
  final int? questionCount;

  Header({
    this.title,
    this.closeItem,
    this.showDivider = false,
    this.isAllSelected = false,
    this.unreadCount = 0,
    this.questionNumber,
    this.questionCount,
    this.onToggleMarkAsRead,
    this.onToggleSelectAll,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 1.0, bottom: 13.0),
              child: Row(
                children: [
                  if (onToggleSelectAll != null) ...[
                    GestureDetector(
                      onTap: () => onToggleSelectAll?.call(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(
                              isAllSelected
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank,
                              size: 24,
                              color: backgroundColor,
                            ),
                            SizedBox(width: 10),
                            Text("Select all",
                                style: TextStyle(
                                    fontSize: 16, color: backgroundColor))
                          ],
                        ),
                      ),
                    )
                  ] else ...[
                    GestureDetector(
                      onTap: () => closeItem?.call(),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Container(
                          color: primaryColor,
                          child: Icon(
                            Icons.arrow_back,
                            color: backgroundColor
                                .withOpacity(closeItem != null ? 1 : 0.5),
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Text(
                      title ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: backgroundColor,
                          ),
                    ),
                  ],
                  if (onToggleMarkAsRead != null) ...[
                    Spacer(flex: 1),
                    IconButton(
                      icon: Icon(
                        Icons.mark_chat_read_outlined,
                        size: 24,
                        color: backgroundColor,
                      ),
                      onPressed: onToggleMarkAsRead,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 24,
                        color: backgroundColor,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, NotificationSettings.id),
                    )
                  ] else if (questionCount != null &&
                      questionNumber != null) ...[
                    Spacer(flex: 2),
                    Text("$questionNumber of $questionCount"),
                  ] else ...[
                    Spacer(flex: 2),
                    SizedBox(width: 35, height: 35, child: Container())
                  ],
                ],
              ),
            ),
            if (showDivider)
              Divider(thickness: 1, height: 1, color: dividerColor),
          ],
        ),
      );
}
