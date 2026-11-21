import 'field_model.dart';

class GSSliderModel extends GSFieldModel {
  final double min;
  final double max;
  final int? divisions;

  /// When true the value is a `RangeValues` instead of a `double`.
  final bool isRange;

  GSSliderModel({
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
    required this.min,
    required this.max,
    this.divisions,
    this.isRange = false,
  });
}
