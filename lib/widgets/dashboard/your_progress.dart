import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class YourProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Module 4 - Reducing Sugar",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: SizedBox(
                  height: 30,
                  child: SliderTheme(
                    data: SliderThemeData(
                      disabledActiveTrackColor: primaryColorDark,
                      disabledInactiveTrackColor: Colors.black12,
                      disabledThumbColor: primaryColorDark,
                      disabledActiveTickMarkColor: Colors.white70,
                      trackHeight: 10,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    ),
                    child: Slider(
                      value: 3,
                      min: 0.0,
                      max: 12.0,
                      divisions: 12,
                      onChanged: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
