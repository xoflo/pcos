import 'package:thepcosprotocol_app/models/member.dart';
import 'package:thepcosprotocol_app/constants/loading_status.dart';
import 'package:thepcosprotocol_app/services/webservices.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/providers/loading_status_notifier.dart';

class MemberProvider extends LoadingStatusNotifier {
  Member member = Member();
  Member memberOriginal = Member();

  String _why = "";
  String get why => _why;

  int? get id {
    return this.member.id;
  }

  String get firstName {
    return this.member.firstName ?? "";
  }

  String get lastName {
    return this.member.lastName ?? "";
  }

  String get alias {
    return this.member.alias ?? "";
  }

  String get email {
    return this.member.email ?? "";
  }

  set firstName(String firstName) {
    this.member.firstName = firstName;
  }

  set lastName(String lastName) {
    this.member.lastName = lastName;
  }

  set email(String email) {
    this.member.email = email;
  }

  set alias(String alias) {
    this.member.alias = alias;
  }

  Future<bool> setWhy(String why) async {
    setLoadingStatus(LoadingStatus.loading, true);

    final bool didSetWhy =
        await WebServices().setMemberWhy(member.id.toString(), why);

    if (didSetWhy) {
      await PreferencesController()
          .saveString(SharedPreferencesKeys.WHATS_YOUR_WHY, why);
    }

    _why = why;

    setLoadingStatus(LoadingStatus.success, true);

    return didSetWhy;
  }

  Future<void> populateMember() async {
    LoadingStatus status = LoadingStatus.loading;
    setLoadingStatus(status, false);
    try {
      Member? memberDetails;
      try {
        memberDetails = await WebServices().getMemberDetails();
      } catch (e) {
        setLoadingStatus(LoadingStatus.failed, true);
        return;
      }

      if (memberDetails != null) {
        this.member = memberDetails;
        this.memberOriginal.firstName = memberDetails.firstName;
        this.memberOriginal.lastName = memberDetails.lastName;
        this.memberOriginal.email = memberDetails.email;
        this.memberOriginal.alias = memberDetails.alias;

        final String whatsYourWhy = await PreferencesController()
            .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);
        _why = whatsYourWhy;

        status = LoadingStatus.success;
      } else {
        status = LoadingStatus.empty;
      }
    } catch (ex) {
      status = LoadingStatus.empty;
    }

    setLoadingStatus(status, true);
  }

  Future<bool> saveMemberDetails() async {
    setLoadingStatus(LoadingStatus.loading, false);
    String requestBody = "{";
    bool nameChanged = false;

    if (memberOriginal.firstName != member.firstName) {
      requestBody += "'firstName': '${member.firstName}'";
      nameChanged = true;
    }

    if (memberOriginal.lastName != member.lastName) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'lastName': '${member.lastName}'";
      nameChanged = true;
    }

    if (memberOriginal.email != member.email) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'email': '${member.email}'";
    }
    if (memberOriginal.alias != member.alias) {
      if (nameChanged) {
        requestBody += ",";
      }
      requestBody += "'alias': '${member.alias}'";
    }

    requestBody += "}";

    final bool saved = await WebServices().updateMemberDetails(requestBody);

    setLoadingStatus(LoadingStatus.success, true);
    return saved;
  }
}
