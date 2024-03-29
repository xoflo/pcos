import 'package:thepcosprotocol_app/models/member_type_tag.dart';

class Member {
  final int? id;
  final String? preRegistrationCode;
  String? firstName;
  String? lastName;
  String? alias;
  String? email;
  final String? twitter;
  final String? facebook;
  final String? countryID;
  final String? contactPhone;
  final String? adminNotes;
  final bool? isEmailVerified;
  final bool? isEnabled;
  final DateTime? dateNextLessonAvailableLocal;
  final DateTime? dateCreatedUTC;
  final List<MemberTypeTag>? typeTags;
  final SubscriptionStatus? subscriptionStatus;
  final bool? isPendingDeletion;

  bool get isSubscriptionValid {
    switch (subscriptionStatus) {
      // When the user subscription is active or they are in a trial
      // mode, they should be able to have access to the app smoothly.
      case SubscriptionStatus.active:
      case SubscriptionStatus.trialing:
      // We want to give users the grace period to give them enough time
      // to subscribe to the app before they lose access to it altogether.
      // Otherwise, we do not allow them to get logged in up until they
      // pay for the subscription.
      case SubscriptionStatus.past_due:
        return true;
      default:
        return false;
    }
  }

  Member({
    this.id,
    this.preRegistrationCode,
    this.firstName,
    this.lastName,
    this.alias,
    this.email,
    this.twitter,
    this.facebook,
    this.countryID,
    this.contactPhone,
    this.adminNotes,
    this.isEmailVerified,
    this.isEnabled,
    this.typeTags,
    this.dateNextLessonAvailableLocal,
    this.dateCreatedUTC,
    this.subscriptionStatus,
    this.isPendingDeletion,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    String nextLessonDateString = json['dateNextLessonAvailableUTC'];
    if (!nextLessonDateString.endsWith("Z")) {
      nextLessonDateString = "${nextLessonDateString}Z";
    }

    final SubscriptionStatus subscriptionStatus =
        SubscriptionStatus.values.firstWhere(
      (element) =>
          json["subscriptionStatus"] == element.toString().split('.').last,
      orElse: () => SubscriptionStatus.empty,
    );
    return Member(
      id: json['id'],
      preRegistrationCode: json['preRegistrationCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      alias: json['alias'],
      email: json['email'],
      twitter: json['twitter'],
      facebook: json['facebook'],
      countryID: json['countryID'],
      contactPhone: json['contactPhone'],
      adminNotes: json['adminNotes'],
      isEmailVerified: json['isEmailVerified'],
      isEnabled: json['isEnabled'],
      isPendingDeletion: json['isPendingDeletion'],
      typeTags: MemberTypeTagList.fromList(json['typeTags']).results,
      dateNextLessonAvailableLocal:
          DateTime.parse(nextLessonDateString).toLocal(),
      dateCreatedUTC: DateTime.parse(json['dateCreatedUTC']),
      subscriptionStatus: subscriptionStatus,
    );
  }
}

enum SubscriptionStatus {
  active,
  past_due,
  unpaid,
  trialing,
  canceled,
  empty,
}
/*
"id":2,
"preRegistrationCode":"",
"firstName":"Andy",
"lastName":"Frost",
"alias":"andyfrost50",
"email":"andyfrost50@hotmail.com",
"twitter":"",
"facebook":"",
"countryID":"",
"contactPhone":"",
"adminNotes":"",
"isEmailVerified":true,
"isEnabled":true,
"dateCreatedUTC":"2020-12-13T23:18:51.08"
*/
