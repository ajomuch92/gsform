import 'package:flutter/material.dart';

import 'field_model.dart';

class GSTimePickerModel extends GSFieldModel {
  String? hint;
  TimeOfDay? initialTime;

  GSTimePickerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.prefixWidget,
    super.postfixWidget,
    super.required,
    super.status,
    super.value,
    RegExp? validateReg,
    super.weight,
    super.showTitle,
    this.hint,
    this.initialTime,
  }) : super(validateRegEx: validateReg);
}
