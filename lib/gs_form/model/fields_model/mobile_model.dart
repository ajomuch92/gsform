import 'field_model.dart';

class GSMobileModel extends GSFieldModel {
  int? maxLength;
  String? hint;

  GSMobileModel({
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
    super.enableReadOnly,
    super.onTap,
    this.maxLength,
    this.hint,
  }) : super(validateRegEx: validateReg);
}
