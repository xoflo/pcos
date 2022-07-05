import 'package:flutter/material.dart';

class BlankImage extends StatelessWidget {
  const BlankImage({Key? key, this.height}) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        height: height,
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
