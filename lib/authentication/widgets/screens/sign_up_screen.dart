import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

import '../../states/states.dart';

class SignupPage extends StatelessWidget {
  final String userType;
  final String userTypeLabel;
  final bool selfSignup;
  const SignupPage(
      {Key? key, required this.userType, required this.userTypeLabel, this.selfSignup=true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();
    final GlobalKey genderKey = GlobalKey();
    final GlobalKey lgaKey = GlobalKey();
    final GlobalKey wardKey = GlobalKey();

    return BlocProvider(
      create: (_) => SignupCubit(SignupState(
        userType: userTypeLabel,
      )),
      child: BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
        return BaseScaffold(
          appBarBackgroundColor: Colors.grey[100],
          textAndIconColors: Colors.black,
          title: RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "SIGN UP",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ])),
          centerTitle: true,
          showBack: true,
          body: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(userTypeLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        ImagePickerUtil.pickImage().then((value) {
                          if (value != null) {
                            context
                                .read<SignupCubit>()
                                .updateProfilePicture(value.path);
                          }
                        }).catchError((err) {
                          Alert.toast(context, message: err.toString());
                        });
                      },
                      child: Builder(
                        builder: (c) {
                          if (state.profilePicture == null) {
                            return DottedBorder(
                                borderType: BorderType.Circle,
                                color: Theme.of(context).primaryColor,
                                radius: const Radius.circular(150),
                                child: Image.asset(
                                  AssetConstants.imageNotFound,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ));
                          } else {
                            return CardFileImage(
                              imageString: state.profilePicture!,
                              size: const Size(150, 150),
                              radius: 150,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Select profile picture",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 20),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "First name",
                      keyboardType: TextInputType.name,
                      hintText: "Enter first name",
                      onChange: (s) =>
                          context.read<SignupCubit>().updateFirstName(s),
                      initialValue: state.firstName,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Last name",
                      keyboardType: TextInputType.name,
                      hintText: "Enter last name",
                      initialValue: state.lastName,
                      onChange: (s) =>
                          context.read<SignupCubit>().updateLastName(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextDropdown(
                      key: genderKey,
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Gender",
                      keyboardType: TextInputType.name,
                      hintText: "Gender",
                      initialValue: state.gender,
                      enableSearch: false,
                      list: const ["Male", "Female"],
                      onChanged: (s) => context
                          .read<SignupCubit>()
                          .updateGender((s as DropDownValueModel).name),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Phone number",
                      keyboardType: TextInputType.number,
                      hintText: "Enter phone number",
                      initialValue: state.phoneNumber,
                      onChange: (s) =>
                          context.read<SignupCubit>().updatePhoneNumber(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Password",
                      hidePassword: !(state.passwordVisible ?? false),
                      keyboardType: (state.passwordVisible ?? false)
                          ? TextInputType.visiblePassword
                          : null,
                      hintText: "Password",
                      initialValue: state.password,
                      suffixIcon: IconButton(
                          icon: Icon((state.passwordVisible ?? false)
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            context.read<SignupCubit>().updatePasswordVisible(
                                !(state.passwordVisible ?? false));
                          }),
                      onChange: (s) =>
                          context.read<SignupCubit>().updatePassword(s),
                    ),
                    const SizedBox(height: 10),
                    AppTextDropdown(
                        key: lgaKey,
                        validator: (text) => text == null || text.isEmpty
                            ? "Field is required"
                            : null,
                        labelText: "LGA",
                        keyboardType: TextInputType.name,
                        initialValue: state.lga,
                        list: state.lgas ?? [],
                        onChanged: (s) {
                          context
                              .read<SignupCubit>()
                              .updateLga((s as DropDownValueModel).name);
                        }),
                    const SizedBox(height: 10),
                    if (userType != UserType.lgaCoordinator.name)
                      AppTextDropdown(
                          key: wardKey,
                          validator: (text) => text == null || text.isEmpty
                              ? "Field is required"
                              : null,
                          labelText: "Ward",
                          keyboardType: TextInputType.name,
                          initialValue: state.ward,
                          list: state.wards ?? <String>[],
                          onChanged: (s) {
                            context.read<SignupCubit>().updateWard((s as DropDownValueModel).name);
                          }),
                    SizedBox(
                      height: 30,
                      child: Center(
                          child: Text(state.error ?? "",
                              maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ),
                    Center(
                      child: AppTextButton(
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        loading: state.loading ?? false,
                        width: MediaQuery.of(context).size.width -100,
                        label: "CONTINUE",
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          if(state.profilePicture == null){
                            Alert.message(context, message: "Please select a profile picture");
                            return;
                          }
                          try{
                          await context.read<SignupCubit>().signUp((newUser) {
                            NavUtils.navToReplace(
                                context,
                                SuccessPage(
                                    message:
                                    selfSignup ? "You have been successfully registered onto the platform, you'll be able to login after your account has been activated"
                                    : "You have successfully registered an account for this user, they'll be able to login once they've been activated",
                                    onContinue: (context) {
                                      if(selfSignup){
                                        BlocProvider.of<AppCubit>(context)
                                            .toggleFirstTimeLoad(false);
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                      }else{
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    }));
                          });
                          }catch(e){
                            print(e);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        "By proceeding you agree to the terms and conditions of this platform and that all data you entered above is true to the best of your knowledge",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
