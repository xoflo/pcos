import 'package:flutter/material.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/widgets/shared/color_button.dart';

class ProfileReadOnly extends StatelessWidget {
  final MemberViewModel? member;
  final Size? screenSize;
  final Function(MemberViewModel?)? editMemberDetails;

  ProfileReadOnly({this.member, this.screenSize, this.editMemberDetails});

  Padding addProfileRow(BuildContext context, final String title,
      final String value, final bool isLocked) {
    final labelWidth = (screenSize?.width ?? 0) * .3;
    final valueWidth = (screenSize?.width ?? 0) * .6;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: labelWidth,
            child: Text(
              "$title:",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          isLocked
              ? Text(
                  value,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                )
              : Container(
                  width: valueWidth,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          isLocked
              ? Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Tooltip(
                    waitDuration: Duration(milliseconds: 200),
                    showDuration: Duration(seconds: 2),
                    padding: EdgeInsets.all(5),
                    height: 35,
                    textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: primaryColor),
                    message: S.current.userNameLocked,
                    child:
                        Icon(Icons.lock_outline, color: primaryColor, size: 16),
                  ))
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addProfileRow(
            context,
            S.current.profileAliasLabel,
            member?.alias ?? "",
            true,
          ),
          addProfileRow(
            context,
            S.current.profileFirstNameLabel,
            member?.firstName ?? "",
            false,
          ),
          addProfileRow(
            context,
            S.current.profileLastNameLabel,
            member?.lastName ?? "",
            false,
          ),
          addProfileRow(
            context,
            S.current.profileEmailLabel,
            member?.email ?? "",
            false,
          ),
          ColorButton(
            width: 140,
            isUpdating: false,
            label: S.current.profileEditButton,
            onTap: () {
              editMemberDetails?.call(member);
            },
          ),
        ],
      ),
    );
  }
}
