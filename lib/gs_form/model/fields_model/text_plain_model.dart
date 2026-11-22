import 'field_model.dart';

class GSTextPlainModel extends GSFieldModel {
  int? maxLength;
  int? maxLine;
  int? minLine;
  String? hint;
  bool? showCounter;

  GSTextPlainModel({
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
    super.enableReadOnly,
    super.weight,
    super.showTitle,
    super.onTap,
    this.minLine,
    this.maxLength,
    this.maxLine,
    this.hint,
    this.showCounter,
  });
}
