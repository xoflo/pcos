import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:thepcosprotocol_app/constants/favourite_type.dart';
import 'package:thepcosprotocol_app/controllers/preferences_controller.dart';
import 'package:thepcosprotocol_app/models/lesson.dart';
import 'package:thepcosprotocol_app/models/lesson_wiki.dart';
import 'package:thepcosprotocol_app/models/navigation/app_tutorial_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/previous_modules_arguments.dart';
import 'package:thepcosprotocol_app/models/navigation/settings_arguments.dart';
import 'package:thepcosprotocol_app/models/recipe.dart';
import 'package:thepcosprotocol_app/models/lesson_recipe.dart';
import 'package:thepcosprotocol_app/providers/favourites_provider.dart';
import 'package:thepcosprotocol_app/providers/modules_provider.dart';
import 'package:thepcosprotocol_app/providers/recipes_provider.dart';
import 'package:thepcosprotocol_app/screens/other/lesson_search.dart';
import 'package:thepcosprotocol_app/screens/other/previous_modules.dart';
import 'package:thepcosprotocol_app/screens/other/quiz.dart';
import 'package:thepcosprotocol_app/screens/other/wiki_search.dart';
import 'package:thepcosprotocol_app/styles/colors.dart';
import 'package:thepcosprotocol_app/utils/device_utils.dart';
import 'package:thepcosprotocol_app/widgets/app_tutorial/app_tutorial_page.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_wikis.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/lesson_recipes.dart';
import 'package:thepcosprotocol_app/widgets/lesson/course_lesson.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/tasks.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/your_why.dart';
import 'package:thepcosprotocol_app/widgets/recipes/recipe_details.dart';
import 'package:thepcosprotocol_app/constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import 'package:thepcosprotocol_app/utils/dialog_utils.dart';
import 'package:thepcosprotocol_app/generated/l10n.dart';
import 'package:thepcosprotocol_app/screens/more/settings.dart';
import 'package:thepcosprotocol_app/widgets/dashboard/current_module.dart';
import 'package:thepcosprotocol_app/services/firebase_analytics.dart';
import 'package:thepcosprotocol_app/constants/analytics.dart' as Analytics;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DashboardLayout extends StatefulWidget {
  final bool showYourWhy;
  final bool showLessonRecipes;
  final Function(bool) updateYourWhy;

  DashboardLayout({
    required this.showYourWhy,
    required this.showLessonRecipes,
    required this.updateYourWhy,
  });

  @override
  _DashboardLayoutState createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _dataUsageWarningDisplayed = false;
  int _selectedLessonIndex = -1;
  int _selectedLessonId = 0;
  bool _selectedLessonIsComplete = true;
  int _selectedWiki = 0;
  int _selectedRecipe = 0;
  String _yourWhy = "";
  List<LessonWiki> _lessonWikis = [];

  //#region Initialisation
  @override
  void initState() {
    super.initState();
    _initialise();
    _checkShowTutorial();
  }

  Future<void> _initialise() async {
    final bool dataUsageWarningDisplayed = await PreferencesController()
        .getBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED);
    final String whatsYourWhy = await PreferencesController()
        .getString(SharedPreferencesKeys.WHATS_YOUR_WHY);
    setState(() {
      _dataUsageWarningDisplayed = dataUsageWarningDisplayed;
      _yourWhy = whatsYourWhy;
    });
  }

  void _updateWhatsYourWhy(final String whatsYourWhy) {
    widget.updateYourWhy(true);
    setState(() {
      _yourWhy = whatsYourWhy;
    });
  }

  Future<void> _checkShowTutorial() async {
    if (!await PreferencesController()
        .getBool(SharedPreferencesKeys.VIEWED_TUTORIAL)) {
      analytics.logEvent(name: Analytics.ANALYTICS_EVENT_TUTORIAL_BEGIN);
      PreferencesController()
          .saveBool(SharedPreferencesKeys.VIEWED_TUTORIAL, true);
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pushNamed(
          context,
          AppTutorialPage.id,
          arguments: AppTutorialArguments(),
        );
      });
    }
  }
  //#endregion

  //#region User Alerts
  void _askUserForDailyReminder() {
    void openSettings(BuildContext context) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, Settings.id,
          arguments: SettingsArguments((bool) {}, (bool) {}, (bool) {}));
    }

    void displaySetupLaterMessage(BuildContext context) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        S.current.requestDailyReminderTitle,
        S.current.requestDailyReminderNoText,
        S.current.okayText,
        "",
        null,
        (BuildContext context) {
          Navigator.of(context).pop();
        },
      );
    }

    PreferencesController()
        .saveBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER, true);

    showAlertDialog(
      context,
      S.current.requestDailyReminderTitle,
      S.current.requestDailyReminderText,
      S.current.noText,
      S.current.yesText,
      openSettings,
      displaySetupLaterMessage,
    );
  }

  void _askUserForNotificationPermission() {
    void requestNotificationPermission(BuildContext context) async {
      Navigator.of(context).pop();
      await NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
              sound: true, badge: true, alert: true));
    }

    PreferencesController().saveBool(
        SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION, true);

    showAlertDialog(
      context,
      S.current.requestNotificationPermissionTitle,
      S.current.requestNotificationPermissionText,
      S.current.noText,
      S.current.yesText,
      requestNotificationPermission,
      (BuildContext context) {
        Navigator.of(context).pop();
      },
    );
  }
  //#endregion

  //#region Lesson
  void _openLesson(final Lesson lesson, final ModulesProvider modulesProvider) {
    //mark lesson a complete if not already
    if (!lesson.isComplete) {
      //is this the last lesson of the Module, if so, also setComplete for module
      final bool setModuleComplete =
          modulesProvider.currentModuleLessons.last.lessonID == lesson.lessonID;
      modulesProvider.setLessonAsComplete(
          lesson.lessonID, lesson.moduleID, setModuleComplete);
    }

    bool showDataUsageWarning = false;

    if (!_dataUsageWarningDisplayed) {
      showDataUsageWarning = true;
      //save has seen warning so not to display again
      PreferencesController()
          .saveBool(SharedPreferencesKeys.DATA_USAGE_WARNING_DISPLAYED, true);
      setState(() {
        _dataUsageWarningDisplayed = true;
      });
    }
    //get the lesson wikis and recipes
    final List<LessonWiki> lessonWikis =
        modulesProvider.getLessonWikis(lesson.lessonID);
    final List<LessonRecipe> lessonRecipes =
        modulesProvider.getLessonRecipes(lesson.lessonID);

    openBottomSheet(
      context,
      CourseLesson(
        modulesProvider: modulesProvider,
        showDataUsageWarning: showDataUsageWarning,
        lesson: lesson,
        lessonWikis: lessonWikis,
        lessonRecipes: lessonRecipes,
        closeLesson: _closeLesson,
        getPreviousModuleLessons: () {},
      ),
      Analytics.ANALYTICS_SCREEN_LESSON,
      lesson.lessonID.toString(),
    );
  }

  void _closeLesson() async {
    Navigator.pop(context);

    final bool requestedDailyReminder = await PreferencesController()
        .getBool(SharedPreferencesKeys.REQUESTED_DAILY_REMINDER);

    if (!requestedDailyReminder) {
      //ask the member if they would like a daily reminder first time after closing a lesson
      _askUserForDailyReminder();
    } else if (await NotificationPermissions
            .getNotificationPermissionStatus() !=
        PermissionStatus.granted) {
      if (!await PreferencesController()
          .getBool(SharedPreferencesKeys.REQUESTED_NOTIFICATIONS_PERMISSION)) {
        //ask the member if they would like notifications after closing a lesson after a period of time has passed
        final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
        final int firstAppUseTimestamp = await PreferencesController()
                .getInt(SharedPreferencesKeys.APP_FIRST_USE_TIMESTAMP) ??
            0;
        try {
          if ((currentTimestamp - firstAppUseTimestamp) / 1000 > 259200) {
            //longer than three days (259200 seconds) since app first used
            _askUserForNotificationPermission();
          }
        } catch (ex) {
          //seems to be an error with checking timestamps, show request anyway
          _askUserForNotificationPermission();
        }
      }
    }
  }

  void _openPreviousModules(
      final BuildContext context, final ModulesProvider modulesProvider) {
    analytics.logEvent(name: Analytics.ANALYTICS_SCREEN_PREVIOUS_MODULES);
    Navigator.pushNamed(context, PreviousModules.id,
        arguments: PreviousModulesArguments(modulesProvider));
  }

  void _openLessonSearch(
      final BuildContext context, final ModulesProvider modulesProvider) {
    //clear old search results before opening
    modulesProvider.clearSearch();
    analytics.logEvent(name: Analytics.ANALYTICS_SCREEN_LESSON_SEARCH);
    Navigator.pushNamed(context, LessonSearch.id);
  }

  void _onLessonChanged(final ModulesProvider modulesProvider,
      final int lessonIndex, final Lesson lesson) {
    List<LessonWiki> lessonWikis =
        modulesProvider.getLessonWikis(lesson.lessonID);

    setState(() {
      _selectedLessonIndex = lessonIndex;
      _selectedLessonId = lesson.lessonID;
      _selectedLessonIsComplete = lesson.isComplete;
      _lessonWikis = lessonWikis;
    });
  }
  //#endregion

  //#region Actions

  void _openWikiSearch(
      final BuildContext context, final ModulesProvider modulesProvider) {
    //clear old search results before opening
    analytics.logEvent(name: Analytics.ANALYTICS_SCREEN_LESSON_WIKI_SEARCH);
    Navigator.pushNamed(context, WikiSearch.id);
  }

  void _openQuiz(
      final BuildContext context, final ModulesProvider modulesProvider) {
    analytics.logEvent(name: Analytics.ANALYTICS_SCREEN_QUIZ);
    Navigator.pushNamed(context, QuizScreen.id);
  }

  //#endregion

  //#region Get Widgets
  Widget getCurrentModule(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
    final FavouritesProvider favouritesProvider,
  ) {
    if (modulesProvider.currentLesson != null && _selectedLessonId == 0) {
      _selectedLessonIsComplete =
          modulesProvider.currentLesson?.isComplete ?? false;
    }
    final bool showPreviousModule = modulesProvider.previousModules.isEmpty
        ? false
        : modulesProvider.previousModules.length > 0
            ? true
            : false;
    return CurrentModule(
      selectedLesson: _selectedLessonIndex,
      width: screenSize.width,
      isHorizontal: isHorizontal,
      modulesProvider: modulesProvider,
      favouritesProvider: favouritesProvider,
      showPreviousModule: showPreviousModule,
      openLesson: _openLesson,
      openPreviousModules: _openPreviousModules,
      onLessonChanged: _onLessonChanged,
      openLessonSearch: _openLessonSearch,
    );
  }

  Widget getTasks(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
  ) {
    if (modulesProvider.displayLessonTasks.isNotEmpty &&
        modulesProvider.displayLessonTasks.length > 0) {
      return Tasks(
        screenSize: screenSize,
        isHorizontal: isHorizontal,
        modulesProvider: modulesProvider,
        updateWhatsYourWhy: _updateWhatsYourWhy,
      );
    }
    return Container();
  }

  Widget getLessonWikis(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
  ) {
    //get the lesson wikis and recipes
    final List<LessonWiki> lessonWikis = _selectedLessonId == 0
        ? modulesProvider.initialLessonWikis
        : _lessonWikis;

    return LessonWikis(
      screenSize: screenSize,
      lessonId: _selectedLessonId,
      isLessonComplete: _selectedLessonIsComplete,
      lessonWikis: lessonWikis,
      modulesProvider: modulesProvider,
      loadingStatus: modulesProvider.status,
      isHorizontal: isHorizontal,
      width: screenSize.width,
      selectedWiki: _selectedWiki,
      openWikiSearch: _openWikiSearch,
    );
  }

  Widget getLessonRecipes(
    final Size screenSize,
    final bool isHorizontal,
    final ModulesProvider modulesProvider,
    final FavouritesProvider favouritesProvider,
  ) {
    //function for opening the recipe details
    void _openRecipeDetails(final BuildContext context, final int? recipeId) {
      void _closeRecipeDetails() {
        Navigator.pop(context);
      }

      final RecipesProvider recipeProvider =
          Provider.of<RecipesProvider>(context, listen: false);
      final Recipe recipe = recipeProvider.getRecipeById(recipeId);
      final bool isFavourite =
          favouritesProvider.isFavourite(FavouriteType.Recipe, recipeId);

      if (recipe.recipeId != -1) {
        openBottomSheet(
          context,
          RecipeDetails(
            recipe: recipe,
            isFavourite: isFavourite,
            closeRecipeDetails: _closeRecipeDetails,
          ),
          Analytics.ANALYTICS_SCREEN_RECIPE_DETAIL,
          recipe.recipeId.toString(),
        );
      }
    }

    final List<LessonRecipe> lessonRecipes = _selectedLessonId == 0
        ? modulesProvider.initialLessonRecipes
        : modulesProvider.getLessonRecipes(_selectedLessonId);
    return LessonRecipes(
      recipes: lessonRecipes,
      loadingStatus: modulesProvider.status,
      isComplete: _selectedLessonIsComplete,
      isHorizontal: isHorizontal,
      width: screenSize.width,
      openRecipe: _openRecipeDetails,
      selectedRecipe: _selectedRecipe,
    );
  }

  //#endregion

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final isHorizontal =
        DeviceUtils.isHorizontalWideScreen(screenSize.width, screenSize.height);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Consumer2<ModulesProvider, FavouritesProvider>(
              builder: (context, modulesProvider, favouritesProvider, child) =>
                  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.showYourWhy
                      ? YourWhy(width: screenSize.width, whatsYourWhy: _yourWhy)
                      : Container(height: 20),
                  getTasks(screenSize, isHorizontal, modulesProvider),
                  getCurrentModule(screenSize, isHorizontal, modulesProvider,
                      favouritesProvider),
                  getLessonWikis(screenSize, isHorizontal, modulesProvider),
                  widget.showLessonRecipes
                      ? getLessonRecipes(screenSize, isHorizontal,
                          modulesProvider, favouritesProvider)
                      : Container(),
                  modulesProvider.lessonQuizzes.length > 0
                      ? GestureDetector(
                          onTap: () {
                            _openQuiz(context, modulesProvider);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Open Quiz",
                                    style: TextStyle(color: secondaryColor)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.quiz,
                                    color: secondaryColor,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
