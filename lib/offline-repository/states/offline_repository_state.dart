
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class OfflineRepositoryCubit extends Cubit<OfflineRepositoryState> {

  OldOGRepository repository = OldOGRepository();

  OfflineRepositoryCubit(super.initialState){
    _init();
  }

  void _init()async{
    try {
      final allRecords = await repository.countAllRecords();
      emit(state.copyWith(ogNumRecords: allRecords));
    }catch(e){
      debugPrint(e.toString());
    }
  }

}

class OfflineRepositoryState {
  String? error;
  int? ogNumRecords;
  int? ictNumRecords;

  OfflineRepositoryState({this.error, this.ogNumRecords, this.ictNumRecords});

  OfflineRepositoryState copyWith(
      {String? error, int? ogNumRecords, int? ictNumRecords}) {
    return OfflineRepositoryState(
      error: error ?? this.error,
      ogNumRecords: ogNumRecords ?? this.ogNumRecords,
      ictNumRecords: ictNumRecords ?? this.ictNumRecords,
    );
  }

}
