import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

class GSBankCardModel extends GSFieldModel {
  String? hint;

  GSBankCardModel({
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
    super.validateRegEx,
    super.weight,
    super.showTitle,
    super.enableReadOnly,
    this.hint,
  }) : super(focusNode: FocusNode());
}
