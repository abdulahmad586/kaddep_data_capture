
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class ICTDataSyncCubit extends Cubit<ICTDataSyncState> {

  final int regId;
  final ICTDataEntryService _dataEntryService = ICTDataEntryService();
  final ICTRepository _offlineRepository = ICTRepository();
  ICTDataSyncCubit(this.regId, super.initialState){
    _init();
  }

  void _init()async{
    final data = await _offlineRepository.getRecordById(regId);
    if(data!=null){
      emit(state.copyWith(data: data, statusText: "Press the button below to publish this record"));
    }
  }

  void syncRecord(String userId, Function() onSuccess) async{

    try {
      if(state.synced??false) throw "Record is already synced";
      emit(state.copyWith(syncing: true, statusText: "Syncing record to the server", error: ""));
      await _dataEntryService.syncData(model: state.data!, userId: userId, onSendProgress:syncProgressListener);
      await _offlineRepository.updateStatusSynched(regId);
      emit(state.copyWith(syncing: false, statusText: "Record synced!", error: "", synced: true));
      Future.delayed(const Duration(milliseconds: 500), onSuccess);
    }catch(e){
      emit(state.copyWith(syncing: false,
          statusText: "",
          error: e.toString(),
          synced: false));
    }
  }


  void syncProgressListener(int done, int total){
    emit(state.copyWith(syncProgress: total == 0?0:done/total));
  }

}

class ICTDataSyncState {
  String? error;
  String? statusText;
  bool? syncing;
  bool? synced;
  double? syncProgress;
  ICTGrantSchema? data;

  ICTDataSyncState({this.error,  this.syncing, this.synced, this.syncProgress, this.data, this.statusText});

  ICTDataSyncState copyWith(
      {String? error, bool? syncing, bool? synced, ICTGrantSchema? data, double? syncProgress, String? statusText}) {
    return ICTDataSyncState(
      error: error ?? this.error,
      syncing: syncing ?? this.syncing,
      synced: synced ?? this.synced,
      data: data ?? this.data,
      statusText: statusText ?? this.statusText,
      syncProgress: syncProgress ?? this.syncProgress,
    );
  }

}
