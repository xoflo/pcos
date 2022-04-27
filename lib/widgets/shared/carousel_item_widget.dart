import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/shared/carousel_item.dart';

class CarouselItemWidget extends StatelessWidget {
  const CarouselItemWidget({Key? key, required this.item}) : super(key: key);

  final CarouselItem item;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            Image(
              image: AssetImage(item.asset),
              height: 240,
              width: 240,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              item.subtitle,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
