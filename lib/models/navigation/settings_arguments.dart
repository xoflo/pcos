class SettingsArguments {
  final Function(bool) updateYourWhy;
  final Function(bool) updateLessonRecipes;
  final bool onlyShowDailyReminder;

  SettingsArguments(
    this.updateYourWhy,
    this.updateLessonRecipes,
    this.onlyShowDailyReminder,
  );
}
