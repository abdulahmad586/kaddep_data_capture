import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class BusinessInformationFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final OGDataEntryState state;
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
              future: cubitContext.read<OGDataEntryCubit>().switchPage(activeStep+1),
              builder: (c, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator(),);
                }

                // final wardsList = (snapshot.data as Map<String, Object?>?)?['wardsList'] as List<String>? ?? state.wards ?? [];

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
                              .read<OGDataEntryCubit>()
                              .updateValue(OGDataField.businessName, s),
                      initialValue:
                      OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.businessName) as String?,
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
                          cubitContext.read<OGDataEntryCubit>().updateValue(
                              OGDataField.yearsInOperation,
                              s.isNotEmpty ? int.parse(s) : 0),
                      initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.yearsInOperation)
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
                          cubitContext.read<OGDataEntryCubit>().updateValue(
                              OGDataField.numStaff,
                              s.isNotEmpty ? int.parse(s) : 0),
                      initialValue:
                      OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.numStaff)
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
                      initialValue: OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.businessAddress)
                      as String?,
                      onChange: (s) => cubitContext
                          .read<OGDataEntryCubit>()
                          .updateValue(OGDataField.businessAddress, s),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ImageBlobPickZone(
                        OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.ownerAtBusinessPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<OGDataEntryCubit>().updateValue(
                          OGDataField.ownerAtBusinessPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Owner at business location"),
                    const SizedBox(height: 15),
                    LocationPicker(
                      latitude:OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.latitude) as double? ?? 0,
                      longitude:OGDataEntryState.getPageOGDataField(snapshot.data as Map<String, Object?>,OGDataField.longitude) as double? ?? 0,
                      onChange: ({double latitude = 0, double longitude = 0}) {
                        cubitContext
                            .read<OGDataEntryCubit>()
                            .updateValue(OGDataField.longitude, longitude);
                        cubitContext
                            .read<OGDataEntryCubit>()
                            .updateValue(OGDataField.latitude, latitude);
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