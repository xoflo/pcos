import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/blank_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';

class ImageComponent extends StatelessWidget {
  const ImageComponent({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty)
      return Image.network(
        imageUrl,
        width: double.maxFinite,
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => BlankImage(height: 300),
        loadingBuilder: (_, __, ___) => Container(
          height: 300,
          padding: EdgeInsets.only(bottom: 30),
          child: PcosLoadingSpinner(),
        ),
      );
    return BlankImage(height: 200);
  }
}
