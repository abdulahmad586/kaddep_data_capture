import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class ICTDataEntryCubit extends Cubit<ICTDataEntryState> {

  final ICTRepository _offlineRepository = ICTRepository();
  final WardsRepository _wardsRepository = WardsRepository();
  final BanksRepository _banksRepository = BanksRepository();

  ICTDataEntryCubit(super.initialState){
    _init();
  }

  void _init()async{
    if(state.regId ==null){
      await _initialiseDBRecord("",ICTDataType.newData);
    }else{
      await _offlineRepository.checkCompletion(state.regId!, updateCompletionField: true);
    }
    _loadBanks();
    _loadLGAs();
    switchPage(state.page??0);
  }

  Future<void> onEnd()async{
    await _offlineRepository.checkCompletion(state.regId!, updateCompletionField: true);
  }

  void _loadBanks()async{
    List<Map<String,Object?>> banksList = await _banksRepository.getAllBanks();
    emit(state.copyWith(banksList: banksList.map((e) => e['name'] as String).toList()));
  }

  void _loadLGAs()async{
    final lgas = await _wardsRepository.getAllLGAs();
    emit(state.copyWith(lgas: lgas.map((e) => (e['lga'] as String).capitalize()).toList(),lgaCodes: lgas.map((e) => e['code'] as String).toList()));
  }

  void _loadWards(String lga)async{
    final wards = await _wardsRepository.getAllWardsInLga(lga.toUpperCase());
    emit(state.copyWith(wards: wards.map((e) => (e['ward'] as String).capitalize()).toList()));
  }

  Future<List<String>> loadWards(String lga)async{
    final wards = await _wardsRepository.getAllWardsInLga(lga.toUpperCase());
    return wards.map((e) => (e['ward'] as String).capitalize()).toList();
  }

  _initialiseDBRecord(String bvn, ICTDataType dataType)async{
    final id = await _offlineRepository.addEmptyRecord(bvn,dataType, "","","");
    emit(state.copyWith(regId: id));
  }

  switchPage(int page)async{
    if(page < 7){
      List<ICTDataField> fields=pageOGDataFields[page]??[];

      final result = await fetchPageDataFromDb(fields.map((e) => e.name).toList());
      return result;
    }else{
      await _offlineRepository.updateCompletionStatus(state.regId!, true);
      return {'done':true, 'id': state.regId};
    }
  }

  void prevPage(){
    final currentPage = (state.page??1);
    if(currentPage >1){
      emit(state.copyWith(page: currentPage-1));
    }
  }

  void nextPage(int maxPages){
    final currentPage = (state.page??1);
    if(currentPage < maxPages){
      emit(state.copyWith(page: currentPage+1));
    }
  }

  final fieldsRequiringRefresh = [ICTDataField.bank, ICTDataField.ownerPassportPhotoUrl,ICTDataField.ictProcCat, ICTDataField.itemsPurchased, ICTDataField.certPhotoUrl, ICTDataField.cacProofDocPhotoUrl, ICTDataField.ownerAtBusinessPhotoUrl, ICTDataField.idDocPhotoUrl, ICTDataField.businessLGA, ICTDataField.renumerationPhotoUrl,ICTDataField.groupPhotoUrl, ICTDataField.businessRegIssuer, ICTDataField.taxRegPhotoUrl];

  updateValue(ICTDataField key, Object value)async{
    final pageData = <String,Object?>{};
    pageData[key.name] = value;
    if(key == ICTDataField.businessLGA){
      final id = state.lgas?.indexWhere((element) => element.toLowerCase() == value.toString().toLowerCase()) ?? -1;
      if(id != -1){
        pageData[ICTDataField.businessLGACode.name] = state.lgaCodes?[id] ?? "";
        pageData[ICTDataField.businessWard.name] = "";
        emit(state.copyWith(wards: []));
      }
      _loadWards(value as String);
    }

    await _savePageDataToDb(pageData);

    if(fieldsRequiringRefresh.contains(key)){
      refreshPage();
    }
  }

  refreshPage(){
    emit(state.copyWith(lastRefresh: DateTime.now()));
  }

  Future<Map<String,Object?>> fetchPageDataFromDb(List<String> fields)async{
    if(state.regId !=null && fields.isNotEmpty){
      final otherTableResults = <String,Object?>{};

      final rawData = await _offlineRepository.getRecordFieldsById(state.regId!, fields);
      Map<String,Object?> data = {...otherTableResults};
      rawData?.forEach((key, value)async {
        if(value !=null){
          switch(ICTDataField.values.byName(key)){
            case ICTDataField.dob:
              value = DateTime.tryParse((value as String)) ??  parseMyDate(value);
              break;
            case ICTDataField.itemsPurchased:
              final itemsPurchasedJson = value as String?;
              List<ItemsPurchased> items = [];
              if(itemsPurchasedJson !=null){
                items = await ItemsPurchased.fromSchemaArray(jsonDecode(itemsPurchasedJson));
              }
              value = items;
              break;
            default:
          }
        }
        data[key] = value;
      });

      final selectedLga = (ICTDataEntryState.getPageICTDataField(data, ICTDataField.businessLGA) as String?);
      if(fields.contains(ICTDataField.businessWard.name) && selectedLga != null){
        data["wardsList"] = await loadWards(selectedLga);
      }

      return data;
    }
    return {};
  }

  _savePageDataToDb(Map<String,Object?> pageData){
    if(state.regId!=null){
      pageData.forEach((key, value) {
        if(value !=null){
          ICTDataField field= ICTDataField.values.byName(key);
          switch(field){
            case ICTDataField.dob:
              value = (value as DateTime).toIso8601String();
              break;
            default:

          }
          _offlineRepository.updateDataField(state.regId!, key, value);
        }
      });
    }
  }

  fetchData(ICTDataField field) async{

    final rawData = await _offlineRepository.getRecordFieldsById(state.regId!, [field.name]);
    return rawData?[field.name];
  }

}

