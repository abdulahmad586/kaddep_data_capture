import 'package:flutter/material.dart';
import 'package:kaddep_data_capture/home/home.dart';
import 'package:kaddep_data_capture/shared/shared.dart';

class GrantTypeSelector extends StatefulWidget{
  final Function(GrantType?) onGrantSelected;

  const GrantTypeSelector({super.key, required this.onGrantSelected});

  @override
  State<GrantTypeSelector> createState() => _GrantTypeSelectorState();
}

class _GrantTypeSelectorState extends State<GrantTypeSelector> {

  GrantType? grantType;

  void onChanged(enabled, GrantType type){
    setState(()=>grantType = enabled! ? type : null);
    widget.onGrantSelected(grantType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: GestureDetector(
              onTap: ()=>onChanged(!(grantType == GrantType.operational), GrantType.operational),
              child: GenericListItem(label: "Operational Expenses Grant", desc2: "Tap to select", trailing: Checkbox(value: grantType == GrantType.operational, tristate: false, onChanged: (c)=>onChanged(c, GrantType.operational)),)),
        ),
        Card(
          child: GestureDetector(
              onTap: ()=>onChanged(!(grantType == GrantType.ict), GrantType.ict),
              child: GenericListItem(label: "ICT Procurement Grant", desc2: "Tap to select", trailing: Checkbox(value: grantType == GrantType.ict, tristate: false, onChanged: (c)=>onChanged(c, GrantType.ict)),)),
        ),
      ],
    );
  }
}