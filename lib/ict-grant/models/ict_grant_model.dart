import 'dart:convert';
import 'dart:typed_data';

import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class MiniICTGrantSchema {
  final int rid;
  final String? bvn;
  final String? firstName;
  final String? lastName;
  final String? businessName;
  final String? businessLGA;
  final OGDataType? dataType;
  final bool fromOldRecord;
  final bool? dataComplete;
  final bool? dataSynced;
  final bool? serverVerified;
  final String? syncErrorMessage;

  const MiniICTGrantSchema(
      {required this.rid,
        this.bvn,
        this.fromOldRecord = false,
        this.businessLGA,
        this.firstName,
        this.lastName,
        this.businessName,
        this.dataComplete,
        this.dataType,
        this.dataSynced,
        this.serverVerified,
        this.syncErrorMessage});

  static List<ICTDataField> dataFields = [
    ICTDataField.rid,
    ICTDataField.bvn,
    ICTDataField.firstName,
    ICTDataField.lastName,
    ICTDataField.businessName,
    ICTDataField.businessLGA,
    ICTDataField.dataType,
    ICTDataField.dataComplete,
    ICTDataField.syncStatus,
    ICTDataField.serverVerified,
    ICTDataField.syncErrorMessage,
  ];

  static List<ICTDataField> dataFieldsFromOld = [
    ICTDataField.id,
    ICTDataField.bvn,
    ICTDataField.businessLGA,
    ICTDataField.firstName,
    ICTDataField.lastName,
    ICTDataField.businessName,
  ];

  factory MiniICTGrantSchema.fromMap(Map<String, Object?> map) {
    return MiniICTGrantSchema(
      rid: (map["rid"] ?? map["id"]) as int,
      fromOldRecord: map['rid'] == null,
      bvn: map["bvn"] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      businessName: map['businessName'] as String?,
      businessLGA: map['businessLGA'] as String?,
      dataType: map['dataType'] == null
          ? null
          : OGDataType.values.byName(map['dataType'] as String),
      dataComplete: map['dataComplete'] == null
          ? null
          : (map['dataComplete'] == 1 ? true : false),
      dataSynced: map['syncStatus'] == null
          ? null
          : (map['syncStatus'] == 1 ? true : false),
      serverVerified: map['serverVerified'] == null
          ? null
          : (map['serverVerified'] == 1 ? true : false),
      syncErrorMessage: map['syncErrorMessage'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'rid': rid,
      'fromOldRecord': fromOldRecord,
      'bvn': bvn,
      'firstName': firstName,
      'lastName': lastName,
      'businessName': businessName,
      'businessLGA': businessLGA,
    };
  }

  static List<MiniICTGrantSchema> fromMapArray(
      List<Map<String, Object?>> list) {
    return list.map((e) => MiniICTGrantSchema.fromMap(e)).toList();
  }

  static List<MiniICTGrantSchema> fromSchemaArray(
      List<Map<String, Object?>> results) {
    return results.map((e) => MiniICTGrantSchema.fromMap(e)).toList();
  }
}

class ItemsPurchased {
  final String itemsList;
  final Uint8List? receiptPhotoUrl;

  const ItemsPurchased(
      {required this.itemsList, required this.receiptPhotoUrl});

  factory ItemsPurchased.fromSchema(Map<String, Object?> obj) {
    if (obj["receiptPhotoUrl"] is List<dynamic>) {
      obj["receiptPhotoUrl"] = Uint8List.fromList(
          List<int>.from(obj["receiptPhotoUrl"] as List<dynamic>));
    } else if (obj['receiptPhotoUrl'] is String) {
      obj['receiptPhotoUrl'] =
          FileUtils.base64ToBlob(obj['receiptPhotoUrl'] as String);
    }
    return ItemsPurchased(
        itemsList: obj["itemsList"] as String,
        receiptPhotoUrl: obj["receiptPhotoUrl"] as Uint8List?);
  }

  Future<Map<String, Object?>> toMap() async {
    return {
      'itemsList': itemsList,
      'receiptPhotoUrl': receiptPhotoUrl == null
          ? null
          : await FileUtils.blobToBase64(receiptPhotoUrl!),
    };
  }

  static Future<List<Map<String, Object?>>> toMapArray(
      List<ItemsPurchased> itemsPurchased) async {
    List<Map<String, Object?>> list = [];
    for (var element in itemsPurchased) {
      list.add(await element.toMap());
    }
    return list;
  }

  static Future<List<ItemsPurchased>> fromSchemaArray(
      List<dynamic> list) async {
    List<ItemsPurchased> listResult = [];
    for (var item in list) {
      listResult.add(await ItemsPurchased.fromSchema(item));
    }
    return listResult;
  }
}

class ICTGrantSchema {

  final int? rid;
  final int? id;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String gender;
  final String phone;
  final String email;
  final String bvn;
  final String nin;
  final String homeAddress;
  final bool civilServant;
  final Uint8List ownerPassportPhotoUrl;
  final Uint8List idDocPhotoUrl;
  final String idDocType;
  final String businessName;
  final String businessAddress;
  final String businessLGA;
  final String businessLGACode;
  final String businessWard;
  final Uint8List ownerAtBusinessPhotoUrl;
  final String catType;
  final Uint8List certPhotoUrl;
  final Uint8List? cacProofDocPhotoUrl;
  final String businessRegIssuer;
  final String businessRegNo;
  final int yearsInOperation;
  final int numStaff;
  final String ictProcCat;
  final List<ItemsPurchased> itemsPurchased;
  final String complPurchase1;
  final String complPurchase2;
  final String complPurchase3;
  final int costOfItems;
  final Uint8List? renumerationPhotoUrl;
  final Uint8List? groupPhotoUrl;
  final String? comment;
  final String bank;
  final String accountNumber;
  final String accountName;
  final String taxId;
  final String issuer;
  final Uint8List? taxRegPhotoUrl;

  final double longitude;
  final double latitude;
  final DateTime updatedAt;
  final DateTime createdAt;

  ICTGrantSchema({
    this.rid,
    this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.email,
    required this.bvn,
    required this.nin,
    required this.homeAddress,
    required this.civilServant,
    required this.businessName,
    required this.businessAddress,
    required this.businessLGA,
    required this.businessLGACode,
    required this.businessWard,
    required this.businessRegIssuer,
    required this.businessRegNo,
    required this.yearsInOperation,
    required this.numStaff,
    required this.ictProcCat,
    required this.complPurchase1,
    required this.complPurchase2,
    required this.complPurchase3,
    required this.costOfItems,
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.taxId,
    required this.taxRegPhotoUrl,
    required this.comment,
    required this.groupPhotoUrl,
    required this.renumerationPhotoUrl,
    required this.cacProofDocPhotoUrl,
    required this.certPhotoUrl,
    required this.catType,
    required this.ownerAtBusinessPhotoUrl,
    required this.idDocPhotoUrl,
    required this.idDocType,
    required this.ownerPassportPhotoUrl,
    required this.itemsPurchased,
    required this.issuer,
    required this.longitude,
    required this.latitude,
    required this.updatedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'email': email,
      'bvn': bvn,
      'nin': nin,
      'homeAddress': homeAddress,
      'civilServant': civilServant,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'businessLGA': businessLGA,
      'businessLGACode': businessLGACode,
      'businessWard': businessWard,
      'businessRegIssuer': businessRegIssuer,
      'businessRegNo': businessRegNo,
      'yearsInOperation': yearsInOperation,
      'numStaff': numStaff,
      'ictProcCat': ictProcCat,
      'complPurchase1': complPurchase1,
      'complPurchase2': complPurchase2,
      'complPurchase3': complPurchase3,
      'costOfItems': costOfItems,
      'bank': bank,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'taxId': taxId,
      'issuer': issuer,
      'longitude': longitude,
      'latitude': latitude,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Future<ICTGrantSchema> fromMap(
      Map<String, dynamic> map) async {
    return ICTGrantSchema(
      id: map['id'] ?? map["_id"] ?? map["rid"],
      rid: map['rid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      dob: DateTime.tryParse(map['dob']) ?? parseMyDate(map['dob'])!,
      gender: map['gender'],
      phone: map['phone'] ?? map['phoneNumber'],
      email: map['email'] ?? "",
      bvn: map['bvn'],
      nin: map['nin'],
      homeAddress: map['homeAddress'] ?? map['address'],
      civilServant: (map["civilServant"] ?? map['isCivilServant']) == "Yes"
          ? true
          : false,
      businessName: map['businessName'],
      businessAddress: map['businessAddress'],
      businessLGA: map['businessLGA'],
      businessLGACode: map['businessLGACode'],
      businessWard: map['businessWard'],
      businessRegIssuer: map['businessRegIssuer'],
      businessRegNo: map['businessRegNo'] ?? map['businessRegNum'],
      yearsInOperation: map['yearsInOperation'],
      numStaff: map['numStaff'],
      ictProcCat: map['ictProcCat'],
      itemsPurchased: map['itemsPurchased'] == null
          ? []
          : (await ItemsPurchased.fromSchemaArray(
          jsonDecode(map['itemsPurchased']))),
      complPurchase1: map['complPurchase1'] ?? "",
      complPurchase2: map['complPurchase2'] ?? "",
      complPurchase3: map['complPurchase3'] ?? "",
      costOfItems: map['costOfItems'] != null && (int.tryParse(map['costOfItems'].toString().replaceAll(",","")) != null && int.tryParse(map['costOfItems'].toString().replaceAll(",",""))!   >= 0) ? int.parse(map['costOfItems'].toString().replaceAll(",","")) : 0,
      bank: map['bank'],
      accountNumber: map['accountNumber'],
      accountName: map['accountName'],
      taxId: map['tin'] ?? map['taxId'] ?? map["taxRegNum"] ?? "",
      issuer: map['tinIssuer'] ?? map['issuer'] ?? map['taxIssuer'] ?? "",
      longitude: map['longitude'],
      latitude: map['latitude'],
      cacProofDocPhotoUrl: map['cacProofDocPhotoUrl'],
      catType: map['catType'],
      ownerPassportPhotoUrl: map['ownerPassportPhotoUrl'],
      idDocType: map['idDocType'],
      idDocPhotoUrl: map['idDocPhotoUrl'],
      ownerAtBusinessPhotoUrl: map['ownerAtBusinessPhotoUrl'],
      certPhotoUrl: map['certPhotoUrl'],
      renumerationPhotoUrl: map['renumerationPhotoUrl'],
      groupPhotoUrl: map['groupPhotoUrl'],
      comment: map['comment'] ?? "",
      taxRegPhotoUrl: map['taxRegPhotoUrl'],
      updatedAt:
      DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      createdAt:
      DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Future<Map<String, dynamic>> toMapForSync({bool truncate = false}) async {
    final businessRegCat = {
      'catType': catType,
      'certPhotoUrl': await FileUtils.blobToBase64(certPhotoUrl),
      'cacProofDocPhotoUrl': businessRegIssuer == "CAC"
          ? await FileUtils.blobToBase64(cacProofDocPhotoUrl!)
          : null,
    };
    if(numStaff == 0){
      throw "Number of Staff should not be zero, please edit record";
    }
    return {
      'id': id ?? rid,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'phoneNumber': phone,
      'bvn': bvn,
      'nin': nin,
      'idDocument': {
        'idDocType': idDocType,
        'idDocPhotoUrl': await FileUtils.blobToBase64(idDocPhotoUrl),
      },
      'email': email,
      'ownerPassportPhotoUrl':
      await FileUtils.blobToBase64(ownerPassportPhotoUrl),
      'address': homeAddress,
      'isCivilServant': civilServant,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'businessLGA': businessLGA.capitalizeWords(),
      'businessLGACode': businessLGACode.toUpperCase(),
      'businessWard': businessWard.toUpperCase(),
      'businessRegCat': businessRegCat,
      'businessRegIssuer': businessRegIssuer,
      'businessRegNum': businessRegNo,
      'ownerAtBusinessPhotoUrl':
      await FileUtils.blobToBase64(ownerAtBusinessPhotoUrl),
      'latitude': latitude,
      'longitude': longitude,
      'yearsInOperation': yearsInOperation,
      'numStaff': numStaff,
      'ictProcCat': ictProcCat,
      'itemsPurchased': ictProcCat != "Salary"
          ? await ItemsPurchased.toMapArray(itemsPurchased)
          : null,
      'salaryRenum': ictProcCat == "Salary"
          ? {
        'groupPhotoUrl': groupPhotoUrl == null
            ? null
            : await FileUtils.blobToBase64(groupPhotoUrl!),
        'renumerationPhotoUrl': renumerationPhotoUrl == null
            ? null
            : await FileUtils.blobToBase64(renumerationPhotoUrl!),
        'comment': comment,
      }
          : null,
      'costOfItems': costOfItems,
      'bank': bank,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'tax': taxId.isNotEmpty && taxRegPhotoUrl !=null
          ? {'taxId': taxId, 'issuer': issuer, 'taxRegPhotoUrl': await FileUtils.blobToBase64(taxRegPhotoUrl!)}
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Future<List<ICTGrantSchema>> fromMapArray(
      List<Map<String, Object?>> results) async {
    List<ICTGrantSchema> listResult = [];
    for (var item in results) {
      listResult.add(await ICTGrantSchema.fromMap(item));
    }
    return listResult;
  }

  static Map<String, Object?> convertOldRecordToNew(
      Map<String, Object?> record) {
    return {
      ...record,
      'businessRegNum': record['businessRegNo'],
      'phoneNumber': record['phone'],
      'address': record['homeAddress']?? record["address"],
      'homeAddress': record['homeAddress']?? record["address"],
      'isCivilServant': (record['isCivilServant'] == "Yes" ||
          record['isCivilServant'] == "1" ||
          record['isCivilServant'] == true)
          ? "1"
          : "0",
      'businessLGACode': '',
      'catType': record['catType'] ?? record['businessRegCat'],
      'taxId': record['tin'] ?? record["taxRegNum"],
      'issuer': record['tinIssuer'] ?? record["taxIssuer"],
      // 'itemsPurchased': record[OGDataField.businessOpsExpenseCat.name] == "Salary" ? null : jsonEncode(
      //   [
      //     itemsPurchased
      //   ]
      // ),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
