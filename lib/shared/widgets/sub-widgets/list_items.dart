import 'package:flutter/material.dart';

class GenericListItem extends StatelessWidget {
  const GenericListItem(
      {Key? key,
      required this.label,
      this.onPressed,
      this.desc,
      this.desc2,
      this.leading,
      this.trailing,
      this.verticalPadding,
      this.backgroundColor,
      this.descStyle,
      this.desc2Style,
      this.labelStyle})
      : super(key: key);

  final Function()? onPressed;
  final String label;
  final String? desc;
  final String? desc2;
  final Widget? leading;
  final Widget? trailing;
  final double? verticalPadding;
  final Color? backgroundColor;
  final TextStyle? labelStyle, descStyle, desc2Style;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        elevation: 0,
        fillColor: backgroundColor,
        splashColor: Theme.of(context).splashColor,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 20.0, horizontal: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              leading != null
                  ? Row(
                      children: [
                        leading!,
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    )
                  : const SizedBox(),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(label,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: labelStyle ??
                              const TextStyle(
                                  fontSize: 14, color: Colors.black)),)
                    ],
                  ),
                  SizedBox(height: desc != null ? 5.0 : 0),
                  desc != null
                      ? Text(desc!,
                          textAlign: TextAlign.start,
                          style: descStyle ??
                              const TextStyle(fontSize: 12, color: Colors.grey))
                      : const SizedBox(),
                  SizedBox(height: desc2 != null ? 5.0 : 0),
                  desc2 != null
                      ? Text(desc2!,
                          textAlign: TextAlign.start,
                          style: desc2Style ??
                              const TextStyle(fontSize: 12, color: Colors.grey))
                      : const SizedBox(),
                ],
              )),
              SizedBox(
                width: trailing != null ? 10.0 : 0,
              ),
              trailing ?? const SizedBox()
            ],
          ),
        ));
  }
}
