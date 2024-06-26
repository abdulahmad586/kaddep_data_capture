import 'dart:async';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class AuthService {
  final DioClient _dioClient = DioClient();

  Future<UserModel> login(
      {required String phone, required String password}) async {
    const endpoint = ApiConstants.postLogin;
    try {
      // UserModel user = sampleUser;
      final response = await _dioClient.post(
        endpoint,
        data: {
          'phone': phone,
          'password': password,
        },
      );
      UserModel user = UserModel.fromMap(response['user']);
      String? token = response['token'];
      if(token != null){
        AppStorage storage = AppStorage();
        storage.authToken = token;
        _dioClient.initToken(token);
      }
      return user;
    } catch (e) {
      print("Throwing error:$e");
      throw e.toString();
    }
  }

  bool loginExpired(){
    try {
      AppStorage storage = AppStorage();
      String? authToken = storage.authToken;
      if (authToken != null) {
        return false;
        return JwtDecoder.isExpired(authToken);
      }
    }catch(e){
      print(e);
    }
    return true;
  }

  Future<UserModel> registerUser({
    required String userType,
    required String firstName,
    required String lastName,
    required String gender,
    required String phone,
    required String lga,
    required String lgaCode,
    required String ward,
    required String password,
    required String profilePicture,
  }) async {
    const endpoint = ApiConstants.postRegister;
    try {

      var formData = FormData.fromMap({
        'userType': userType,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phone': phone,
        'password': password,
        'lga': lga.capitalizeWords(),
        'lgaCode':lgaCode.toUpperCase(),
        'ward': ward.toUpperCase(),
      });
      formData.files.add(MapEntry(
          'photo',
          MultipartFile.fromFileSync(profilePicture,
              filename: profilePicture.split("/").last)));

      final response = await _dioClient.post(
        endpoint,
        data: formData,
      );
      ApiResponse apiResponse =
      ApiResponse.fromMap(response, dataField: 'user');

      return UserModel.fromMap(apiResponse.data);
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<bool> changePassword(
  //     {required String oldPassword, required String newPassword}) async {
  //   const endpoint = ApiConstants.putChangePassword;
  //   try {
  //     final response = await _dioClient.put(
  //       endpoint,
  //       data: {
  //         'oldPass': oldPassword,
  //         'newPass': newPassword
  //       },
  //     );
  //     ApiResponse apiResponse =
  //     ApiResponse.fromMap(response, dataField: 'data');
  //
  //     return apiResponse.ok ?? false;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

}

AuthService authRepo = AuthService();
