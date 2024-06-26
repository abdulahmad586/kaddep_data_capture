
import 'dart:convert';
import 'dart:typed_data';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

import 'package:kaddep_data_capture/shared/shared.dart';

class ICTProcurementExpensesFragment extends StatelessWidget{

  final BuildContext cubitContext;
  final ICTDataEntryState state;
  final GlobalKey<FormState> formKey;

  const ICTProcurementExpensesFragment({super.key, required this.cubitContext, required this.state, required this.formKey});

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
                String? bankName = (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.bank) as String?);
                List<ItemsPurchased> itemsPurchased = (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.itemsPurchased) as List<ItemsPurchased>?) ?? [];


                String? expenseCat = ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.ictProcCat) as String?;
                final cost = ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.costOfItems);
                String? accountName = (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.accountName) as String?);
                String? accountNumber = (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.accountNumber) as String?);

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    AppTextDropdown(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : null,
                      labelText: "ICT procurement expense category",
                      keyboardType: TextInputType.name,
                      enableSearch: false,
                      list: const  ['Salary', 'Rent', 'Utilities', 'Raw Materials'],
                      initialValue: expenseCat,
                      onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.ictProcCat, s is String ? s : (s as DropDownValueModel).name),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if(expenseCat != "Salary")Wrap( spacing: 10, children: List.generate(itemsPurchased.length+1, (index) {
                      if(index ==0){
                        return GestureDetector(
                          onTap: (){
                            Alert.showModal(context, ItemsPurchasedEditor(({required String itemsList, required Uint8List receipt}) async{
                              itemsPurchased.add(ItemsPurchased(itemsList: itemsList, receiptPhotoUrl: receipt));
                              final jsonString = jsonEncode(await ItemsPurchased.toMapArray(itemsPurchased));
                              if(cubitContext.mounted)cubitContext.read<ICTDataEntryCubit>().updateValue(ICTDataField.itemsPurchased, jsonString);
                              if(context.mounted)Navigator.pop(context);
                            }));
                          },
                          child: const Chip(label: Text("Add Items")),);
                      }else{
                        return Chip(label: Text(itemsPurchased[index-1].itemsList, style: Theme.of(context).textTheme.bodySmall), onDeleted: ()async{
                          itemsPurchased.removeAt(index-1);
                          final jsonString = jsonEncode(await ItemsPurchased.toMapArray(itemsPurchased));
                          if(cubitContext.mounted)cubitContext.read<ICTDataEntryCubit>().updateValue(ICTDataField.itemsPurchased, jsonString);
                        },);
                      }
                    }),),

                    if(expenseCat == "Salary")const SizedBox(height: 10),
                    if(expenseCat == "Salary")ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.renumerationPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.renumerationPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Salary Remuneration (Payroll) Image", isDocument: true),
                    if(expenseCat == "Salary")const SizedBox(
                      height: 15,
                    ),
                    if(expenseCat == "Salary")ImageBlobPickZone(
                        ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.groupPhotoUrl)
                        as Uint8List?, (path) async {
                      cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.groupPhotoUrl, await FileUtils.imageToBlob(path));
                    }, fieldLabel: "Staff Group Picture With Owner",),
                    if(expenseCat == "Salary")const SizedBox(
                      height: 15,
                    ),
                    if(expenseCat == "Salary")AppTextField(
                      key: GlobalKey(),
                      labelText: "Salary remarks/observation",
                      minLines: 3,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      initialValue: ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.comment) as String?,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.comment, s),
                    ),
                    const SizedBox(
                      height:10
                    ),
                    AppTextField(
                      validator: (text) =>
                      text == null || text.isEmpty ? "Field is required" : (int.tryParse(text) != null && int.parse(text) > 0 ? null:"Please enter a valid amount"),
                      labelText: "Cost of item(s)",
                      keyboardType: TextInputType.number,
                      initialValue: cost?.toString(),
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.costOfItems, s),
                    ),
                    const SizedBox(
                      height:10
                    ),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? null
                          : (text.length != 11 ? "Invalid BVN" : null),
                      labelText: "Bank Verification Number (BVN)",
                      keyboardType: TextInputType.number,
                      enabled:false,
                      initialValue:
                      (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.bvn) as String?),
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.bvn, s),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextDropdown(
                      labelText: "Bank Name",
                      validator: (t) => (t ==null || t.isEmpty) && ((accountName != null && accountName.isNotEmpty) || (accountNumber != null && accountNumber.isNotEmpty)) ? "Please select bank":null,
                      keyboardType: TextInputType.name,
                      list: (state.banksList??<String>[]),
                      onChanged: (s) => cubitContext.read<ICTDataEntryCubit>().updateValue(
                          ICTDataField.bank, s is String ? s : (s as DropDownValueModel).name),
                      initialValue:ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.bank) as String?,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      validator: (text) => (text == null || text.isEmpty)
                          ? ( bankName != null && bankName.isNotEmpty ? "Please enter account name" : null)
                          : null,
                      labelText: "Account name",
                      initialValue: accountName,
                      keyboardType: TextInputType.name,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.accountName, s),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextField(
                      validator: (text) => (text == null || text.isEmpty)
                          ? ( bankName != null && bankName.isNotEmpty ? "Please enter account number" : null)
                          : (text.length != 10 ? "Invalid account number" : null),
                      labelText: "Account number",
                      initialValue: (ICTDataEntryState.getPageICTDataField(snapshot.data as Map<String, Object?>,ICTDataField.accountNumber)
                      as String?),
                      keyboardType: TextInputType.number,
                      onChange: (s) => cubitContext
                          .read<ICTDataEntryCubit>()
                          .updateValue(ICTDataField.accountNumber, s),
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