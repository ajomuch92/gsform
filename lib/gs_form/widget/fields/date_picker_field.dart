// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/data_model/date_data_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';

import '../../model/fields_model/date_picker_model.dart';

class GSDatePickerField extends StatefulWidget implements GSFieldCallBack {
  final GSDatePickerModel model;
  final GSFormStyle formStyle;

  DateTime? selectedDate;
  String selectedDateText = '';

  GSDatePickerField(this.model, this.formStyle, {super.key});

  @override
  State<GSDatePickerField> createState() => _GSDatePickerFieldState();

  @override
  getValue() {
    return selectedDate == null
        ? null
        : DateDataModel(
            dateServerType: selectedDate!,
            timeStamp: selectedDate!.millisecondsSinceEpoch,
            showDateStr: selectedDateText,
          );
  }

  @override
  bool isValid() => !(model.required ?? false) || selectedDate != null;

  /// Accepts a [DateTime] or `null`.
  @override
  void setValue(dynamic value) => selectedDate = value == null ? null : DateUtils.dateOnly(value as DateTime);

  @override
  void reset() => setValue(model.initialDate?.toDateTime());
}

class _GSDatePickerFieldState extends State<GSDatePickerField> {
  @override
  void initState() {
    super.initState();
    widget.selectedDate ??= widget.model.initialDate?.toDateTime();
  }

  @override
  void didUpdateWidget(covariant GSDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the user's pick when the parent rebuilds.
    widget.selectedDate = oldWidget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.selectedDate;
    widget.selectedDateText = date == null ? '' : GSFormUtils.formatDate(context, date, widget.model.dateFormatType);
    return InkWell(
      onTap: _openPicker,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 18, bottom: 18),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            date == null ? widget.model.hint ?? '' : widget.selectedDateText,
            style: date == null ? widget.formStyle.fieldHintStyle : widget.formStyle.fieldTextStyle,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker() async {
    final bounds = GSFormUtils.pickerBounds(
      widget.model.isPastAvailable,
      widget.model.availableFrom,
      widget.model.availableTo,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: GSFormUtils.clampDate(widget.selectedDate ?? DateTime.now(), bounds),
      firstDate: bounds.start,
      lastDate: bounds.end,
    );
    if (picked != null && mounted) {
      setState(() {
        widget.selectedDate = picked;
        widget.selectedDateText = GSFormUtils.formatDate(context, picked, widget.model.dateFormatType);
      });
      widget.model.notifyChanged(widget.getValue());
    }
  }
}
