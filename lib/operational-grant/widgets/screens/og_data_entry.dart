import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/operational-grant/widgets/sub-widgets/tax_information_fragment.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/home/home.dart';

class OGDataEntryPage extends StatelessWidget {
  final int? existingRecordId;
  OGDataEntryPage({this.existingRecordId, super.key});

  BuildContext? cubitContext;

  List<String> stepsLabel = [
    "Personal Information",
    "Identification Details",
    "Business Information",
    "Business Registration",
    "Operational Expenses",
    "Tax Information",
    "Finish"
  ];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  List<IconData> stepsIcons = [
    Icons.photo,
    Icons.person,
    Icons.phone,
    Icons.business,
    Icons.business,
    Icons.done_all
  ];

  Future<Object?> fetchData(OGDataField field)async{
    return await cubitContext?.read<OGDataEntryCubit>().fetchData(field);
  }

  Future<bool> proceedToNextStep(BuildContext c,int step)async {
    if (cubitContext != null) {
      switch (step) {
        case 1:
          if (await fetchData(OGDataField.ownerPassportPhotoUrl) == null) {
            if(c.mounted)reportValidationError(c, "Picture of business owner is required");
            return false;
          } else if (await fetchData(OGDataField.idDocPhotoUrl) == null) {
            if(c.mounted)reportValidationError(c, "Identity verification document is required");
            return false;
          }
          break;
        case 2:
          if (await fetchData(OGDataField.ownerAtBusinessPhotoUrl) == null) {
            if(c.mounted)reportValidationError(c, "Picture of owner at business location is required");
            return false;
          }else if (await fetchData(OGDataField.longitude) == null || await fetchData(OGDataField.longitude) == 0) {
                if(c.mounted) reportValidationError(c, "Missing GPS coordinates, tap location panel for more info");
                return false;
              }
          break;
        case 3:
          if (await fetchData(OGDataField.certPhotoUrl) == null) {
            if(c.mounted)reportValidationError(c, "Business registration certificate image is required");
            return false;
          }else if ((await fetchData(OGDataField.businessRegIssuer)) == "CAC" && await fetchData(OGDataField.cacProofDocPhotoUrl) == null) {
            if(c.mounted) reportValidationError(c, "CAC proof of ownership page image is required");
            return false;
          }
          break;
        case 4:
          final itemsPurchasedJson = await fetchData(OGDataField.itemsPurchased) as String?;
          List<ItemsPurchased> itemsPurchased = [];
          if(itemsPurchasedJson !=null){
            itemsPurchased = await ItemsPurchased.fromSchemaArray(jsonDecode(itemsPurchasedJson));
          }
          if ((await fetchData(OGDataField.businessOpsExpenseCat)) == "Salary" && ((await fetchData(OGDataField.renumerationPhotoUrl) == null) || (await fetchData(OGDataField.groupPhotoUrl)) == null) ) {
            if(c.mounted)reportValidationError(c, "Salary remuneration (payroll) & Staff group images are required");
            return false;
          }else if ((await fetchData(OGDataField.businessOpsExpenseCat)) != "Salary" &&  ( await fetchData(OGDataField.itemsPurchased) == null || itemsPurchased.isEmpty ) ) {
            if(c.mounted) reportValidationError(c, "Please add at least one item you purchased");
            return false;
          }
          break;
        case 5:
          final taxIssuer = (await fetchData(OGDataField.issuer)) as String?;
          if ( (taxIssuer != null && taxIssuer.isNotEmpty) && (await fetchData(OGDataField.taxRegPhotoUrl)) ==null ) {
            if(c.mounted)reportValidationError(c, "Tax registration image is required");
            return false;
          }
          break;
      }
    }
    return formKeys[step].currentState?.validate() ?? false;
  }

