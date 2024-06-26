
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

abstract class AppBaseRepository {
  final AppSQLiteController _sqLiteController = AppSQLiteController();

  AppBaseRepository();

  Future<int> insertRecord(String statement,
      {List<Object?> params = const []}) async {
    return await _sqLiteController.insertRecord(statement, params: params);
  }

  Future<List<Map<String, Object?>>> fetchRecords(String statement,
      {List<Object?> params = const []}) async {
    return await _sqLiteController.fetchRecords(statement, params: params);
  }

  Future<Map<String, Object?>?> fetchRecordById(String id, String tableName, {String idField="id", List<String> returnFields=const ["*"]}) async {
    if(returnFields.isEmpty){
      returnFields = ["*"];
    }
    final results = await _sqLiteController.fetchRecords("SELECT ${returnFields.join(", ")} FROM $tableName WHERE $idField = ?", params: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> count(String tableName, {String idField="id", String whereSuffix="1=1", List<Object?> params= const[]}) async {
    final results = await _sqLiteController.fetchRecords('SELECT COUNT("$idField") as num FROM $tableName WHERE $whereSuffix', params: params);
    return results.first["num"] as int;
  }

  Future<int> updateRecords(String statement,
      {List<Object?> params = const []}) async {
    return await _sqLiteController.updateRecords(statement, params: params);
  }

  Future<int> deleteRecords(String statement,
      {List<Object?> params = const []}) async {
    return await _sqLiteController.updateRecords(statement, params: params);
  }

}
