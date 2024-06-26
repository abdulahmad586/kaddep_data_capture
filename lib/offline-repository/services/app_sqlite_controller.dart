import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:sqflite/sqflite.dart';

class AppSQLiteController {

  static const String opGrantsTableName= "opsrepo";
  static const String ictGrantsTableName= "ictgrant";
  static const String banksTableName= "banks";

  Database? _database;

  static final AppSQLiteController _instance = AppSQLiteController._internal();

  factory AppSQLiteController() => _instance;

  bool databaseOpen = false;

  AppSQLiteController._internal() {
    Future.delayed(const Duration(seconds: 2), _openDatabase);
  }

  Future<void> _openDatabase() async {
    var dbDir = await getDatabasesPath();
    String databasePath = "$dbDir/oldData.db";

    final file = File(databasePath);
    if(!(await file.exists()) || (await file.length()) < 1024 * 1024 * 100 ){
      debugPrint("Starting migration...");
      ByteData data = await rootBundle.load(AssetConstants.oldDataDatabase);
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes);
      debugPrint("Finished migration");
    }

    _database = await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
          databaseOpen = true;
        });
    databaseOpen = true;
  }

  void reopenDatabase(){
    if(!databaseOpen){
      _openDatabase();
    }
  }

  Future<int> insertRecord(String sql,
      {List<Object?> params = const []}) async {
    if(_database == null || !databaseOpen){
      await _openDatabase();
    }
    int id = await _database!.rawInsert(sql, params);
    return id;
  }

  Future<int> deleteRecords(String sql,
      {List<Object?> params = const []}) async {
    if(_database == null || !databaseOpen){
      await _openDatabase();
    }
    int id = await _database!.rawDelete(sql, params);
    return id;
  }

  Future<int> updateRecords(String sql,
      {List<Object?> params = const []}) async {
    if(_database == null || !databaseOpen){
      await _openDatabase();
    }
    int id = await _database!.rawUpdate(sql, params);
    return id;
  }

  Future<List<Map<String, Object?>>> fetchRecords(String sql,
      {List<Object?> params = const []}) async {
    List<Map<String, Object?>> results = await _database!.rawQuery(sql, params);
    return results;
  }

  void close() {
    _database?.close();
    databaseOpen = false;
  }


}
