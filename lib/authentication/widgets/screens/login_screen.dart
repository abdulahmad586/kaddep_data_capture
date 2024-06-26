import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/tutorial-videos/tutorial-videos.dart';

import '../../states/states.dart';
import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  static const String routeKey = "login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  String stat = "";
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(
          LoginState(loading: false,/* phone: "08012345678", password: "MyPassword" */)),
      child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
        return BaseScaffold(
          appBarBackgroundColor: Colors.white,
          noGradient: true,
          textAndIconColors: Colors.black,
          showBack: false,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      AssetConstants.logoBig,
                      height: 120,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "LOG",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: "IN",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ])),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Welcome back, please enter your details to login",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 40),
                    AppTextField(
                      validator: (text) => text == null || text.isEmpty
                          ? "Field is required"
                          : null,
                      labelText: "Phone number",
                      onChange: (s) =>
                          context.read<LoginCubit>().updatePhone(s),
                      keyboardType: TextInputType.phone,
                      initialValue: state.phone,
                    ),
                    const SizedBox(height: 20),
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
                            context.read<LoginCubit>().updatePasswordVisible(
                                !(state.passwordVisible ?? false));
                          }),
                      onChange: (s) =>
                          context.read<LoginCubit>().updatePassword(s),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 35,
                      child: Center(
                        child: Text(
                          state.error ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Center(
                      child: AppTextButton(
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        loading: state.loading ?? false,
                        width: MediaQuery.of(context).size.width-100,
                        label: "CONTINUE",
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          context.read<LoginCubit>().signIn((UserModel user) {
                            BlocProvider.of<AppCubit>(context)
                                .updateUserData(user);
                            BlocProvider.of<AppCubit>(context)
                                .updateLoginStatus(true, state.password!);
                            BlocProvider.of<AppCubit>(context)
                                .toggleFirstTimeLoad(false);
                            Navigator.popUntil(context, (route) => route.isFirst);
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              NavUtils.navToReplace(
                                  context, const SignupUserTypePage());
                            },
                            child: Row(
                              children: [
                                Icon(Icons.person,
                                    size: 17,
                                    color: Theme.of(context).primaryColor),
                                Text(" Sign up?",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold)),
                              ],
                            )),
                        TextButton(
                          onPressed: () {
                            NavUtils.navTo(context, VideosListScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_collection_outlined, color: Theme.of(context).primaryColor,),
                              const SizedBox(width:10),
                              Text(
                                "Tutorial videos",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

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
