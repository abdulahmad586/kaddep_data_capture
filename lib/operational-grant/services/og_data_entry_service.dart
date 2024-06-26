import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class OGDataEntryService {
  final DioClient _dioClient = DioClient();

  Future<OperationalGrantSchema> syncData(
      {required OperationalGrantSchema model, required String userId, Function(int, int)? onSendProgress}) async {
    const endpoint = ApiConstants.postUploadOpsGrant;
    try {

      final mapWithBase64 = await model.toMapForSync();
      mapWithBase64.addAll({'capturedBy': userId});

      // mapWithBase64.forEach((key, value) {
      //   print("$key ====> $value");
      // });

      FormData formData = FormData.fromMap(mapWithBase64);
      final response = await _dioClient.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress ?? (int current, int total){
          // print("SENDING $current/$total");
        }
      );

      if(response['ok'] == true){
        return model;
      }else{
       throw response['msg'] ?? "An unknown error occurred";
      }
    } catch (e) {
      print("Throwing error:$e");
      throw e.toString();
    }
  }


}
