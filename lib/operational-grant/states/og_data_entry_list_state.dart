import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class OGDataEntryListCubit extends Cubit<OGDataEntryListState> {
  final OGRepository _offlineRepository = OGRepository();
  final OGDataEntryService _dataEntryService = OGDataEntryService();

  OGDataEntryListCubit()
      : super(OGDataEntryListState(page: 1, limit: 150, list: [], error: null, view: DataEntryListView.unpublished, loading: false)){
    loadSyncStats().then((value) => loadData(refresh:true));
    loadUnfinished();
  }

  Future<void> loadSyncStats()async{
    try{
      emit(state.copyWith(unsyncedDataCount: await _offlineRepository.countUnSyncedRecords(), syncedDataCount: await _offlineRepository.countSyncedRecords()));
    }catch(e){
      print("Error loading sync stats: $e");
    }
  }

  Future<void> loadUnfinished()async{
    try {
      await _offlineRepository.getUnfinishedRecords().then((value) =>
          emit(state.copyWith(unfinishedRecords: value)));
    }catch(e){
      print("Error loading unfinished stats: $e");
    }
    }

  Future<void> refreshAll()async{
    try {
      loadData(refresh: true);
      Future.delayed(const Duration(seconds: 1), (){
        loadSyncStats();
        loadUnfinished();
      });
    }catch(e){
      print("Error refreshing all: $e");
    }
  }

  void clearSyncError(){
    emit(state.copyWith(syncError: ""));
  }

  startSyncing(String userId)async {
    if(state.syncing??false) return;
    emit(state.copyWith(syncing: true, syncedDataCount: 0, syncError: ""));
    while(await _offlineRepository.countUnSyncedRecords() > 0){
      try{
        List<OperationalGrantSchema> models = await _offlineRepository.getUnsyncedRecords(page: 1, limit:1);
        if(models.isNotEmpty){
          await syncData(models.first, userId);
          await _offlineRepository.updateStatusSynched(models.first.rid!);
          emit(state.copyWith(syncedDataCount: (state.syncedDataCount??0)+1));
        }else{
          emit(state.copyWith(syncing: false, syncError: "", page: 1));
          loadSyncStats().then((value) => loadData(refresh:true));
          break;
        }
      }catch(e){
        emit(state.copyWith(syncError: e.toString(), syncing: false));
        print(e);
        break;
      }
    }
    loadSyncStats().then((value) => loadData(refresh:true));
  }

  startSyncVerification()async {
    // if(state.syncing??false) return;
    // emit(state.copyWith(syncing: true, syncedDataCount: 0, syncError: ""));
    // while(await _offlineRepository.countUnSyncedRecords() > 0){
    //   try{
    //     List<OperationalGrantSchema> models = await _offlineRepository.getUnsyncedRecords(page: 1, limit:1);
    //     if(models.isNotEmpty){
    //       await syncData(models.first);
    //       await _offlineRepository.updateStatusSynched(models.first.rid!);
    //       emit(state.copyWith(syncedDataCount: (state.syncedDataCount??0)+1));
    //     }else{
    //       emit(state.copyWith(syncing: false, syncError: "", page: 1));
    //       loadSyncStats().then((value) => loadData(refresh:true));
    //       break;
    //     }
    //   }catch(e){
    //     emit(state.copyWith(syncError: e.toString(), syncing: false));
    //     break;
    //   }
    // }
    // emit(state.copyWith(syncing: false, syncError: "", page: 1));
    // loadSyncStats().then((value) => loadData(refresh:true));
  }

  void loadData({bool refresh=false})async{

    try{
      print("LOADING DATA ");
      emit(state.copyWith(loading: true, error: "", page: refresh ? 1 : state.page));
      var list = <MiniOperationalGrantSchema>[];
      switch(state.view){
        case DataEntryListView.published:
          list = await _offlineRepository.getSyncedMiniRecords(page: refresh ? state.page! : state.page!+1, limit: state.limit!);
          break;
        case DataEntryListView.unpublished:
          list = await _offlineRepository.getUnsyncedMiniRecords(page: refresh ? state.page! : state.page!+1, limit: state.limit!);
          break;
        default:
          break;
      }

      if(refresh){
        emit(state.copyWith(loading: false, error: "", list: list));
        print("FINISHED LOADING DATA 1");
      }else{
        emit(state.copyWith(loading: false, error: "", list: [...(state.list ??[]), ...list], page: state.page!+1));
        print("FINISHED LOADING DATA 2 ");
      }
    }catch(e){
      emit(state.copyWith(error: e.toString(), loading: false));
      print("Error loading data! $e");
    }

  }



  void deleteItem(int index)async{
    int rid = state.list![index].rid;
    if(await _offlineRepository.deleteRecord(rid)){
      final newList = state.list!.where((element) => element.rid != rid).toList();
      emit(state.copyWith(list: newList));
    }
  }

  Future<OperationalGrantSchema> syncData(OperationalGrantSchema model, String userId)async{
    return await _dataEntryService.syncData(model: model, userId: userId, onSendProgress: (int progress, int total){
      emit(state.copyWith(itemSyncProgress: total == 0 ? 0 : progress/total));
    });
  }

  Future<List<dynamic>> verifySyncOfRecords()async{

    return [];
  }

  void switchView(DataEntryListView view){
    emit(state.copyWith(view: view, page: 1));
    Future.delayed(const Duration(milliseconds: 200),()=>loadData(refresh: true));
  }

  Future<bool> deleteRecordById(int id) async{
    final result = await _offlineRepository.deleteRecord(id);
    loadUnfinished();
    return result;
  }

  void test() {
    // _offlineRepository.getUnfinishedRecords().then((value) => print(value.le));
  }

}

class OGDataEntryListState {

  DataEntryListView? view;
  List<MiniOperationalGrantSchema>? list;
  List<Map<String,Object?>>? unfinishedRecords;
  String? error;
  String? syncError;
  bool? loading;
  int? page;
  int? limit;

  bool? syncing = false;
  int? unsyncedDataCount = 0;
  int? syncedDataCount = 0;
  double? itemSyncProgress;

  OGDataEntryListState({
    this.view,
    this.list,
    this.unfinishedRecords,
    this.error,
    this.syncError,
    this.loading,
    this.page,
    this.limit,
    this.unsyncedDataCount,
    this.syncedDataCount,
    this.itemSyncProgress,
    this.syncing,
  });

  OGDataEntryListState copyWith({DataEntryListView? view, List<MiniOperationalGrantSchema>? list, List<Map<String,Object?>>? unfinishedRecords, String? syncError, bool? syncing, int? unsyncedDataCount, int? syncedDataCount, String? error, bool? loading, int? page, int? limit, double? itemSyncProgress}) {
    return OGDataEntryListState(
      view: view ?? this.view,
      list: list ?? this.list,
      unfinishedRecords: unfinishedRecords ?? this.unfinishedRecords,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      page:  page ?? this.page,
      limit: limit ?? this.limit,
      syncing: syncing ?? this.syncing,
      syncError: syncError ?? this.syncError,
      unsyncedDataCount: unsyncedDataCount ?? this.unsyncedDataCount,
      syncedDataCount: syncedDataCount ?? this.syncedDataCount,
      itemSyncProgress: itemSyncProgress ?? this.itemSyncProgress,
    );
  }
}

enum DataEntryListView{
  published,
  unpublished
}
