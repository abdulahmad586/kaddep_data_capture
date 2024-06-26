import 'package:flutter/material.dart';

import '../shared.dart';

extension BuildContextExtensions on BuildContext {
  Future<T?> push<T extends Object?>(
    Route<T> route, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator).push<T>(route);
  }

  Future<T?> pushReplacement<T extends Object?>(
    Route<T> route, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator)
        .pushReplacement<T, T>(route);
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> route, {
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator)
        .pushAndRemoveUntil(route, (route) => false);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator)
        .pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator)
        .pushNamedAndRemoveUntil(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    String newRouteName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    return Navigator.of(this, rootNavigator: rootNavigator)
        .pushNamedAndRemoveUntil(
      newRouteName,
      (_) => false,
      arguments: arguments,
    );
  }

  void popUntil(RoutePredicate predicate) {
    return Navigator.of(this).popUntil(predicate);
  }

  void pop<T extends Object?>({T? result, bool rootNavigator = false}) {
    return Navigator.of(this, rootNavigator: rootNavigator).pop<T>(result);
  }

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) =>
      ScaffoldMessenger.of(this)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(color: Theme.of(this).canvasColor),
            ),
            backgroundColor: Theme.of(this).textTheme.bodyText1?.color,
            duration: duration,
          ),
        );

  void showBottomSheet(
    Widget widget, {
    Color backgroundColor = Colors.grey,
    double elevation = 0.0,
  }) =>
      Scaffold.of(this)
        ..showBottomSheet(
          (BuildContext context) {
            return widget;
          },
          backgroundColor: backgroundColor,
          elevation: elevation,
          enableDrag: true,
        );

  Future<void> showAppDialog({required String title, required String message}) async {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(this).primaryColor),
          ),
          content: Text(message),
          actions: <Widget>[
            Row(children: [
              AppTextButton(
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                label: "Close",
                onPressed: ()=> Navigator.pop(this),
              ),
            ],)
          ],
        );
      },
    );
  }

  void showConfirmationDialog({
    required VoidCallback onConfirm,
    required String title,
    required String message,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(this).primaryColor),
          ),
          content: Text(message),
          actions: <Widget>[
            Row(children: [
              AppTextButton(
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                label: "Cancel",
                onPressed: ()=> Navigator.pop(this),
              ),
              AppTextButton(
                buttonColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: "Proceed",
                onPressed: onConfirm,
              ),
            ],)
          ],
        );
      },
    );
  }

  void showCustomDialog({
    VoidCallback? onConfirm,
    required String title,
    required Widget content,
    bool showOptions = true,
  }) {
    showDialog(
      context: this,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(this).primaryColor),
          ),
          content: content,
          actions: showOptions?<Widget>[
            Row(children: [
              AppTextButton(
                buttonColor: Colors.white,
                textColor: Theme.of(context).primaryColor,
                label: "Cancel",
                onPressed: ()=> Navigator.pop(this),
              ),
              if(onConfirm != null)AppTextButton(
                buttonColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: "Proceed",
                onPressed: onConfirm,
              ),
            ],)
          ] : null,
        );
      },
    );
  }

  //show drawer from anywhere
  void showDrawer() {
    Scaffold.of(this).openDrawer();
  }

  void unFocus() {
    return FocusScope.of(this).requestFocus(FocusNode());
  }
}
