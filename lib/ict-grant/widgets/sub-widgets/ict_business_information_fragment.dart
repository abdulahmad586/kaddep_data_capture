import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class BusinessInformationFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final ICTDataEntryState state;
  final GlobalKey<FormState> formKey;

  const BusinessInformationFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

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
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator(),);
                }

                final wardsList = (snapshot.data as Map<String, Object?>?)?['wardsList'] as List<String>? ?? state.wards ?? [];

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business name",
                      keyboardType: TextInputType.name,
                      onChange: (s) =>
                          cubitContext
                              .read<ICTDataEntryCubit>()
                              .updateValue(ICTDataField.businessName, s),
                      initialValue:
                      ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.businessName) as String?,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : (int.tryParse(text) ==null || text.length > 2 ? "Invalid number": null),
                      labelText: "Years in operation",
                      keyboardType: TextInputType.number,
                      onChange: (s) =>
                          cubitContext.read<ICTDataEntryCubit>().updateValue(
                              ICTDataField.yearsInOperation,
                              s.isNotEmpty ? int.parse(s) : 0),
                      initialValue: ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.yearsInOperation)
                          ?.toString(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : (int.tryParse(text) == null || (int.tryParse(text)! > 99 || int.tryParse(text)! == 0) ? "Invalid number": null),
                      labelText: "Number of staff",
                      keyboardType: TextInputType.number,
                      onChange: (s) =>
                          cubitContext.read<ICTDataEntryCubit>().updateValue(
                              ICTDataField.numStaff,
                              s.isNotEmpty ? int.parse(s) : 0),
                      initialValue:
                      ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.numStaff)
                          ?.toString() ?? "1",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "Business Address",
                      keyboardType: TextInputType.streetAddress,
                      initialValue: ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.businessAddress)
                      as String?,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.businessAddress, s),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.ownerAtBusinessPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.ownerAtBusinessPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Owner at business location"),
                    const SizedBox(height: 15),
                    LocationPicker(
                      latitude:ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.latitude) as double? ?? 0,
                      longitude:ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.longitude) as double? ?? 0,
                      onChange: ({double latitude = 0, double longitude = 0}) {
                        cubitContext
                            .read<ICTDataEntryCubit>()
                            .updateValue(ICTDataField.longitude, longitude);
                        cubitContext
                            .read<ICTDataEntryCubit>()
                            .updateValue(ICTDataField.latitude, latitude);
                      },
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