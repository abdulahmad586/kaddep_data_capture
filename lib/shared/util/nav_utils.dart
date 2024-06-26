import 'package:flutter/material.dart';

class NavUtils {
  static void navTo(BuildContext context, Widget dest, {Function()? onReturn}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dest),
    ).then((value) {
      if(onReturn != null){
        onReturn();
      }
    });
  }

  static void navToNamed(BuildContext context, String routeName, {Function()? onReturn}) {
    Navigator.pushNamed(
      context,
      routeName,
    ).then((value) {
      if(onReturn != null){
        onReturn();
      }
    });
  }

  static void navToReplace(BuildContext context, Widget dest, {Function()? onReturn}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dest),
    ).then((value) {
      if(onReturn != null){
        onReturn();
      }
    });
  }

  static void navToReplaceNamed(BuildContext context, String routeName, {Function()? onReturn}) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    ).then((value) {
      if(onReturn != null){
        onReturn();
      }
    });
  }

}
