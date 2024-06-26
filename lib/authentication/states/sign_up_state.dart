import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/shared/models/models.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class SignupCubit extends Cubit<SignupState> {

  final WardsRepository _wardsRepository = WardsRepository();
  final AuthService authService = AuthService();

  SignupCubit(super.initialState){
    _init();
  }

  void _init(){
    _loadLGAs();
  }

  void _loadLGAs()async{
    final lgas = await _wardsRepository.getAllLGAs();
    emit(state.copyWith(lgas: lgas.map((e) => (e['lga'] as String).capitalize()).toList(),lgaCodes: lgas.map((e) => e['code'] as String).toList()));
  }

  void _loadWards(String lga)async{
    final wards = await _wardsRepository.getAllWardsInLga(lga.toUpperCase());
    emit(state.copyWith(wards: wards.map((e) => (e['ward'] as String).capitalize()).toList()));
  }

  updatePasswordVisible(bool visible){
    emit(state.copyWith(passwordVisible: visible));
  }

  updateFirstName(String firstName){
    emit(state.copyWith(firstName: firstName));
  }

  updateLastName(String value){
    emit(state.copyWith(lastName: value));
  }

  updateGender(String value){
    emit(state.copyWith(gender: value));
  }

  updatePhoneNumber(String value){
    emit(state.copyWith(phoneNumber: value));
  }

  updateAddress(String value){
    emit(state.copyWith(address: value));
  }

  updateLga(String value){
    emit(state.copyWith(lga: value));
    final id = state.lgas?.indexWhere((element) => element.toLowerCase() == value.toString().toLowerCase()) ?? -1;
    if(id != -1){
      String lgaCode = state.lgaCodes?[id] ?? "";
      emit(state.copyWith(wards: [],lga:value, lgaCode: lgaCode));
    }
    _loadWards(value);
  }

  updateLgaCode(String value){
    emit(state.copyWith(lgaCode: value));
  }

  updateWard(String ward){
    emit(state.copyWith(ward: ward));
  }

  updatePassword(String value){
    emit(state.copyWith(password: value));
  }

  updateProfilePicture(String value){
    emit(state.copyWith(profilePicture: value));
  }

  updateUserType(String value){
    emit(state.copyWith(userType: value));
  }

  signUp(Function(UserModel) onSignup)async {
    try {
      emit(state.copyWith(loading: true, error: ""));

      final registeredUser = await authService.registerUser(userType: state.userType!, lgaCode: state.lgaCode!, password:state.password!, firstName: state.firstName!, lastName: state.lastName!, gender: state.gender!, phone: state.phoneNumber!, lga: state.lga!, ward:state.ward ?? "", profilePicture: state.profilePicture!);
      emit(state.copyWith(loading: false, error: ""));
      onSignup(registeredUser);
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }


}

class SignupState {
  String? error;
  bool? loading;
  bool? passwordVisible;

  String? firstName;
  String? lastName;
  String? gender;
  String? phoneNumber;
  String? address;
  String? password;
  String? lga;
  String? lgaCode;
  String? ward;
  String? profilePicture;
  String? userType;

  List<String>? lgas;
  List<String>? lgaCodes;
  List<String>? wards;

  SignupState({this.error, this.loading, this.passwordVisible, this.lgas, this.lgaCodes, this.wards, this.lgaCode, this.firstName, this.password, this.lastName, this.gender, this.phoneNumber, this.address, this.lga, this.ward, this.profilePicture, this.userType});

  SignupState copyWith(
      {String? error, bool? loading, bool? passwordVisible, String? firstName, String? lastName, String? password, String? gender, String? phoneNumber, String? address, String? lga, String? lgaCode, String? ward, String? profilePicture, String? userType, List<String>? lgas,List<String>? lgaCodes, List<String>? wards}) {
    return SignupState(
        error: error ?? this.error,
        loading: loading ?? this.loading,
        passwordVisible: passwordVisible ?? this.passwordVisible,
        firstName: firstName ?? this.firstName,
        lastName: lastName?? this.lastName,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        lga: lga ?? this.lga,
        lgas: lgas ?? this.lgas,
        wards: wards ?? this.wards,
        lgaCode: lgaCode ?? this.lgaCode,
        lgaCodes: lgaCodes ?? this.lgaCodes,
        ward: ward ?? this.ward,
        profilePicture: profilePicture ?? this.profilePicture,
        userType: userType ?? this.userType,
        password: password ?? this.password
    );
  }
}
