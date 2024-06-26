import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/shared/connections/connections.dart';
import 'package:sidebarx/sidebarx.dart';

import '../models/models.dart';
import '../services/services.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(super.initialState){
    _init();
  }

  UserModel? get user => state.user;

  void _init(){
    AppStorage storage = AppStorage();
    Map<String,dynamic>? loggedInUser = storage.loggedInUser == null ? null : Map<String, dynamic>.from(storage.loggedInUser!);
    if(loggedInUser !=null && storage.password !=null){
      updateUserData(UserModel.fromMap(loggedInUser));
      updateLoginStatus(true,storage.password!);
      if(storage.authToken !=null){
        DioClient().initToken(storage.authToken!);
      }
      if(authRepo.loginExpired()){
        emit(state.copyWith(user: null, isLoggedIn: false));
      }
    }
  }

  updateUserData(UserModel? user) {
    AppStorage storage = AppStorage();
    storage.loggedInUser = user?.toMap();
    emit(state.copyWith(user: user));
  }

  updateLoginStatus(bool isLoggedIn, String password) {
    AppStorage storage = AppStorage();
    storage.password = password;
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  updateMode(bool isOnlineMode) {
    emit(state.copyWith(isOnlineMode: isOnlineMode));
  }

  toggleFirstTimeLoad(bool isFirstTimeLoad) {
    AppSettings().isFirstTimeLoad = isFirstTimeLoad;
    emit(state.copyWith(isFirstTimeLoad: isFirstTimeLoad));
  }

  logoutUser(BuildContext context) {
    emit(state.copyWith(isLoggedIn: false));
    AppStorage().authToken = null;
    AppStorage().password = null;
    AppStorage().loggedInUser = null;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void updateSidebarController(SidebarXController controller) {
    emit(state.copyWith(sidebarXController: controller));
  }

  void updateSelectedHomePage(int index){
    emit(state.copyWith(homeSelectedScreen:index));
  }

}

class AppState {
  UserModel? user;
  bool? isLoggedIn;
  bool? isOnlineMode;
  int? homeSelectedScreen;
  bool? isFirstTimeLoad;
  SidebarXController? sidebarXController;

  AppState({this.user, this.isLoggedIn, this.homeSelectedScreen, this.isFirstTimeLoad,this.isOnlineMode, this.sidebarXController});

  AppState copyWith({UserModel? user, bool? isLoggedIn, int? homeSelectedScreen, bool?isOnlineMode, bool? isFirstTimeLoad, SidebarXController? sidebarXController}) {
    return AppState(
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isOnlineMode: isOnlineMode ?? this.isOnlineMode,
      isFirstTimeLoad: isFirstTimeLoad ?? this.isFirstTimeLoad,
      sidebarXController: sidebarXController ?? this.sidebarXController,
      homeSelectedScreen: homeSelectedScreen ?? this.homeSelectedScreen,
    );
  }
}
