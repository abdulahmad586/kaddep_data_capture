import 'package:flutter/material.dart';

import 'sub-widgets.dart';

class MorePopup extends StatelessWidget {
  const MorePopup({
    Key? key,
    this.options = const [],
    required this.onAction,
    this.iconBackground = Colors.white,
    this.shape = BoxShape.rectangle,
    this.iconSize = 17,
  }) : super(key: key);
  final List<String> options;
  final Function(int) onAction;
  final Color iconBackground;
  final BoxShape shape;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: ColorIconButton(
        "",
        Icons.more_horiz,
        iconBackground,
        iconColor: Colors.black,
        iconSize: iconSize,
        shape: shape,
        showShadow: false,
        borderColor: Colors.grey[100],
      ),
      itemBuilder: (BuildContext context) {
        return List.generate(
          options.length,
          (index) => PopupMenuItem<String>(
            value: '$index',
            child: Text(
              options[index],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
      onSelected: (String string) {
        onAction(int.parse(string));
      },
    );
  }
}
