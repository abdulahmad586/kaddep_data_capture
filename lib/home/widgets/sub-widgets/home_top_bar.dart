import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class HomeTopBar extends StatelessWidget{

  final String? text1, text2;
  final bool showUserIcon;
  const HomeTopBar({this.text1, this.text2, this.showUserIcon=false, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
        builder: (context,state) {
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if(showUserIcon)GestureDetector(
                          onTap: (){
                            NavUtils.navTo(context, const SettingsScreen());
                          },
                          child: CardImage(imageString: state.user!.pictureUrl, size: const Size(35,35), radius: 5,)),
                      if(showUserIcon)const SizedBox(width:10),
                      RichText(text: TextSpan(children: [
                        TextSpan(text: text1??"Hello, ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color:Colors.black),),
                        TextSpan(text: text2??state.user!.firstName.capitalize(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.normal, color:Colors.grey[600]),),
                      ])),
                    ],
                  ),
                  Row(
                    children: [
                      // if(state.isOnlineMode??false) Text("Online", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                      // if(!(state.isOnlineMode??false))Text("Offline", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                      Switch(
                        thumbIcon:MaterialStateProperty.resolveWith ((Set  states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Icon(Icons.close);
                          }
                          return Icon(Icons.cloud, color: (state.isOnlineMode??false) ?Colors.lightGreenAccent:null,); // All other states will use the default thumbIcon.
                        }),
                        value: state.isOnlineMode??false, onChanged: (enabled){
                        context.read<AppCubit>().updateMode(enabled);
                      }, activeColor: Theme.of(context).primaryColor,)
                    ],
                  )
                ]
            ),
          );
        }
    );
  }

}