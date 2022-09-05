import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/screens/tabs/favourites/favourites_toolkit_details.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';

class FavouritesToolkits extends StatelessWidget {
  final noToolkitsText = "No toolkits to display";

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FavouritesProvider>(context);
    favouritesProvider.fetchToolkitStatus(notifyListener: false);

    return LoaderOverlay(
      indicatorPosition: Alignment.center,
      loadingStatusNotifier: favouritesProvider,
      height: double.maxFinite,
      emptyMessage: noToolkitsText,
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: favouritesProvider.toolkits.length,
        itemBuilder: (context, item) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              FavouritesToolkitDetails.id,
              arguments: favouritesProvider.toolkits[item],
            ).then((_) => favouritesProvider.fetchToolkitStatus),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HtmlWidget(
                      favouritesProvider.toolkits[item].title,
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: backgroundColor),
                    ),
                  ),
                  SizedBox(width: 15),
                  Image(
                    image: AssetImage('assets/favorite_toolkit.png'),
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
