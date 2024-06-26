import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/offline-repository/offline-repository.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';
import 'package:kaddep_data_capture/operational-grant/operational-grant.dart';
import 'package:kaddep_data_capture/shared/shared.dart';
import 'package:kaddep_data_capture/user-management/user-management.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:kaddep_data_capture/authentication/authentication.dart';

class HomePage extends StatelessWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomePage.scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(builder: (context){
        return FloatingActionButton(
          onPressed: ()async{
          if(context.read<SettingsCubit>().state.captureLga !=null){
            GrantType? selected;
            context.showCustomDialog(onConfirm: (){
              if(selected !=null){
                Navigator.pop(context);
                Future.delayed(const Duration(milliseconds: 200),(){
                  NavUtils.navTo(context, BVNLookup(grantType: selected!), onReturn: (){
                    context.read<OGDataEntryListCubit>().refreshAll();
                    context.read<ICTDataEntryListCubit>().refreshAll();
                  });
                });
              }
            },
            title: "Select Grant Type",
            content: GrantTypeSelector(onGrantSelected: (GrantType? grant) {
              selected = grant;
            },
            ));
          }else{
            context.showConfirmationDialog(onConfirm: (){
              Navigator.pop(context);
              NavUtils.navTo(context, const ChangeCaptureLocation());
            }, title: "Set Capture Location", message: "You have not selected the LGA and ward you'll be capturing data");
          }
        },
        backgroundColor: Theme.of(context).primaryColor, child: const Icon(Icons.add, color: Colors.white,),);
      }),
      bottomNavigationBar:BlocBuilder<AppCubit, AppState>(
        builder: (context,state) {
          return AnimatedBottomNavigationBar(
            icons: [Icons.dashboard, Icons.computer, Icons.business_sharp, state.user?.userType == UserModel.userTypeFieldAgent ? Icons.storage : Icons.people,],
            activeIndex: state.homeSelectedScreen ?? 0,
            activeColor: Theme.of(context).primaryColor,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index){
              context.read<AppCubit>().updateSelectedHomePage(index);
            },
            //other params
          );
        }
      ),
      body: Row(
        children: [
          // if (!_isSmallScreen) HomeDrawer(controller: _controller),
          Expanded(
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context,state) {
                return _Screens(
                  selectedIndex: state.homeSelectedScreen??0,
                  // controller: _controller,
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppCubit, AppState>(
      builder: (context,state) {
        return SidebarX(
          controller: _controller,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            hoverColor: scaffoldBackgroundColor,
            textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            selectedTextStyle: const TextStyle(color: Colors.white),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: canvasColor),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: actionColor.withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [accentCanvasColor, canvasColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 30,
                )
              ],
            ),
            iconTheme: IconThemeData(
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 200,
            decoration: BoxDecoration(
              color: canvasColor,
            ),
          ),
          footerDivider: divider,
          headerBuilder: (context, extended) {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(AssetConstants.logoBig),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.grey, spreadRadius: 2, blurStyle: BlurStyle.solid),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Text("TEAM ALPHA", style:Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.white), overflow: TextOverflow.ellipsis,),
                ),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color:Colors.white, size:17),
                    const SizedBox(width:5),
                    Text("Team Leader", style:Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.white), overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ],
            );
          },
          footerBuilder: (context, extented){
            Widget icon = Icon(Icons.logout, size: 20, color: Colors.white.withOpacity(0.7),);

            if(extented){

              return ListTile(leading: icon, title: Text("Logout", style: Theme.of(context).textTheme.labelMedium?.copyWith(color:Colors.white.withOpacity(0.7) ),), onTap: (){
                NavUtils.navToReplace(context, const LoginPage());
              },);
            }else{
              return IconButton(onPressed: (){
                NavUtils.navToReplace(context, const LoginPage());
              }, icon: icon);
            }
          },
          items: [
            SidebarXItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              onTap: () {
                debugPrint('Dashboard');
              },
            ),
            const SidebarXItem(
              icon: Icons.computer,
              label: 'ICT Grant',
            ),
            const SidebarXItem(
              icon: Icons.business_sharp,
              label: 'Operational Grant',
            ),
            SidebarXItem(
              icon: state.user?.userType == UserModel.userTypeFieldAgent ? Icons.storage : Icons.people,
              label: state.user?.userType == UserModel.userTypeFieldAgent ? "Storage" : "Users",
            ),
          ],
        );
      }
    );
  }
}

class _Screens extends StatelessWidget {
  const _Screens({
    Key? key, required this.selectedIndex,
  }) : super(key: key);

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppState>(
      builder: (context,state) {

        final String? userType = state.user?.userType;
        return _getScreenByIndex( selectedIndex, isSmallScreen(context), userType);
      }
    );
  }
}

Widget _getScreenByIndex(int selectedIndex, bool isSmallScreen, String? userType){
  // if(isSmallScreen){
    switch(selectedIndex){
      case 0:
        return DashboardPage();
      case 1:
        return const ICTDataEntryListPage();
      case 2:
        return const DataEntryListPage();
      case 3:
        if(userType != UserModel.userTypeFieldAgent){
          return const UsersListPage();
        }
        return const OfflineRepositoryPage();
      default:
        return const Center(child: Text("Page not found"),);
    }
  // }
}

bool isSmallScreen(BuildContext context){
  return MediaQuery.of(context).size.width < 600;
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);