import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';

class YourWhy extends StatefulWidget {
  final double width;
  final String whatsYourWhy;

  YourWhy({@required this.width, @required this.whatsYourWhy});

  @override
  _YourWhyState createState() => _YourWhyState();
}

class _YourWhyState extends State<YourWhy> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  void _initialise() async {
    await Future.delayed(const Duration(milliseconds: 250), () {});
    setState(() {
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    S.current.yourWhyTitle,
                    style: TextStyle(
                      fontFamily: 'Courgette',
                      fontSize: 20,
                      color: primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 40,
                    right: 20,
                    bottom: 8,
                  ),
                  child: Text(
                    widget.whatsYourWhy,
                    style: TextStyle(
                      fontFamily: 'Courgette',
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
