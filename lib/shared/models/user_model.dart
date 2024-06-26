import 'package:kaddep_data_capture/shared/shared.dart';

enum UserType{
  lgaCoordinator,
  wardCoordinator,
  fieldAgent
}

class UserModel{
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String lga;
  String lgaCode;
  String? ward;
  String pictureUrl;
  String status;
  String userType;

  static const String userTypeFieldAgent = "Field Agent";
  static const String userTypeWardCoordinator = "Ward Coordinator";
  static const String userTypeLGACoordinator = "LGA Coordinator";

  UserModel({required this.id, required this.firstName, required this.lastName, required this.phoneNumber, required this.status, required this.lga, required this.lgaCode, this.ward, required this.pictureUrl, required this.userType});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'firstName':firstName,
      'lastName': lastName,
      'lga': lga,
      'lgaCode': lgaCode,
      'ward': ward,
      'phone': phoneNumber,
      'status': status,
      'userType': userType,
      'pictureUrl': pictureUrl,
    };
  }

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
        id: map["id"] ?? map["_id"],
        firstName: map["firstName"],
        lastName: map["lastName"],
        lga: map["lga"],
        lgaCode: map["lgaCode"],
        ward: map["ward"],
        phoneNumber: map["phone"],
        status: map["status"],
        pictureUrl: (map["pictureUrl"]??"").startsWith("http")? (map["pictureUrl"]??"") : ApiConstants.baseUrl + (map["pictureUrl"]??"").toString().replaceFirst("/", ""),
        userType: map["userType"],
    );

  }

  static List<UserModel> fromMapArray(List<dynamic> list){
    return list.map((e) => UserModel.fromMap(e)).toList();
  }

  static UserType userTypeStringToEnum(String typeString){
    switch(typeString){
      case  "LGA Coordinator":
        return UserType.lgaCoordinator;
      case "Ward Coordinator":
        return UserType.wardCoordinator;
      case "Field Agent":
        return UserType.fieldAgent;
      default:
        return UserType.fieldAgent;

    }
  }

}

UserModel sampleUser = UserModel(
    id: '232323',
    firstName: "Musa",
    lastName: "Suleiman",
    phoneNumber: "08012345678",
    userType: "Field Agent",
    lga: "Kaduna North",
    lgaCode: "MKA",
    status: "active",
    ward: "Malali",
    pictureUrl: "",
);

UserModel sampleUser2 = UserModel(
    id: '232324',
    firstName: "Ismail",
    lastName: "Haruna",
    phoneNumber: "08012345679",
    status: "active",
    lgaCode: "MKA",
    pictureUrl: "",
    userType: "Ward Coordinator",
    lga: "Sabon gari",
    ward: "Hanwa",
);