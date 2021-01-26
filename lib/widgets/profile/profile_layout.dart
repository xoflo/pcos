import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepcosprotocol_app/widgets/shared/header.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/view_models/member_view_model.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_read_only.dart';
import 'package:thepcosprotocol_app/widgets/profile/profile_editable.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';

class ProfileLayout extends StatefulWidget {
  final Function closeMenuItem;

  ProfileLayout({this.closeMenuItem});

  @override
  _ProfileLayoutState createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  bool _isEditable = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMemberDetails();
  }

  void _getMemberDetails() {
    Provider.of<MemberViewModel>(context, listen: false).populateMember();
  }

  void _editDetails(MemberViewModel member) {
    firstNameController.text = member.firstName;
    lastNameController.text = member.lastName;
    emailController.text = member.email;
    setState(() {
      _isEditable = true;
    });
  }

  void _saveChanges(MemberViewModel member) {
    if (_formKey.currentState.validate()) {
      if (member.firstName != firstNameController.text.trim()) {
        member.firstName = firstNameController.text.trim();
      }
      if (member.lastName != lastNameController.text.trim()) {
        member.lastName = lastNameController.text.trim();
      }
      if (member.email != emailController.text.trim()) {
        member.email = emailController.text.trim();
      }
      Provider.of<MemberViewModel>(context, listen: false).saveMemberDetails();
      setState(() {
        _isEditable = false;
      });
    }
  }

  void _cancelChanges() {
    setState(() {
      _isEditable = false;
    });
  }

  Widget _memberDetails(Size screenSize, MemberViewModel vm) {
    switch (vm.status) {
      case LoadingStatus.loading:
        // TODO: does this need wrapping in a widget with more layout?
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Align(
              child: CircularProgressIndicator(
            backgroundColor: backgroundColor,
            valueColor: new AlwaysStoppedAnimation<Color>(primaryColorDark),
          )),
        );
      case LoadingStatus.empty:
        // TODO: create a widget for nothing found and test how it looks
        return Text("Could not return Member details!");
      case LoadingStatus.success:
        return !_isEditable
            ? ProfileReadOnly(
                member: vm,
                screenSize: screenSize,
                editMemberDetails: _editDetails,
              )
            : Form(
                key: _formKey,
                child: ProfileEditable(
                  member: vm,
                  screenSize: screenSize,
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  emailController: emailController,
                  saveMemberDetails: _saveChanges,
                  cancel: _cancelChanges,
                ),
              );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MemberViewModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            itemId: 0,
            favouriteType: FavouriteType.None,
            title: S.of(context).profileTitle,
            isFavourite: false,
            closeItem: widget.closeMenuItem,
          ),
          _memberDetails(screenSize, vm),
        ],
      ),
    );
  }
}
