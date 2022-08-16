import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item.dart';

mixin BaseCarouselPage<T extends StatefulWidget> on State<T> {
  final PageController controller = PageController();

  List<CarouselItem> get items;

  bool get showBackButton;

  bool get shouldPopScope => !Platform.isIOS && showBackButton;

  bool get isNotYetLastItem;

  int activePage = 0;

  List<Widget> generateIndicators() {
    return List<Widget>.generate(items.length, (index) {
      return Container(
          margin: const EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: activePage == index
                ? selectedIndicatorColor
                : unselectedIndicatorColor,
            shape: BoxShape.circle,
          ));
    });
  }

  void incrementPageCount(int page) {
    setState(() {
      activePage = page;
    });
  }

  List<Widget> getButtons();

  CustomPainter? getPainter();

  Widget getItemBuilder(BuildContext context, int position);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => Future.value(shouldPopScope),
      child: Scaffold(
        backgroundColor: primaryColorLight,
        body: Stack(
          children: [
            CustomPaint(
              painter: getPainter(),
              child: Container(
                width: width,
                height: height,
              ),
            ),
            if (showBackButton)
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  systemOverlayStyle:
                      SystemUiOverlayStyle(
                        statusBarColor: primaryColor,
                        statusBarIconBrightness: Brightness.dark),
                  leading: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      color: backgroundColor,
                    ),
                    onPressed: () {
                      // We update the active page so that when popping,
                      // we remove the big ellipsis painted earlier
                      incrementPageCount(activePage + 1);

                      Navigator.of(context).pop();
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
              ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: height * 0.5,
                      child: PageView.builder(
                        controller: controller,
                        itemCount: items.length + 1,
                        pageSnapping: true,
                        itemBuilder: getItemBuilder,
                        onPageChanged: incrementPageCount,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: generateIndicators(),
                  ),
                  ...getButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
