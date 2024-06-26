import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisteredUsers extends StatelessWidget{
  const RegisteredUsers({this.cardColor, super.key});

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
          Text("Data Enumerators", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),),
          const SizedBox(height:15),
          Row(
            children: [
              Icon(Icons.data_exploration, size: 30, color:Colors.grey[300]),
              const SizedBox(width: 10,),
              Text("26", textScaleFactor: 2.0, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.normal, letterSpacing: 1.5),),
            ],
          ),
          Card(
            color: cardColor??Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("+ active", style: Theme.of(context).textTheme.bodySmall?.copyWith(color:Colors.white),),
            ),),
        ],
      ),
    );
  }



}