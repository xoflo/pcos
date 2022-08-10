import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:thepcosprotocol_app/widgets/shared/blank_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImageComponent extends StatefulWidget {
  ImageComponent({Key? key, required this.imageUrl, this.tag = 'image'})
      : super(key: key);

  final String imageUrl;
  final String tag;

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
    final canLaunchThumbnail = await canLaunchUrlString(widget.imageUrl);
    setState(() => canLaunchUrl = canLaunchThumbnail);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isNotEmpty && canLaunchUrl) {
      return FullScreenWidget(
        disposeLevel: DisposeLevel.High,
        backgroundIsTransparent: true,
        backgroundColor: Colors.grey.withOpacity(0.5),
        child: InteractiveViewer(
          child: Hero(
            tag: widget.tag,
            child: Image.network(
              widget.imageUrl,
              width: double.maxFinite,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => BlankImage(height: 200),
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: PcosLoadingSpinner(),
                );
              },
            ),
          ),
        ),
      );
    }
    return BlankImage(height: 200);
  }
}
