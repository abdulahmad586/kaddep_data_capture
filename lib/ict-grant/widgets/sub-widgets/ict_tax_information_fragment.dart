
import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class TaxInformationDetails extends StatelessWidget{

  final BuildContext cubitContext;
  final ICTDataEntryState state;
  final GlobalKey<FormState> formKey;

  const TaxInformationDetails({super.key, required this.cubitContext, required this.state, required this.formKey});

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
                String? issuer = ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.issuer) as String?;
                String? taxId = ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.taxId) as String?;
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppTextDropdown(
                      key: GlobalKey(),
                      validator: (text) => ((taxId == null || taxId.isEmpty) && ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.taxRegPhotoUrl)==null) ? null : (
                      text == null || text.isEmpty ? "Field is required" : null),
                      labelText: "Tax ID Issuer",
                      keyboardType: TextInputType.name,
                      enableSearch: false,
                      list: const  ['JTB', 'FIRS', 'KADIRS'],
                      initialValue: issuer,
                      onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.issuer, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => ((issuer == null || issuer.isEmpty) && ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.taxRegPhotoUrl)==null) ? null : (
                          text == null || text.isEmpty ? "Field is required" : null),
                      labelText: "Tax ID",
                      keyboardType: TextInputType.text,
                      initialValue: taxId,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.taxId, s),
                    ),
                    const SizedBox(height: 20),
                    ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.taxRegPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.taxRegPhotoUrl, await FileUtils.imageToBlob(path));
                    },
                        fieldLabel: "Tax Registration Photo",
                        isDocument: true,
                    ),
                    const SizedBox(
                      height: 50,
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