class ICTDataEntryState {
  String? error;
  int? regId;
  int? page;
  DateTime? lastRefresh;
  bool? loading;
  List<Map<String,Object?>>? tradeTypes;
  List<String>? banksList;
  List<String>? lgas;
  List<String>? lgaCodes;
  List<String>? wards;

  ICTDataEntryState({this.error, this.lastRefresh, this.tradeTypes, this.page, this.regId, this.loading, this.lgas, this.lgaCodes, this.wards, this.banksList});

  ICTDataEntryState copyWith(
      {String? error, int? regId, int? page, DateTime? lastRefresh, List<Map<String,Object?>>? tradeTypes, bool? loading, List<String>? lgas, List<String>? lgaCodes, List<String>? wards, List<String>? banksList}) {
    return ICTDataEntryState(
      error: error ?? this.error,
      page: page ?? this.page,
      regId: regId ?? this.regId,
      loading: loading ?? this.loading,
      lgas: lgas ?? this.lgas,
      lgaCodes: lgaCodes ?? this.lgaCodes,
      wards: wards ?? this.wards,
      banksList: banksList ?? this.banksList,
      tradeTypes: tradeTypes ?? this.tradeTypes,
      lastRefresh: lastRefresh ?? this.lastRefresh,
    );
  }

  static Object? getPageICTDataField(Map<String, Object?>? pageData, ICTDataField key){
    return pageData?[key.name];
  }

  List<String> tradeTypesByCategory(String category) {
    if(tradeTypes == null){
      return <String>[];
    }
    return tradeTypes!.where((element) => element['category'] == category).map((e) => e['trade'] as String).toList();
  }

}

Map<int,List<ICTDataField>> pageOGDataFields = {
  1: [
    ICTDataField.firstName,
    ICTDataField.lastName,
    ICTDataField.dob,
    ICTDataField.gender,
    ICTDataField.phone,
    ICTDataField.email,
    ICTDataField.nin,
    ICTDataField.homeAddress,
    ICTDataField.civilServant,
  ],
  2: [
    ICTDataField.ownerPassportPhotoUrl,
    ICTDataField.idDocType,
    ICTDataField.idDocPhotoUrl,
  ],
  3: [
    ICTDataField.businessName,
    ICTDataField.yearsInOperation,
    ICTDataField.numStaff,
    ICTDataField.businessAddress,
    ICTDataField.businessWard,
    ICTDataField.businessLGA,
    ICTDataField.businessLGACode,
    ICTDataField.longitude,
    ICTDataField.latitude,
    ICTDataField.ownerAtBusinessPhotoUrl,
  ],
  4:[
    ICTDataField.businessRegCat,
    ICTDataField.catType,
    ICTDataField.certPhotoUrl,
    ICTDataField.cacProofDocPhotoUrl,
    ICTDataField.businessRegIssuer,
    ICTDataField.businessRegNum,
  ],
  5: [
    ICTDataField.bvn,
    ICTDataField.ictProcCat,
    ICTDataField.itemsPurchased,
    // ICTDataField.itemsList,
    // ICTDataField.salaryRenum,
    ICTDataField.renumerationPhotoUrl,
    ICTDataField.groupPhotoUrl,
    ICTDataField.comment,
    ICTDataField.costOfItems,
    ICTDataField.bank,
    ICTDataField.accountNumber,
    ICTDataField.accountName,
  ],
  6: [
    // ICTDataField.tax,
    ICTDataField.taxId,
    ICTDataField.issuer,
    ICTDataField.taxRegPhotoUrl,
  ],
};