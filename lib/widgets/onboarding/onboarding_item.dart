import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/onboarding/onboarding.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({Key? key, required this.item}) : super(key: key);

  final Onboarding item;

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
              height: 10,
            ),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 28,
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
