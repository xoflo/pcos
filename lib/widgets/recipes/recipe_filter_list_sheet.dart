import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class RecipeFilterList extends StatelessWidget {
  const RecipeFilterList({
    Key? key,
    required this.values,
    required this.onSelectItem,
    this.selectedItems,
  }) : super(key: key);

  final List<String> values;
  final Function(String) onSelectItem;
  final List<String>? selectedItems;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: 0.4,
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: values
                    .map(
                      (tag) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onSelectItem.call(tag);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (selectedItems != null &&
                                  selectedItems?.contains(tag) == true)
                                Icon(
                                  Icons.check,
                                  color: backgroundColor,
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList()),
          ),
        ),
      );
}
