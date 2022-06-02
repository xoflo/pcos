import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class Header extends StatelessWidget {
  final String? title;
  final Function? closeItem;
  final bool showDivider;
  final int unreadCount;
  final Function()? onToggleMarkAsRead;

  Header({
    this.title,
    this.closeItem,
    this.showDivider = false,
    this.unreadCount = 0,
    this.onToggleMarkAsRead,
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      onPressed: null,
                    )
                  ] else ...[
                    Spacer(flex: 2),
                    SizedBox(width: 35, height: 35, child: Container())
                  ]

                  // SizedBox(
                  //   width: 35,
                  //   height: 35,
                  //   child: showMessagesIcon
                  //       ? MessagesBell(messagesCount: unreadCount)
                  //       : Container(),
                  // ),
                ],
              ),
            ),
            if (showDivider)
              Divider(thickness: 1, height: 1, color: dividerColor),
          ],
        ),
      );
}
