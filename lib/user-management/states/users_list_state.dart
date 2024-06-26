
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/user-management/user-management.dart';

class UsersListCubit extends Cubit<UsersListState> {

  UserService userService = UserService();

  UsersListCubit( super.initialState){
    loadData();
  }

  void loadData()async{
    try{
      emit(state.copyWith(loading: true, error: ""));
      final users = await userService.getUsers(userType: "userType");
      emit(state.copyWith(loading: false, users: users));
    }catch(e){
      emit(state.copyWith(loading:false, error:e.toString()));
    }
  }


}

class UsersListState {
  String? error;
  bool? loading;
  List<UserModel>? users;

  UsersListState({this.error, this.users, this.loading});

  UsersListState copyWith(
      {String? error, List<UserModel>? users, bool? loading}) {
    return UsersListState(
      error: error ?? this.error,
      users: users ?? this.users,
      loading: loading ?? this.loading,
    );
  }

}
