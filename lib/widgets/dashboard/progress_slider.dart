import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class ProgressSlider extends StatefulWidget {
  final Size screenSize;
  final bool isHorizontal;
  final Function onSubmit;

  ProgressSlider({
    @required this.screenSize,
    @required this.isHorizontal,
    @required this.onSubmit,
  });

  @override
  _ProgressSliderState createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  double _sliderValue = 2.5;
  bool isSaving = false;

  void _saveResponse() {
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: widget.screenSize.width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "How are your sugar cravings?",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Please tell us how your sugar cravings are today Amelia?",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      color: primaryColorDark,
                      size: 30,
                    ),
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 5,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                    Icon(
                      Icons.sentiment_satisfied_outlined,
                      color: primaryColorDark,
                      size: 30,
                    ),
                  ],
                ),
                ColorButton(
                  isUpdating: isSaving,
                  label: "Save",
                  onTap: () {
                    _saveResponse();
                  },
                  width: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
