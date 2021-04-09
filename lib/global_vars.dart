class GlobalVars {
  GlobalVars._privateConstructor();

  static final GlobalVars _instance = GlobalVars._privateConstructor();

  factory GlobalVars() {
    return _instance;
  }

  bool _refreshMessagesFromAPI = false;

  void setRefreshMessagesFromAPI(final bool value) {
    _refreshMessagesFromAPI = value;
  }

  bool getRefreshMessagesFromAPI() {
    return _refreshMessagesFromAPI;
  }
}
