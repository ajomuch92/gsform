// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/toggle_model.dart';

/// A switch. When `required`, it must be on (e.g. "I accept the terms").
class GSToggleField extends StatefulWidget implements GSFieldCallBack {
  final GSToggleModel model;
  final GSFormStyle formStyle;
  bool? _value;

  GSToggleField(this.model, this.formStyle, {super.key});

  @override
  getValue() => _value ?? false;

  @override
  bool isValid() => !(model.required ?? false) || getValue() == true;

  /// Accepts a `bool` or `null` (off).
  @override
  void setValue(dynamic value) => _value = value as bool? ?? false;

  @override
  void reset() => setValue(model.value);

  @override
  State<GSToggleField> createState() => _GSToggleFieldState();
}

class _GSToggleFieldState extends State<GSToggleField> {
  @override
  void initState() {
    super.initState();
    widget._value ??= widget.model.value as bool? ?? false;
  }

  @override
  void didUpdateWidget(covariant GSToggleField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._value = oldWidget._value;
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = widget.model.enableReadOnly ?? false;
    return Material(
      type: MaterialType.transparency,
      child: SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        title: Text(widget.model.hint ?? '', style: widget.formStyle.fieldTextStyle),
        value: widget.getValue(),
        onChanged: readOnly
            ? null
            : (v) {
                setState(() => widget._value = v);
                widget.model.notifyChanged(v);
              },
      ),
    );
  }
}
