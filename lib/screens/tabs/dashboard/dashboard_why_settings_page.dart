import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/providers/member_provider.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/widgets/shared/filled_button.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/widgets/shared/loader_overlay_with_change_notifier.dart';
import 'package:thepcosprotocol_app/widgets/shared/no_results.dart';

class DashboardWhySettingsPage extends StatefulWidget {
  const DashboardWhySettingsPage({Key? key}) : super(key: key);

  static const id = "dashboard_why_settings_page";

  @override
  State<DashboardWhySettingsPage> createState() =>
      _DashboardWhySettingsPageState();
}

class _DashboardWhySettingsPageState extends State<DashboardWhySettingsPage> {
  TextEditingController textController = TextEditingController();

  int textLength = 0;

  bool isInitialized = false;

  void initialize(MemberProvider memberProvider) async {
    textController.text = memberProvider.why;
    textLength = memberProvider.why.length;
    isInitialized = true;
  }

  Widget getWidget(MemberProvider memberProvider) {
    if (memberProvider.loadingStatus == LoadingStatus.empty) {
      return NoResults(message: S.current.noMemberDetails);
    }

    return Expanded(
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
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (value) => setState(() => textLength = value.length),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  counterText: "$textLength/100",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor.withOpacity(0.8)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: textColor.withOpacity(0.8)),
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
                        await memberProvider
                            .setWhy(textController.text)
                            .then((_) => Navigator.pop(context));
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    if (!isInitialized) {
      initialize(memberProvider);
    }
    return Scaffold(
      body: LoaderOverlay(
        loadingStatusNotifier: memberProvider,
        height: MediaQuery.of(context).size.height,
        indicatorPosition: Alignment.center,
        child: WillPopScope(
          onWillPop: () async =>
              !Platform.isIOS &&
              memberProvider.loadingStatus != LoadingStatus.loading,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  title: "Your Why",
                  closeItem: () => Navigator.pop(context),
                ),
                getWidget(memberProvider)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
