import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class PassportAndIdFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final OGDataEntryState state;
  final GlobalKey<FormState> formKey;

  const PassportAndIdFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

  @override
  Widget build(BuildContext context) {
    int activeStep = (state.page ??1)-1;
    return Center(
      child: Form(
        key: formKey,
        child: FutureBuilder(
            future: cubitContext.read<OGDataEntryCubit>().switchPage(activeStep+1),
            builder: (c, snapshot) {
              if(!snapshot.hasData){
                return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageBlobPickZone(
                      (OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.ownerPassportPhotoUrl)
                      as Uint8List?), (path) async {
                    cubitContext.read<OGDataEntryCubit>().updateValue(
                        OGDataField.ownerPassportPhotoUrl, await FileUtils.imageToBlob(path));
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
                    OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.idDocType),
                    onChanged: (s) => cubitContext.read<OGDataEntryCubit>().updateValue(
                        OGDataField.idDocType, (s as DropDownValueModel).name),
                    list: const ['Drivers License', 'Voters Card', 'NIN Card', 'Intl Passport'],
                  ),
                  const SizedBox(height: 10),
                  ImageBlobPickZone(
                      OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.idDocPhotoUrl)
                      as Uint8List?, (path) async {
                    cubitContext.read<OGDataEntryCubit>().updateValue(
                        OGDataField.idDocPhotoUrl, await FileUtils.imageToBlob(path));
                  }, fieldLabel: "ID Document Image", isDocument: true),
                ],
              );
            }
        ),
      ),
    );
  }

}