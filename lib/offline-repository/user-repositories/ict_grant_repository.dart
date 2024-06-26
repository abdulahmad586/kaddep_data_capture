import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

enum ICTDataType{
  newData,
  existingData
}

class ICTRepository extends UserBaseRepository {
  static const String tableName = UserSQLiteController.ictGrantsTableName;

  Future<int> onboardOldRecord(Map<String, Object?> recordData, List<ICTDataField> fields) async {
    recordData = ICTGrantSchema.convertOldRecordToNew(recordData);
    final regId = await insertRecord(
        "INSERT INTO $tableName ( ${fields.map((e)=>e.name).toList().join(", ")}, dataType ) VALUES ( ${fields.map((e)=>"?").toList().join(", ")}, ?)",
        params: [
          ...fields.map((e) => recordData[e.name]).toList(),
          ICTDataType.existingData.name,
        ]);

    return regId;
  }

  Future<int> addRecord(ICTGrantSchema info, ICTDataType dataType) async {
    // id	firstName	lastName	dob	gender	phone	email	bvn	homeAddress	civilServant
    // businessName	businessAddress	businessLGA businessLGACode businessWard	businessRegCat	businessRegIssuer
    // businessRegNo	yearsInOperation	numStaff	businessOpsExpenseCat	itemPurchased1
    // itemPurchased2	itemPurchased3	costOfItems	accountName	bank	accountNumber
    // tin	tinIssuer longitude latitude dataType syncStatus dataComplete createdAd updateAt
    final regId = await insertRecord(
        "INSERT INTO $tableName (firstName, lastName,	dob, gender,	phone, email,	bvn,	homeAddress,	civilServant, businessName,	businessAddress,	businessLGA, businessLGACode, businessWard,	businessRegCat,	businessRegIssuer, businessRegNo,	yearsInOperation,	numStaff,	ictProcCat,	complPurchase1, complPurchase2,	complPurchase3,	costOfItems,	accountName, bank,	accountNumber, tin,	tinIssuer, longitude, latitude, dataType ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        params: [
          info.firstName,
          info.lastName,
          info.dob.toIso8601String(),
          info.gender,
          info.phone,
          info.email,
          info.bvn,
          info.homeAddress,
          info.civilServant,
          info.businessName,
          info.businessAddress,
          info.businessLGA,
          info.businessLGACode,
          info.businessWard,
          info.ictProcCat,
          info.businessRegIssuer,
          info.businessRegNo,
          info.yearsInOperation,
          info.numStaff,
          info.ictProcCat,
          info.complPurchase1,
          info.complPurchase2,
          info.complPurchase3,
          info.costOfItems,
          info.accountName,
          info.bank,
          info.accountNumber,
          info.taxId,
          info.issuer,
          info.longitude,
          info.latitude,
          dataType.name,
        ]);

    return regId;
  }

  Future<int> addEmptyRecord(String bvn,  ICTDataType dataType, String lga, String lgaCode, String ward)async{
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

  Future<List<MiniICTGrantSchema>> getRecordsByBvnWithFields(String bvn, List<String> fields)async{
    final results = await fetchRecords("SELECT ${fields.join(", ")} FROM $tableName WHERE bvn = ? ORDER BY bvn", params: [bvn]);
    return MiniICTGrantSchema.fromSchemaArray(results);
  }

  Future<ICTGrantSchema?> getRecordById(int id)async{
    final result = await fetchRecordById(id, tableName, idField: "rid");
    if(result == null){
      return null;
    }
    return ICTGrantSchema.fromMap(result);
  }

  Future<List<ICTGrantSchema>> getSyncedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT * FROM $tableName WHERE syncStatus = ? AND dataComplete = 0 AND rid > ? ORDER BY rid LIMIT ?", params: ["1", skip, limit]);
    return ICTGrantSchema.fromMapArray(results);
  }

  Future<List<Map<String,Object?>>> getUnfinishedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT * FROM $tableName WHERE dataComplete = ? AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
    return results;
  }

  Future<List<ICTGrantSchema>> getUnsyncedRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT * FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
    final result = ICTGrantSchema.fromMapArray(results);
    return result;
  }

  Future<List<MiniICTGrantSchema>> getUnsyncedMiniRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT rid, firstName, lastName, businessName FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["0", skip, limit]);
    final result = MiniICTGrantSchema.fromMapArray(results);
    return result;
  }

  Future<List<MiniICTGrantSchema>> getSyncedMiniRecords({int page=1, int limit=5})async{
    final skip = (page * limit) - limit;
    final results = await fetchRecords("SELECT rid, firstName, lastName, businessName FROM $tableName WHERE syncStatus = ? AND dataComplete = 1 AND rid > ? ORDER BY rid LIMIT ?", params: ["1", skip, limit]);
    final result = MiniICTGrantSchema.fromMapArray(results);
    return result;
  }

  Future<int> countAllRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${ICTDataField.businessLGA.name} = ?", params: [lga.capitalizeWords()] );
  }

  Future<int> countNewRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${ICTDataField.businessLGA.name} = ? AND ${ICTDataField.dataType.name} = ? AND ${ICTDataField.dataComplete.name} = 1", params: [lga.capitalizeWords(), OGDataType.newData.name] );
  }

  Future<int> countUpdatedRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${ICTDataField.businessLGA.name} = ? AND ${ICTDataField.dataType.name} = ? AND ${ICTDataField.dataComplete.name} = ?", params: [lga.capitalizeWords(), OGDataType.existingData.name, 1] );
  }

  Future<int> countExistingRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${ICTDataField.businessLGA.name} = ? AND ${ICTDataField.dataType.name} = ?", params: [lga.capitalizeWords(), OGDataType.existingData.name] );
  }

  Future<int> countSyncedRecordsInLGA(String lga)async{
    return await count(tableName, idField: 'rid', whereSuffix:  "${ICTDataField.businessLGA.name} = ? AND ${ICTDataField.syncStatus.name} = ?", params: [lga.capitalizeWords(), 1] );
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
