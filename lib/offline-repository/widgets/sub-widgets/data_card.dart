import 'package:flutter/material.dart';

class DataCard extends StatelessWidget{
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const DataCard({required this.label, required this.value, required this.icon, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:5),
      padding: const EdgeInsets.symmetric(vertical:20, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.green[800]?.withOpacity(0.05),
          borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: Center(
            child: Icon(icon, color: Colors.white,),
          ),
        ),
        const SizedBox(width:10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
              const SizedBox(height:5),
              Text(value, style: TextStyle(color: Colors.grey[600]),),
            ],
          ),
        ),
      ],),
    );
  }

}