import 'field_model.dart';

class GSTextModel extends GSFieldModel {
  int? maxLength;

  String? hint;

  GSTextModel({
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
    super.onTap,
    super.focusNode,
    super.nextFocusNode,
    this.maxLength,
    this.hint,
  });
}
