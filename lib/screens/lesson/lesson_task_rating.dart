import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';

class LessonTaskRating extends StatefulWidget {
  const LessonTaskRating({Key? key, required this.onSave}) : super(key: key);

  final Function(num) onSave;

  @override
  State<LessonTaskRating> createState() => _LessonTaskRatingState();
}

class _LessonTaskRatingState extends State<LessonTaskRating> {
  double currentValue = 4;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              children: [
                SliderTheme(
                  child: Slider(
                    value: currentValue,
                    divisions: 8,
                    max: 8,
                    min: 0,
                    onChanged: (value) => setState(() => currentValue = value),
                  ),
                  data: SliderTheme.of(context).copyWith(
                    inactiveTickMarkColor: backgroundColor,
                    activeTrackColor: backgroundColor,
                    inactiveTrackColor: Colors.white,
                    trackHeight: 5,
                    trackShape: ExpandedTrackShape(),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                    thumbColor: backgroundColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scale 0",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    ),
                    Text(
                      "Scale 8",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: textColor.withOpacity(0.8)),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 25),
          FilledButton(
            onPressed: () => widget.onSave(currentValue),
            text: "SAVE",
            margin: EdgeInsets.zero,
            foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
          )
        ],
      );
}

class ExpandedTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
