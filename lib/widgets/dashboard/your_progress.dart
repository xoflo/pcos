import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class YourProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Stack(
        children: [
          SizedBox(
            height: 50,
            child: SliderTheme(
              data: SliderThemeData(
                disabledActiveTrackColor: primaryColorDark,
                disabledInactiveTrackColor: Colors.black12,
                disabledThumbColor: primaryColorDark,
                disabledActiveTickMarkColor: Colors.white70,
                trackHeight: 10,
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
          Padding(
            padding: const EdgeInsets.only(top: 38.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Your Progress",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
