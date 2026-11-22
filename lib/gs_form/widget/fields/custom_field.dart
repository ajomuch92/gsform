// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/custom_model.dart';

/// Hosts a user-built input. `required` fails on `null`, empty strings and empty collections.
class GSCustomField extends StatefulWidget implements GSFieldCallBack {
  final GSCustomModel model;
  final GSFormStyle formStyle;
  dynamic _value;
  bool _initialized = false;

  GSCustomField(this.model, this.formStyle, {super.key});

  @override
  getValue() => _value;

  @override
  bool isValid() {
    if (!(model.required ?? false)) return true;
    final v = _value;
    return v != null && !(v is String && v.isEmpty) && !(v is Iterable && v.isEmpty) && !(v is Map && v.isEmpty);
  }

  @override
  void setValue(dynamic value) {
    _value = value;
    _initialized = true;
  }

  @override
  void reset() => setValue(model.value);

  @override
  State<GSCustomField> createState() => _GSCustomFieldState();
}

class _GSCustomFieldState extends State<GSCustomField> {
  @override
  void initState() {
    super.initState();
    if (!widget._initialized) widget.reset();
  }

  @override
  void didUpdateWidget(covariant GSCustomField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.setValue(oldWidget._value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.model.builder(context, widget._value, (v) {
      setState(() => widget._value = v);
      widget.model.notifyChanged(v);
    });
  }
}
