import 'package:flutter/material.dart';

class ImageComponent extends StatelessWidget {
  const ImageComponent({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty)
      return Image.network(
        imageUrl,
        width: double.maxFinite,
        height: 200,
        fit: BoxFit.cover,
      );
    return Container(
      width: double.maxFinite,
      height: 200,
      color: Colors.white,
      child: Center(
        child: Image(
          image: AssetImage('assets/logo_pink.png'),
          fit: BoxFit.contain,
          width: 100,
          height: 50,
        ),
      ),
    );
  }
}
