import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
        SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  BlocBuilder<AppCubit, AppState>( builder: (context,state){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomIconButton(Icons.arrow_back, iconSize:20, iconColor: Colors.grey[800], onPressed: (){
                              Navigator.pop(context);
                            },),
                            const SizedBox(width: 1),
                            RichText(text: TextSpan(children: [
                              TextSpan(text: "${state.user?.firstName}, ".capitalize(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color:Colors.black),),
                              TextSpan(text: state.user?.lastName.capitalize(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color:Colors.grey[600]),),
                            ])),
                          ],
                        ),
                        CustomIconButton(Icons.logout, iconSize:20, backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05), iconColor: Colors.grey[800], onPressed: (){
                          context.read<AppCubit>().logoutUser(context);
                        },)
                      ],
                    );
                  },),
                  const SizedBox(height:20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Account Information", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).hintColor),),
                  ),
                  Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.person,), label: "Personal information", desc:"View your personal information", onPressed: editPersonalInfo,)),
                  // Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.account_balance,), label: "View your personal information", desc:"Link your bank accounts to your wallet", onPressed: manageBankAccounts,)),
                  const SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Security", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).hintColor),),
                  ),
                  // Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.pin,), label: "Transaction PIN", desc:"Change app transaction PIN", onPressed: changeTransactionPIN,)),
                  Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.password,), label: "Account password", desc:"Change your account password", onPressed: changeAccountPassword,)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Legal", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).hintColor),),
                  ),
                  Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.warning_amber), label: "Terms and conditions", desc:"Read our terms and conditions", onPressed: termsAndConditions,)),
                  Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.privacy_tip_outlined,), label: "Privacy policy", desc:"Read our data policy", onPressed: privacyPolicy,)),
                  Card(surfaceTintColor:Colors.white, elevation: 0.5, child: GenericListItem( verticalPadding: 15, leading: AppIconButton(height: 35, width: 35, borderColor: Theme.of(context).primaryColor, iconColor: Theme.of(context).primaryColor, icon: Icons.contact_support_outlined,), label: "Contact us", desc:"Got any complaints, issues, or suggestions?", onPressed: contactUs,)),
                  const SizedBox(height:30),
                  AppTextButton(label: "Delete Account", textColor: Colors.red, onPressed: deleteAccount,),
                  const SizedBox(height:40),
                ],
              )),
        ));
  }

  void editPersonalInfo(){
    // NavUtils.navTo(context, BlocBuilder<MainCubit, MainState>(
    //     builder: (context, state) {
    //       return BaseScaffold(
    //           showBack: true,
    //           body: UserInformation(state.user!)
    //       );
    //     }
    // ));
  }

  void changeAccountPassword(){
    // NavUtils.navTo(context, const ChangePassword());
  }

  void termsAndConditions(){

  }

  void privacyPolicy(){

  }

  void contactUs(){

  }

  void deleteAccount(){
    // NavUtils.navTo(context, const DeleteAccount());
  }


}
