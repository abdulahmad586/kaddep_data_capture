import 'package:flutter/material.dart';

class HeadingDivider extends StatelessWidget{

  final String heading;
  const HeadingDivider(this.heading, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        const SizedBox(width: 7,),
        Text(heading, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor),),
        const SizedBox(width: 7,),
        const Expanded(child: Divider()),
      ],
    );
  }

}