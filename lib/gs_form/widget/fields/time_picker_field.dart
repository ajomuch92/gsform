// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/data_model/time_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/time_picker_model.dart';

class GSTimePickerField extends StatefulWidget implements GSFieldCallBack {
  final GSTimePickerModel model;
  final GSFormStyle formStyle;

  TimeOfDay? selectedTime;
  String selectedTimeText = '';

  GSTimePickerField(this.model, this.formStyle, {super.key});

  @override
  State<GSTimePickerField> createState() => _GSTimePickerFieldState();

  @override
  getValue() {
    final t = selectedTime;
    return t == null ? null : TimeDataModel(displayTime: selectedTimeText, hour: t.hour, minute: t.minute);
  }

  @override
  bool isValid() => !(model.required ?? false) || selectedTime != null;
}

class _GSTimePickerFieldState extends State<GSTimePickerField> {
  @override
  void initState() {
    super.initState();
    widget.selectedTime = widget.model.initialTime;
  }

  @override
  void didUpdateWidget(covariant GSTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the user's pick when the parent rebuilds.
    widget.selectedTime = oldWidget.selectedTime ?? widget.model.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.selectedTime;
    widget.selectedTimeText = t == null ? '' : t.format(context);
    return InkWell(
      onTap: _openPicker,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 16, bottom: 16),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            t == null ? widget.model.hint ?? '' : widget.selectedTimeText,
            style: t == null ? widget.formStyle.fieldHintStyle : widget.formStyle.fieldTextStyle,
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay.now(),
      useRootNavigator: false,
    );
    if (picked != null && mounted) {
      setState(() => widget.selectedTime = picked);
    }
  }
}
