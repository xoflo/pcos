import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class AppTutorialGetStartedItem extends StatelessWidget {
  const AppTutorialGetStartedItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.asset,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String asset;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            padding: EdgeInsets.all(15),
            width: double.maxFinite,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: textColor.withOpacity(0.8)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              right: 5,
            ),
            child: Image(
              image: AssetImage(asset),
              height: 50,
              width: 50,
            ),
          ),
        ],
      );
}
