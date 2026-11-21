import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/enums/required_check_list_enum.dart';
import 'package:gsform_plus/gs_form/model/data_model/check_data_model.dart';

import 'field_model.dart';

class GSCheckBoxModel extends GSFieldModel {
  List<CheckDataModel> items;
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
  RequiredCheckListEnum? requiredCheckListEnum;

  final ValueChanged<CheckDataModel> callBack;

  GSCheckBoxModel({
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
    super.enableReadOnly,
    required this.items,
    required this.callBack,
    this.requiredCheckListEnum,
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
