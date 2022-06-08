import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class RecipeMethodTipsComponent extends StatelessWidget {
  const RecipeMethodTipsComponent({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isBottomDividerVisible = false,
  }) : super(key: key);

  final Function() onPressed;
  final String title;
  final bool isBottomDividerVisible;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: [
              Divider(
                thickness: 1,
                height: 1,
                color: textColor.withOpacity(0.5),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: secondaryColor,
                  )
                ],
              ),
              SizedBox(height: 25),
              if (isBottomDividerVisible)
                Divider(
                  thickness: 1,
                  height: 1,
                  color: textColor.withOpacity(0.5),
                ),
            ],
          ),
        ),
      );
}
