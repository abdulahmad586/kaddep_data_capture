import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class LocationChangeCubit extends Cubit<LocationChangeState> {

  final OldOGRepository _oldOGRepository = OldOGRepository();
  final OldICTRepository _oldICTRepository = OldICTRepository();
  final OGRepository _oGRepository = OGRepository();
  final ICTRepository _ictRepository = ICTRepository();
  final WardsRepository _wardsRepository = WardsRepository();

  LocationChangeCubit(super.initialState){
    _init();
  }

  void _init(){
    _loadLGAs();
  }

  void _loadOldRecordStats()async{
    final oldRecordsInLGA = await _oldOGRepository.countAllRecordsInLGA(state.selectedLGA??"");
    final oldICTRecordsInLGA = await _oldICTRepository.countAllRecordsInLGA(state.selectedLGA??"");
    emit(state.copyWith(oldOperationalGrants: oldRecordsInLGA, oldIctGrants: oldICTRecordsInLGA));
  }

  // void _loadNewRecordStats()async{
  //   final onboardedOperationalGrants = await _oGRepository.countAllRecordsInLGA(state.selectedLGA??"");
  //   final onboardedICTGrants = await _ictRepository.countAllRecordsInLGA(state.selectedLGA??"");
  //   if(!isClosed){
  //     double operationalGrantProgress =( state.oldOperationalGrants??0 )== 0 ? 0: onboardedOperationalGrants/ (state.oldOperationalGrants!);
  //     double ictGrantProgress =( state.oldIctGrants??0 )== 0 ? 0: onboardedICTGrants/ (state.oldIctGrants!);
  //     emit(state.copyWith(onboardedOperationalGrants: onboardedOperationalGrants, operationalGrantProgress: operationalGrantProgress, ictGrantProgress: ictGrantProgress, onboardedIctGrants: onboardedICTGrants));
  //   }
  // }

  // void startOnboardingRecords(Function() onFinished)async{
  //   if(state.selectedLGA == null) return;
  //   await _oGRepository.deleteAllRecords();
  //   const batchSize = 1;
  //   emit(state.copyWith(updating: true, ictGrantProgress: 0, operationalGrantProgress: 0, onboardingInterrupted: false));
  //   List<Map<String, Object?>> records = await _oldOGRepository.getRecordsWithFields(state.selectedLGA!, oGFieldsFromOldRecords.map((e) => e.name).toList(), lastBvn: "0", limit: batchSize );
  //
  //   while(records.isNotEmpty && !isClosed && !(state.onboardingInterrupted??false)){
  //     String lastBvn = await _onboardRecords(records);
  //     records = await _oldOGRepository.getRecordsWithFields(state.selectedLGA!, oGFieldsFromOldRecords.map((e) => e.name).toList(), lastBvn: lastBvn, limit: batchSize );
  //   }
  //
  //   final totalOnboardedRecords = await _oGRepository.countAllRecordsInLGA(state.selectedLGA!);
  //   if(totalOnboardedRecords == state.oldOperationalGrants){
  //     emit(state.copyWith(updating: false));
  //     onFinished();
  //   }else{
  //     await _oGRepository.deleteAllRecords();
  //     _loadNewRecordStats();
  //     debugPrint("SOMETHING WENT WRONG ONBOARDED: $totalOnboardedRecords | ACTUAL: ${state.oldOperationalGrants}");
  //   }
  //
  // }

  void startOnboardingRecords(Function() onFinished)async{
    if(state.selectedLGA == null) return;
    try{
      await Future.wait([
        _oGRepository.deleteAllRecords(),
        _ictRepository.deleteAllRecords()
      ]);
      emit(state.copyWith(updating: true, ictGrantProgress: 0, operationalGrantProgress: 0, onboardingInterrupted: false));

      await Future.wait([
        _startOnboardingOpGrants(),
        _startOnboardingICTGrants(),
      ]);

      emit(state.copyWith(updating: false));
      onFinished();
    }catch(e){
      interruptOnboarding(true);
      debugPrint("An error occurred $e");
    }

  }

  Future<bool> _startOnboardingOpGrants()async{
    List<Map<String, Object?>> ids = await _oldOGRepository.getRecordsWithFieldsByIds(state.selectedLGA!, [OGDataField.id.name]);
    int totalIds = ids.length;
    int totalOnboarded = 0;
    for(int i=0; i<totalIds; i++){
      final recordData = await _oldOGRepository.getRecordFieldsById(ids[i]["id"] as int, oGFieldsFromOldRecords.map((e) => e.name).toList());
      if(recordData != null){
        await _oGRepository.onboardOldRecord(recordData, oGFieldsForNewRecords);
        totalOnboarded +=1;
      }
      emit(state.copyWith(operationalGrantProgress: i/totalIds, onboardedOperationalGrants: totalOnboarded));
    }
    return true;
  }

  Future<bool> _startOnboardingICTGrants()async{
    List<Map<String, Object?>> ids = await _oldICTRepository.getRecordsWithFieldsByIds(state.selectedLGA!, [ICTDataField.id.name]);
    int totalIds = ids.length;
    int totalOnboarded = 0;
    for(int i=0; i<totalIds; i++){
      final recordData = await _oldICTRepository.getRecordFieldsById(ids[i]["id"] as int, ictFieldsFromOldRecords.map((e) => e.name).toList());
      if(recordData != null){
        await _ictRepository.onboardOldRecord(recordData, ictFieldsForNewRecords);
        totalOnboarded +=1;
      }
      emit(state.copyWith(ictGrantProgress: i/totalIds, onboardedIctGrants: totalOnboarded));
    }
    return true;
  }

  Future<void> interruptOnboarding(bool interrupted) async {
    bool wasUpdating = (state.updating ??false) && !(state.onboardingInterrupted??false);
      emit(state.copyWith(onboardingInterrupted: interrupted));
      if(wasUpdating){
        await Future.wait([
          _oGRepository.deleteAllRecords(),
          _ictRepository.deleteAllRecords()
        ]);
      }

  }

  // Future<String> _onboardRecords(List<Map<String, Object?>> records)async{
  //   await _oGRepository.onboardOldRecords(records, oGFieldsForNewRecords);
  //   String bvn = records.last["bvn"] as String;
  //   _loadNewRecordStats();
  //   return bvn;
  // }

  void _loadLGAs()async{
    final lgas = await _wardsRepository.getAllLGAs();
    emit(state.copyWith(lgas: lgas.map((e) => (e['lga'] as String).capitalize()).toList(), lgaCodes: lgas.map((e) => (e['code'] as String).capitalize()).toList()));
  }

  void ictGrantProgressListener(int done, int total){
    emit(state.copyWith(operationalGrantProgress: total == 0?0:done/total));
  }

  void operationalGrantProgressListener(int done, int total){
    emit(state.copyWith(ictGrantProgress: total == 0?0:done/total));
  }

  updateLGA(String value) {
    String selectedCode = "";
    if(value.isNotEmpty){
      final index = state.lgas?.indexWhere((element) => element.toLowerCase() == value.toLowerCase());
      if(index !=null && index != -1){
        selectedCode = state.lgaCodes![index];
      }
    }
    emit(state.copyWith(selectedLGA:value, selectedLGACode:selectedCode));
    _loadOldRecordStats();
  }

}

