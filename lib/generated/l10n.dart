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

  /// `Coach Chat`
  String get coachChatTitle {
    return Intl.message(
      'Coach Chat',
      name: 'coachChatTitle',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messagesTitle {
    return Intl.message(
      'Messages',
      name: 'messagesTitle',
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

  /// `Privacy policy`
  String get privacyTitle {
    return Intl.message(
      'Privacy policy',
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

  /// `Please enter your email`
  String get validateEmailMessage {
    return Intl.message(
      'Please enter your email',
      name: 'validateEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get validatePasswordMessage {
    return Intl.message(
      'Please enter your password',
      name: 'validatePasswordMessage',
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

  /// `PIN successful`
  String get pinEnteredSuccessfulTitle {
    return Intl.message(
      'PIN successful',
      name: 'pinEnteredSuccessfulTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your PIN has been set`
  String get pinSetSuccessfulTitle {
    return Intl.message(
      'Your PIN has been set',
      name: 'pinSetSuccessfulTitle',
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

  /// `Incorrect PIN`
  String get pinUnlockErrorTitle {
    return Intl.message(
      'Incorrect PIN',
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

  /// `You have incorrectly entered your PIN five times, please sign-in using your email and password.`
  String get pinUnlockAttemptsErrorText {
    return Intl.message(
      'You have incorrectly entered your PIN five times, please sign-in using your email and password.',
      name: 'pinUnlockAttemptsErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Chat to your Coach`
  String get coachChatHeading {
    return Intl.message(
      'Chat to your Coach',
      name: 'coachChatHeading',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get sendButtonText {
    return Intl.message(
      'Send',
      name: 'sendButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Enter your message`
  String get enterMessageText {
    return Intl.message(
      'Enter your message',
      name: 'enterMessageText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your message text`
  String get validateMessageText {
    return Intl.message(
      'Please enter your message text',
      name: 'validateMessageText',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get searchInputText {
    return Intl.message(
      'Search',
      name: 'searchInputText',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get recipeDetailsSummaryTab {
    return Intl.message(
      'Summary',
      name: 'recipeDetailsSummaryTab',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients`
  String get recipeDetailsIngredientsTab {
    return Intl.message(
      'Ingredients',
      name: 'recipeDetailsIngredientsTab',
      desc: '',
      args: [],
    );
  }

  /// `Method`
  String get recipeDetailsMethodTab {
    return Intl.message(
      'Method',
      name: 'recipeDetailsMethodTab',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get recipeDetailsTipsTab {
    return Intl.message(
      'Tips',
      name: 'recipeDetailsTipsTab',
      desc: '',
      args: [],
    );
  }

  /// `mins`
  String get minutesShort {
    return Intl.message(
      'mins',
      name: 'minutesShort',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get recipeDifficultyEasy {
    return Intl.message(
      'Easy',
      name: 'recipeDifficultyEasy',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get recipeDifficultyMedium {
    return Intl.message(
      'Medium',
      name: 'recipeDifficultyMedium',
      desc: '',
      args: [],
    );
  }

  /// `Hard`
  String get recipeDifficultyHard {
    return Intl.message(
      'Hard',
      name: 'recipeDifficultyHard',
      desc: '',
      args: [],
    );
  }

  /// `Loading Video`
  String get loadingVideo {
    return Intl.message(
      'Loading Video',
      name: 'loadingVideo',
      desc: '',
      args: [],
    );
  }

  /// `Getting started`
  String get gettingStarted {
    return Intl.message(
      'Getting started',
      name: 'gettingStarted',
      desc: '',
      args: [],
    );
  }

  /// `FAQs`
  String get frequentlyAskedQuestions {
    return Intl.message(
      'FAQs',
      name: 'frequentlyAskedQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Course questions`
  String get courseQuestions {
    return Intl.message(
      'Course questions',
      name: 'courseQuestions',
      desc: '',
      args: [],
    );
  }

  /// `<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget elit a felis vestibulum vehicula id ac ipsum. Ut venenatis augue quis interdum porttitor. Praesent rutrum feugiat porttitor. Pellentesque et dapibus nisl. Pellentesque iaculis tortor tortor, non ultrices elit ullamcorper in. Nam a mollis quam. Vestibulum lacinia mauris lacus, et ultrices nisl dictum non. Quisque gravida ex nec diam ullamcorper, nec dictum magna tincidunt. Nunc urna neque, viverra ac lacus et, ullamcorper fermentum enim. Maecenas nec urna a ex efficitur euismod. Fusce vulputate tortor eu mauris lacinia, ut malesuada tellus imperdiet. Nam ante erat, vulputate eu enim vel, interdum hendrerit turpis. Pellentesque non vulputate nulla, ut suscipit magna. Fusce a neque enim. Aenean et consequat tortor.</p>\n<p>Vivamus convallis at dolor quis efficitur. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In dui quam, pulvinar ac orci vitae, tincidunt finibus justo. Aenean scelerisque id dolor sit amet dignissim. Phasellus scelerisque aliquet vehicula. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla facilisi. Aenean posuere maximus nunc. Nullam mollis dignissim neque, non interdum lorem laoreet vel. Praesent aliquet enim orci, non sodales nisi facilisis sed. Donec consequat massa et malesuada scelerisque. Vestibulum cursus turpis quam, in consectetur ipsum ultrices ac.</p>\n<p>Donec sagittis laoreet dictum. Fusce massa lacus, varius at varius blandit, scelerisque id justo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In sit amet fringilla tortor. Vestibulum dapibus iaculis augue, ut luctus nulla dignissim in. Aliquam et sem ultricies, luctus lacus et, ornare quam. Donec et sagittis mi. Maecenas mollis iaculis leo, sit amet interdum turpis interdum eget. Donec feugiat ante sit amet pellentesque semper. Donec eu erat egestas, tempus neque non, ullamcorper massa. Praesent ac interdum lorem. Aliquam venenatis elementum mollis. Donec pharetra eleifend nulla, in vestibulum purus ullamcorper sit amet.</p>`
  String get gettingStartedText {
    return Intl.message(
      '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eget elit a felis vestibulum vehicula id ac ipsum. Ut venenatis augue quis interdum porttitor. Praesent rutrum feugiat porttitor. Pellentesque et dapibus nisl. Pellentesque iaculis tortor tortor, non ultrices elit ullamcorper in. Nam a mollis quam. Vestibulum lacinia mauris lacus, et ultrices nisl dictum non. Quisque gravida ex nec diam ullamcorper, nec dictum magna tincidunt. Nunc urna neque, viverra ac lacus et, ullamcorper fermentum enim. Maecenas nec urna a ex efficitur euismod. Fusce vulputate tortor eu mauris lacinia, ut malesuada tellus imperdiet. Nam ante erat, vulputate eu enim vel, interdum hendrerit turpis. Pellentesque non vulputate nulla, ut suscipit magna. Fusce a neque enim. Aenean et consequat tortor.</p>\n<p>Vivamus convallis at dolor quis efficitur. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In dui quam, pulvinar ac orci vitae, tincidunt finibus justo. Aenean scelerisque id dolor sit amet dignissim. Phasellus scelerisque aliquet vehicula. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla facilisi. Aenean posuere maximus nunc. Nullam mollis dignissim neque, non interdum lorem laoreet vel. Praesent aliquet enim orci, non sodales nisi facilisis sed. Donec consequat massa et malesuada scelerisque. Vestibulum cursus turpis quam, in consectetur ipsum ultrices ac.</p>\n<p>Donec sagittis laoreet dictum. Fusce massa lacus, varius at varius blandit, scelerisque id justo. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In sit amet fringilla tortor. Vestibulum dapibus iaculis augue, ut luctus nulla dignissim in. Aliquam et sem ultricies, luctus lacus et, ornare quam. Donec et sagittis mi. Maecenas mollis iaculis leo, sit amet interdum turpis interdum eget. Donec feugiat ante sit amet pellentesque semper. Donec eu erat egestas, tempus neque non, ullamcorper massa. Praesent ac interdum lorem. Aliquam venenatis elementum mollis. Donec pharetra eleifend nulla, in vestibulum purus ullamcorper sit amet.</p>',
      name: 'gettingStartedText',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later.`
  String get tryAgain {
    return Intl.message(
      'Please try again later.',
      name: 'tryAgain',
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