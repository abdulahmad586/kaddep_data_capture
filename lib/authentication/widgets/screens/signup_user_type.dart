import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class SignupUserTypePage extends StatelessWidget {
  final UserType? type;
  const SignupUserTypePage({Key? key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool selfSignup = context.read<AppCubit>().state.user==null;

    List<String> userRoles = [];
    List<String> userRolesKeys = [];
    List<String> userRolesImages = [
      AssetConstants.lgaCoordinator,
      AssetConstants.wardCoordinator,
      AssetConstants.fieldAgent,
    ];


    userRoles = [
      "LGA Coordinator",
      "Ward Coordinator",
      "Field Agent",
    ];
    userRolesKeys = [
      UserType.lgaCoordinator.name,
      UserType.wardCoordinator.name,
      UserType.fieldAgent.name,
    ];

    if(!selfSignup){
      userRoles = [
        "Ward Coordinator",
        "Field Agent",
      ];
      userRolesKeys = [
        UserType.wardCoordinator.name,
        UserType.fieldAgent.name,
      ];
      if(context.read<AppCubit>().state.user?.userType == UserModel.userTypeWardCoordinator){
        userRoles = [
          "Field Agent",
        ];
        userRolesKeys = [
          UserType.fieldAgent.name,
        ];
      }
    }

    List<String> userRolesDescrition = [
      "Register as a coordinator of an LGA",
      "Register as a coordinator of a ward",
      "Sign up as a field agent to capture & verify businesses within your locality",
    ];

    return BaseScaffold(
      appBarBackgroundColor: Colors.grey[100],
      textAndIconColors: Colors.black,
      showBack: true,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const CardAssetImage(
              imageString: AssetConstants.logoBig,
              size: Size(120, 120),
              radius: 120,
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "SELECT",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " ROLE",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ])),
            const SizedBox(
              height: 50,
            ),
            Text("Choose the role you'd like to sign up with",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: userRolesKeys.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => NavUtils.navTo(
                          context,
                          SignupPage(
                            userTypeLabel: userRoles[index],
                            userType: userRolesKeys[index],
                            selfSignup: selfSignup
                          )),
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CardAssetImage(
                                  imageString: userRolesImages[index],
                                  size: const Size(70, 70)),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userRoles[index]),
                                const SizedBox(height: 5),
                                Text(
                                  userRolesDescrition[index],
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            )),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Icon(Icons.chevron_right_outlined),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
