import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/models/models.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

enum OGDataType{
  newData,
  existingData
}

class OGRepository extends UserBaseRepository {
  static const String tableName = UserSQLiteController.opGrantsTableName;

  Future<int> onboardOldRecord(Map<String, Object?> recordData, List<OGDataField> fields) async {
    recordData = OperationalGrantSchema.convertOldRecordToNew(recordData);
    final regId = await insertRecord(
        "INSERT INTO $tableName ( ${fields.map((e)=>e.name).toList().join(", ")}, dataType ) VALUES ( ${fields.map((e)=>"?").toList().join(", ")}, ?)",
        params: [
          ...fields.map((e) => recordData[e.name]).toList(),
          OGDataType.existingData.name,
        ]);

    return regId;
  }

  Future<List<Object?>> onboardOldRecords(List<Map<String, Object?>> recordsData, List<OGDataField> fields) async {
    final queries = recordsData.map((recordData){
      recordData = OperationalGrantSchema.convertOldRecordToNew(recordData);
      return MyInsertQuery("INSERT INTO $tableName ( ${fields.map((e)=>e.name).toList().join(", ")}, dataType ) VALUES ( ${fields.map((e)=>"?").toList().join(", ")}, ?)",
          [
            ...fields.map((e) => recordData[e.name]).toList(),
            OGDataType.existingData.name,
          ]);
    }).toList();
    return await insertRecords(queries);
  }

