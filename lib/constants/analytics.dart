//TABS
const String APP_TAB_NAME_DASHBOARD = "dashboard";
const String APP_TAB_NAME_KB = "knowledge_base";
const String APP_TAB_NAME_RECIPES = "recipes";
const String APP_TAB_NAME_FAVOURITES = "favourites";

//EVENTS
const String ANALYTICS_EVENT_LOGIN = "login";
const String ANALYTICS_EVENT_SIGN_UP = "sign_up";
const String ANALYTICS_EVENT_TUTORIAL_BEGIN = "tutorial_begin";
const String ANALYTICS_EVENT_TUTORIAL_COMPLETE = "tutorial_complete";
const String ANALYTICS_EVENT_LESSON_COMPLETE = "lesson_complete";
const String ANALYTICS_EVENT_LESSON_PAGE = "lesson_page";
const String ANALYTICS_EVENT_FLUSHBAR = "flushbar";
const String ANALYTICS_EVENT_OPENDIALOG = "open_dialog";
const String ANALYTICS_EVENT_BUTTONCLICK = "button_click";
const String ANALYTICS_EVENT_SEARCH = "search";
const String ANALYTICS_EVENT_CHANGETAB = "change_tab";
const String ANALYTICS_EVENT_INTERCOM_INIT_FAILED = "intercom_init_failed";
const String ANALYTICS_EVENT_DAILY_REMINDER = "daily_reminder";
const String ANALYTICS_VIDEO_PLAY = "video_play";
const String ANALYTICS_VIDEO_FULLSCREEN = "video_fullscreen";

//PARAMETERS
const String ANALYTICS_PARAMETER_BUTTON = "button";
const String ANALYTICS_PARAMETER_SEARCH_TYPE = "search_type";
const String ANALYTICS_PARAMETER_DIALOG_TITLE = "dialog_title";
const String ANALYTICS_PARAMETER_FLUSHBAR_TITLE = "flushbar_title";
const String ANALYTICS_PARAMETER_VIDEO_NAME = "video_name";
const String ANALYTICS_PARAMETER_LESSON_PAGE_NUMBER = "lesson_page_number";

//SCREENS
const String ANALYTICS_SCREEN_LESSON = "lesson";
const String ANALYTICS_SCREEN_RECIPE_DETAIL = "recipe_detail";
const String ANALYTICS_SCREEN_TUTORIAL = "tutorial";
const String ANALYTICS_SCREEN_COACH_CHAT = "coach_chat";
const String ANALYTICS_SCREEN_PREVIOUS_MODULES = "previous_modules";

//SEARCH TYPES
const String ANALYTICS_SEARCH_RECIPE = "recipe";
const String ANALYTICS_SEARCH_KB = "knowledge_base";

//BUTTONS
const String ANALYTICS_BUTTON_EDIT_PROFILE = "edit_profile";
const String ANALYTICS_BUTTON_SAVE_PROFILE = "save_profile";
const String ANALYTICS_BUTTON_CHANGE_PASSWORD = "change_password";
const String ANALYTICS_BUTTON_SIGN_IN = "sign_in";
const String ANALYTICS_BUTTON_SAVE_TASK = "save_task";
const String ANALYTICS_BUTTON_FORGOTTEN_PIN = "forgotten_pin";
const String ANALYTICS_BUTTON_FORGOTTEN_PWD = "forgotten_password";

class AnalyticsUtils {
  static String getAppTabName(final int index) {
    switch (index) {
      case 0:
        return APP_TAB_NAME_DASHBOARD;
      case 1:
        return APP_TAB_NAME_KB;
      case 2:
        return APP_TAB_NAME_RECIPES;
      case 3:
        return APP_TAB_NAME_FAVOURITES;
      default:
        return "";
    }
  }
}
