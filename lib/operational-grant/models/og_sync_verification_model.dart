class OGSyncVerificationModel{
  final int id;
  final bool verified;
  final String? message;

  const OGSyncVerificationModel({required this.id, required this.verified, this.message});

  factory OGSyncVerificationModel.fromMap(Map<String,dynamic> map){
    return OGSyncVerificationModel(id: map['id'], verified: map['verified'], message: map['message']);
  }

  static List<OGSyncVerificationModel> fromMapArray(List<dynamic> list){
    return list.map((e) => OGSyncVerificationModel.fromMap(e)).toList();
  }

}