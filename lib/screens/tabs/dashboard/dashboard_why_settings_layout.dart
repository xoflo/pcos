import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';
import 'package:thepcosprotocol_app/widgets/shared/pcos_loading_spinner.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;

class DashboardWhySettingsLayout extends StatefulWidget {
  const DashboardWhySettingsLayout({Key? key}) : super(key: key);

  @override
  State<DashboardWhySettingsLayout> createState() =>
      _DashboardWhySettingsLayoutState();
}

class _DashboardWhySettingsLayoutState
    extends State<DashboardWhySettingsLayout> {
  late TextEditingController textController;

  int textLength = 0;

  @override
  void initState() {
    super.initState();

    initialize();
  }

  void initialize() async {
    Provider.of<MemberProvider>(context, listen: false).populateMember();

    final String why = await PreferencesController()
        .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);

    textController = TextEditingController(text: why);
    textLength = why.length;
  }

  Widget getWidget() {
    final viewModel = Provider.of<MemberProvider>(context);
    switch (viewModel.status) {
      case LoadingStatus.empty:
        return NoResults(message: S.current.noMemberDetails);
      case LoadingStatus.loading:
        return PcosLoadingSpinner();
      case LoadingStatus.success:
        return Expanded(
          child: WillPopScope(
            onWillPop: () async => !Platform.isIOS,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    "What is your why?",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: textController,
                      maxLength: 100,
                      maxLines: null,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontWeight: FontWeight.normal),
                      onChanged: (value) =>
                          setState(() => textLength = value.length),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        counterText: "$textLength/100",
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textColor.withOpacity(0.8)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textColor.withOpacity(0.8)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textColor.withOpacity(0.8)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: textColor.withOpacity(0.8)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    FilledButton(
                      text: "SAVE",
                      margin: EdgeInsets.symmetric(vertical: 25),
                      foregroundColor: Colors.white,
                      backgroundColor: backgroundColor,
                      onPressed: textLength == 0
                          ? null
                          : () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              final didSetWhy =
                                  await viewModel.setWhy(textController.text);
                              if (didSetWhy) {
                                await PreferencesController()
                                    .saveString(
                                        SharedPreferencesKeys.WHATS_YOUR_WHY,
                                        textController.text)
                                    .then((value) => Navigator.pop(
                                        context, textController.text));
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Header(
          title: "Your Why",
          closeItem: () => Navigator.pop(context),
        ),
        getWidget()
      ],
    );
  }
}
