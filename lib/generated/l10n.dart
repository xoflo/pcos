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
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ovie`
  String get appTitle {
    return Intl.message(
      'Ovie',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `The PCOS Nutritionist`
  String get companyTitle {
    return Intl.message(
      'Ovie',
      name: 'companyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Course`
  String get dashboardTitle {
    return Intl.message(
      'Your Course',
      name: 'dashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Wikis`
  String get wikiTitle {
    return Intl.message(
      'Wikis',
      name: 'wikiTitle',
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

  /// `Workouts`
  String get workoutsTitle {
    return Intl.message(
      'Workouts',
      name: 'workoutsTitle',
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

  /// `App Help`
  String get appHelpTitle {
    return Intl.message(
      'App Help',
      name: 'appHelpTitle',
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

  /// `Sign up for Ovie.`
  String get gotoSignupText {
    return Intl.message(
      'Sign up for Ovie.',
      name: 'gotoSignupText',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account for Ovie?`
  String get gotoSigninText {
    return Intl.message(
      'Already have an account for Ovie?',
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

  /// `To register for Ovie on your device click the 'Sign Up' button below to visit the Ovie Questionnaire website.`
  String get openWebsiteText {
    return Intl.message(
      'To register for Ovie on your device click the \'Sign Up\' button below to visit the Ovie Questionnaire website.',
      name: 'openWebsiteText',
      desc: '',
      args: [],
    );
  }

  /// `Ovie is a personalised programme, delivered according to your own goals.`
  String get openWebsiteWhy {
    return Intl.message(
      'Ovie is a personalised programme, delivered according to your own goals.',
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

  /// `Your email/username or password are incorrect. Please try again.`
  String get signinErrorText {
    return Intl.message(
      'Your email/username or password are incorrect. Please try again.',
      name: 'signinErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Check Failed`
  String get signinSubscriptionErrorTitle {
    return Intl.message(
      'Account Activation Required',
      name: 'signinSubErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Check Failed Text`
  String get signinSubscriptionErrorText {
    return Intl.message(
      'Your account still needs to be activated. Click on the button below to activate this. If you have any troubles, reach out to the Ovie team!',
      name: 'signinSubErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Your email address has not been verified. Please check your inbox for a new verification email.`
  String get signInEmailNotVerifiedErrorText {
    return Intl.message(
      'Your email address has not been verified. Please check your inbox for a new verification email.',
      name: 'signInEmailNotVerifiedErrorText',
      desc: '',
      args: [],
    );
  }

  /// `We could not sign you in. Please try again later.`
  String get signinUnknownErrorText {
    return Intl.message(
      'We could not sign you in. Please try again later.',
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

  /// `Forgot passcode?`
  String get pinForgottenTitle {
    return Intl.message(
      'Forgot passcode?',
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

  /// `Forgot Password?`
  String get passwordForgottenTitle {
    return Intl.message(
      'Forgot Password?',
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

  /// `Lunch`
  String get recipesTagLunch {
    return Intl.message(
      'Lunch',
      name: 'recipesTagLunch',
      desc: '',
      args: [],
    );
  }

  /// `Dinner`
  String get recipesTagDinner {
    return Intl.message(
      'Dinner',
      name: 'recipesTagDinner',
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

  /// `Dessert`
  String get recipesTagDessert {
    return Intl.message(
      'Dessert',
      name: 'recipesTagDessert',
      desc: '',
      args: [],
    );
  }

  /// `Condiments`
  String get recipesTagCondiments {
    return Intl.message(
      'Condiments',
      name: 'recipesTagCondiments',
      desc: '',
      args: [],
    );
  }

  /// `Drinks`
  String get recipesTagDrinks {
    return Intl.message(
      'Drinks',
      name: 'recipesTagDrinks',
      desc: '',
      args: [],
    );
  }

  /// `Plant Based`
  String get recipesTagSecondaryPlantBased {
    return Intl.message(
      'Plant Based',
      name: 'recipesTagSecondaryPlantBased',
      desc: '',
      args: [],
    );
  }

  /// `Vegetarian`
  String get recipesTagSecondaryVegetarian {
    return Intl.message(
      'Vegetarian',
      name: 'recipesTagSecondaryVegetarian',
      desc: '',
      args: [],
    );
  }

  /// `Gluten Free`
  String get recipesTagSecondaryGlutenFree {
    return Intl.message(
      'Gluten Free',
      name: 'recipesTagSecondaryGlutenFree',
      desc: '',
      args: [],
    );
  }

  /// `Dairy Free`
  String get recipesTagSecondaryDairyFree {
    return Intl.message(
      'Dairy Free',
      name: 'recipesTagSecondaryDairyFree',
      desc: '',
      args: [],
    );
  }

  /// `Nut Free`
  String get recipesTagSecondaryNutFree {
    return Intl.message(
      'Nut Free',
      name: 'recipesTagSecondaryNutFree',
      desc: '',
      args: [],
    );
  }

  /// `Egg Free`
  String get recipesTagSecondaryEggFree {
    return Intl.message(
      'Egg Free',
      name: 'recipesTagSecondaryEggFree',
      desc: '',
      args: [],
    );
  }

  /// `Pescatarian`
  String get recipesTagSecondaryPescatarian {
    return Intl.message(
      'Pescatarian',
      name: 'recipesTagSecondaryPescatarian',
      desc: '',
      args: [],
    );
  }

  /// `Fodmap Friendly`
  String get recipesTagSecondaryFodmapFriendly {
    return Intl.message(
      'Fodmap Friendly',
      name: 'recipesTagSecondaryFodmapFriendly',
      desc: '',
      args: [],
    );
  }

  /// `Calorie Controlled`
  String get recipesTagSecondaryCalorieControlled {
    return Intl.message(
      'Calorie Controlled',
      name: 'recipesTagSecondaryCalorieControlled',
      desc: '',
      args: [],
    );
  }

  /// `Slow Cooker`
  String get recipesTagSecondarySlowCooker {
    return Intl.message(
      'Slow Cooker',
      name: 'recipesTagSecondarySlowCooker',
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

  /// `On`
  String get onText {
    return Intl.message(
      'On',
      name: 'onText',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get offText {
    return Intl.message(
      'Off',
      name: 'offText',
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

  /// `Please open the app store on your device, and upgrade the Ovie app.`
  String get versionDialogDesc {
    return Intl.message(
      'Please open the app store on your device, and upgrade the Ovie app.',
      name: 'versionDialogDesc',
      desc: '',
      args: [],
    );
  }

  /// `This version of the Ovie app is no longer supported.`
  String get versionText1 {
    return Intl.message(
      'This version of the Ovie app is no longer supported.',
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

  /// `No workouts found!`
  String get noResultsWorkouts {
    return Intl.message(
      'No workouts found!',
      name: 'noResultsWorkouts',
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

  /// `View lesson`
  String get favouritesViewLesson {
    return Intl.message(
      'View lesson',
      name: 'favouritesViewLesson',
      desc: '',
      args: [],
    );
  }

  /// `View wiki`
  String get favouritesViewWiki {
    return Intl.message(
      'View wiki',
      name: 'favouritesViewWiki',
      desc: '',
      args: [],
    );
  }

  /// `View recipe`
  String get favouritesViewRecipe {
    return Intl.message(
      'View recipe',
      name: 'favouritesViewRecipe',
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

  /// `Tutorial`
  String get tutorialTitle {
    return Intl.message(
      'Tutorial',
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

  /// `Daily Reminder`
  String get requestDailyReminderTitle {
    return Intl.message(
      'Daily Reminder',
      name: 'requestDailyReminderTitle',
      desc: '',
      args: [],
    );
  }

  /// `To help you get the most from Ovie, we can send you a daily reminder. Would you like to set a daily reminder?`
  String get requestDailyReminderText {
    return Intl.message(
      'To help you get the most from Ovie, we can send you a daily reminder. Would you like to set a daily reminder?',
      name: 'requestDailyReminderText',
      desc: '',
      args: [],
    );
  }

  /// `You can set a daily reminder later by clicking the Settings icon in the main menu.`
  String get requestDailyReminderNoText {
    return Intl.message(
      'You can set a daily reminder later by clicking the Settings icon in the main menu.',
      name: 'requestDailyReminderNoText',
      desc: '',
      args: [],
    );
  }

  /// `Daily Reminder:`
  String get settingsDailyReminderText {
    return Intl.message(
      'Daily Reminder:',
      name: 'settingsDailyReminderText',
      desc: '',
      args: [],
    );
  }

  /// `Your Daily Reminder`
  String get dailyReminderTitle {
    return Intl.message(
      'Your Daily Reminder',
      name: 'dailyReminderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Don't forget to check your latest lesson or view your progress so far.`
  String get dailyReminderText {
    return Intl.message(
      'Don\'t forget to check your latest lesson or view your progress so far.',
      name: 'dailyReminderText',
      desc: '',
      args: [],
    );
  }

  /// `Display 'Your Why':`
  String get settingsYourWhyText {
    return Intl.message(
      'Display \'Your Why\':',
      name: 'settingsYourWhyText',
      desc: '',
      args: [],
    );
  }

  /// `Display Lesson Recipes \non Your Course:`
  String get settingsLessonRecipesText {
    return Intl.message(
      'Display Lesson Recipes \non Your Course:',
      name: 'settingsLessonRecipesText',
      desc: '',
      args: [],
    );
  }

  /// `Allow Notifications`
  String get notificationPermissionsAllowButton {
    return Intl.message(
      'Allow Notifications',
      name: 'notificationPermissionsAllowButton',
      desc: '',
      args: [],
    );
  }

  /// `Please Allow Notifications`
  String get notificationPermissionsNeedToAllowTitle {
    return Intl.message(
      'Please Allow Notifications',
      name: 'notificationPermissionsNeedToAllowTitle',
      desc: '',
      args: [],
    );
  }

  /// `To set a daily reminder you will need to allow notifications on your device by clicking the button below.`
  String get notificationPermissionsNeedToAllowText {
    return Intl.message(
      'To set a daily reminder you will need to allow notifications on your device by clicking the button below.',
      name: 'notificationPermissionsNeedToAllowText',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get requestNotificationPermissionTitle {
    return Intl.message(
      'Notifications',
      name: 'requestNotificationPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `To help you get the most from Ovie, we may send you notifications from time to time. Would you like to receive notifications?`
  String get requestNotificationPermissionText {
    return Intl.message(
      'To help you get the most from Ovie, we may send you notifications from time to time. Would you like to receive notifications?',
      name: 'requestNotificationPermissionText',
      desc: '',
      args: [],
    );
  }

  /// `Data Usage`
  String get dataUsageWarningTitle {
    return Intl.message(
      'Data Usage',
      name: 'dataUsageWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Warning - Please ensure you have enough data to stream videos.`
  String get dataUsageWarningText {
    return Intl.message(
      'Warning - Please ensure you have enough data to stream videos.',
      name: 'dataUsageWarningText',
      desc: '',
      args: [],
    );
  }

  /// `Coach Chat`
  String get coachChatFailedTitle {
    return Intl.message(
      'Coach Chat',
      name: 'coachChatFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't open the Coach Chat right now, please try again later.`
  String get coachChatFailedText {
    return Intl.message(
      'We couldn\'t open the Coach Chat right now, please try again later.',
      name: 'coachChatFailedText',
      desc: '',
      args: [],
    );
  }

  /// `Module`
  String get moduleText {
    return Intl.message(
      'Module',
      name: 'moduleText',
      desc: '',
      args: [],
    );
  }

  /// `Lesson`
  String get lessonText {
    return Intl.message(
      'Lesson',
      name: 'lessonText',
      desc: '',
      args: [],
    );
  }

  /// `Previous modules`
  String get viewPreviousModules {
    return Intl.message(
      'Previous modules',
      name: 'viewPreviousModules',
      desc: '',
      args: [],
    );
  }

  /// `Previous Modules`
  String get previousModules {
    return Intl.message(
      'Previous Modules',
      name: 'previousModules',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveText {
    return Intl.message(
      'Save',
      name: 'saveText',
      desc: '',
      args: [],
    );
  }

  /// `Just a moment whilst we load your personalized Ovie plan!`
  String get loadingLessons {
    return Intl.message(
      'Just a moment whilst we load your personalized Ovie plan!',
      name: 'loadingLessons',
      desc: '',
      args: [],
    );
  }

  /// `No lessons to display!`
  String get noResultsLessons {
    return Intl.message(
      'No lessons to display!',
      name: 'noResultsLessons',
      desc: '',
      args: [],
    );
  }

  /// `No lessons matching your search.`
  String get noResultsLessonsSearch {
    return Intl.message(
      'No lessons matching your search.',
      name: 'noResultsLessonsSearch',
      desc: '',
      args: [],
    );
  }

  /// `View lesson`
  String get viewNow {
    return Intl.message(
      'View lesson',
      name: 'viewNow',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismissText {
    return Intl.message(
      'Dismiss',
      name: 'dismissText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a value in the text box`
  String get textTaskValidation {
    return Intl.message(
      'Please enter a value in the text box',
      name: 'textTaskValidation',
      desc: '',
      args: [],
    );
  }

  /// `Please make a selection above`
  String get boolTaskValidation {
    return Intl.message(
      'Please make a selection above',
      name: 'boolTaskValidation',
      desc: '',
      args: [],
    );
  }

  /// `Your why:`
  String get yourWhyTitle {
    return Intl.message(
      'Your why:',
      name: 'yourWhyTitle',
      desc: '',
      args: [],
    );
  }

  /// `What's your why`
  String get yourWhyWarningTitle {
    return Intl.message(
      'What\'s your why',
      name: 'yourWhyWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `This can only be enabled after the first module has been completed.`
  String get yourWhyWarningText {
    return Intl.message(
      'This can only be enabled after the first module has been completed.',
      name: 'yourWhyWarningText',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get tutorialWelcomeWelcome {
    return Intl.message(
      'Welcome to',
      name: 'tutorialWelcomeWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for signing up to our programme. We are here to help you get the most from Ovie.`
  String get tutorialWelcomeThankYou {
    return Intl.message(
      'Thank you for signing up to our programme. We are here to help you get the most from Ovie.',
      name: 'tutorialWelcomeThankYou',
      desc: '',
      args: [],
    );
  }

  /// `We tailor the programme to meet your specific needs using the information provided in the questionnaire.`
  String get tutorialWelcomeTailor {
    return Intl.message(
      'We tailor the programme to meet your specific needs using the information provided in the questionnaire.',
      name: 'tutorialWelcomeTailor',
      desc: '',
      args: [],
    );
  }

  /// `It is important to take your time to complete all the modules and lessons in the programme, beginning with the first module 'What is your Why?'.`
  String get tutorialWelcomeModules {
    return Intl.message(
      'It is important to take your time to complete all the modules and lessons in the programme, beginning with the first module \'What is your Why?\'.',
      name: 'tutorialWelcomeModules',
      desc: '',
      args: [],
    );
  }

  /// `Coach Chat`
  String get tutorialWelcomeCoachTitle {
    return Intl.message(
      'Coach Chat',
      name: 'tutorialWelcomeCoachTitle',
      desc: '',
      args: [],
    );
  }

  /// `Also, when you feel you need our support, remember to tap the 'Coach Chat' to contact one of our friendly experts.`
  String get tutorialWelcomeCoachDesc {
    return Intl.message(
      'Also, when you feel you need our support, remember to tap the \'Coach Chat\' to contact one of our friendly experts.',
      name: 'tutorialWelcomeCoachDesc',
      desc: '',
      args: [],
    );
  }

  /// `Header Bar`
  String get tutorialNavigationHeaderBar {
    return Intl.message(
      'Header Bar',
      name: 'tutorialNavigationHeaderBar',
      desc: '',
      args: [],
    );
  }

  /// `Open the menu drawer for app settings, profile, change password, policies, and to lock the app.`
  String get tutorialNavigationDrawerMenu {
    return Intl.message(
      'Open the menu drawer for app settings, profile, change password, policies, and to lock the app.',
      name: 'tutorialNavigationDrawerMenu',
      desc: '',
      args: [],
    );
  }

  /// `Tap the chat icon to use the 'Coach Chat' feature, or view your notifications by tapping the bell.`
  String get tutorialNavigationNotifications {
    return Intl.message(
      'Tap the chat icon to use the \'Coach Chat\' feature, or view your notifications by tapping the bell.',
      name: 'tutorialNavigationNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Bottom Tabs`
  String get tutorialNavigationBottomTabs {
    return Intl.message(
      'Bottom Tabs',
      name: 'tutorialNavigationBottomTabs',
      desc: '',
      args: [],
    );
  }

  /// `Your Course`
  String get tutorialNavigationYourCourse {
    return Intl.message(
      'Your Course',
      name: 'tutorialNavigationYourCourse',
      desc: '',
      args: [],
    );
  }

  /// `Recipes`
  String get tutorialNavigationRecipes {
    return Intl.message(
      'Recipes',
      name: 'tutorialNavigationRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge Base`
  String get tutorialNavigationKB {
    return Intl.message(
      'Knowledge Base',
      name: 'tutorialNavigationKB',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get tutorialNavigationFaves {
    return Intl.message(
      'Favourites',
      name: 'tutorialNavigationFaves',
      desc: '',
      args: [],
    );
  }

  /// `Your Course`
  String get tutorialYourCourseTitle {
    return Intl.message(
      'Your Course',
      name: 'tutorialYourCourseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check this daily for your lessons and to complete your tasks`
  String get tutorialYourCourseDesc {
    return Intl.message(
      'Check this daily for your lessons and to complete your tasks',
      name: 'tutorialYourCourseDesc',
      desc: '',
      args: [],
    );
  }

  /// `Recipes`
  String get tutorialRecipesTitle {
    return Intl.message(
      'Recipes',
      name: 'tutorialRecipesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Oh course we have recipes! Find recipes to help maintain your course goals`
  String get tutorialRecipesDesc {
    return Intl.message(
      'Oh course we have recipes! Find recipes to help maintain your course goals',
      name: 'tutorialRecipesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Knowledge Base`
  String get tutorialKBTitle {
    return Intl.message(
      'Knowledge Base',
      name: 'tutorialKBTitle',
      desc: '',
      args: [],
    );
  }

  /// `Any questions you have about food, exercise, supplements and all other course content can be found here`
  String get tutorialKBDesc {
    return Intl.message(
      'Any questions you have about food, exercise, supplements and all other course content can be found here',
      name: 'tutorialKBDesc',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get tutorialFavesTitle {
    return Intl.message(
      'Favourites',
      name: 'tutorialFavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add lessons, knowledge base questions or recipes to your favourites tab for later`
  String get tutorialFavesDesc {
    return Intl.message(
      'Add lessons, knowledge base questions or recipes to your favourites tab for later',
      name: 'tutorialFavesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get tutorialClose {
    return Intl.message(
      'Close',
      name: 'tutorialClose',
      desc: '',
      args: [],
    );
  }

  /// `Download to device`
  String get downloadToDevice {
    return Intl.message(
      'Download to device',
      name: 'downloadToDevice',
      desc: '',
      args: [],
    );
  }

  /// `Download Failed`
  String get downloadFailed {
    return Intl.message(
      'Download Failed',
      name: 'downloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `We could not download the file to your device`
  String get downloadFailedMsg {
    return Intl.message(
      'We could not download the file to your device',
      name: 'downloadFailedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Download Complete`
  String get downloadSuccess {
    return Intl.message(
      'Download Complete',
      name: 'downloadSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please check your device download folder.`
  String get downloadSuccessMsg {
    return Intl.message(
      'Please check your device download folder.',
      name: 'downloadSuccessMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please check your device photos.`
  String get downloadSuccessMsgiOS {
    return Intl.message(
      'Please check your device photos.',
      name: 'downloadSuccessMsgiOS',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Search`
  String get lessonSearch {
    return Intl.message(
      'Lesson Search',
      name: 'lessonSearch',
      desc: '',
      args: [],
    );
  }

  /// `Future Lesson`
  String get futureLesson {
    return Intl.message(
      'Future Lesson',
      name: 'futureLesson',
      desc: '',
      args: [],
    );
  }

  /// `No favourite lessons to display.`
  String get noFavouriteLesson {
    return Intl.message(
      'No favourite lessons to display.',
      name: 'noFavouriteLesson',
      desc: '',
      args: [],
    );
  }

  /// `No favourite lesson wikis to display.`
  String get noFavouriteWikis {
    return Intl.message(
      'No favourite lesson wikis to display.',
      name: 'noFavouriteWikis',
      desc: '',
      args: [],
    );
  }

  /// `No favourite recipes to display.`
  String get noFavouriteRecipe {
    return Intl.message(
      'No favourite recipes to display.',
      name: 'noFavouriteRecipe',
      desc: '',
      args: [],
    );
  }

  /// `Saved to your Favorites which you can find in Library`
  String get savedToFavouritesMessage {
    return Intl.message(
      'Saved to your Favorites which you can find in Library',
      name: 'savedToFavouritesMessage',
      desc: '',
      args: [],
    );
  }

  /// `No favorite workouts to display.`
  String get noFavouriteWorkout {
    return Intl.message(
      'No favorite workouts to display.',
      name: 'noFavouriteWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Wiki`
  String get lessonWiki {
    return Intl.message(
      'Lesson Wiki',
      name: 'lessonWiki',
      desc: '',
      args: [],
    );
  }

  /// `View answer`
  String get viewWikiAnswer {
    return Intl.message(
      'View answer',
      name: 'viewWikiAnswer',
      desc: '',
      args: [],
    );
  }

  /// `View question`
  String get viewWikiQuestion {
    return Intl.message(
      'View question',
      name: 'viewWikiQuestion',
      desc: '',
      args: [],
    );
  }

  /// `There are no wiki items for this lesson`
  String get noWikis {
    return Intl.message(
      'There are no wiki items for this lesson',
      name: 'noWikis',
      desc: '',
      args: [],
    );
  }

  /// `Open the lesson to view the lesson and wikis`
  String get lockedWikis {
    return Intl.message(
      'Open the lesson to view the lesson and wikis',
      name: 'lockedWikis',
      desc: '',
      args: [],
    );
  }

  /// `There are no recipes for this lesson`
  String get noRecipes {
    return Intl.message(
      'There are no recipes for this lesson',
      name: 'noRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Open the lesson to view the lesson and recipes`
  String get lockedRecipes {
    return Intl.message(
      'Open the lesson to view the lesson and recipes',
      name: 'lockedRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Recipes`
  String get lessonRecipes {
    return Intl.message(
      'Lesson Recipes',
      name: 'lessonRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Swipe up for answer`
  String get swipeUpForAnswer {
    return Intl.message(
      'Swipe up for answer',
      name: 'swipeUpForAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Swipe down for question`
  String get swipeDownForQuestion {
    return Intl.message(
      'Swipe down for question',
      name: 'swipeDownForQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Toolkit`
  String get toolkitTitle {
    return Intl.message(
      'Toolkit',
      name: 'toolkitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Wiki Search`
  String get searchWiki {
    return Intl.message(
      'Lesson Wiki Search',
      name: 'searchWiki',
      desc: '',
      args: [],
    );
  }

  /// `No lesson wiki matching your search.`
  String get noWikisSearch {
    return Intl.message(
      'No lesson wiki matching your search.',
      name: 'noWikisSearch',
      desc: '',
      args: [],
    );
  }

  /// `All Modules`
  String get allModules {
    return Intl.message(
      'All Modules',
      name: 'allModules',
      desc: '',
      args: [],
    );
  }

  /// `Start Quiz`
  String get startQuiz {
    return Intl.message(
      'Start Quiz',
      name: 'startQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get quizNext {
    return Intl.message(
      'Next',
      name: 'quizNext',
      desc: '',
      args: [],
    );
  }

  /// `Select all that apply`
  String get quizMulti {
    return Intl.message(
      'Select all that apply',
      name: 'quizMulti',
      desc: '',
      args: [],
    );
  }

  /// `Check Answer`
  String get checkAnswer {
    return Intl.message(
      'Check Answer',
      name: 'checkAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Well Done`
  String get quizCorrectResponse {
    return Intl.message(
      'Well Done',
      name: 'quizCorrectResponse',
      desc: '',
      args: [],
    );
  }

  /// `Unlucky`
  String get quizWrongResponse {
    return Intl.message(
      'Unlucky',
      name: 'quizWrongResponse',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Question`
  String get quizQuestionWarningTitle {
    return Intl.message(
      'Quiz Question',
      name: 'quizQuestionWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please provide an answer for this question.`
  String get quizQuestionWarningText {
    return Intl.message(
      'Please provide an answer for this question.',
      name: 'quizQuestionWarningText',
      desc: '',
      args: [],
    );
  }

  /// `Thank you`
  String get quizGenericEndTitle {
    return Intl.message(
      'Thank you',
      name: 'quizGenericEndTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have now completed this quiz`
  String get quizGenericEndMessage {
    return Intl.message(
      'You have now completed this quiz',
      name: 'quizGenericEndMessage',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warningText {
    return Intl.message(
      'Warning',
      name: 'warningText',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get somethingWentWrongMessage {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'somethingWentWrongMessage',
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
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
