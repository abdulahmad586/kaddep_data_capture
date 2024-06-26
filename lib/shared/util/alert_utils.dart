import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/sub-widgets/sub-widgets.dart';

class Alert {
  static void caution(BuildContext context,
      {String title = "Caution",
      String firstButtonLabel = "Cancel",
      String message = "Are you sure you want to proceed?",
      Function()? onFirstButtonClick,
      Function()? onProceed}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: ((context) {
          return Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AppTextButton(
                        onPressed: onFirstButtonClick ??
                            () {
                              Navigator.pop(context);
                            },
                        buttonColor: Colors.white,
                        textColor: Colors.black,
                        label: firstButtonLabel),
                    AppTextButton(
                        onPressed: () {
                          if (onProceed != null) {
                            onProceed();
                          }
                          Navigator.pop(context);
                        },
                        buttonColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        label: 'Proceed'),
                  ],
                ),
              ],
            ),
          );
        }));
  }

  static void showInputPrompt(
    BuildContext context, {
    String title = "Input text",
    String message = "",
    String label = "Email Address",
    String hint = "E m a i l",
    Widget? centerWidget,
    TextInputType inputType = TextInputType.emailAddress,
    Function(String)? onProceed,
  }) {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: ((context) {
          return Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  centerWidget ?? const SizedBox(),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: AppTextField(
                      validator: (text) {
                        return null;
                      },
                      labelText: label,
                      controller: controller,
                      keyboardType: inputType,
                      hintText: hint,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // const SizedBox(height: 20),
                      AppTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonColor: Colors.white,
                          textColor: Colors.black,
                          label: 'Cancel'),
                      AppTextButton(
                          onPressed: () {
                            if (onProceed != null) {
                              onProceed(controller.text);
                            }
                            Navigator.pop(context);
                          },
                          buttonColor: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          label: 'Proceed'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }

  static void message(BuildContext context,
      {String title = "Info!",
      String message = "Your request was successful",
      Function()? close,
      bool? error}) {
    if (error != null && error) {
      title = "0ops";
    } else if (error != null && !error) {
      title = "Success";
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: ((context) {
          return Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: error == null
                          ? null
                          : (error == true ? Colors.red : Colors.green)),
                ),
                const SizedBox(height: 20),
                error == null
                    ? SvgPicture.asset(
                        'assets/icons/info.svg',
                        height: 50,
                        width: 50,
                      )
                    : (error == true
                        ? SvgPicture.asset('assets/icons/info.svg',
                            height: 50, width: 50)
                        : SvgPicture.asset('assets/icons/check.svg',
                            height: 50, width: 50)),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                AppTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (close != null) {
                        close();
                      }
                    },
                    buttonColor: Colors.white,
                    textColor: Colors.black,
                    label: 'Close'),
              ],
            ),
          );
        }));
  }

  static void showModal(BuildContext context, Widget child) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: ((context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: child,
          );
        }));
  }

  static void toast(BuildContext context, {String message = ""}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
