// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/fields_model/pin_code_model.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_input_value.dart';

/// One box per digit, backed by a single invisible text field (so paste and SMS autofill work).
class GSPinCodeField extends StatefulWidget with GSTextInputValue {
  @override
  final GSPinCodeModel model;
  final GSFormStyle formStyle;

  GSPinCodeField(this.model, this.formStyle, {super.key});

  @override
  String formatValue(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length > model.length ? digits.substring(0, model.length) : digits;
  }

  @override
  getValue() => controller?.text ?? '';

  @override
  bool isValid() {
    final text = getValue() as String;
    if (text.isEmpty) return !(model.required ?? false);
    return text.length == model.length && (model.validateRegEx?.hasMatch(text) ?? true);
  }

  @override
  State<GSPinCodeField> createState() => _GSPinCodeFieldState();
}

class _GSPinCodeFieldState extends State<GSPinCodeField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) widget.setValue(widget.model.value);
  }

  @override
  void didUpdateWidget(covariant GSPinCodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller = oldWidget.controller;
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.formStyle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller!,
        builder: (context, value, _) {
          final text = value.text;
          return Stack(
            children: [
              ExcludeSemantics(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.model.length, (i) {
                    final active =
                        i == text.length || (i == widget.model.length - 1 && text.length == widget.model.length);
                    return Container(
                      width: 36,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: active
                                ? style.fieldTextStyle.color ?? Colors.black
                                : style.fieldHintStyle.color ?? Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        i < text.length ? (widget.model.obscure ? '•' : text[i]) : '',
                        style: style.fieldTextStyle.copyWith(fontSize: (style.fieldTextStyle.fontSize ?? 14) + 6),
                      ),
                    );
                  }),
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  alwaysIncludeSemantics: true,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.model.focusNode,
                    readOnly: widget.model.enableReadOnly ?? false,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.model.length),
                    ],
                    showCursor: false,
                    enableInteractiveSelection: false,
                    obscureText: widget.model.obscure,
                    onChanged: (_) => widget.notifyChanged(),
                    decoration: const InputDecoration(border: InputBorder.none, counterText: ''),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
