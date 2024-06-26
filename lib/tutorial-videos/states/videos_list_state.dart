
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class VideosListCubit extends Cubit<VideosListState> {

  VideosListCubit( super.initialState){
    emit(state.copyWith(videoStatuses: Map<String,String>.from(AppStorage().videosStatus) ));
  }

  void updateStatus(String videoId, String status){
    final newStatuses = {...(state.videoStatuses??{}), videoId:status};
    AppStorage().videosStatus = newStatuses;
    emit(state.copyWith(videoStatuses: newStatuses));
  }

}

class VideosListState {
  String? error;
  Map<String,String>? videoStatuses;

  VideosListState({this.error,  this.videoStatuses});

  VideosListState copyWith(
      {String? error, Map<String,String>? videoStatuses}) {
    return VideosListState(
      error: error ?? this.error,
      videoStatuses: videoStatuses ?? this.videoStatuses,
    );
  }

}
