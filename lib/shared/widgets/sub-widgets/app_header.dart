import 'package:flutter/material.dart';

import 'sub-widgets.dart';

class AppTabHeader extends StatefulWidget {

  final List<String> tabsList;
  final List<String>? tabsHintList;
  final Function(int)? onTabChange;
  final Function(String)? onSearch;
  final Function()? onSearchClose;
  final int selectedTab;
  final bool hideSearch;
  final bool centered;
  final double? spaceBetween;

  const AppTabHeader(
      {Key? key,
      required this.tabsList,
      this.selectedTab = 0,
      this.tabsHintList,
      this.spaceBetween,
      this.onTabChange,
      this.onSearch,
      this.hideSearch = false,
      this.centered = false,
      this.onSearchClose})
      : super(key: key);

  @override
  State<AppTabHeader> createState() => _AppTabHeaderState();
}

class _AppTabHeaderState extends State<AppTabHeader> {
  bool searching = false;
  int _selectedTab = 0;

  @override
  void initState() {
    _selectedTab=widget.selectedTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: widget.centered ? MainAxisSize.min : MainAxisSize.max,
          children: [
            TextTab(
                tabTexts: widget.tabsList,
                activeTab: _selectedTab,
                spaceBetween: widget.spaceBetween ?? 15,
                onChange: (int id) {
                  setState(() {
                    _selectedTab = id;
                  });
                  if (widget.onTabChange != null) {
                    widget.onTabChange!(id);
                  }
                }),
          ],
        ));
  }
}
