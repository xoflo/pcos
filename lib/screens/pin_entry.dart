import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/widgets/auth/header_image.dart';
import 'package:thepcosprotocol_app/widgets/auth/pin_pad.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class PinEntry extends StatefulWidget {
  @override
  _PinEntryState createState() => _PinEntryState();
}

class _PinEntryState extends State<PinEntry> {
  List<bool> _progress = [false, false, false, false];
  int _currentPosition = 0;
  String _pinEntered = "";
  bool _pinComplete = false;

  void resetPinPad() {
    setState(() {
      _progress = [false, false, false, false];
      _currentPosition = 0;
      _pinEntered = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double pinButtonSize =
        screenSize.width > 600 ? 100 : screenSize.width * .3;
    final double headerPadding = screenSize.width > 600 ? 20.0 : 0.0;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: headerPadding),
            child: HeaderImage(screenSize: screenSize),
          ),
          !_pinComplete
              ? PinPad(
                  pinButtonSize: pinButtonSize,
                  headerText: "Enter your PIN to unlock",
                  progress: _progress,
                  currentPosition: _currentPosition,
                  pinButtonPressed: (pinNumber) {
                    debugPrint("PIN Button Pressed=$pinNumber");
                    if (_currentPosition < 4) {
                      setState(() {
                        _pinEntered += pinNumber.toString();
                        _progress[_currentPosition] = true;
                        _currentPosition++;
                      });
                      if (_currentPosition == 4) {
                        _pinComplete = true;
                      }
                    }
                  },
                  resetPinPad: resetPinPad,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          S.of(context).pinCorrectTitle,
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      SizedBox(
                        child: Icon(
                          Icons.thumb_up_rounded,
                          size: 100.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
