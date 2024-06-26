import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/services.dart';

class SettingsCubit extends Cubit<SettingsState> {
  AppSettings settings = AppSettings();

  SettingsCubit()
      : super(SettingsState()){
    _loadSettings();
  }

  _loadSettings(){
    emit(state.copyWith(captureLga: settings.captureLga, captureLgaCode: settings.captureLgaCode));
  }

  updateCaptureLocation(String lga, String lgaCode){
    settings.captureLga = lga;
    settings.captureLgaCode = lgaCode;
    emit(state.copyWith(captureLga: lga, captureLgaCode: lgaCode));
  }

}

class SettingsState {

  String? captureLga;
  String? captureLgaCode;

  SettingsState({this.captureLga, this.captureLgaCode});

  SettingsState copyWith(
      {String? captureLga, String? captureLgaCode}) {
    return SettingsState(
      captureLga: captureLga ?? this.captureLga,
      captureLgaCode: captureLgaCode ?? this.captureLgaCode,
    );
  }
}
