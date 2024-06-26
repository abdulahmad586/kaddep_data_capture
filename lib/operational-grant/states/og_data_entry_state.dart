import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class OGDataEntryCubit extends Cubit<OGDataEntryState> {

  final OGRepository _offlineRepository = OGRepository();
  final WardsRepository _wardsRepository = WardsRepository();
  final BanksRepository _banksRepository = BanksRepository();

  OGDataEntryCubit(super.initialState){
    _init();
  }

  void _init()async{
    if(state.regId ==null){
      await _initialiseDBRecord("",OGDataType.newData);
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

  _initialiseDBRecord(String bvn, OGDataType dataType)async{
    final id = await _offlineRepository.addEmptyRecord(bvn,dataType, "","","");
    emit(state.copyWith(regId: id));
  }

  switchPage(int page)async{
    if(page < 7){
      List<OGDataField> fields=pageOGDataFields[page]??[];

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

  final fieldsRequiringRefresh = [OGDataField.bank, OGDataField.ownerPassportPhotoUrl,OGDataField.businessOpsExpenseCat, OGDataField.itemsPurchased, OGDataField.certPhotoUrl, OGDataField.cacProofDocPhotoUrl, OGDataField.ownerAtBusinessPhotoUrl, OGDataField.idDocPhotoUrl, OGDataField.businessLGA, OGDataField.renumerationPhotoUrl,OGDataField.groupPhotoUrl, OGDataField.businessRegIssuer, OGDataField.taxRegPhotoUrl];

  updateValue(OGDataField key, Object value)async{
    final pageData = <String,Object?>{};
    pageData[key.name] = value;
    if(key == OGDataField.businessLGA){
      final id = state.lgas?.indexWhere((element) => element.toLowerCase() == value.toString().toLowerCase()) ?? -1;
      if(id != -1){
        pageData[OGDataField.businessLGACode.name] = state.lgaCodes?[id] ?? "";
        pageData[OGDataField.businessWard.name] = "";
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
          switch(OGDataField.values.byName(key)){
            case OGDataField.dob:
              value = DateTime.tryParse((value as String)) ??  parseMyDate(value);
              break;
            case OGDataField.itemsPurchased:
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

      final selectedLga = (OGDataEntryState.getPageOGDataField(data, OGDataField.businessLGA) as String?);
      if(fields.contains(OGDataField.businessWard.name) && selectedLga != null){
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
          OGDataField field= OGDataField.values.byName(key);
          switch(field){
            case OGDataField.dob:
              value = (value as DateTime).toIso8601String();
              break;
            default:

          }
          _offlineRepository.updateDataField(state.regId!, key, value);
        }
      });
    }
  }

  fetchData(OGDataField field) async{

    final rawData = await _offlineRepository.getRecordFieldsById(state.regId!, [field.name]);
    return rawData?[field.name];
  }

}

class OGDataEntryState {
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

  OGDataEntryState({this.error, this.lastRefresh, this.tradeTypes, this.page, this.regId, this.loading, this.lgas, this.lgaCodes, this.wards, this.banksList});

  OGDataEntryState copyWith(
      {String? error, int? regId, int? page, DateTime? lastRefresh, List<Map<String,Object?>>? tradeTypes, bool? loading, List<String>? lgas, List<String>? lgaCodes, List<String>? wards, List<String>? banksList}) {
    return OGDataEntryState(
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

  static Object? getPageOGDataField(Map<String, Object?>? pageData, OGDataField key){
    return pageData?[key.name];
  }

  List<String> tradeTypesByCategory(String category) {
    if(tradeTypes == null){
      return <String>[];
    }
    return tradeTypes!.where((element) => element['category'] == category).map((e) => e['trade'] as String).toList();
  }

}

Map<int,List<OGDataField>> pageOGDataFields = {
  1: [
    OGDataField.firstName,
    OGDataField.lastName,
    OGDataField.dob,
    OGDataField.gender,
    OGDataField.phone,
    OGDataField.email,
    OGDataField.homeAddress,
    OGDataField.civilServant,
  ],
  2: [
    OGDataField.ownerPassportPhotoUrl,
    OGDataField.idDocType,
    OGDataField.idDocPhotoUrl,
  ],
  3: [
    OGDataField.businessName,
    OGDataField.yearsInOperation,
    OGDataField.numStaff,
    OGDataField.businessAddress,
    OGDataField.businessWard,
    OGDataField.businessLGA,
    OGDataField.businessLGACode,
    OGDataField.longitude,
    OGDataField.latitude,
    OGDataField.ownerAtBusinessPhotoUrl,
  ],
  4:[
    OGDataField.businessRegCat,
    OGDataField.catType,
    OGDataField.certPhotoUrl,
    OGDataField.cacProofDocPhotoUrl,
    OGDataField.businessRegIssuer,
    OGDataField.businessRegNum,
  ],
  5: [
    OGDataField.bvn,
    OGDataField.businessOpsExpenseCat,
    OGDataField.itemsPurchased,
    // OGDataField.itemsList,
    // OGDataField.salaryRenum,
    OGDataField.renumerationPhotoUrl,
    OGDataField.groupPhotoUrl,
    OGDataField.comment,
    OGDataField.costOfItems,
    OGDataField.bank,
    OGDataField.accountNumber,
    OGDataField.accountName,
  ],
  6: [
    // OGDataField.tax,
    OGDataField.taxId,
    OGDataField.issuer,
    OGDataField.taxRegPhotoUrl,
  ],
};