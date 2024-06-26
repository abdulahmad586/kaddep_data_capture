import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class CardImage extends StatelessWidget {
  const CardImage(
      {Key? key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding})
      : super(key: key);

  final Size size;
  final double radius;
  final String imageString;
  final Widget? child;
  final bool showBorder;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageString,
      errorWidget: (context, error, something){
        return Image.asset(AssetConstants.imageNotFound, height: size.height, width: size.width);
      },
      imageBuilder: (context, imageProvider) => Container(
          padding: padding,
          width: size.width,
          height: (size.height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            boxShadow: [
              BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
            ],
            color: const Color.fromARGB(0, 0, 0, 0),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
          child: Center(child: child),
      ),
    );
  }
}

class CardAssetImage extends StatelessWidget {
  const CardAssetImage(
      {Key? key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding})
      : super(key: key);

  final Size size;
  final double radius;
  final String imageString;
  final Widget? child;
  final bool showBorder;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image: Image.asset(imageString).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

class CardFileImage extends StatelessWidget {
  const CardFileImage(
      {Key? key,
      required this.imageString,
      required this.size,
      this.radius = 0,
      this.child,
      this.showBorder = false,
      this.borderColor,
      this.padding})
      : super(key: key);

  final Size size;
  final double radius;
  final String imageString;
  final Widget? child;
  final bool showBorder;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image: Image.file(File(imageString)).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

class CardBlobImage extends StatelessWidget {
  const CardBlobImage(
      {Key? key,
        required this.imageBlob,
        required this.size,
        this.radius = 0,
        this.child,
        this.showBorder = false,
        this.borderColor,
        this.padding})
      : super(key: key);

  final Size size;
  final double radius;
  final Uint8List imageBlob;
  final Widget? child;
  final bool showBorder;
  final Color? borderColor;
  final EdgeInsets? padding;

  @override
  build(BuildContext context) {
    return Container(
        padding: padding,
        width: size.width,
        height: (size.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          boxShadow: [
            BoxShadow(color: borderColor ?? Colors.white, spreadRadius: 3)
          ],
          color: const Color.fromARGB(0, 0, 0, 0),
          image: DecorationImage(
              image: Image.memory(imageBlob).image, fit: BoxFit.cover),
        ),
        child: Center(child: child));
  }
}

Widget textBadge(BuildContext context, String text,
    {Color backgroundColor = Colors.white, Color fontColor = Colors.black}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: fontColor)),
  );
}
