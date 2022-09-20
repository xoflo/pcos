import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepcosprotocol_app/screens/tabs/dashboard/carousel_page_indicator.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel/carousel_item.dart';

mixin BaseCarouselPage<T extends StatelessWidget> on StatelessWidget {
  final PageController controller = PageController();

  List<CarouselItem> get items;

  bool showBackButton(BuildContext context);

  bool shouldPopScope(BuildContext context) =>
      !Platform.isIOS && showBackButton(context);

  bool get isNotYetLastItem;

  int get itemsLength;

  CustomPainter? get painter;

  final ValueNotifier<int> activePage = ValueNotifier(0);

  Widget get indicator => CarouselPageIndicator(
        numberOfPages: items.length,
        activePage: activePage,
      );

  void updatePageValue(int page) => activePage.value = page;

  List<Widget> getButtons(BuildContext context);

  Widget getItemBuilder(BuildContext context, int position);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: WillPopScope(
        onWillPop: () => Future.value(shouldPopScope(context)),
        child: SafeArea(
          bottom: Platform.isAndroid,
          top: Platform.isAndroid,
          child: Scaffold(
            backgroundColor: primaryColorLight,
            body: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: painter,
                  child: Container(
                    width: width,
                    height: height,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        child: PageView.builder(
                          controller: controller,
                          itemCount: itemsLength,
                          pageSnapping: true,
                          itemBuilder: getItemBuilder,
                          onPageChanged: updatePageValue,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: Column(
                        children: [
                          indicator,
                          ...getButtons(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                if (showBackButton(context))
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
                          updatePageValue(activePage.value + 1);

                          Navigator.pop(context);
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
