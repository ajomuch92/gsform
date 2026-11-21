import 'package:flutter/cupertino.dart';
import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

class GSQRScannerModel extends GSFieldModel {
  String? hint;
  Widget? iconWidget;

  GSQRScannerModel({
    super.type,
    required super.tag,
    super.title,
    super.errorMessage,
    super.helpMessage,
    super.required,
    super.status,
    super.weight,
    super.showTitle,
    super.enableReadOnly,
    this.hint,
    this.iconWidget,
  });
}
