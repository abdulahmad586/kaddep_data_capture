import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './services.dart';

class AppConfig {

  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;

  AppConfig._internal();

  String? appStoreBoxPath;
  String? databaseDirectory;

  static Future<void> configure({bool initialiseHive=true})async{
    WidgetsFlutterBinding.ensureInitialized();
    String appStoreBoxPath = (await getApplicationSupportDirectory()).path;

    AppConfig config = AppConfig();
    config.appStoreBoxPath = appStoreBoxPath;
    config.databaseDirectory = await getDatabasesPath();
    UserSQLiteController();
    AppSQLiteController();
    if(initialiseHive){
      AppStorage storage = AppStorage();
      AppSettings settings = AppSettings();
      await Future.wait([storage.initHive(), settings.initHive()]);
    }
  }

}