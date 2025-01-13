import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class BusinessRegistrationFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final OGDataEntryState state;
  final GlobalKey<FormState> formKey;

  const BusinessRegistrationFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

  @override
  Widget build(BuildContext context) {
    int activeStep = (state.page ??1)-1;
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          FutureBuilder(
              future: cubitContext.read<OGDataEntryCubit>().switchPage(activeStep+1),
              builder: (c, snapshot) {
                if(!snapshot.hasData){
                  return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
                }

                String? issuer = OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.businessRegIssuer) as String?;
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppTextDropdown(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business registration issuer",
                      keyboardType: TextInputType.name,
                      enableSearch: false,
                      list: const  ['CAC', 'SMEDAN', 'Cooperative Assoc.'/*, 'KADEDA'*/],
                      initialValue: issuer,
                      onChanged: (s) => cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.businessRegIssuer, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextDropdown(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business registration category",
                      keyboardType: TextInputType.name,
                      enableSearch: false,
                      list: const   [
                        'CAC Business Name',
                        'CAC Limited Liability Company',
                        'SMEDAN Business Registration',
                        'Single Purpose Cooperative Assoc.',
                        'Multi Purpose Cooperative Assoc.',
                      ],
                      initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.catType) as String?,
                      onChanged: (s) => cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.catType, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business registration number",
                      keyboardType: TextInputType.streetAddress,
                      initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.businessRegNum)
                      as String?,
                      onChange: (s) => cubitContext
                          .read<OGDataEntryCubit>()
                          .updateValue(OGDataField.businessRegNum, s),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(height: 10),
                    ImageBlobPickZone(
                        OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.certPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.certPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Certificate Image", isDocument: true),
                    const SizedBox(
                      height: 10,
                    ),
                    if(issuer == "CAC")ImageBlobPickZone(
                        OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.cacProofDocPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.cacProofDocPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "CAC Proof of Ownership Page Image", isDocument: true),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }

}