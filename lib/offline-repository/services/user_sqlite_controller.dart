import 'package:flutter/services.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:sqflite/sqflite.dart';

import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class UserSQLiteController {
  late String _databasePath;

  Database? _database;

  static final UserSQLiteController _instance = UserSQLiteController._internal();
  factory UserSQLiteController() => _instance;

  bool databaseOpen = false;

  UserSQLiteController._internal() {
    AppConfig config = AppConfig();
    _databasePath = "${config.databaseDirectory!}/offlineData.db";
    Future.delayed(const Duration(seconds: 2), _openDatabase);
  }

  Future<void> _openDatabase() async {
    final wardsDatabaseContent = await rootBundle.loadString(AssetConstants.wardsDatabaseSql);
    _database = await openDatabase(_databasePath, version: 1,
        onCreate: (Database db, int version) async {
          databaseOpen = true;
          await db.transaction((txn) async {
            for (var query in tableInitializations) {
              await txn.execute(query);
            }

            for (var query in indicesInitializations) {
              await txn.execute(query);
            }

            final results = await txn.rawQuery('SELECT COUNT("ward") as num FROM $wardsTableName');
            final count = results.first["num"] as int;
            if(count < wardsDatabaseContent.split("\n").length){
              for (var query in wardsDatabaseContent.split("\n")) {
                await txn.execute(query);
              }
            }

          });
        });
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

  Future<List<Object?>> insertRecords(List<MyInsertQuery> myQueries) async {
    try {
      if (_database == null || !databaseOpen) {
        await _openDatabase();
      }

      var result = await _database?.transaction<List<Object?>>((txn) async {
        Batch batch = txn.batch();
        List<Object?> newIds = [];

        for (var query in myQueries) {
          batch.rawInsert(query.sql, query.parameters);
        }

        List<Object?> batchResults = await batch.commit();
        newIds.addAll(batchResults);

        return newIds;
      });

      return result ?? [];
    } catch (e) {
      if (e is DatabaseException) {
        print("Database exception: $e");
      } else {
        print("Error during database transaction: $e");
      }
      return [];
    }
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
    if(_database ==null){
      await Future.delayed(const Duration(seconds: 2));
    }
    List<Map<String, Object?>> results = await _database!.rawQuery(sql, params);
    return results;
  }

  void close() {
    _database?.close();
    databaseOpen = false;
  }

  /// --------------------------------------------------------INITIALIZATION QUERIES----------------------------------------------------------------------

  static const opGrantsTableName = "opgrants";
  static const ictGrantsTableName = "ictgrants";
  static const wardsTableName = "wards";

// id	firstName	lastName	dob	gender	phone	email	bvn	homeAddress	civilServant
  // businessName	businessAddress	businessLGA businessLGACode businessWard	businessRegCat	businessRegIssuer
  // businessRegNo	yearsInOperation	numStaff	businessOpsExpenseCat	itemPurchased1
  // itemPurchased2	itemPurchased3	costOfItems	accountName	bank	accountNumber
  // tin	tinIssuer longitude latitude dataType syncStatus dataComplete
  static const List<String> tableInitializations = [
    'CREATE TABLE IF NOT EXISTS "$wardsTableName" ("state" TEXT(255), "lga" TEXT(255), "ward" TEXT(255), "code" TEXT(255) );',
    'CREATE TABLE IF NOT EXISTS "$opGrantsTableName" ("rid" integer NOT NULL PRIMARY KEY AUTOINCREMENT, id INTEGER, "firstName" TEXT, "lastName" TEXT, "dob" TEXT, "gender" TEXT, "phone" TEXT, "email" TEXT, "homeAddress" TEXT,"civilServant" INTEGER, "bvn" TEXT, "ownerPassportPhotoUrl" BLOB, "idDocType" TEXT, "idDocPhotoUrl" BLOB, "businessName" TEXT, "businessAddress" TEXT,"businessLGA" TEXT, "businessLGACode" TEXT, "businessWard" TEXT, "ownerAtBusinessPhotoUrl" BLOB, "latitude" REAL, "longitude" REAL, "businessRegCat" TEXT, "catType" TEXT, "certPhotoUrl" BLOB, "cacProofDocPhotoUrl" BLOB, "businessRegIssuer" TEXT, "businessRegNum" TEXT, "yearsInOperation" INTEGER, "numStaff" INTEGER, "businessOpsExpenseCat" TEXT, "itemsPurchased" TEXT, "costOfItems" INTEGER, "renumerationPhotoUrl" BLOB, "groupPhotoUrl" BLOB, "comment" TEXT, "bank" TEXT, "accountNumber" TEXT, "accountName" TEXT, "taxId" TEXT, "issuer" TEXT, "taxRegPhotoUrl" BLOB, "dataType" TEXT DEFAULT NULL, "syncStatus" INTEGER DEFAULT 0, "dataComplete" INTEGER DEFAULT 0, "serverVerified" INTEGER DEFAULT O, "syncErrorMessage" TEXT, "createdAt" TEXT, "updatedAt" TEXT )',
    'CREATE TABLE IF NOT EXISTS "$ictGrantsTableName" ("rid" integer NOT NULL PRIMARY KEY AUTOINCREMENT, id INTEGER, "firstName" TEXT, "lastName" TEXT, "dob" TEXT, "gender" TEXT, "phone" TEXT, "email" TEXT, "homeAddress" TEXT,"civilServant" INTEGER, "bvn" TEXT,"ownerPassportPhotoUrl" BLOB, "idDocType" TEXT, "idDocPhotoUrl" BLOB, "businessName" TEXT, "businessAddress" TEXT,"businessLGA" TEXT, "businessLGACode" TEXT, "businessWard" TEXT, "ownerAtBusinessPhotoUrl" BLOB, "latitude" REAL, "longitude" REAL, "businessRegCat" TEXT, "catType" TEXT, "certPhotoUrl" BLOB, "cacProofDocPhotoUrl" BLOB, "businessRegIssuer" TEXT, "businessRegNum" TEXT, "yearsInOperation" INTEGER, "numStaff" INTEGER, "ictProcCat" TEXT, "itemsPurchased" TEXT, "costOfItems" INTEGER, "renumerationPhotoUrl" BLOB, "groupPhotoUrl" BLOB, "comment" TEXT, "bank" TEXT, "accountNumber" TEXT, "accountName" TEXT, "taxId" TEXT, "issuer" TEXT, "taxRegPhotoUrl" BLOB, "dataType" TEXT DEFAULT NULL, "syncStatus" INTEGER DEFAULT 0, "dataComplete" INTEGER DEFAULT 0, "serverVerified" INTEGER DEFAULT O, "syncErrorMessage" TEXT, "createdAt" TEXT, "updatedAt" TEXT )',
  ];

  static const List<String> indicesInitializations = [
    'CREATE INDEX IF NOT EXISTS "main"."code_idx" ON "$wardsTableName" ("code" ASC);',
    'CREATE INDEX IF NOT EXISTS "main"."lga_idx" ON "$wardsTableName" ("lga" ASC);',
    'CREATE INDEX IF NOT EXISTS "main"."ward_idx" ON "$wardsTableName" ("ward" ASC);'
   ];

}
