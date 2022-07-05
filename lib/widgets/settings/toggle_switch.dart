import 'package:flutter/cupertino.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({
    Key? key,
    required this.title,
    required this.value,
    required this.onToggle,
  }) : super(key: key);

  final String title;
  final bool value;
  final Function(bool) onToggle;

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isSwitchOn = false;

  @override
  void initState() {
    super.initState();
    isSwitchOn = widget.value;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
            CupertinoSwitch(
              value: widget.value,
              activeColor: backgroundColor,
              trackColor: secondaryColor,
              onChanged: (isOn) {
                setState(() => isSwitchOn = isOn);
                widget.onToggle.call(isOn);
              },
            )
          ],
        ),
      );
}
