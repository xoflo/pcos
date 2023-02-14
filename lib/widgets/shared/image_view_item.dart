import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thepcosprotocol_app/widgets/shared/blank_image.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Widget that displays image in a rounded-corner view that serves as view items in a collective view like grid view.
/// onViewPressed: Usually, tapping this view transitions to another page when tapped (e.g. detail page).
class ImageViewItem extends StatefulWidget {
  const ImageViewItem({
    Key? key,
    required this.thumbnail,
    required this.onViewPressed,
    required this.onViewClosed,
    this.title,
  }) : super(key: key);

  final String? thumbnail;
  final String? title;

  final Function() onViewPressed;
  final Function() onViewClosed;

  @override
  State<ImageViewItem> createState() => _RecipeItemState();
}

class _RecipeItemState extends State<ImageViewItem> {
  bool canLaunchUrl = false;

  @override
  void initState() {
    super.initState();

    setCanLaunch();
  }

  void setCanLaunch() async {
    final canLaunchThumbnail = await canLaunchUrlString(widget.thumbnail ?? "");
    setState(() => canLaunchUrl = canLaunchThumbnail);
  }

  @override
  Widget build(BuildContext context) => OpenContainer(
        openShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onClosed: (_) => widget.onViewClosed(),
        closedColor: Colors.transparent,
        closedElevation: 0,
        openBuilder: (context, action) => widget.onViewPressed(),
        closedBuilder: (context, action) => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.thumbnail?.isNotEmpty == true && canLaunchUrl
                        ? Image.network(
                            widget.thumbnail ?? "",
                            key: GlobalKey(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => BlankImage(),
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: PcosLoadingSpinner(),
                              );
                            },
                          )
                        : BlankImage(),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment(1, 0.8),
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: HtmlWidget(
                      "<p style='max-lines:2; text-overflow: ellipsis;'>" +
                          (widget.title ?? "") +
                          "</p>",
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
