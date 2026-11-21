import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/widget/fields/text_input_value.dart';
import 'package:gsform_plus/gs_form/model/fields_model/bank_card_filed_model.dart';

import '../../core/form_style.dart';
import '../../util/util.dart';

// ignore: must_be_immutable
class GSBankCardField extends StatefulWidget with GSTextInputValue {
  @override
  final GSBankCardModel model;
  final GSFormStyle formStyle;

  GSBankCardField(this.model, this.formStyle, {super.key});

  static final formatter = GSMaskFormatter('#### #### #### ####');

  @override
  String formatValue(String text) => formatter.apply(text);

  @override
  State<GSBankCardField> createState() => _GSBankCardFieldState();

  @override
  getValue() {
    return controller!.text.replaceAll(' ', '');
  }

  @override
  bool isValid() {
    if (model.validateRegEx == null) {
      if (!(model.required ?? false)) {
        return true;
      } else {
        return controller!.text.replaceAll(' ', '').length == 16;
      }
    } else {
      return model.validateRegEx!.hasMatch(controller!.text);
    }
  }
}

class _GSBankCardFieldState extends State<GSBankCardField> {
  @override
  void initState() {
    if (widget.controller == null) widget.setValue(widget.model.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GSBankCardField oldWidget) {
    if (oldWidget.model.value == widget.model.value) {
      widget.controller = oldWidget.controller;
    } else {
      widget.setValue(widget.model.value);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: TextField(
        readOnly: widget.model.enableReadOnly ?? false,
        inputFormatters: [GSBankCardField.formatter],
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        controller: widget.controller,
        onChanged: (_) => widget.notifyChanged(),
        maxLines: 1,
        style: widget.formStyle.fieldTextStyle,
        keyboardType: TextInputType.number,
        focusNode: widget.model.focusNode,
        textInputAction: widget.model.nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) {
          FocusScope.of(context).requestFocus(widget.model.nextFocusNode);
        },
        decoration: InputDecoration(
          hintText: widget.model.hint ?? '- - - -   - - - -   - - - -   - - - -',
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
