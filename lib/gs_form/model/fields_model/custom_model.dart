import 'package:flutter/widgets.dart';

import 'field_model.dart';

/// Builds the input of a custom field. Call [onChanged] with the new value when the user changes it.
typedef GSCustomFieldBuilder = Widget Function(BuildContext context, dynamic value, ValueChanged<dynamic> onChanged);

class GSCustomModel extends GSFieldModel {
  final GSCustomFieldBuilder builder;

  GSCustomModel({
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
    required this.builder,
  });
}
