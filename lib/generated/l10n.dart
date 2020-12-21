// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `The PCOS Protocol`
  String get appTitle {
    return Intl.message(
      'The PCOS Protocol',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `The PCOS Nutritionist`
  String get companyTitle {
    return Intl.message(
      'The PCOS Nutritionist',
      name: 'companyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboardTitle {
    return Intl.message(
      'Dashboard',
      name: 'dashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge Base`
  String get knowledgeBaseTitle {
    return Intl.message(
      'Knowledge Base',
      name: 'knowledgeBaseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recipes`
  String get recipesTitle {
    return Intl.message(
      'Recipes',
      name: 'recipesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get favouritesTitle {
    return Intl.message(
      'Favourites',
      name: 'favouritesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message(
      'Profile',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePasswordTitle {
    return Intl.message(
      'Change Password',
      name: 'changePasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Request Data`
  String get requestDataTitle {
    return Intl.message(
      'Request Data',
      name: 'requestDataTitle',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get helpTitle {
    return Intl.message(
      'Help',
      name: 'helpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get supportTitle {
    return Intl.message(
      'Support',
      name: 'supportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacyTitle {
    return Intl.message(
      'Privacy',
      name: 'privacyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Terms of use`
  String get termsOfUseTitle {
    return Intl.message(
      'Terms of use',
      name: 'termsOfUseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signInTitle {
    return Intl.message(
      'Sign In',
      name: 'signInTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpTitle {
    return Intl.message(
      'Sign Up',
      name: 'signUpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `To use The PCOS Protocol you first need to complete our PCOS questionnaire and sign up for our programme.`
  String get gotoSignupText {
    return Intl.message(
      'To use The PCOS Protocol you first need to complete our PCOS questionnaire and sign up for our programme.',
      name: 'gotoSignupText',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account for The PCOS Protocol?`
  String get gotoSigninText {
    return Intl.message(
      'Already have an account for The PCOS Protocol?',
      name: 'gotoSigninText',
      desc: '',
      args: [],
    );
  }

  /// `Return to Sign In`
  String get returnToSignInTitle {
    return Intl.message(
      'Return to Sign In',
      name: 'returnToSignInTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email Link`
  String get emailLinkTitle {
    return Intl.message(
      'Email Link',
      name: 'emailLinkTitle',
      desc: '',
      args: [],
    );
  }

  /// `Or we can send a link to your email so you can visit the website on another device.`
  String get emailLinkText {
    return Intl.message(
      'Or we can send a link to your email so you can visit the website on another device.',
      name: 'emailLinkText',
      desc: '',
      args: [],
    );
  }

  /// `Open Website`
  String get openWebsiteTitle {
    return Intl.message(
      'Open Website',
      name: 'openWebsiteTitle',
      desc: '',
      args: [],
    );
  }

  /// `To register now on your device click the button below to visit the PCOS Questionnaire website.`
  String get openWebsiteText {
    return Intl.message(
      'To register now on your device click the button below to visit the PCOS Questionnaire website.',
      name: 'openWebsiteText',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Failed`
  String get signinErrorTitle {
    return Intl.message(
      'Sign In Failed',
      name: 'signinErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your email or password are incorrect, please try again.`
  String get signinErrorText {
    return Intl.message(
      'Your email or password are incorrect, please try again.',
      name: 'signinErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Could not open browser`
  String get questionnaireWebsiteErrorTitle {
    return Intl.message(
      'Could not open browser',
      name: 'questionnaireWebsiteErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open a browser and visit [url]`
  String get questionnaireWebsiteErrorText {
    return Intl.message(
      'Open a browser and visit [url]',
      name: 'questionnaireWebsiteErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clearButton {
    return Intl.message(
      'Clear',
      name: 'clearButton',
      desc: '',
      args: [],
    );
  }

  /// `PIN Correct`
  String get pinCorrectTitle {
    return Intl.message(
      'PIN Correct',
      name: 'pinCorrectTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please set your unlock PIN`
  String get pinSetTitle {
    return Intl.message(
      'Please set your unlock PIN',
      name: 'pinSetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your unlock PIN`
  String get pinConfirmTitle {
    return Intl.message(
      'Please confirm your unlock PIN',
      name: 'pinConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `PIN Entry Successful`
  String get pinCompleteTitle {
    return Intl.message(
      'PIN Entry Successful',
      name: 'pinCompleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get pinEntryErrorTitle {
    return Intl.message(
      'Please try again',
      name: 'pinEntryErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your PINs do not match, please try again`
  String get pinEntryErrorText {
    return Intl.message(
      'Your PINs do not match, please try again',
      name: 'pinEntryErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Ooops`
  String get pinSaveErrorTitle {
    return Intl.message(
      'Ooops',
      name: 'pinSaveErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `We could not save your pin to your device, please try again next time you sign in.`
  String get pinSaveErrorText {
    return Intl.message(
      'We could not save your pin to your device, please try again next time you sign in.',
      name: 'pinSaveErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Enter your PIN to unlock`
  String get pinUnlockTitle {
    return Intl.message(
      'Enter your PIN to unlock',
      name: 'pinUnlockTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get pinUnlockErrorTitle {
    return Intl.message(
      'Please try again',
      name: 'pinUnlockErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your PIN is incorrect, please try again`
  String get pinUnlockErrorText {
    return Intl.message(
      'Your PIN is incorrect, please try again',
      name: 'pinUnlockErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Unsuccessful Pin Entry`
  String get pinUnlockAttemptsErrorTitle {
    return Intl.message(
      'Unsuccessful Pin Entry',
      name: 'pinUnlockAttemptsErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have incorrect entered your PIN five times, please sign-in using your email and password.`
  String get pinUnlockAttemptsErrorText {
    return Intl.message(
      'You have incorrect entered your PIN five times, please sign-in using your email and password.',
      name: 'pinUnlockAttemptsErrorText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}