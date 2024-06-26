import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/shared/shared.dart';


class UserListItem extends StatelessWidget{
  final UserModel data;
  final Function()? onTap;
  final Widget? trailing;

  const UserListItem({super.key, required this.data, this.onTap, this.trailing});

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
                        CardImage(imageString: data.pictureUrl, size: const Size(50,50), radius: 10,)
                      ],
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: SizedBox(
                        height: 60,
                        child: Align(alignment: Alignment.centerLeft, child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text([data.firstName, data.lastName].join(" "), textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Text(data.userType, textAlign: TextAlign.start, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),),
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