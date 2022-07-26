import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class DashboardLessonLockedComponent extends StatelessWidget {
  const DashboardLessonLockedComponent({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock_outline,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
}
