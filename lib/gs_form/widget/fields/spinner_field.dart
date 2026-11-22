// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/spinner_model.dart';

class GSSpinnerField extends StatefulWidget implements GSFieldCallBack {
  final hintIndex = -1;

  GSSpinnerModel model;
  GSFormStyle formStyle;
  SpinnerDataModel? returnedData;

  GSSpinnerField(this.model, this.formStyle, {super.key});

  @override
  State<GSSpinnerField> createState() => _GSSpinnerFieldState();

  @override
  getValue() {
    return returnedData;
  }

  @override
  bool isValid() {
    if (model.required != null && model.required!) {
      if (returnedData?.id == -1 || returnedData == null) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  /// Accepts a [SpinnerDataModel], its `id`, or `null` (shows the hint or first item).
  @override
  void setValue(dynamic value) {
    final id = value is SpinnerDataModel ? value.id : value as int?;
    for (final e in model.items) {
      e.isSelected = e.id == id;
    }
    returnedData = model.items.where((e) => e.id == id).firstOrNull;
  }

  @override
  void reset() => setValue(model.value);
}

class _GSSpinnerFieldState extends State<GSSpinnerField> {
  void _ensureHint() {
    final items = widget.model.items;
    final hint = widget.model.hint;
    if (hint != null && hint.isNotEmpty && (items.isEmpty || items.first.id != widget.hintIndex)) {
      items.insert(0, SpinnerDataModel(name: hint, id: widget.hintIndex, data: null, isSelected: false));
    }
  }

  SpinnerDataModel? _find(bool Function(SpinnerDataModel) test) => widget.model.items.where(test).firstOrNull;

  @override
  void initState() {
    super.initState();
    _ensureHint();
    final initial = widget.model.value as SpinnerDataModel? ?? _find((e) => e.isSelected ?? false);
    widget.model.value ??= initial; // remembered for reset()
    // With a hint and nothing pre-selected the hint is shown, so `required` can fail.
    widget.returnedData =
        _find((e) => e.id == widget.returnedData?.id) ??
        _find((e) => e.id == initial?.id) ??
        widget.model.items.firstOrNull;
  }

  @override
  void didUpdateWidget(covariant GSSpinnerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureHint();
    final prevId = oldWidget.returnedData?.id;
    widget.returnedData =
        _find((e) => e.id == prevId) ?? _find((e) => e.isSelected ?? false) ?? widget.model.items.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<SpinnerDataModel>(
            underline: const SizedBox(),
            iconSize: 0,
            icon: const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Icon(Icons.keyboard_arrow_down, size: 20),
            ),
            isExpanded: true,
            value: widget.returnedData,
            items: widget.model.items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: Text(
                        e.name,
                        style: e.id == widget.hintIndex
                            ? widget.formStyle.fieldHintStyle
                            : widget.formStyle.fieldTextStyle,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null && value.id != widget.hintIndex) {
                for (final e in widget.model.items) {
                  e.isSelected = e.id == value.id;
                }
                widget.model.onChange?.call(value);
                setState(() => widget.returnedData = value);
                widget.model.notifyChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
