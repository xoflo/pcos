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

  /// `Message`
  String get messageTitle {
    return Intl.message(
      'Message',
      name: 'messageTitle',
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

  /// `Email or Username`
  String get emailLabel {
    return Intl.message(
      'Email or Username',
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

  /// `Sign up for The PCOS Protocol.`
  String get gotoSignupText {
    return Intl.message(
      'Sign up for The PCOS Protocol.',
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

  /// `Open Questionnaire`
  String get openWebsiteTitle {
    return Intl.message(
      'Open Questionnaire',
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

  /// `The PCOS Protocol is a personalised programme, delivered according to your own goals.`
  String get openWebsiteWhy {
    return Intl.message(
      'The PCOS Protocol is a personalised programme, delivered according to your own goals.',
      name: 'openWebsiteWhy',
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

  /// `Your email/username or password are incorrect, please try again.`
  String get signinErrorText {
    return Intl.message(
      'Your email/username or password are incorrect, please try again.',
      name: 'signinErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Your email address has not be verified, please check your inbox for a new verification email.`
  String get signInEmailNotVerifiedErrorText {
    return Intl.message(
      'Your email address has not be verified, please check your inbox for a new verification email.',
      name: 'signInEmailNotVerifiedErrorText',
      desc: '',
      args: [],
    );
  }

  /// `We could not sign you in, please try again later`
  String get signinUnknownErrorText {
    return Intl.message(
      'We could not sign you in, please try again later',
      name: 'signinUnknownErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email or username`
  String get validateEmailMessage {
    return Intl.message(
      'Please enter your email or username',
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

  /// `Forgotten PIN`
  String get pinForgottenTitle {
    return Intl.message(
      'Forgotten PIN',
      name: 'pinForgottenTitle',
      desc: '',
      args: [],
    );
  }

  /// `This will clear your credentials and PIN so you can sign in with your username/email and password. Do you want to continue?`
  String get pinForgottenMessage {
    return Intl.message(
      'This will clear your credentials and PIN so you can sign in with your username/email and password. Do you want to continue?',
      name: 'pinForgottenMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get pinForgottenContinue {
    return Intl.message(
      'Continue',
      name: 'pinForgottenContinue',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get pinForgottenCancel {
    return Intl.message(
      'Cancel',
      name: 'pinForgottenCancel',
      desc: '',
      args: [],
    );
  }

  /// `Forgotten Password`
  String get passwordForgottenTitle {
    return Intl.message(
      'Forgotten Password',
      name: 'passwordForgottenTitle',
      desc: '',
      args: [],
    );
  }

  /// `We will send an email to your registered email address so you can reset your password. Do you want to continue?`
  String get passwordForgottenMessage {
    return Intl.message(
      'We will send an email to your registered email address so you can reset your password. Do you want to continue?',
      name: 'passwordForgottenMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your registered email address or username in the 'Email or username' box and click 'Forgotten Password' again.`
  String get passwordForgottenEmailMessage {
    return Intl.message(
      'Please enter your registered email address or username in the \'Email or username\' box and click \'Forgotten Password\' again.',
      name: 'passwordForgottenEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, send email`
  String get passwordForgottenContinue {
    return Intl.message(
      'Yes, send email',
      name: 'passwordForgottenContinue',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get passwordForgottenCancel {
    return Intl.message(
      'Cancel',
      name: 'passwordForgottenCancel',
      desc: '',
      args: [],
    );
  }

  /// `Okay`
  String get okayText {
    return Intl.message(
      'Okay',
      name: 'okayText',
      desc: '',
      args: [],
    );
  }

  /// `We have sent you a reset password email, please check your inbox and junk mail. Thank you`
  String get passwordForgottenCompleteMessage {
    return Intl.message(
      'We have sent you a reset password email, please check your inbox and junk mail. Thank you',
      name: 'passwordForgottenCompleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `We could not send you an email right now, please try again later.`
  String get passwordForgottenFailedMessage {
    return Intl.message(
      'We could not send you an email right now, please try again later.',
      name: 'passwordForgottenFailedMessage',
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

  /// `Use this to unlock the app`
  String get pinSetSuccessfulMessage {
    return Intl.message(
      'Use this to unlock the app',
      name: 'pinSetSuccessfulMessage',
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

  /// `Authentication token expired`
  String get pinRefreshErrorTitle {
    return Intl.message(
      'Authentication token expired',
      name: 'pinRefreshErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your authentication token has expired, please sign-in using your email and password.`
  String get pinRefreshErrorText {
    return Intl.message(
      'Your authentication token has expired, please sign-in using your email and password.',
      name: 'pinRefreshErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection required`
  String get internetConnectionTitle {
    return Intl.message(
      'Internet connection required',
      name: 'internetConnectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please ensure you are connected to the internet. `
  String get internetConnectionText {
    return Intl.message(
      'Please ensure you are connected to the internet. ',
      name: 'internetConnectionText',
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

  /// `Please try again later.`
  String get tryAgain {
    return Intl.message(
      'Please try again later.',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get profileFirstNameLabel {
    return Intl.message(
      'First name',
      name: 'profileFirstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get profileLastNameLabel {
    return Intl.message(
      'Last name',
      name: 'profileLastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get profileAliasLabel {
    return Intl.message(
      'Username',
      name: 'profileAliasLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get profileEmailLabel {
    return Intl.message(
      'Email',
      name: 'profileEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get profileEditButton {
    return Intl.message(
      'Edit profile',
      name: 'profileEditButton',
      desc: '',
      args: [],
    );
  }

  /// `Save profile`
  String get profileSaveButton {
    return Intl.message(
      'Save profile',
      name: 'profileSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get profileCancelButton {
    return Intl.message(
      'Cancel',
      name: 'profileCancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name.`
  String get profileValidateFirstNameMessage {
    return Intl.message(
      'Please enter your first name.',
      name: 'profileValidateFirstNameMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name.`
  String get profileValidateLastNameMessage {
    return Intl.message(
      'Please enter your last name.',
      name: 'profileValidateLastNameMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email.`
  String get profileValidateEmailMessage {
    return Intl.message(
      'Please enter your email.',
      name: 'profileValidateEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get profileInvalidEmailMessage {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'profileInvalidEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be updated`
  String get userNameLocked {
    return Intl.message(
      'Username cannot be updated',
      name: 'userNameLocked',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get changePasswordOldLabel {
    return Intl.message(
      'Current password',
      name: 'changePasswordOldLabel',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get changePasswordNewLabel {
    return Intl.message(
      'New password',
      name: 'changePasswordNewLabel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get changePasswordConfirmLabel {
    return Intl.message(
      'Confirm password',
      name: 'changePasswordConfirmLabel',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePasswordSaveButton {
    return Intl.message(
      'Change password',
      name: 'changePasswordSaveButton',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password.`
  String get changePasswordOldMessage {
    return Intl.message(
      'Please enter your current password.',
      name: 'changePasswordOldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get changePasswordNewMessage {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'changePasswordNewMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password.`
  String get changePasswordConfirmMessage {
    return Intl.message(
      'Please confirm your new password.',
      name: 'changePasswordConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your new and confirm passwords do not match.`
  String get changePasswordDifferentMessage {
    return Intl.message(
      'Your new and confirm passwords do not match.',
      name: 'changePasswordDifferentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Current password incorrect`
  String get changePasswordOldPasswordWrongTitle {
    return Intl.message(
      'Current password incorrect',
      name: 'changePasswordOldPasswordWrongTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your current password is not correct, please try entering your current password again.`
  String get changePasswordOldPasswordWrongMessage {
    return Intl.message(
      'Your current password is not correct, please try entering your current password again.',
      name: 'changePasswordOldPasswordWrongMessage',
      desc: '',
      args: [],
    );
  }

  /// `Change password failed`
  String get changePasswordFailedTitle {
    return Intl.message(
      'Change password failed',
      name: 'changePasswordFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `We could not update your password, please try again later.`
  String get changePasswordFailedMessage {
    return Intl.message(
      'We could not update your password, please try again later.',
      name: 'changePasswordFailedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Change password successful`
  String get changePasswordSuccessTitle {
    return Intl.message(
      'Change password successful',
      name: 'changePasswordSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been updated.`
  String get changePasswordSuccessMessage {
    return Intl.message(
      'Your password has been updated.',
      name: 'changePasswordSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get tagAll {
    return Intl.message(
      'All',
      name: 'tagAll',
      desc: '',
      args: [],
    );
  }

  /// `Breakfast`
  String get recipesTagBreakfast {
    return Intl.message(
      'Breakfast',
      name: 'recipesTagBreakfast',
      desc: '',
      args: [],
    );
  }

  /// `Mains`
  String get recipesTagMains {
    return Intl.message(
      'Mains',
      name: 'recipesTagMains',
      desc: '',
      args: [],
    );
  }

  /// `Snack`
  String get recipesTagSnack {
    return Intl.message(
      'Snack',
      name: 'recipesTagSnack',
      desc: '',
      args: [],
    );
  }

  /// `Sweet`
  String get recipesTagSweet {
    return Intl.message(
      'Sweet',
      name: 'recipesTagSweet',
      desc: '',
      args: [],
    );
  }

  /// `Savoury`
  String get recipesTagSavoury {
    return Intl.message(
      'Savoury',
      name: 'recipesTagSavoury',
      desc: '',
      args: [],
    );
  }

  /// `Vegetarian`
  String get recipesTagVegetarian {
    return Intl.message(
      'Vegetarian',
      name: 'recipesTagVegetarian',
      desc: '',
      args: [],
    );
  }

  /// `Vegan`
  String get recipesTagVegan {
    return Intl.message(
      'Vegan',
      name: 'recipesTagVegan',
      desc: '',
      args: [],
    );
  }

  /// `Egg-free`
  String get recipesTagEggFree {
    return Intl.message(
      'Egg-free',
      name: 'recipesTagEggFree',
      desc: '',
      args: [],
    );
  }

  /// `Fodmap-friendly`
  String get recipesTagFodmap {
    return Intl.message(
      'Fodmap-friendly',
      name: 'recipesTagFodmap',
      desc: '',
      args: [],
    );
  }

  /// `Diet`
  String get kbTagDiet {
    return Intl.message(
      'Diet',
      name: 'kbTagDiet',
      desc: '',
      args: [],
    );
  }

  /// `Energy`
  String get kbTagEnergy {
    return Intl.message(
      'Energy',
      name: 'kbTagEnergy',
      desc: '',
      args: [],
    );
  }

  /// `Exercise`
  String get kbTagExercise {
    return Intl.message(
      'Exercise',
      name: 'kbTagExercise',
      desc: '',
      args: [],
    );
  }

  /// `Fertility`
  String get kbTagFertility {
    return Intl.message(
      'Fertility',
      name: 'kbTagFertility',
      desc: '',
      args: [],
    );
  }

  /// `Hair`
  String get kbTagHair {
    return Intl.message(
      'Hair',
      name: 'kbTagHair',
      desc: '',
      args: [],
    );
  }

  /// `Insulin`
  String get kbTagInsulin {
    return Intl.message(
      'Insulin',
      name: 'kbTagInsulin',
      desc: '',
      args: [],
    );
  }

  /// `Skin`
  String get kbTagSkin {
    return Intl.message(
      'Skin',
      name: 'kbTagSkin',
      desc: '',
      args: [],
    );
  }

  /// `Stress`
  String get kbTagStress {
    return Intl.message(
      'Stress',
      name: 'kbTagStress',
      desc: '',
      args: [],
    );
  }

  /// `Thyroid`
  String get kbTagThyroid {
    return Intl.message(
      'Thyroid',
      name: 'kbTagThyroid',
      desc: '',
      args: [],
    );
  }

  /// `Filter:`
  String get searchHeaderFilterText {
    return Intl.message(
      'Filter:',
      name: 'searchHeaderFilterText',
      desc: '',
      args: [],
    );
  }

  /// `Close app`
  String get areYouSureText {
    return Intl.message(
      'Close app',
      name: 'areYouSureText',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to close the App?`
  String get exitAppText {
    return Intl.message(
      'Are you sure you want to close the App?',
      name: 'exitAppText',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yesText {
    return Intl.message(
      'Yes',
      name: 'yesText',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get noText {
    return Intl.message(
      'No',
      name: 'noText',
      desc: '',
      args: [],
    );
  }

  /// `App Store`
  String get versionDialogTitle {
    return Intl.message(
      'App Store',
      name: 'versionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please open the app store on your device, and upgrade The PCOS Protocol app.`
  String get versionDialogDesc {
    return Intl.message(
      'Please open the app store on your device, and upgrade The PCOS Protocol app.',
      name: 'versionDialogDesc',
      desc: '',
      args: [],
    );
  }

  /// `This version of The PCOS Protocol app is no longer supported.`
  String get versionText1 {
    return Intl.message(
      'This version of The PCOS Protocol app is no longer supported.',
      name: 'versionText1',
      desc: '',
      args: [],
    );
  }

  /// `Please visit the app store to upgrade your app version.`
  String get versionText2 {
    return Intl.message(
      'Please visit the app store to upgrade your app version.',
      name: 'versionText2',
      desc: '',
      args: [],
    );
  }

  /// `No recipes found!`
  String get noResultsRecipes {
    return Intl.message(
      'No recipes found!',
      name: 'noResultsRecipes',
      desc: '',
      args: [],
    );
  }

  /// `No knowledge base items found!`
  String get noResultsKBs {
    return Intl.message(
      'No knowledge base items found!',
      name: 'noResultsKBs',
      desc: '',
      args: [],
    );
  }

  /// `We could not display your details, please try again later.`
  String get noMemberDetails {
    return Intl.message(
      'We could not display your details, please try again later.',
      name: 'noMemberDetails',
      desc: '',
      args: [],
    );
  }

  /// `No items found!`
  String get noItemsFound {
    return Intl.message(
      'No items found!',
      name: 'noItemsFound',
      desc: '',
      args: [],
    );
  }

  /// `There are no messages to display.`
  String get noNotifications {
    return Intl.message(
      'There are no messages to display.',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Lessons`
  String get lessonsTitle {
    return Intl.message(
      'Lessons',
      name: 'lessonsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Remove favourite`
  String get favouriteRemoveTitle {
    return Intl.message(
      'Remove favourite',
      name: 'favouriteRemoveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this favourite?`
  String get favouriteRemoveText {
    return Intl.message(
      'Are you sure you want to remove this favourite?',
      name: 'favouriteRemoveText',
      desc: '',
      args: [],
    );
  }

  /// `Delete message`
  String get deleteMessageTitle {
    return Intl.message(
      'Delete message',
      name: 'deleteMessageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this message?`
  String get deleteMessageText {
    return Intl.message(
      'Are you sure you want to delete this message?',
      name: 'deleteMessageText',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Tutorial`
  String get tutorialTitle {
    return Intl.message(
      'Welcome Tutorial',
      name: 'tutorialTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
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