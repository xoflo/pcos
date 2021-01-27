import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class FrequentlyAskedQuestions extends StatefulWidget {
  @override
  _FrequentlyAskedQuestionsState createState() =>
      _FrequentlyAskedQuestionsState();
}

class _FrequentlyAskedQuestionsState extends State<FrequentlyAskedQuestions> {
  List<Item> _questions = List<Item>();

  Future<List<Item>> createQuestions() async {
    _questions.add(Item(
      headerValue:
          "I'm Type 1 but I wasn’t sure if I have to remove gluten and dairy already? Apart from sugar, what else am I meant to remove?",
      expandedValue:
          "All of the changes you have to make for your type are emailed to you on a daily basis and are in your membership site/app. So don't worry about anything else, just follow the instructions listed in the modules as they come through, we've organised the information so you're not getting all of the information at once so that you're not overwhelmed with making too many different changes at the same time.",
    ));
    _questions.add(Item(
      headerValue:
          "Is chorizo OK to eat? I've read about processed meats not being good for pcos.?",
      expandedValue:
          "Stick to the national/international guidelines of only a couple of times a week for processed meats.",
    ));
    _questions.add(Item(
      headerValue: "Is it ok to use collagen as protein powder?",
      expandedValue:
          "Collagen isn't a complete protein like a pea and rice blend of protein powder - however in terms of protein content, you can definitely use this to reach that 40-50g target. Mixing and matching is a great way to use collagen - maybe for you that's making a warm drink and adding that collagen but then having a protein shake or eggs and another protein source like salmon or chicken on the side.",
    ));

    return _questions;
  }

  @override
  void initState() {
    super.initState();
    setItems();
  }

  void setItems() async {
    List<Item> items = await createQuestions();
    setState(() {
      _questions = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _questions.length == 0
        ? Text("Loading")
        : SingleChildScrollView(
            child: ExpansionPanelList(
              dividerColor: secondaryColorLight,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _questions[index].isExpanded = !isExpanded;
                });
              },
              children: _questions.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(
                        item.headerValue,
                        style: TextStyle(color: primaryColorDark),
                      ),
                    );
                  },
                  body: ListTile(
                    title: Text(
                      item.expandedValue,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  isExpanded: item.isExpanded,
                  canTapOnHeader: true,
                );
              }).toList(),
            ),
          );
  }
}

class Item {
  Item({
    this.headerValue,
    this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  String expandedValue;
  bool isExpanded;
}
