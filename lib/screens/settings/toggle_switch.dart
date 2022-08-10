import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.normal),
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
      );
}
