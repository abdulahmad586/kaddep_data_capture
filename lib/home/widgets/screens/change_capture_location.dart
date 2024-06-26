import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/home/states/states.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class ChangeCaptureLocation extends StatelessWidget {
  const ChangeCaptureLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=> LocationChangeCubit(LocationChangeState(updating: false, oldIctGrants: 0, oldOperationalGrants: 0, onboardedIctGrants: 0, onboardedOperationalGrants: 0 )),
      child: BlocBuilder<LocationChangeCubit,LocationChangeState>(
          builder: (context,state){
            return PopScope(
              canPop: !(state.updating??false),
              onPopInvoked: (popped){
                // if(state.updating??false){
                //   context.showConfirmationDialog(onConfirm: (){
                //     context.read<LocationChangeCubit>().interruptOnboarding(true);
                //     Navigator.pop(context);
                //   }, title: "Onboarding in Progress", message: "Your records are being onboarded, please wait until this operation is finished to close this page");
                //   return;
                // }
              },
              child: BaseScaffold(
                noGradient: true,
                backgroundColor: Colors.white,
                title: Text(
                  "UPDATE CAPTURE LOCATION",
                  style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                showBack:true,
                backIcon: Icons.arrow_back,
                body: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height-(MediaQuery.of(context).size.height*0.15),
                    padding: const EdgeInsets.all(10),

                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextDropdown(
                          // key: GlobalKey(),
                          validator: (text) =>
                          text == null || text.isEmpty ? "Field is required" : null,
                          labelText: "Local Government Area",
                          isEnabled: !(state.updating??false),
                          keyboardType: TextInputType.name,
                          initialValue:state.selectedLGA,
                          list: state.lgas??<String>[],
                          onChanged: (s) => context.read<LocationChangeCubit>().updateLGA(s is String ? s : (s as DropDownValueModel).name),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if(!state.lgaNotSelected)Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const SizedBox(height:20),
                          Text("Records found in ${state.selectedLGA} LGA", textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),),
                          const SizedBox(height:20),
                          GridView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 120,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 10,
                            ),
                            children: [
                              StatWidget(icon: Icons.computer, label: "ICT Grant", showShadow: false, display: state.oldIctGrants.toString(),),
                              StatWidget(icon: Icons.business_sharp, label: "Operational Grant", showShadow: false, display: state.oldOperationalGrants.toString(),),
                            ],
                          ),
                          const SizedBox(height:20),
                          Text("Records onboarded", textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor),),
                          const SizedBox(height:20),
                          GridView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 120,
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 10,
                            ),
                            children: [
                              StatWidget(icon: Icons.computer, iconBackgroundColor: Colors.blue, label: "ICT Grant", showShadow: false, display: state.onboardedIctGrants.toString(),),
                              StatWidget(icon: Icons.business_sharp, iconBackgroundColor: Colors.blue, label: "Operational Grant", showShadow: false, display: state.onboardedOperationalGrants.toString(),),
                            ],
                          ),
                        ]),
                        const Spacer(),
                        Text((state.error != null && state.error!.isNotEmpty ? state.error : null) ?? state.statusText ?? "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: state.error != null && state.error!.isNotEmpty ? Colors.red : Colors.grey,
                            )),

                        if(state.updating ??false)Text("Processing ${(state.onboardedOperationalGrants??0)+(state.onboardedIctGrants??0)} of ${(state.oldOperationalGrants??0)+(state.oldIctGrants??0)} records",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[700],
                            )),
                        const SizedBox(height:10),

                        Center(
                          child: AppTextButton(
                            buttonColor: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            loading: (state.updating ?? false),
                            disabled: state.lgaNotSelected==null,
                            width: MediaQuery.of(context).size.width-100,
                            label: "ONBOARD RECORDS",
                            // loadingWidget: Text("${( (state.ictGrantProgress ?? 0) + (state.operationalGrantProgress??0) ).toInt()}%", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),),
                            onPressed:(){
                              context.showConfirmationDialog(title: "Proceed?", message: "You are about to override all existing records with this new set of data", onConfirm: (){
                                context.read<LocationChangeCubit>().startOnboardingRecords((){
                                  context.read<SettingsCubit>().updateCaptureLocation(state.selectedLGA!, state.selectedLGACode!);
                                  NavUtils.navToReplace(
                                      context,
                                      SuccessPage(
                                          message:
                                          "Your location of interest has been set successfully",
                                          onContinue: (context) {
                                            Navigator.pop(context);
                                          }));
                                });
                                Navigator.pop(context);
                              }, );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
      ),
    );
  }
}
