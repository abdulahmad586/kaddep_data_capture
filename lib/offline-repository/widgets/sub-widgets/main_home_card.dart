import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class MainHomeCard extends StatelessWidget{
  final int totalRecords;
  const MainHomeCard({this.cardColor, this.totalRecords=0, super.key});

  final Color? cardColor;

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
          Text("Original", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),),
          Text("Records", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),),
          const SizedBox(height:15),
          Row(
            children: [
              Icon(Icons.app_registration, size: 30, color:Colors.grey[300]),
              const SizedBox(width: 5,),
              Text((totalRecords > 9999 ? ((totalRecords/1000).toStringAsFixed(1)) : totalRecords).toString() + (totalRecords > 9999 ? "k":""), textScaler: const TextScaler.linear(2.0), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.normal, letterSpacing: 1.5),),
            ],
          ),
          Card(
            color: cardColor??Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("ict & op grants", style: Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.white),),
            ),),
        ],
      ),
    );
  }



}