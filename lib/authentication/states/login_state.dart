import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/authentication/services/authentication_service.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(super.initialState);

  void updatePhone(String value){
    emit(state.copyWith(phone: value));
  }

  void updatePassword(String value){
    emit(state.copyWith(password: value));
  }

  void updatePasswordVisible(bool value){
    emit(state.copyWith(passwordVisible: value));
  }


  signIn(Function(UserModel) onLoggedIn) async {
    try {
      emit(state.copyWith(loading: true, error: ""));

      final loginResponse = await authRepo.login(phone:state.phone!, password: state.password!);
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(loading: false, error: ""));
      onLoggedIn(loginResponse);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  forgotPassword(String email) async {
    try {
      // await authRepo.resetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }
}

class LoginState {
  String? error;
  bool? loading;
  bool? passwordVisible;

  String? phone;
  String? password;

  LoginState(
      {this.error,
      this.loading,
      this.phone,
      this.password,
      this.passwordVisible});

  LoginState copyWith(
      {String? error,
      bool? loading,
      String? phone,
      String? password,
      bool? passwordVisible}) {
    return LoginState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      passwordVisible: passwordVisible ?? this.passwordVisible,
    );
  }
}
