import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            color: primaryColorLight,
            child: TextFormField(
              // controller: usernameController,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                isDense: true,
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty == true) {
                  return "Please enter your new username";
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "Previous Modules",
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Image(
                                image: AssetImage(
                                    'assets/library_knowledge_base.png'),
                                height: 52,
                                width: 52,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "Knowledge Base",
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Image(
                                image: AssetImage(
                                    'assets/library_knowledge_base.png'),
                                height: 52,
                                width: 52,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
