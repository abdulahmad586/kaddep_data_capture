import 'dart:async';
import 'package:kaddep_data_capture/shared/shared.dart';

class UserService {
  final DioClient _dioClient = DioClient();

  Future<List<UserModel>> getUsers(
      {required String userType}) async {
    const endpoint = ApiConstants.getUsers;
    try {
      final response = await _dioClient.get(
        endpoint,
      );
      if(response["ok"]) {
        List<UserModel> users = UserModel.fromMapArray(response['users']);
        return users;
      }else{
        throw response["message"] ?? response["msg"] ?? "An unknown error occurred";
      }
    } catch (e) {
      print("Throwing error:$e");
      throw e.toString();
    }
  }

}