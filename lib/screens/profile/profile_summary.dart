import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:thepcosprotocol_app/models/member_type_tag.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({Key? key, required this.tags}) : super(key: key);

  final List<MemberTypeTag> tags;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: 25),
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 35, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...tags
                    .map(
                      (tag) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tag.summary?.isNotEmpty == true) ...[
                            HtmlWidget(
                              tag.summary ?? "",
                              textStyle: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(height: 10)
                          ],
                          if (tag.description?.isNotEmpty == true) ...[
                            HtmlWidget(
                              tag.description ?? "",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: textColor.withOpacity(0.8)),
                            ),
                            SizedBox(height: 30)
                          ]
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      );
}
