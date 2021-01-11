import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final int recipeId;
  final String title;
  final String thumbnail;

  RecipeListItem({this.recipeId, this.title, this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: FadeInImage.assetNetwork(
                  alignment: Alignment.center,
                  placeholder: 'assets/images/pcos_protocol.png',
                  image: thumbnail,
                  fit: BoxFit.fitWidth,
                  width: double.maxFinite,
                  height: 221,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  top: 12.0,
                ),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
