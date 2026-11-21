import 'package:flutter/cupertino.dart';

import 'field_model.dart';

class GSPriceModel extends GSFieldModel {
  int? maxLength;

  String? hint;

  GSPriceModel({
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
    dynamic maxLength,
    super.weight,
    super.showTitle,
    super.enableReadOnly,
    super.onTap,
    this.hint,
  }) : super(focusNode: FocusNode());
}
