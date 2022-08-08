import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/models/navigation/lesson_wiki_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/library_wiki_arguments.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/lesson/lesson_wiki_page.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';

class LibraryWikiPage extends StatefulWidget {
  const LibraryWikiPage({Key? key}) : super(key: key);

  static const id = "library_wiki_page";

  @override
  State<LibraryWikiPage> createState() => _LibraryWikiPageState();
}

class _LibraryWikiPageState extends State<LibraryWikiPage> {
  late ModulesProvider modulesProvider;

  @override
  void initState() {
    super.initState();
    modulesProvider = Provider.of<ModulesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as LibraryWikiArguments;

    return Scaffold(
      backgroundColor: primaryColor,
      body: WillPopScope(
        onWillPop: () async => Platform.isIOS ? false : true,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                title: "Wiki Library",
                  closeItem: () => Navigator.pop(context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  child: Text(
                    args.moduleTitle,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: args.lessonWikis.length,
                    itemBuilder: (context, index) {
                      final wiki = args.lessonWikis[index];

                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          LessonWikiPage.id,
                          arguments: LessonWikiArguments(true, wiki),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: HtmlWidget(
                            wiki.question ?? "",
                            textStyle: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: backgroundColor),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
