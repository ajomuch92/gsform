import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/model/fields_model/field_model.dart';

/// Shared value handling for fields backed by a [TextEditingController].
mixin GSTextInputValue on StatefulWidget implements GSFieldCallBack {
  TextEditingController? controller;

  GSFieldModel get model;

  /// How a value is displayed, e.g. with thousands separators or a mask.
  String formatValue(String text) => text;

  @override
  void setValue(dynamic value) {
    final text = formatValue(value?.toString() ?? '');
    (controller ??= TextEditingController()).value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void reset() => setValue(model.value);

  /// Called from the text field's `onChanged`.
  void notifyChanged() => model.notifyChanged(getValue());
}
