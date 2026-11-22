// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/masked_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_input_value.dart';

class GSMaskedField extends StatefulWidget with GSTextInputValue {
  @override
  final GSMaskedModel model;
  final GSFormStyle formStyle;
  final GSMaskFormatter formatter;

  GSMaskedField(this.model, this.formStyle, {super.key}) : formatter = GSMaskFormatter(model.mask);

  @override
  String formatValue(String text) => formatter.apply(text);

  /// The text as shown, mask literals included.
  @override
  getValue() => controller?.text ?? '';

  @override
  bool isValid() {
    final text = getValue() as String;
    if (text.isEmpty) return !(model.required ?? false);
    return model.validateRegEx?.hasMatch(text) ?? formatter.isComplete(text);
  }

  @override
  State<GSMaskedField> createState() => _GSMaskedFieldState();
}

class _GSMaskedFieldState extends State<GSMaskedField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) widget.setValue(widget.model.value);
  }

  @override
  void didUpdateWidget(covariant GSMaskedField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller = oldWidget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        controller: widget.controller,
        onChanged: (_) => widget.notifyChanged(),
        inputFormatters: [widget.formatter],
        keyboardType: widget.model.keyboardType ?? TextInputType.text,
        style: widget.formStyle.fieldTextStyle,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) => FocusScope.of(context).requestFocus(widget.model.nextFocusNode),
        decoration: InputDecoration(
          hintText: widget.model.hint ?? widget.model.mask,
          border: InputBorder.none,
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }
}
