import 'package:hive/hive.dart';

import './services.dart';

class AppSettings {

  static const boxName = "appSettings";

  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;

  AppSettings._internal();

  Box? box;
  bool initialisedHive = false;

  bool get isFirstTimeLoad => box?.get("isFirstTimeLoad", defaultValue: true);
  set isFirstTimeLoad(bool isFirstTimeLoad) => box?.put("isFirstTimeLoad", isFirstTimeLoad);

  String? get captureLga => box?.get("captureLga", defaultValue: null);
  set captureLga(String? captureLga) => box?.put("captureLga", captureLga);

  String? get captureLgaCode => box?.get("captureLgaCode", defaultValue: null);
  set captureLgaCode(String? captureLgaCode) => box?.put("captureLgaCode", captureLgaCode);

  Future<void> initHive() async {
    AppConfig config= AppConfig();
    if (config.appStoreBoxPath == null) {
      throw Exception(
          "Storage box path not set, please use AppConfig to set this value");
    }

    if (!initialisedHive) {
      Hive.init(config.appStoreBoxPath);
      await Hive.openBox(boxName);
      box = Hive.box(boxName);
      initialisedHive = true;
      print("App settings initialised");
    }
  }


}