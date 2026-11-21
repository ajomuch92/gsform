import 'package:flutter/cupertino.dart';

import '../data_model/spinner_data_model.dart';
import 'field_model.dart';

class GSSpinnerModel extends GSFieldModel {
  List<SpinnerDataModel> items;
  String? hint;
  ValueChanged<SpinnerDataModel?>? onChange;

  GSSpinnerModel({
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
    dynamic onTap,
    super.showTitle,
    required this.items,
    this.onChange,
    this.hint,
  });
}
