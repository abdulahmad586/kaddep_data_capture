import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class WardsRepository extends UserBaseRepository {
  static const String tableName = UserSQLiteController.wardsTableName;

  Future<List<Map<String,Object?>>> getAllLGAs()async{
    final result = await fetchRecords('SELECT DISTINCT "lga", "code" FROM "$tableName";');
    return result;
  }

  Future<List<Map<String,Object?>>> getAllWardsInLga(String lga)async{
    final result = await fetchRecords('SELECT ward FROM "$tableName" WHERE lga = ?;', params: [lga.toUpperCase()]);
    return result;
  }

}
