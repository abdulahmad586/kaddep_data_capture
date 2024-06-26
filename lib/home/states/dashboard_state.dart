import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';

class DashboardCubit extends Cubit<DashboardState> {

  final OGRepository _oGRepository = OGRepository();
  final ICTRepository _ictRepository = ICTRepository();

  DashboardCubit(String lga, super.initialState){
    Future.delayed(const Duration(seconds: 3),(){
      loadStats(lga);
    });
  }

  void loadStats(String lga)async{
    final existingOgGrants = await _oGRepository.countExistingRecordsInLGA(lga);
    final newOgGrants = await _oGRepository.countNewRecordsInLGA(lga);
    final updatedOgGrants = await _oGRepository.countUpdatedRecordsInLGA(lga);
    final syncedOgGrants = await _oGRepository.countSyncedRecordsInLGA(lga);

    final existingICTGrants = await _ictRepository.countExistingRecordsInLGA(lga);
    final newICTGrants = await _ictRepository.countNewRecordsInLGA(lga);
    final updatedICTGrants = await _ictRepository.countUpdatedRecordsInLGA(lga);
    final syncedICTGrants = await _ictRepository.countSyncedRecordsInLGA(lga);

    emit(state.copyWith( existingIctGrants: existingICTGrants, newIctGrants: newICTGrants, updatedIctGrants: updatedICTGrants, syncedIctGrants: syncedICTGrants, newOgGrants: newOgGrants, existingOgGrants: existingOgGrants, updatedOfGrants: updatedOgGrants, syncedOgGrants: syncedOgGrants));
  }

}

class DashboardState {
  int? newIctGrants;
  int? existingIctGrants;
  int? updatedIctGrants;
  int? syncedIctGrants;

  int? newOgGrants;
  int? existingOgGrants;
  int? updatedOfGrants;
  int? syncedOgGrants;

  DashboardState({this.newIctGrants, this.existingIctGrants, this.updatedIctGrants, this.syncedIctGrants,
    this.newOgGrants, this.existingOgGrants, this.updatedOfGrants, this.syncedOgGrants});

  DashboardState copyWith(
      {int? newIctGrants, int? existingIctGrants, int? updatedIctGrants, int? syncedIctGrants, int? newOgGrants, int? existingOgGrants, int? updatedOfGrants, int? syncedOgGrants}) {
    return DashboardState(
      newIctGrants: newIctGrants ?? this.newIctGrants,
      existingIctGrants: existingIctGrants ?? this.existingIctGrants,
      updatedIctGrants: updatedIctGrants ?? this.updatedIctGrants,
      syncedIctGrants: syncedIctGrants ?? this.syncedIctGrants,
      newOgGrants: newOgGrants ?? this.newOgGrants,
      existingOgGrants: existingOgGrants ?? this.existingOgGrants,
      updatedOfGrants: updatedOfGrants ?? this.updatedOfGrants,
      syncedOgGrants: syncedOgGrants ?? this.syncedOgGrants,
    );
  }

}
