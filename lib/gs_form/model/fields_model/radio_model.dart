import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/model/data_model/radio_data_model.dart';

import 'field_model.dart';

class GSRadioModel extends GSFieldModel {
  List<RadioDataModel> items;
  String? hint;
  Widget? selectedIcon;
  Widget? unSelectedIcon;
  bool? scrollable;
  double? height;
  Axis? scrollDirection;
  bool? showScrollBar;
  bool searchable;
  String? searchHint;
  Icon? searchIcon;
  BoxDecoration? searchBoxDecoration;
  Color? scrollBarColor;
  final ValueChanged<RadioDataModel> callBack;

  GSRadioModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.status,
    super.value,
    super.weight,
    super.showTitle,
    required this.items,
    required this.callBack,
    this.selectedIcon,
    this.unSelectedIcon,
    this.hint,
    this.scrollable,
    this.height,
    this.scrollDirection,
    this.scrollBarColor,
    this.showScrollBar,
    required this.searchable,
    this.searchHint,
    this.searchIcon,
    this.searchBoxDecoration,
  });
}
