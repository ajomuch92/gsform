// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/model/data_model/date_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/date_range_picker_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';

import '../../core/form_style.dart';

class GSDateRangePickerField extends StatefulWidget implements GSFieldCallBack {
  final GSDateRangePickerModel model;
  final GSFormStyle formStyle;

  DateTimeRange? selectedRange;
  String startText = '';
  String endText = '';

  GSDateRangePickerField(this.model, this.formStyle, {super.key});

  @override
  State<GSDateRangePickerField> createState() => _GSDateRangePickerFieldState();

  @override
  getValue() {
    final r = selectedRange;
    return r == null
        ? null
        : DateDataRangeModel(
            startDateServerType: r.start,
            endDateServerType: r.end,
            startTimeStamp: r.start.millisecondsSinceEpoch,
            endTimeStamp: r.end.millisecondsSinceEpoch,
            displayStartDateStr: startText,
            displayEndDateStr: endText,
          );
  }

  @override
  bool isValid() => !(model.required ?? false) || selectedRange != null;
}

class _GSDateRangePickerFieldState extends State<GSDateRangePickerField> {
  DateTimeRange? _initialRange() {
    final start = widget.model.initialStartDate, end = widget.model.initialEndDate;
    return start == null || end == null ? null : DateTimeRange(start: start.toDateTime(), end: end.toDateTime());
  }

  @override
  void initState() {
    super.initState();
    widget.selectedRange = _initialRange();
  }

  @override
  void didUpdateWidget(covariant GSDateRangePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the user's pick when the parent rebuilds.
    widget.selectedRange = oldWidget.selectedRange ?? _initialRange();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.selectedRange;
    if (r != null) {
      widget.startText = GSFormUtils.formatDate(context, r.start, widget.model.dateFormatType);
      widget.endText = GSFormUtils.formatDate(context, r.end, widget.model.dateFormatType);
    }
    return InkWell(
      onTap: _openPicker,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 16, bottom: 16),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            r == null
                ? widget.model.hint ?? ''
                : '${widget.model.from}: ${widget.startText}   ${widget.model.to}: ${widget.endText}',
            style: r == null ? widget.formStyle.fieldHintStyle : widget.formStyle.fieldTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
    final current = widget.selectedRange;
    final fits = current != null && !current.start.isBefore(bounds.start) && !current.end.isAfter(bounds.end);
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: fits ? current : null,
      firstDate: bounds.start,
      lastDate: bounds.end,
    );
    if (picked != null && mounted) {
      setState(() => widget.selectedRange = picked);
    }
  }
}
