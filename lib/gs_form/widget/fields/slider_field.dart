// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/slider_model.dart';

/// A `double` slider, or a `RangeValues` range slider when `isRange` is true.
class GSSliderField extends StatefulWidget implements GSFieldCallBack {
  final GSSliderModel model;
  final GSFormStyle formStyle;
  dynamic _value;

  GSSliderField(this.model, this.formStyle, {super.key});

  dynamic get _default => model.isRange ? RangeValues(model.min, model.max) : model.min;

  @override
  getValue() => _value ?? _default;

  @override
  bool isValid() => true;

  /// Accepts a `num` (or `RangeValues` when `isRange`); `null` goes back to the minimum / full range.
  @override
  void setValue(dynamic value) => _value = value is num ? value.toDouble() : value;

  @override
  void reset() => setValue(model.value);

  @override
  State<GSSliderField> createState() => _GSSliderFieldState();
}

class _GSSliderFieldState extends State<GSSliderField> {
  @override
  void initState() {
    super.initState();
    if (widget._value == null) widget.reset();
  }

  @override
  void didUpdateWidget(covariant GSSliderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._value = oldWidget._value;
  }

  String _label(double v) => v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1);

  void _changed(dynamic v) {
    setState(() => widget._value = v);
    widget.model.notifyChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final readOnly = m.enableReadOnly ?? false;
    final value = widget.getValue();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: m.isRange
          ? RangeSlider(
              min: m.min,
              max: m.max,
              divisions: m.divisions,
              values: value as RangeValues,
              labels: RangeLabels(_label(value.start), _label(value.end)),
              onChanged: readOnly ? null : _changed,
            )
          : Slider(
              min: m.min,
              max: m.max,
              divisions: m.divisions,
              value: value as double,
              label: _label(value),
              onChanged: readOnly ? null : _changed,
            ),
    );
  }
}
