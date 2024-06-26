import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    this.onTap,
    this.icon,
    this.iconSize,
    this.height,
    this.width,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    super.key,
  });

  final Function()? onTap;
  final IconData? icon;
  final double? iconSize, height, width;
  final Color? iconColor, borderColor, backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType
            .transparency, //Makes it usable on any background color, thanks @IanSmith
        child: Ink(
          height: height ?? 45,
          width: width ?? 45,
          decoration: BoxDecoration(
              border: Border.all(
                  color: borderColor ?? Theme.of(context).primaryColor, width: 1.0),
              color: backgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: InkWell(
            //This keeps the splash effect within the circle
            borderRadius:
            BorderRadius.circular(400), //Something large to ensure a circle
            onTap: onTap,
            child: Center(
              // padding: const EdgeInsets.all(20.0),
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
        ));
  }
}
