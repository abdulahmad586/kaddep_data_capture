import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';

class AppTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? hidePassword;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onTapOutside;
  final Function()? onEditingComplete;
  final Function(String)? onChange;
  final String? initialValue;

  const AppTextField(
      {super.key,
        this.keyboardType,
        this.validator,
        this.widthPercentage,
        this.width,
        this.hintText,
        this.labelText,
        this.icon,
        this.suffixIcon,
        this.prefixIcon,
        this.fillColor,
        this.hidePassword,
        this.enabled,
        this.autoFocus,
        this.itemsColor,
        this.minLines,
        this.maxLines,
        this.controller,
        this.onEditingComplete,
        this.onChange,
        this.onTap,
        this.onTapOutside,
        this.initialValue,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width,
        child: TextFormField(
          initialValue: initialValue,
          obscureText: hidePassword ?? false,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines ?? 1,
          onTap: onTap,
          onChanged: onChange,
          validator: validator ??
                  (value) {
                return null;
              },
          onTapOutside: onTapOutside ==null ?null :(p){onTapOutside!();},
          keyboardType: keyboardType,
          onEditingComplete: onEditingComplete,
          autofocus: autoFocus ?? false,
          style: Theme.of(context).textTheme.bodyMedium,
          controller: controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            suffixIcon: suffixIcon ??
                (icon == null
                    ? null
                    : Icon(
                  icon,
                  size: 15,
                  color: itemsColor,
                )),
            prefixIcon: prefixIcon,
            hintText: hintText,
            labelText: labelText,
            fillColor: fillColor??Theme.of(context).highlightColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ));
  }
}

class AppTextDateField extends StatelessWidget {
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onTapOutside;
  final Function()? onEditingComplete;
  final Function(DateTime)? onChange;
  final DateTime? initialValue;

  const AppTextDateField(
      {super.key,
        this.validator,
        this.widthPercentage,
        this.width,
        this.hintText,
        this.labelText,
        this.icon,
        this.suffixIcon,
        this.fillColor,
        this.enabled,
        this.autoFocus,
        this.itemsColor,
        this.minLines,
        this.maxLines,
        this.controller,
        this.onEditingComplete,
        this.onChange,
        this.onTap,
        this.onTapOutside,
        this.initialValue,
      });

  @override
  Widget build(BuildContext context) {

    TextEditingController ctrl = controller ?? TextEditingController.fromValue(TextEditingValue(text: initialValue == null ? "": "${initialValue?.day} / ${initialValue?.month} / ${initialValue?.year}"));
    ctrl.addListener(() {
      if(ctrl.text.isNotEmpty){
        onChange?.call(DateTime.parse(ctrl.text));
      }
    });

    return SizedBox(
        width: width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width,
        child: TextfieldDatePicker(
          cupertinoDatePickerBackgroundColor: Colors.white,
          cupertinoDatePickerMaximumDate: DateTime(2099),
          cupertinoDatePickerMaximumYear: 2099,
          cupertinoDatePickerMinimumYear: 1930,
          cupertinoDatePickerMinimumDate: DateTime(1930),
          cupertinoDateInitialDateTime: DateTime.now(),
          materialDatePickerFirstDate: DateTime(1930),
          materialDatePickerInitialDate: DateTime.now(),
          materialDatePickerLastDate: DateTime(2099),
          preferredDateFormat: DateFormat('yyyy-MM-dd'),
          textfieldDatePickerController: ctrl,
          validator: validator,
          onEditingComplete: onEditingComplete,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textCapitalization: TextCapitalization.sentences,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isDense: true,
            suffixIcon:
            suffixIcon ?? (icon == null ? null : Icon(icon, size: 15)),
            hintText: hintText,
            labelText: labelText,
            fillColor: Theme.of(context).highlightColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
    );
  }
}


class AppTextDropdown extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? hidePassword;
  final List<String> list;
  final void Function(dynamic)? onChanged;
  final bool? enableSearch, isEnabled;
  final dynamic initialValue;

  const AppTextDropdown({
    super.key,
    this.keyboardType,
    this.validator,
    this.widthPercentage,
    this.width,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.hidePassword,
    required this.list,
    this.onChanged,
    this.enableSearch,
    this.initialValue,
    this.isEnabled
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ??
            ((widthPercentage ?? 100) / 100) *
                MediaQuery.of(context).size.width,
        child: DropDownTextField(
          validator: validator ??
                  (value) {
                return null;
              },
          keyboardType: keyboardType,
          // style: Theme.of(context).textTheme.labelLarge,
          searchDecoration: InputDecoration(hintText: hintText),
          onChanged: onChanged,
          isEnabled: isEnabled ??true,
          enableSearch: enableSearch ?? true,
          initialValue: initialValue,
          textFieldDecoration: InputDecoration(
            isDense: true,
            suffixIcon:
            suffixIcon ?? (icon == null ? null : Icon(icon, size: 15)),
            hintText: hintText,
            labelText: labelText,
            fillColor: Theme.of(context).highlightColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
          dropDownList: List.generate(
              list.length,
                  (index) =>
                  DropDownValueModel(name: list[index], value: list[index])),
        ));
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField(
      {
        super.key,
        required this.loader,
        required this.itemBuilder,
        this.keyboardType,
        this.validator,
        this.widthPercentage,
        this.width,
        this.hintText,
        this.labelText,
        this.icon,
        this.suffixIcon,
        this.hidePassword,
        this.enabled,
        this.autoFocus,
        this.itemsColor,
        this.minLines,
        this.maxLines,
        this.controller,
        this.onEditingComplete,
        this.onSuggestionSelected,
        this.fillColor,
        this.onChange,
        this.onTap});
  final Future<List<dynamic>> Function(String) loader;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final double? widthPercentage;
  final double? width;
  final String? hintText;
  final String? labelText;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool? hidePassword;
  final bool? enabled, autoFocus;
  final Color? itemsColor, fillColor;
  final int? minLines, maxLines;
  final TextEditingController? controller;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final dynamic Function(dynamic)? onSuggestionSelected;
  final Function(String)? onChange;
  final Widget Function(BuildContext, dynamic) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          ((widthPercentage ?? 100) / 100) * MediaQuery.of(context).size.width,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          // autofocus: true,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontStyle: FontStyle.italic),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            isDense: true,
            suffixIcon: suffixIcon ??
                (icon == null
                    ? null
                    : Icon(
                  icon,
                  size: 15,
                  color: itemsColor,
                )),
            hintText: hintText,
            labelText: labelText,
            fillColor: fillColor?? Theme.of(context).highlightColor.withAlpha(30),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.red[100]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await loader(pattern);
        },
        itemBuilder: itemBuilder,
        onSuggestionSelected: onSuggestionSelected ??(s){},
      ),
    );
  }
}
