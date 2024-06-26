import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/ict-grant/ict-grant.dart';

class ICTListItem extends StatelessWidget{
  final MiniICTGrantSchema data;
  final Function()? onTap;
  final Widget? trailing;
  final Color? cardColor;

  const ICTListItem({super.key, required this.data, this.cardColor, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap:onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: cardColor ?? Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          child: const Center(
                            child: Icon(Icons.business, color: Colors.white,),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: SizedBox(
                        height: 60,
                        child: Align(alignment: Alignment.centerLeft, child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.businessName!, textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text([data.firstName, data.lastName].join(" "), textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),),
                              ],
                            ),
                          ],
                        )))),
                    if(trailing !=null)trailing!
                  ],),
              ),),
          ),
        ),
      ),
    );
  }
  
}