  void reportValidationError(BuildContext c,String error) {
    Alert.toast(c, message: error);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked:(popped)async{
        await cubitContext?.read<OGDataEntryCubit>().onEnd();
      },
      child: BlocProvider(
        create: (_) => OGDataEntryCubit(OGDataEntryState(page: 1, regId: existingRecordId)),
        child: BlocBuilder<OGDataEntryCubit, OGDataEntryState>(
          builder: (context,state) {
            cubitContext = context;
            int activeStep = (state.page??1)-1;
            return SafeArea(
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: _buildFab(context, activeStep),
                appBar: PreferredSize(
                  preferredSize: Size(
                      AppBar().preferredSize.width, AppBar().preferredSize.height),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(Icons.arrow_back, onPressed: () {
                          Navigator.pop(context);
                        }),
                        const Expanded(
                            child: HomeTopBar(text1: "Data", text2: " Capture")),
                      ],
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey[100],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: stepsLabel[activeStep].split(" ")[0],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (activeStep != stepsLabel.length - 1)
                          TextSpan(
                            text:
                                " ${stepsLabel[activeStep].substring(stepsLabel[activeStep].indexOf(" "))}",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                      ])),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Builder(builder: (c) {
                          return Builder(
                            builder: (c) {
                              late Widget widget;
                              switch (activeStep) {
                                case 0:
                                  widget = PersonalInformationFragment(cubitContext: context, state: state, formKey: formKeys[0],);
                                  break;
                                case 1:
                                  widget = PassportAndIdFragment(cubitContext: context, state: state, formKey: formKeys[1],);
                                  break;
                                case 2:
                                  widget = BusinessInformationFragment(cubitContext: context, state: state, formKey: formKeys[2],);
                                  break;
                                case 3:
                                  widget = BusinessRegistrationFragment(cubitContext: context, state: state, formKey: formKeys[3],);
                                  break;
                                case 4:
                                  widget = BusinessExpensesFragment(cubitContext: context, state: state, formKey: formKeys[4],);
                                  break;
                                case 5:
                                  widget = TaxInformationDetails(cubitContext: context, state: state, formKey: formKeys[5],);
                                  break;
                                case 6:
                                  widget = _buildFinishPage(c, state);
                                  break;
                                default:
                                  widget = const Text("Unimplemented");
                              }
                              return widget;
                            },
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, int activeStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -5,
                child: SizedBox(
                  width: 110,
                  height: 100,
                  child: RotatedBox(
                    quarterTurns: -45,
                    child: CircularProgressIndicator(
                      value: ((activeStep + 1) / stepsLabel.length) / 2,
                      strokeWidth: 10,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                  width: 100,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(100))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (activeStep + 1).toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Text("/${stepsLabel.length}"),
                    ],
                  )),
            ],
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppTextButton(
                    label: "Back",
                    icon: Icons.arrow_back,
                    buttonColor: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    width: 100,
                    onPressed: () {
                      if (activeStep != 0) {
                        cubitContext?.read<OGDataEntryCubit>().prevPage();
                      }
                    }),
                BlocBuilder<AppCubit, AppState>(builder: (c, state) {
                  return AppTextButton(
                      label: activeStep != stepsLabel.length - 1
                          ? "Next"
                          : ((state.isOnlineMode ?? false)
                              ? "Publish"
                              : "Save Draft"),
                      buttonColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      width: 100,
                      onPressed: () async {
                        if (activeStep < stepsLabel.length - 1) {
                          if (await proceedToNextStep(context,activeStep)) {
                            cubitContext?.read<OGDataEntryCubit>().nextPage(stepsLabel.length);
                            cubitContext?.read<OGDataEntryCubit>().switchPage(activeStep);
                          }
                        } else {
                          if (state.isOnlineMode ?? false) {
                            final recordId = cubitContext?.read<OGDataEntryCubit>().state.regId;
                            if(recordId !=null){
                              NavUtils.navToReplace(context, SyncOGRecordPage(recordId));
                            }else{
                              Alert.toast(context, message: "Something went wrong, please reload this page.");
                            }
                          } else {
                            _saveOfflineRecord(context);
                          }
                        }
                      });
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishPage(BuildContext context, OGDataEntryState state) {

    int activeStep = (state.page ??1)-1;
    return Center(
      child: FutureBuilder(
          future: context.read<OGDataEntryCubit>().switchPage(activeStep+1),
          builder: (c, snapshot) {
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Icon(
                    Icons.done_all,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "Field verification completed!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                "You can save this data locally and sync later or send now",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          );
        }
      ),
    );
  }

  void _saveOfflineRecord(BuildContext context) async {

    NavUtils.navToReplace(
      context,
      SuccessPage(
        message: "Your record has been successfully saved!",
        onContinue: (context) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
