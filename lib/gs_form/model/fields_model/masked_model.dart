import 'package:flutter/widgets.dart';

import 'field_model.dart';

class GSMaskedModel extends GSFieldModel {
  /// `#` digit, `A` letter, `*` letter or digit; anything else is a literal. E.g. `(###) ###-####`.
  final String mask;
  final String? hint;
  final TextInputType? keyboardType;

  GSMaskedModel({
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
    super.weight,
    super.showTitle,
    super.enableReadOnly,
    super.validateRegEx,
    required this.mask,
    this.hint,
    this.keyboardType,
  }) : super(focusNode: FocusNode());
}
