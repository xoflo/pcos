import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class SearchHeaderSecondaryFilter extends StatefulWidget {
  final List<MultiSelectItem<String>>? tagValuesSecondary;
  final List<String>? tagValuesSelectedSecondary;
  final Function(List<String>)? onSecondaryTagSelected;

  SearchHeaderSecondaryFilter({
    required this.tagValuesSecondary,
    required this.tagValuesSelectedSecondary,
    required this.onSecondaryTagSelected,
  });

  @override
  _SearchHeaderSecondaryFilterState createState() =>
      _SearchHeaderSecondaryFilterState();
}

class _SearchHeaderSecondaryFilterState
    extends State<SearchHeaderSecondaryFilter> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    if ((widget.tagValuesSelectedSecondary?.length ?? 0) > 0) {
      setState(() {
        _isVisible = true;
      });
    } else {
      //use this to trigger animation on load
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() {
          _isVisible = true;
        });
      });
    }
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          backgroundColor: backgroundColor,
          items: widget.tagValuesSecondary ?? [],
          initialValue: widget.tagValuesSelectedSecondary as List<Object?>,
          onConfirm: (values) {
            widget.onSecondaryTagSelected?.call(values as List<String>);
          },
          searchIcon: Icon(
            Icons.search,
            color: primaryColor,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          _showMultiSelect(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: primaryColor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 3.0,
                  ),
                  child: Text(
                    "More options...",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              (widget.tagValuesSelectedSecondary?.length ?? 0) > 0
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Text(
                            (widget.tagValuesSelectedSecondary?.length)
                                .toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
