import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class BanksRepository extends AppBaseRepository {
  static const String tableName = AppSQLiteController.banksTableName;

  Future<List<Map<String,Object?>>> getAllBanks()async{
    final result = await fetchRecords('SELECT name FROM "$tableName";');
    return result;
  }

}
