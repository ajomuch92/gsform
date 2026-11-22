import 'field_model.dart';

class GSPinCodeModel extends GSFieldModel {
  final int length;
  final bool obscure;

  GSPinCodeModel({
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
    required this.length,
    this.obscure = false,
  });
}
