import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

class BVNLookupCubit extends Cubit<BVNLookupState> {

  final OGRepository _ogRepository = OGRepository();
  final ICTRepository _ictRepository = ICTRepository();
  final OldICTRepository _oldIctRepository = OldICTRepository();
  final OldOGRepository _oldOGRepository = OldOGRepository();
  final WardsRepository _wardsRepository = WardsRepository();

  BVNLookupCubit(super.initialState, String lga){
    _loadWards(lga);
  }

  void _loadWards(String lga)async{
    final wards = await _wardsRepository.getAllWardsInLga(lga.toUpperCase());
    emit(state.copyWith(wards: wards.map((e) => (e['ward'] as String).toUpperCase()).toList()));
  }

  void updateWard(String? ward){
    emit(state.copyWith(ward: ward));
  }

  searchBvn(String bvn) {
    if(state.grantType==GrantType.ict){
      _searchBvnInIct(bvn);
    }else if(state.grantType==GrantType.operational){
      _searchBvnInOG(bvn);
    }
  }
  
  clearSearchResults() {
    emit(state.copyWith(searchResults:[]));
  }

  void updateGrantType(GrantType? value) {
      emit(state.copyWith(grantType: value));
  }

  void updateTabView(int newTab) {
    emit(state.copyWith(tabView: newTab));
  }

  _searchBvnInIct(String bvn)async{
    final records = await _ictRepository.getRecordsByBvnWithFields(bvn,MiniICTGrantSchema.dataFields.map((e) => e.name).toList());
    if(records.isEmpty){
      final recordsInOldRepo = await _oldIctRepository.getRecordsByBvnWithFields(bvn, MiniICTGrantSchema.dataFieldsFromOld.map((e) => e.name).toList());
      emit(state.copyWith(searchResults: recordsInOldRepo));
    }else{
      emit(state.copyWith(searchResults: records));
    }
  }
  
  _searchBvnInOG(String bvn)async{
    final records = await _ogRepository.getRecordsByBvnWithFields(bvn,MiniOperationalGrantSchema.dataFields.map((e) => e.name).toList());
    if(records.isEmpty){
      final recordsInOldRepo = await _oldOGRepository.getRecordsByBvnWithFields(bvn, MiniOperationalGrantSchema.dataFieldsFromOld.map((e) => e.name).toList());
      emit(state.copyWith(searchResults: recordsInOldRepo));
    }else{
      emit(state.copyWith(searchResults: records));
    }
  }

  updateLGAAndWard(int id, String lga, String lgaCode, String ward)async{
    await Future.wait([
      _ogRepository.updateDataField(id, OGDataField.businessLGA.name, lga),
      _ogRepository.updateDataField(id, OGDataField.businessLGACode.name, lgaCode),
      _ogRepository.updateDataField(id, OGDataField.businessWard.name, ward),
    ]);
  }

  Future<int> addNewRecord(String bvn, String lga, String lgaCode, String ward) async{
    final id = await _ogRepository.addEmptyRecord(bvn,OGDataType.newData, lga, lgaCode, ward);
    return id;
  }
  
  

}

enum GrantType{
  ict,
  operational,
}

class BVNLookupState {
  bool? searching;
  String? error;
  GrantType? grantType;
  String? ward;
  List<String>? wards;
  int? tabView;
  List<Object>? searchResults;

  BVNLookupState({this.error, this.ward, this.wards, this.tabView, this.grantType, this.searching, this.searchResults});

  BVNLookupState copyWith(
      {String? error, int? tabView, GrantType? grantType, List<String>? wards, String? ward,  List<Object>? searchResults, bool? searching}) {
    return BVNLookupState(
      error: error ?? this.error,
      tabView: tabView ?? this.tabView,
      searching: searching ?? this.searching,
      grantType: grantType ?? this.grantType,
      searchResults: searchResults ?? this.searchResults,
      wards: wards ?? this.wards,
      ward: ward ?? this.ward,
    );
  }

}
