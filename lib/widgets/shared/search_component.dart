import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({
    Key? key,
    required this.searchController,
    required this.searchBackgroundColor,
    required this.onSearchPressed,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController searchController;
  final Color searchBackgroundColor;
  final Function() onSearchPressed;
  final FocusNode? focusNode;

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  bool isSearchFinished = false;
  bool isSearchDisabled = true;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        width: double.maxFinite,
        color: widget.searchBackgroundColor,
        child: TextFormField(
          controller: widget.searchController,
          focusNode: widget.focusNode,
          style: Theme.of(context).textTheme.bodyText1,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_) => widget.onSearchPressed.call(),
          onChanged: (text) => setState(() => isSearchDisabled = text.isEmpty),
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Opacity(
                    opacity: widget.searchController.text.isEmpty ? 0.5 : 1,
                    child: Icon(
                      Icons.close,
                      color: backgroundColor,
                      size: 20,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.focusNode?.unfocus();
                      widget.searchController.clear();
                      widget.onSearchPressed.call();
                    });
                  },
                ),
                IconButton(
                  icon: Opacity(
                    opacity: widget.searchController.text.isEmpty ? 0.5 : 1,
                    child: Icon(
                      Icons.search,
                      color: backgroundColor,
                      size: 20,
                    ),
                  ),
                  onPressed: widget.searchController.text.isEmpty
                      ? null
                      : widget.onSearchPressed,
                ),
              ],
            ),
            hintText: "Search",
            isDense: true,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: backgroundColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: backgroundColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: backgroundColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: backgroundColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
