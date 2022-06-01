import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/messages_bell.dart';

class Header extends StatelessWidget {
  final String? title;
  final Function? closeItem;
  final bool showMessagesIcon;
  final bool showDivider;
  final int unreadCount;

  Header({
    this.title,
    this.closeItem,
    this.showMessagesIcon = false,
    this.showDivider = false,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, top: 1.0, bottom: 13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    closeItem?.call();
                  },
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: Container(
                      color: primaryColor,
                      child: Icon(
                        Icons.arrow_back,
                        color: backgroundColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: backgroundColor,
                      ),
                ),
                SizedBox(
                    width: 35,
                    height: 35,
                    child: showMessagesIcon
                        ? MessagesBell(messagesCount: unreadCount)
                        : Container()),
              ],
            ),
          ),
          if (showDivider)
            Divider(thickness: 1, height: 1, color: dividerColor),
        ],
      ),
    );
  }
}