class LocationChangeState {
  bool? updating;
  bool? onboardingInterrupted;
  String? error;
  String? statusText;
  String? selectedLGA;
  String? selectedLGACode;
  double? ictGrantProgress;
  double? operationalGrantProgress;

  List<String>? lgas;
  List<String>? lgaCodes;

  int? oldIctGrants;
  int? oldOperationalGrants;

  int? onboardedIctGrants;
  int? onboardedOperationalGrants;

  bool get lgaNotSelected => selectedLGA == null || selectedLGACode == null;

  LocationChangeState({this.error, this.onboardingInterrupted, this.oldIctGrants, this.onboardedIctGrants, this.onboardedOperationalGrants, this.oldOperationalGrants, this.selectedLGA, this.selectedLGACode, this.lgas, this.lgaCodes, this.updating, this.operationalGrantProgress, this.ictGrantProgress, this.statusText});

  LocationChangeState copyWith(
      {String? error, bool? updating, bool? onboardingInterrupted, int? oldIctGrants, int? oldOperationalGrants, int? onboardedIctGrants, int? onboardedOperationalGrants, String? selectedLGA, String? selectedLGACode, List<String>? lgas, List<String>? lgaCodes, double? operationalGrantProgress, double? ictGrantProgress, String? statusText}) {
    return LocationChangeState(
      onboardingInterrupted: onboardingInterrupted ?? this.onboardingInterrupted,
      selectedLGACode: selectedLGACode ?? this.selectedLGACode,
      selectedLGA: selectedLGA ?? this.selectedLGA,
      lgas: lgas ?? this.lgas,
      lgaCodes: lgaCodes ?? this.lgaCodes,
      error: error ?? this.error,
      updating: updating ?? this.updating,
      statusText: statusText ?? this.statusText,
      operationalGrantProgress: operationalGrantProgress ?? this.operationalGrantProgress,
      ictGrantProgress: ictGrantProgress ?? this.ictGrantProgress,
      oldOperationalGrants: oldOperationalGrants ?? this.oldOperationalGrants,
      onboardedOperationalGrants: onboardedOperationalGrants ?? this.onboardedOperationalGrants,
      oldIctGrants: oldIctGrants ?? this.oldIctGrants,
      onboardedIctGrants: onboardedIctGrants ?? this.onboardedIctGrants,
    );
  }

}
