import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

import 'filled_button.dart';

typedef void BoolCallback(bool value);

class FavoritesToggleButton extends StatefulWidget {
  const FavoritesToggleButton({
    Key? key,
    required this.label,
    this.width,
    required this.onToggleCallback,
  }) : super(key: key);

  final String label;
  final double? width;
  final BoolCallback onToggleCallback;

  @override
  _FavoritesToggleButtonState createState() => _FavoritesToggleButtonState();
}

class _FavoritesToggleButtonState extends State<FavoritesToggleButton> {
  bool _isShowFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      icon: Image(
        image: _isShowFavoritesOnly
            ? AssetImage('assets/heart_white_outline.png')
            : AssetImage('assets/heart_green_outline.png'),
        height: 20,
        width: 20,
      ),
      text: widget.label,
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: widget.width ?? 200.0,
      foregroundColor: _isShowFavoritesOnly ? Colors.white : backgroundColor,
      backgroundColor: _isShowFavoritesOnly ? backgroundColor : primaryColor,
      isRoundedButton: true,
      borderColor: _isShowFavoritesOnly ? null : backgroundColor,
      onPressed: () async {
        // await favoritesProvider.fetchAndSaveData();
        setState(() => _isShowFavoritesOnly = !_isShowFavoritesOnly);
        widget.onToggleCallback(_isShowFavoritesOnly);
      },
    );
  }
}
