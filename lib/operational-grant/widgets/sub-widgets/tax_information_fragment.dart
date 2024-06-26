
import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class TaxInformationDetails extends StatelessWidget{

  final BuildContext cubitContext;
  final OGDataEntryState state;
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
              future: cubitContext.read<OGDataEntryCubit>().switchPage(activeStep+1),
              builder: (c, snapshot) {
                if(!snapshot.hasData){
                  return const SizedBox(height:50,width:50, child: CircularProgressIndicator(),);
                }
                String? issuer = OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.issuer) as String?;
                String? taxId = OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.taxId) as String?;
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppTextDropdown(
                      key: GlobalKey(),
                      validator: (text) => ((taxId == null || taxId.isEmpty) && OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.taxRegPhotoUrl)==null) ? null : (
                      text == null || text.isEmpty ? "Field is required" : null),
                      labelText: "Tax ID Issuer",
                      keyboardType: TextInputType.name,
                      enableSearch: false,
                      list: const  ['JTB', 'FIRS', 'KADIRS'],
                      initialValue: issuer,
                      onChanged: (s) => cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.issuer, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => ((issuer == null || issuer.isEmpty) && OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.taxRegPhotoUrl)==null) ? null : (
                          text == null || text.isEmpty ? "Field is required" : null),
                      labelText: "Tax ID",
                      keyboardType: TextInputType.text,
                      initialValue: taxId,
                      onChange: (s) => cubitContext
                          .read<OGDataEntryCubit>()
                          .updateValue(OGDataField.taxId, s),
                    ),
                    const SizedBox(height: 20),
                    ImageBlobPickZone(
                        OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.taxRegPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.taxRegPhotoUrl, await FileUtils.imageToBlob(path));
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