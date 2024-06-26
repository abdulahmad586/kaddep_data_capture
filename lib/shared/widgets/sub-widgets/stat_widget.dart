import 'package:flutter/material.dart';

import 'sub-widgets.dart';

class StatWidget extends StatelessWidget {
  final IconData icon;
  final Widget? iconWidget;
  final String label;
  final String display;
  final Color? backgroundColor, iconBackgroundColor;
  final double? width, height;
  final bool showShadow;
  final Function()? onClick;

  const StatWidget(
      {required this.icon,
        this.iconWidget,
      required this.label,
      this.display = "",
      this.width,
      this.height,
      this.backgroundColor,
      this.iconBackgroundColor,
      this.onClick,
      this.showShadow = true,
      super.key,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(70, 213, 211, 211),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 17.0,
                      offset: const Offset(-10, 10))
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              iconWidget??ColorIconButton(
                "",
                icon,
                iconBackgroundColor ?? Theme.of(context).primaryColor, //Color.fromARGB(255, 243, 228, 192),
                iconColor: Colors.grey[300]!,
                iconSize: 15,
                showShadow: false,
              ),
              const SizedBox()
            ]),
            const SizedBox(height: 5.0),
            Text(
              label,
              style: TextStyle(fontSize: 14.0, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 1.0),
            Text(
              display,
              style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ElectionStat extends StatelessWidget {
  final String partyImage;
  final String partyName;
  final String result;
  final Color? textColor;
  final Color? backgroundColor;
  final double? width, height;
  final bool showShadow;
  final Function()? onClick;

  const ElectionStat(
      {required this.partyImage,
        required this.partyName,
        this.result="",
        this.width,
        this.height,
        this.textColor,
        this.backgroundColor,
        this.onClick,
        this.showShadow = true,
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(70, 255, 152, 0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: showShadow
              ? [
            BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 17.0,
                offset: const Offset(-10, 10))
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CardImage(imageString: partyImage, size: const Size(30,30), radius: 20,),
              const SizedBox()
            ]),
            const SizedBox(height: 5.0),
            Text(
              partyName,
              style: TextStyle(fontSize: 11.0, color: textColor?? Colors.grey),
            ),
            const SizedBox(height: 5.0),
            Text(
              result.toString(),
              style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

