import 'package:hive/hive.dart';

import './services.dart';

class AppStorage {
  static const boxName = "appStore";

  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;

  AppStorage._internal();

  Box? box;
  bool initialisedHive = false;

  Map<dynamic,dynamic> get videosStatus => box?.get("videosStatus", defaultValue: <dynamic,dynamic>{}) ?? <String,String>{};
  set videosStatus(Map<dynamic,dynamic> statuses) => box?.put("videosStatus", statuses);

  Map<dynamic,dynamic>? get loggedInUser => box?.get("loggedInUser", defaultValue: null);
  set loggedInUser(Map<dynamic,dynamic>? loggedInUser) => box?.put("loggedInUser", loggedInUser);

  String? get password => box?.get("password", defaultValue: null);
  set password(String? password) => box?.put("password", password);

  String? get authToken => box?.get("authToken", defaultValue: null);
  set authToken(String? authToken) => box?.put("authToken", authToken);

  Future<void> initHive() async {
    AppConfig config = AppConfig();
    if (config.appStoreBoxPath == null) {
      throw Exception(
          "Storage box path not set, please use AppConfig to set this value");
    }

    if (!initialisedHive) {
      Hive.init(config.appStoreBoxPath);
      await Hive.openBox(boxName);
      box = Hive.box(boxName);
      initialisedHive = true;
      print("App storage initialised");
    }
  }
}
