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

  int get itemsLength;

  int get carouselFlex => 1;

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
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: getPainter(),
              child: Container(
                width: width,
                height: height,
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: carouselFlex,
                    child: Container(
                      child: PageView.builder(
                        controller: controller,
                        itemCount: itemsLength,
                        pageSnapping: true,
                        itemBuilder: getItemBuilder,
                        onPageChanged: incrementPageCount,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    child: Column(
                      children: [
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
            if (showBackButton)
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: primaryColor,
                      statusBarIconBrightness: Brightness.dark),
                  leading: IconButton(
                    icon: Icon(
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
          ],
        ),
      ),
    );
  }
}
