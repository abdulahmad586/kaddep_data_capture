import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class PersonalInformationFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final OGDataEntryState state;
  final GlobalKey<FormState> formKey;

  const PersonalInformationFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

  @override
  Widget build(BuildContext context) {
    int activeStep = (state.page ??1)-1;
    return Form(
      key: formKey,
      child: FutureBuilder(
          future: cubitContext.read<OGDataEntryCubit>().switchPage(activeStep+1),
          builder: (c, snapshot) {
            if(!snapshot.hasData){
              return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
            }

            Object? isCivilServantObj = OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.civilServant);
            int? isCivilServant = isCivilServantObj is String ? ( isCivilServantObj == "Yes" ? 1 : 0) : (isCivilServantObj as int?);

            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "First name",
                  keyboardType: TextInputType.name,
                  initialValue:
                  OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.firstName) as String?,
                  onChange: (s) => cubitContext
                      .read<OGDataEntryCubit>()
                      .updateValue(OGDataField.firstName, s),
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "Last name",
                  keyboardType: TextInputType.name,
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.lastName) as String?,
                  onChange: (s) => cubitContext
                      .read<OGDataEntryCubit>()
                      .updateValue(OGDataField.lastName, s),
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextDateField(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "Date of birth",
                  onChange: (s) =>
                      cubitContext.read<OGDataEntryCubit>().updateValue(OGDataField.dob, s),
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.dob) as DateTime?,
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextDropdown(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "Gender",
                  enableSearch: false,
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.gender),
                  onChanged: (s) => cubitContext
                      .read<OGDataEntryCubit>()
                      .updateValue(OGDataField.gender, (s as DropDownValueModel).name),
                  list: const ["Male", "Female"],
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  validator: (text) => text == null || text.isEmpty
                      ? "Field is required"
                      : (text.length != 11
                      ? "Please enter a valid phone number"
                      : null),
                  labelText: "Phone",
                  keyboardType: TextInputType.phone,
                  onChange: (s) =>
                      cubitContext.read<OGDataEntryCubit>().updateValue(OGDataField.phone, s),
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.phone) as String?,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  labelText: "Email (optional)",
                  keyboardType: TextInputType.emailAddress,
                  onChange: (s) =>
                      cubitContext.read<OGDataEntryCubit>().updateValue(OGDataField.email, s),
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.email) as String?,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  validator: (text) => text == null || text.isEmpty
                      ? "Field is required"
                      : (text.length != 11
                      ? "Please enter a valid NIN"
                      : null),
                  labelText: "NIN",
                  keyboardType: TextInputType.phone,
                  onChange: (s) =>
                      cubitContext.read<OGDataEntryCubit>().updateValue(OGDataField.nin, s),
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.nin) as String?,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextField(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "Home address",
                  minLines: 3,
                  maxLines: 3,
                  keyboardType: TextInputType.streetAddress,
                  initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.homeAddress) as String?,
                  onChange: (s) => cubitContext
                      .read<OGDataEntryCubit>()
                      .updateValue(OGDataField.homeAddress, s),
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextDropdown(
                  validator: (text) =>
                  text == null || text.isEmpty ? "Field is required" : null,
                  labelText: "Are you a civil servant?",
                  enableSearch: false,
                  initialValue: isCivilServant == null ? null : ( isCivilServant == 1 ? "Yes" : "No"),
                  onChanged: (s){
                    cubitContext
                        .read<OGDataEntryCubit>()
                        .updateValue(OGDataField.civilServant, (s as DropDownValueModel).name == "No" ? false : true);
                  },
                  list: const ["No", "Yes"],
                ),

              ],
            );
          }
      ),
    );
  }

}