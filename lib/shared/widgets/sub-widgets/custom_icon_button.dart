import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{

  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor, iconColor;
  final double iconSize;
  const CustomIconButton(this.icon, {super.key, required this.onPressed, this.iconSize=17, this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      fillColor: backgroundColor,
      constraints: const BoxConstraints(minWidth: 40.0, minHeight: 36.0),
      elevation: 0,
      child: Icon(icon, color: iconColor ?? Colors.black, size: iconSize,)
    );
  }

}