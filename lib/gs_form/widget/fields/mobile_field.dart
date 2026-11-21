import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_input_value.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/mobile_model.dart';

// ignore: must_be_immutable
class GSMobileField extends StatefulWidget with GSTextInputValue {
  @override
  final GSMobileModel model;
  final GSFormStyle formStyle;

  GSMobileField(this.model, this.formStyle, {super.key});

  @override
  State<GSMobileField> createState() => _GSMobileFieldState();

  @override
  getValue() {
    return controller!.text;
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (!(model.required ?? false)) {
        return true;
      } else {
        return controller!.text.isNotEmpty;
      }
    } else {
      return model.validateRegEx!.hasMatch(controller!.text);
    }
  }
}

class _GSMobileFieldState extends State<GSMobileField> {
  @override
  void initState() {
    if (widget.controller == null) widget.setValue(widget.model.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GSMobileField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.value == widget.model.value) {
      widget.controller = oldWidget.controller;
    } else {
      widget.setValue(widget.model.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        textAlign: TextAlign.left,
        controller: widget.controller,
        onChanged: (_) => widget.notifyChanged(),
        maxLength: widget.model.maxLength ?? 11,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.phone,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        decoration: InputDecoration(
          hintText: widget.model.hint,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          counterText: '',
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }
}
