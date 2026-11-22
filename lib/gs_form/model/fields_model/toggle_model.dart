import 'field_model.dart';

class GSToggleModel extends GSFieldModel {
  /// Text shown next to the switch.
  final String? hint;

  GSToggleModel({
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
    this.hint,
  });
}
