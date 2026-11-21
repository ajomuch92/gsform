// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/field_callback.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform_plus/gs_form/model/fields_model/autocomplete_model.dart';

/// A text field that suggests matching items. The value is the picked [SpinnerDataModel]; typed text alone is not a value.
class GSAutocompleteField extends StatefulWidget implements GSFieldCallBack {
  final GSAutocompleteModel model;
  final GSFormStyle formStyle;
  SpinnerDataModel? selected;
  TextEditingController? controller;
  FocusNode? focusNode;

  GSAutocompleteField(this.model, this.formStyle, {super.key});

  @override
  getValue() => selected;

  @override
  bool isValid() => !(model.required ?? false) || selected != null;

  /// Accepts a [SpinnerDataModel], its `id`, or `null`.
  @override
  void setValue(dynamic value) {
    final id = value is SpinnerDataModel ? value.id : value as int?;
    selected = model.items.where((e) => e.id == id).firstOrNull;
    (controller ??= TextEditingController()).text = selected?.name ?? '';
  }

  @override
  void reset() => setValue(model.value);

  @override
  State<GSAutocompleteField> createState() => _GSAutocompleteFieldState();
}

class _GSAutocompleteFieldState extends State<GSAutocompleteField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) widget.reset();
    widget.focusNode ??= widget.model.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant GSAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget
      ..selected = oldWidget.selected
      ..controller = oldWidget.controller
      ..focusNode = oldWidget.focusNode;
  }

  void _select(SpinnerDataModel? item) {
    if (identical(item, widget.selected)) return;
    widget.selected = item;
    widget.model.notifyChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.formStyle;
    return RawAutocomplete<SpinnerDataModel>(
      textEditingController: widget.controller,
      focusNode: widget.focusNode,
      displayStringForOption: (e) => e.name,
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        return q.isEmpty ? widget.model.items : widget.model.items.where((e) => e.name.toLowerCase().contains(q));
      },
      onSelected: _select,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: widget.model.enableReadOnly ?? false,
          style: style.fieldTextStyle,
          // Editing the text drops a previous pick until a suggestion is chosen again.
          onChanged: (text) => _select(widget.model.items.where((e) => e.name == text).firstOrNull),
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: widget.model.hint,
            hintStyle: style.fieldHintStyle,
            border: InputBorder.none,
          ),
        ),
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(style.fieldRadius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240, maxWidth: 400),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                for (final option in options)
                  ListTile(
                    title: Text(option.name, style: style.fieldTextStyle),
                    onTap: () => onSelected(option),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
