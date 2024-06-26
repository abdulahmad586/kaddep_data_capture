import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/home/states/states.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class BVNLookup extends StatelessWidget {
  final GrantType grantType;
  const BVNLookup({required this.grantType,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> bvnFormKey = GlobalKey();
    final TextEditingController bvn = TextEditingController();

    return BlocProvider<BVNLookupCubit>(
      create: (_)=> BVNLookupCubit(BVNLookupState(searching: false, searchResults: [], grantType: grantType, tabView: 0 ), context.read<SettingsCubit>().state.captureLga!),
      child: BlocBuilder<BVNLookupCubit,BVNLookupState>(
        builder: (context,state){
          return BaseScaffold(
            noGradient: true,
            backgroundColor: Colors.white,
            title: Text(
              "BVN Lookup",
              style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            showBack:true,
            backIcon: Icons.clear,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height-150,
                child: Column(
                  children: [
                    Card(
                      child: GenericListItem(
                        leading: AppIconButton(icon: grantType == GrantType.operational ? Icons.business : Icons.computer,),
                        verticalPadding: 10,
                        label:grantType == GrantType.operational ? "Operational Expenses Grant":"ICT Procurement Grant",
                        desc: "Grant Type",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: GenericListItem(
                        leading: const AppIconButton(icon:Icons.location_city,),
                        verticalPadding: 10,
                        label:context.read<SettingsCubit>().state.captureLga ?? "",
                        desc: "Local Government Area",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextDropdown(
                      labelText: "Ward",
                      validator: (s)=>s == null || s.isEmpty ? "Please select ward" : null,
                      enableSearch: true,
                      list: state.wards??<String>[],
                      onChanged: (s){
                        if(s is String){
                          context.read<BVNLookupCubit>().updateWard(null);
                        }else{
                          context.read<BVNLookupCubit>().updateWard((s as DropDownValueModel).name);
                        }
                      },
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // AppTextDropdown(
                    //   labelText: "Grant Type",
                    //   enableSearch: false,
                    //   list: const ["ICT Grant", "Operational Grant"],
                    //   onChanged: (s){
                    //     if(s is String){
                    //       context.read<BVNLookupCubit>().updateGrantType(null);
                    //     }else{
                    //       context.read<BVNLookupCubit>().updateGrantType((s as DropDownValueModel).name == "ICT Grant" ? GrantType.ict : GrantType.operational);
                    //     }
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // if(state.grantType !=null)AppTabHeader(tabsList: const ["Search BVN", "Saved Drafts"], onTabChange: (newTab){
                    //   context.read<BVNLookupCubit>().updateTabView(newTab);
                    // },),
                    const SizedBox(height:10),
                    if(state.tabView == 0)Form(
                      key: bvnFormKey,
                      child: AppTextField(
                        controller: bvn,
                        labelText: "Bank Verification Number (BVN)",
                        keyboardType: TextInputType.number,
                        prefixIcon: bvn.text.length == 11 ? const Icon(Icons.done):const Icon(Icons.numbers),
                        validator: (text)=> text==null || text.isEmpty ? "BVN is required" : (text.length != 11 ? "Invalid BVN" : null),
                        suffixIcon: (state.searchResults?.isNotEmpty ?? false) ? CustomIconButton(Icons.clear, onPressed: (){context.read<BVNLookupCubit>().clearSearchResults(); bvn.clear(); }) :  const Icon(Icons.search),
                        enabled: state.grantType != null && state.ward !=null && state.ward!.isNotEmpty,
                        onChange: (s){
                          bvnFormKey.currentState?.validate();
                          if(s.length == 11){
                            context.read<BVNLookupCubit>().searchBvn(s);
                          }else{
                            context.read<BVNLookupCubit>().clearSearchResults();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height:10),
                    const Divider(),
                    const SizedBox(height:10),
                    if(state.tabView ==0)Expanded(child: (state.searchResults?.isEmpty??true) ?
                       SingleChildScrollView(
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height:30),
                            Text("No record found?", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),
                            const SizedBox(height:10),
                            Text("You may onboard a new candidate by clicking the button below", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),  textAlign: TextAlign.center,),
                            const SizedBox(height:10),
                            AppTextButton(label: "New Record", buttonColor:Theme.of(context).primaryColor, textColor:Colors.white, onPressed: ()async {
                              if(state.grantType == GrantType.ict){
                                context.showAppDialog(title: "Coming soon", message: "Sorry this grant type is not yet available");
                                return;
                              }

                              if (!(bvnFormKey.currentState?.validate() ?? false)) return;
                              String lga = context.read<SettingsCubit>().state.captureLga ?? "";
                              String lgaCode = context.read<SettingsCubit>().state.captureLgaCode ?? "";
                              String ward = state.ward ?? "";

                              final recordId = await context.read<BVNLookupCubit>().addNewRecord(bvn.text, lga, lgaCode, ward);
                              bvn.clear();
                              if(context.mounted ){
                                NavUtils.navTo(context, OGDataEntryPage(existingRecordId: recordId,));
                              }
                              },
                            ),
                          ],
                         ),
                       ) : ListView.builder(
                      itemCount: state.searchResults?.length ?? 0,
                      itemBuilder: (context, index){
                        if(state.grantType == GrantType.operational){
                          final data = state.searchResults![index] as MiniOperationalGrantSchema;
                          void editRecord ()async{
                            if(data.fromOldRecord){
                              context.showAppDialog(title: "Difference in Location", message: "Sorry, your capture location is not ${data.businessLGA} LGA");
                            }else{
                              if((data.dataComplete??false) && !(data.dataSynced??false)){
                                context.showConfirmationDialog(onConfirm: ()async{
                                  NavUtils.navTo(context, OGDataEntryPage(existingRecordId: data.rid));
                                }, title: "Record is complete", message: "This record has already been updated and verified, would you like to edit this record?");
                              }else if((data.dataSynced??false)){
                                context.showAppDialog(title: "Record synced", message: "Sorry this record has already been synced to the cloud!");
                              }else{
                                String lga = context.read<SettingsCubit>().state.captureLga ?? "";
                                String lgaCode = context.read<SettingsCubit>().state.captureLgaCode ?? "";
                                String ward = state.ward ?? "";
                                await context.read<BVNLookupCubit>().updateLGAAndWard(data.rid, lga, lgaCode, ward);
                                if(context.mounted)NavUtils.navTo(context, OGDataEntryPage(existingRecordId: data.rid));
                              }
                            }
                          }

                          return Card(
                            child: RawMaterialButton(
                              onPressed: editRecord,
                              child: GenericListItem(
                                leading: const AppIconButton(icon:Icons.person,),
                                verticalPadding: 10,
                                label: [data.firstName, data.lastName].join(" ").capitalizeWords(),
                                desc: data.businessName,
                                desc2: data.fromOldRecord ? "Registered in ${data.businessLGA} LGA" : ((data.dataType == OGDataType.existingData ? "Existing" : (data.dataType == OGDataType.newData ? "New": null)) ?? "Unknown"),
                                desc2Style: data.fromOldRecord ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red):null,
                                trailing: CustomIconButton((data.dataSynced??false) ? Icons.verified : Icons.verified_outlined, iconColor: (data.dataSynced??false) ? Colors.green : null, onPressed: editRecord,)
                              ),
                            ),
                          );
                        }else{
                          final data = state.searchResults![index] as MiniICTGrantSchema;
                          void editRecord ()async{
                            if(data.fromOldRecord){
                              context.showAppDialog(title: "Difference in Location", message: "Sorry, your capture location is not ${data.businessLGA} LGA");
                            }else{
                              if((data.dataComplete??false) && !(data.dataSynced??false)){
                                context.showConfirmationDialog(onConfirm: ()async{
                                  NavUtils.navTo(context, ICTDataEntryPage(existingRecordId: data.rid));
                                }, title: "Record is complete", message: "This record has already been updated and verified, would you like to edit this record?");
                              }else if((data.dataSynced??false)){
                                context.showAppDialog(title: "Record synced", message: "Sorry this record has already been synced to the cloud!");
                              }else{
                                String lga = context.read<SettingsCubit>().state.captureLga ?? "";
                                String lgaCode = context.read<SettingsCubit>().state.captureLgaCode ?? "";
                                String ward = state.ward ?? "";
                                await context.read<BVNLookupCubit>().updateLGAAndWard(data.rid, lga, lgaCode, ward);
                                if(context.mounted)NavUtils.navTo(context, ICTDataEntryPage(existingRecordId: data.rid));
                              }
                            }
                          }

                          return Card(
                            child: RawMaterialButton(
                              onPressed: editRecord,
                              child: GenericListItem(
                                  leading: const AppIconButton(icon:Icons.person,),
                                  verticalPadding: 10,
                                  label: [data.firstName, data.lastName].join(" ").capitalizeWords(),
                                  desc: data.businessName,
                                  desc2: data.fromOldRecord ? "Registered in ${data.businessLGA} LGA" : ((data.dataType == OGDataType.existingData ? "Existing" : (data.dataType == OGDataType.newData ? "New": null)) ?? "Unknown"),
                                  desc2Style: data.fromOldRecord ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red):null,
                                  trailing: CustomIconButton((data.dataSynced??false) ? Icons.verified : Icons.verified_outlined, iconColor: (data.dataSynced??false) ? Colors.green : null, onPressed: editRecord,)
                              ),
                            ),
                          );
                        }

                      },
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
