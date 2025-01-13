import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class BusinessRegistrationFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final ICTDataEntryState state;
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
              future: cubitContext.read<ICTDataEntryCubit>().switchPage(activeStep+1),
              builder: (c, snapshot) {
                if(!snapshot.hasData){
                  return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
                }

                String? issuer = ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.businessRegIssuer) as String?;
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
                      list: const  ['CAC', 'SMEDAN', 'Cooperative Assoc.',/* 'KADEDA'*/],
                      initialValue: issuer,
                      onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.businessRegIssuer, s is String ? s : (s as DropDownValueModel).name),
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
                      initialValue: ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.catType) as String?,
                      onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.catType, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business registration number",
                      keyboardType: TextInputType.streetAddress,
                      initialValue: ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.businessRegNum)
                      as String?,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.businessRegNum, s),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(height: 10),
                    ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.certPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.certPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Certificate Image", isDocument: true),
                    const SizedBox(
                      height: 10,
                    ),
                    if(issuer == "CAC")ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.cacProofDocPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.cacProofDocPhotoUrl, await FileUtils.imageToBlob(path));
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