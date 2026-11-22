import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

class GSEmailModel extends GSFieldModel {
  int? maxLength;

  String? hint;

  GSEmailModel({
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
  });
}
