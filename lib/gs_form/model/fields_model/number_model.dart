import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

class GSNumberModel extends GSFieldModel {
  int? maxLength;
  String? hint;
  bool? showCounter;

  GSNumberModel({
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
    dynamic focusNode,
    super.showTitle,
    super.enableReadOnly,
    super.onTap,
    this.showCounter,
    this.maxLength,
    this.hint,
  });
}
