import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class OldICTRepository extends AppBaseRepository {
  static const String tableName = AppSQLiteController.ictGrantsTableName;

  Future<Map<String,Object?>?> getRecordFieldsById(int id, List<String> fields)async{
    final result = await fetchRecordById(id.toString(), tableName, idField: "id", returnFields: fields);
    return result;
  }

  Future<Map<String,Object?>?> getRecordFieldsByBvn(String bvn, List<String> fields)async{
    final result = await fetchRecordById(bvn, tableName, idField: "bvn", returnFields: fields);
    return result;
  }

  Future<List<Map<String,Object?>>> getRecordsWithFields(String lga, List<String> fields,
      {String lastBvn="0", int limit=5})async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE ${ICTDataField.businessLGA.name} = ? AND bvn > ? ORDER BY bvn LIMIT ?", params: [lga.capitalizeWords(), lastBvn, limit]);
    return results;
  }

  Future<List<Map<String,Object?>>> getRecordsWithFieldsByIds(String lga, List<String> fields,
      {String lastBvn="0", int limit=5})async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE ${ICTDataField.businessLGA.name} = ? ORDER BY id", params: [lga.capitalizeWords()]);
    return results;
  }

  Future<List<MiniICTGrantSchema>> getRecordsByBvnWithFields(String bvn, List<String> fields)async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE bvn = ? ORDER BY bvn", params: [bvn]);
    return MiniICTGrantSchema.fromSchemaArray(results);
  }

  Future<int> countAllRecords()async{
    return await count(tableName, idField: 'id', whereSuffix: "'1' = ?", params: ['1'] );
  }

  Future<int> countAllRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'id', whereSuffix:  "${ICTDataField.businessLGA.name} = ?", params: [lga.capitalizeWords()] );
  }

}
