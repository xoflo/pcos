import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/blank_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageComponent extends StatefulWidget {
  ImageComponent({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  State<ImageComponent> createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  bool canLaunchUrl = false;

  @override
  void initState() {
    super.initState();

    setCanLaunch();
  }

  void setCanLaunch() async {
    final canLaunchThumbnail = await canLaunch(widget.imageUrl);
    setState(() => canLaunchUrl = canLaunchThumbnail);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isNotEmpty && canLaunchUrl)
      return Image.network(
        widget.imageUrl,
        width: double.maxFinite,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => BlankImage(height: 200),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: PcosLoadingSpinner(),
          );
        },
      );
    return BlankImage(height: 200);
  }
}