  Future<List<Map<String,Object?>>> getRecordsWithFields(List<String> fields,
      {String lastBvn="0", int limit=5})async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE bvn > ? ORDER BY bvn LIMIT ?", params: [lastBvn, limit]);
    return results;
  }

  Future<List<MiniOperationalGrantSchema>> getRecordsByBvnWithFields(String bvn, List<String> fields)async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE bvn = ? ORDER BY bvn", params: [bvn]);
    return MiniOperationalGrantSchema.fromSchemaArray(results);
  }

  Future<Map<String,Object?>?> getLastOnboardedRecord(List<String> fields)async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName ORDER BY bvn DESC LIMIT ?", params: [1]);
    return results[0];
  }

  Future<int> addEmptyRecord(String bvn,  OGDataType dataType, String lga, String lgaCode, String ward)async{
    final regId = await insertRecord("INSERT INTO $tableName ( bvn, dataType, businessLGA, businessLGACode, businessWard ) VALUES ( ?, ?, ?, ?, ? ) ", params: [bvn, dataType.name, lga, lgaCode, ward]);
    return regId;
  }

  ///[checkCompletion] returns true if data contained in the row identified by the [regId] is complete
  Future<bool> checkCompletion(int regId, {bool updateCompletionField=false})async{
    bool res = false;
    try{
      final result = await getRecordById(regId);
      if(result ==null){
        res = false;
      }
      res = true;
    }catch(e){
      res = false;
    }

    if(updateCompletionField){
      await updateCompletionStatus(regId, res);
    }

    return res;
  }

  Future<Map<String,Object?>?> getRecordFieldsById(int id, List<String> fields)async{
    final result = await fetchRecordById(id, tableName, idField: "rid", returnFields: fields);
    return result;
  }

  Future<OperationalGrantSchema?> getRecordById(int id)async{
    Map<String,Object?> resultsMap = {};

    for(var fieldsList in oGDatabaseFieldsPages){
      final results = await fetchRecords("SELECT rid, ${fieldsList.map((e) => e.name).join(", ")} FROM $tableName WHERE rid = ? LIMIT 1", params: [id]);
      if(results.isNotEmpty){
        var result = results.first;
          resultsMap = {...resultsMap, ...result };
      }
    }

    if(resultsMap.isEmpty){
      return null;
    }

    final result = OperationalGrantSchema.fromMap(resultsMap);
    return result;
  }

  Future<List<OperationalGrantSchema>> getSyncedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT * FROM $tableName WHERE syncStatus = ? AND dataComplete = 0 AND rid > ? ORDER BY rid LIMIT ?", params: ["1", skip, limit]);
    return OperationalGrantSchema.fromMapArray(results);
  }

  Future<List<Map<String,Object?>>> getUnfinishedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT * FROM $tableName WHERE dataComplete = ? AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
    return results;
  }

  Future<List<OperationalGrantSchema>> getUnsyncedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    Map<int,Map<String,Object?>> resultsMap = {};

    for(var fieldsList in oGDatabaseFieldsPages){
      final results = await fetchRecords("SELECT rid, ${fieldsList.map((e) => e.name).join(", ")} FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
      for(var result in results){
        if(resultsMap.containsKey(result['rid'])){
          resultsMap[result['rid'] as int] = {...(resultsMap[result['rid'] as int] ?? {}), ...result };
        }else{
          resultsMap[result['rid'] as int] = result;
        }
      }
    }

    final result = OperationalGrantSchema.fromMapArray(resultsMap.values.toList());
    return result;
  }

  Future<List<MiniOperationalGrantSchema>> getUnsyncedMiniRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT rid, firstName, lastName, businessName, syncStatus, dataComplete FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
    final result = MiniOperationalGrantSchema.fromMapArray(results);
    return result;
  }

  Future<List<MiniOperationalGrantSchema>> getSyncedMiniRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT rid, firstName, lastName, businessName,  syncStatus, dataComplete FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["1", skip, limit]);
    final result = MiniOperationalGrantSchema.fromMapArray(results);
    return result;
  }

  Future<int> countAllRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${OGDataField.businessLGA.name} = ?", params: [lga.capitalizeWords()] );
  }

  Future<int> countNewRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${OGDataField.businessLGA.name} = ? AND ${OGDataField.dataType.name} = ? AND ${OGDataField.dataComplete.name} = 1", params: [lga.capitalizeWords(), OGDataType.newData.name] );
  }

  Future<int> countUpdatedRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${OGDataField.businessLGA.name} = ? AND ${OGDataField.dataType.name} = ? AND ${OGDataField.dataComplete.name} = ?", params: [lga.capitalizeWords(), OGDataType.existingData.name, 1] );
  }

  Future<int> countExistingRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${OGDataField.businessLGA.name} = ? AND ${OGDataField.dataType.name} = ?", params: [lga.capitalizeWords(), OGDataType.existingData.name] );
  }

  Future<int> countSyncedRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${OGDataField.businessLGA.name} = ? AND ${OGDataField.syncStatus.name} = ?", params: [lga.capitalizeWords(), 1] );
  }

  Future<int> countSyncedRecords()async{
    return await count(tableName, idField: 'rid', whereSuffix: "syncStatus = ?", params: ['1'] );
  }

  Future<int> countUnSyncedRecords()async{
    return await count(tableName, idField: 'rid', whereSuffix: "syncStatus = ? AND dataComplete = 1", params: ['0'] );
  }

  Future<int> countAllRecords()async{
    return await count(tableName, idField: 'rid', );
  }
  
  Future<bool> updateStatusSynched(int rid)async{
    final updateResult = await updateRecords("UPDATE $tableName SET syncStatus = ? WHERE rid = ?", params:[1, rid]);
    return updateResult > 0;
  }

  Future<bool> updateCompletionStatus(int rid, bool complete)async{
    final updateResult = await updateRecords("UPDATE $tableName SET dataComplete = ? WHERE rid = ?", params:[complete ? 1 : 0, rid]);
    return updateResult > 0;
  }

  Future<bool> updateDataField(int id, String fieldName, Object value) async{
    final updateResult = await updateRecords("UPDATE $tableName SET $fieldName = ? WHERE rid = ?", params:[value, id]);
    return updateResult > 0;
  }

  Future<bool> deleteRecord(int rid)async{
    final deleteResult = await deleteRecords("DELETE FROM $tableName WHERE rid = ?", params:[rid]);
    return deleteResult > 0;
  }

  Future<bool> deleteAllRecords()async{
    final deleteResult = await deleteRecords("DELETE FROM $tableName WHERE dataComplete = 0 AND syncStatus = 0", params:[]);
    return deleteResult > 0;
  }

}
