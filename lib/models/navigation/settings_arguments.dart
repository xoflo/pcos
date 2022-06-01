class SettingsArguments {
  final Function(bool) updateYourWhy;
  final Function(bool) updateLessonRecipes;
  final Function(bool) updateUseUsername;

  SettingsArguments(
    this.updateYourWhy,
    this.updateLessonRecipes,
    this.updateUseUsername,
  );
}
