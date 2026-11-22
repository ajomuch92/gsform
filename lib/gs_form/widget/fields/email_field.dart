import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_input_value.dart';
import 'package:gsform_plus/gs_form/core/constant.dart';

import '../../core/form_style.dart';
import '../../model/fields_model/email_model.dart';

// ignore: must_be_immutable
class GSEmailField extends StatefulWidget with GSTextInputValue {
  @override
  final GSEmailModel model;
  final GSFormStyle formStyle;

  GSEmailField(this.model, this.formStyle, {super.key});

  @override
  State<GSEmailField> createState() => _GSEmailFieldState();

  @override
  getValue() {
    return controller!.text;
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (controller!.text.isNotEmpty) {
        return RegExp(GSConstant.emailRegEx).hasMatch(controller!.text);
      }
      if (!(model.required ?? false)) {
        return true;
      }
      return controller!.text.isNotEmpty;
    }
    return model.validateRegEx!.hasMatch(controller!.text);
  }
}

class _GSEmailFieldState extends State<GSEmailField> {
  @override
  void initState() {
    if (widget.controller == null) widget.setValue(widget.model.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GSEmailField oldWidget) {
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
        controller: widget.controller,
        onChanged: (_) => widget.notifyChanged(),
        maxLength: widget.model.maxLength,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.emailAddress,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        decoration: InputDecoration(
          hintText: widget.model.hint,
          counterText: '',
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: widget.formStyle.fieldHintStyle,
        ),
      ),
    );
  }
}
