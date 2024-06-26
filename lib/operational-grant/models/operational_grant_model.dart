import 'dart:convert';
import 'dart:typed_data';

import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class MiniOperationalGrantSchema {
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

  const MiniOperationalGrantSchema(
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

  static List<OGDataField> dataFields = [
    OGDataField.rid,
    OGDataField.bvn,
    OGDataField.firstName,
    OGDataField.lastName,
    OGDataField.businessName,
    OGDataField.businessLGA,
    OGDataField.dataType,
    OGDataField.dataComplete,
    OGDataField.syncStatus,
    OGDataField.serverVerified,
    OGDataField.syncErrorMessage,
  ];

  static List<OGDataField> dataFieldsFromOld = [
    OGDataField.id,
    OGDataField.bvn,
    OGDataField.businessLGA,
    OGDataField.firstName,
    OGDataField.lastName,
    OGDataField.businessName,
  ];

  factory MiniOperationalGrantSchema.fromMap(Map<String, Object?> map) {
    return MiniOperationalGrantSchema(
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

  static List<MiniOperationalGrantSchema> fromMapArray(
      List<Map<String, Object?>> list) {
    return list.map((e) => MiniOperationalGrantSchema.fromMap(e)).toList();
  }

  static List<MiniOperationalGrantSchema> fromSchemaArray(
      List<Map<String, Object?>> results) {
    return results.map((e) => MiniOperationalGrantSchema.fromMap(e)).toList();
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

class OperationalGrantSchema {
  // id	firstName	lastName	dob	gender	phone	email	bvn	homeAddress	civilServant
  // businessName	businessAddress	businessLGA businessLGACode businessWard	businessRegCat	businessRegIssuer
  // businessRegNo	yearsInOperation	numStaff	businessOpsExpenseCat	itemPurchased1
  // itemPurchased2	itemPurchased3	costOfItems	accountName	bank	accountNumber
  // tin	tinIssuer longitude latitude dataType syncStatus dataComplete

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
  final String businessOpsExpenseCat;
  final List<ItemsPurchased> itemsPurchased;
  final String itemPurchased1;
  final String itemPurchased2;
  final String itemPurchased3;
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

  OperationalGrantSchema({
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
    required this.businessOpsExpenseCat,
    required this.itemPurchased1,
    required this.itemPurchased2,
    required this.itemPurchased3,
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
      // 'nin': nin,
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
      'businessOpsExpenseCat': businessOpsExpenseCat,
      'itemPurchased1': itemPurchased1,
      'itemPurchased2': itemPurchased2,
      'itemPurchased3': itemPurchased3,
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

  static Future<OperationalGrantSchema> fromMap(
      Map<String, dynamic> map) async {
    return OperationalGrantSchema(
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
      businessOpsExpenseCat: map['businessOpsExpenseCat'],
      itemsPurchased: map['itemsPurchased'] == null
          ? []
          : (await ItemsPurchased.fromSchemaArray(
              jsonDecode(map['itemsPurchased']))),
      itemPurchased1: map['itemPurchased1'] ?? "",
      itemPurchased2: map['itemPurchased2'] ?? "",
      itemPurchased3: map['itemPurchased3'] ?? "",
      costOfItems: map['costOfItems'] != null && (int.tryParse(map['costOfItems'].toString().replaceAll(",","")) != null && int.tryParse(map['costOfItems'].toString().replaceAll(",",""))!   >= 0) ? int.parse(map['costOfItems'].toString().replaceAll(",","")) : 0,
      bank: map['bank'],
      accountNumber: map['accountNumber'],
      accountName: map['accountName'],
      taxId: map['tin'] ?? map['taxId'] ?? "",
      issuer: map['tinIssuer'] ?? map['issuer'] ?? "",
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
      'email': email ?? "",
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
      'businessOpsExpenseCat': businessOpsExpenseCat,
      'itemsPurchased': businessOpsExpenseCat != "Salary"
          ? await ItemsPurchased.toMapArray(itemsPurchased)
          : null,
      'salaryRenum': businessOpsExpenseCat == "Salary"
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

  static Future<List<OperationalGrantSchema>> fromMapArray(
      List<Map<String, Object?>> results) async {
    List<OperationalGrantSchema> listResult = [];
    for (var item in results) {
      listResult.add(await OperationalGrantSchema.fromMap(item));
    }
    return listResult;
  }

  static Map<String, Object?> convertOldRecordToNew(
      Map<String, Object?> record) {
    return {
      ...record,
      'businessRegNum': record['businessRegNo'],
      'phoneNumber': record['phone'],
      'address': record['homeAddress'],
      'isCivilServant': (record['civilServant'] == "Yes" ||
              record['civilServant'] == "1" ||
              record['civilServant'] == true)
          ? "1"
          : "0",
      'businessLGACode': '',
      'catType': record['catType'] ?? record['businessRegCat'],
      'taxId': record['tin'],
      'issuer': record['tinIssuer'],
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
