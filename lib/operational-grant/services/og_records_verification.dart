import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class OGDataVerificationService {
  final DioClient _dioClient = DioClient();

  Future<List<OGSyncVerificationModel>> verifyRecordsSync(
      {required List<int> recordIds}) async {
    const endpoint = ApiConstants.postVerifyRecordsSynchronization;
    try {
      final response = await _dioClient.post(
        endpoint,
        data: {'recordIds': recordIds},
      );

      if(response['ok'] == true){
        return OGSyncVerificationModel.fromMapArray(response['data']);
      }else{
       throw response['msg'] ?? response['message'] ?? "An unknown error occurred";
      }
    } catch (e) {
      throw e.toString();
    }
  }


}
