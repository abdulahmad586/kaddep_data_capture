import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/authentication/widgets/screens/signup_user_type.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/user-management/user-management.dart';
import 'package:kaddep_data_capture/user-management/widgets/widgets.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:loading_indicator/loading_indicator.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider<UsersListCubit>(
      create: (_)=>UsersListCubit(UsersListState()),
      child: Scaffold(
        body: BlocBuilder<AppCubit, AppState>(
            buildWhen: (c, p) => c.isOnlineMode != p.isOnlineMode || c.user!.userType != p.user!.userType,
            builder: (context, appState) {
              final userType = UserModel.userTypeStringToEnum(appState.user!.userType);
              return BlocBuilder<UsersListCubit, UsersListState>(
                builder: (context,state) {
                  return Container(
                    decoration: (appState.isOnlineMode ?? false)
                        ? ThemeConstants.onlineModeDecoration
                        : null,
                    height: MediaQuery.of(context).size.height * 1.5,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.0),
                          child: HomeTopBar(text1:"Users", text2:" Manager"),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RegisteredUsers(
                                cardColor: Colors.lime[800],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.lime[800]?.withOpacity(0.05),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.lime[800],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.verified,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Active",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "30",
                                                    style: TextStyle(
                                                        color: Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.lime[800]?.withOpacity(0.05),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.lime[800],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.warning_amber,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Inactive",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "2",
                                                    style: TextStyle(
                                                        color: Colors.grey[600]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextButton(
                                  label: "New User",
                                  buttonColor: Colors.lime[800],
                                  textColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                NavUtils.navTo(
                                  context,
                                  SignupUserTypePage(
                                    type: userType,
                                  ),
                                );
                              }),
                              TextPopup(
                                  width: 150,
                                  list: const [
                                    "Enumerators",
                                    "Ward Coordinators",
                                    "LGA Coordinators",
                                  ],
                                  onSelected: (i) {})
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Builder(
                            builder: (context) {
                              if(state.error !=null && state.error!.isNotEmpty){
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.warning_amber, size: 40, color: Colors.amber,),
                                    const SizedBox(height: 10,),
                                    Text(state.error!, maxLines: 2, textAlign: TextAlign.center,),
                                    const SizedBox(height: 10,),
                                    AppTextButton(label: "Refresh", onPressed: (){
                                      context.read<UsersListCubit>().loadData();
                                    })
                                  ],
                                );
                              }else if(state.loading??false){
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width:100,
                                      height: 20,
                                      child: LoadingIndicator(
                                          indicatorType: Indicator.ballPulse,
                                          colors: [
                                            Colors.blue,
                                            Colors.orange,
                                            Colors.lime,
                                          ],
                                          pathBackgroundColor: Colors.black),
                                    )
                                  ],
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                  itemCount: state.users?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) {
                                              return SingleUserScreen(
                                                  user: state.users![index]);
                                            }),
                                          );
                                        },
                                        child: UserListItem(data: state.users![index]));
                                  });
                            }
                          ),
                        )),
                      ],
                    ),
                  );
                }
              );
            }),

      ),
    );
  }
}
