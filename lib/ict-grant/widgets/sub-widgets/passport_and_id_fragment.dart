import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class PassportAndIdFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final ICTDataEntryState state;
  final GlobalKey<FormState> formKey;

  const PassportAndIdFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

  @override
  Widget build(BuildContext context) {
    int activeStep = (state.page ??1)-1;
    return Center(
      child: Form(
        key: formKey,
        child: FutureBuilder(
            future: cubitContext.read<ICTDataEntryCubit>().switchPage(activeStep+1),
            builder: (c, snapshot) {
              if(!snapshot.hasData){
                return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageBlobPickZone(
                      (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.ownerPassportPhotoUrl)
                      as Uint8List?), (path) async {
                    cubitContext.read<ICTDataEntryCubit>().updateValue(
                        ICTDataField.ownerPassportPhotoUrl, await FileUtils.imageToBlob(path));
                  }, fieldLabel: "Picture of Business Owner"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextDropdown(
                    validator: (text) =>
                    text == null || text.isEmpty ? "Field is required" : null,
                    labelText: "Identification Method",
                    keyboardType: TextInputType.name,
                    enableSearch: false,
                    initialValue:
                    ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.idDocType),
                    onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                        ICTDataField.idDocType, (s as DropDownValueModel).name),
                    list: const ['Drivers License', 'Voters Card', 'NIN Card', 'Intl Passport'],
                  ),
                  const SizedBox(height: 10),
                  ImageBlobPickZone(
                      ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.idDocPhotoUrl)
                      as Uint8List?, (path) async {
                    cubitContext.read<ICTDataEntryCubit>().updateValue(
                        ICTDataField.idDocPhotoUrl, await FileUtils.imageToBlob(path));
                  }, fieldLabel: "ID Document Image", isDocument: true),
                ],
              );
            }
        ),
      ),
    );
  }

}