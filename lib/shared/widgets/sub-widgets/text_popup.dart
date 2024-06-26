import 'package:flutter/material.dart';

class TextPopup extends StatelessWidget {
  const TextPopup(
      {Key? key,
      required this.list,
      required this.onSelected,
      this.active = 0,
      this.label,
      this.width})
      : super(key: key);

  final List<String> list;
  final int active;
  final String? label;
  final Function(int) onSelected;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        label == null
            ? const SizedBox()
            : Text(
                label!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
        SizedBox(
            width: width ?? 100,
            height: 50,
            child: PopupMenuButton(
              icon: Row(
                children: [
                  Expanded(
                    child: Text(
                      list[active],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                  )
                ],
              ),
              itemBuilder: (BuildContext context) {
                return List.generate(
                  list.length,
                  (index) {
                    return PopupMenuItem<String>(
                      value: '$index',
                      child: Text(
                        list[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                );
              },
              onSelected: (String string) {
                onSelected(int.parse(string));
              },
            ))
      ],
    );
  }
}
