
import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/tutorial-videos/tutorial-videos.dart';


class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseScaffold(
      appBarBackgroundColor: Colors.grey[100],
      textAndIconColors: Colors.black,
      showBack: false,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
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
              RichText(text: TextSpan(children: [
                TextSpan(text: "GET", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
                TextSpan(text: " STARTED", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),),
              ])),
              const SizedBox(height: 40),
              const Text("KADDEP Data Capture"),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: AppTextButton(
                  buttonColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  width: 250,
                  label: "REGISTER",
                  onPressed: () {
                    NavUtils.navTo(context, const SignupUserTypePage());
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: AppTextButton(
                  buttonColor: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  width: 250,
                  label: "LOGIN",
                  onPressed: () {
                    NavUtils.navTo(context, const LoginPage());
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height:10),
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
                      "Watch tutorial videos",
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
        ),
      ),
    );
  }
}
