import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class RegisteredSMEs extends StatelessWidget{
  const RegisteredSMEs({this.cardColor, this.value=0, super.key});

  final Color? cardColor;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: (MediaQuery.of(context).size.width - 50) /2,
      decoration: BoxDecoration(
          color: (cardColor ?? Theme.of(context).primaryColor).withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 17.0,
                offset: const Offset(-10, 10))
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.rotate(angle: -45, child: SvgPicture.asset("assets/images/scribble.svg", height: 30, color: Colors.white),),
          const SizedBox(height:10),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context,state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${state.captureLga??"Unknown"} LGA", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),),
                  Text(state.captureLgaCode?.toUpperCase() ??"Not selected", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),),
                ],
              );
            }
          ),
          Row(
            children: [
              Icon(Icons.app_registration, size: 30, color:Colors.grey[300]),
              const SizedBox(width: 10,),
              Text(value.toString(), textScaler: const TextScaler.linear(2.0), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.normal, letterSpacing: 1.5),),
            ],
          ),
          Card(
            color: cardColor??Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("+ 1,230 . 10%", style: Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.white),),
            ),),
        ],
      ),
    );
  }



}