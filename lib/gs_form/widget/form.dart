import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/form_controller.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/util/util.dart';

import 'field.dart';
import 'section.dart';

// ignore: must_be_immutable
class GSForm extends StatelessWidget {
  GSFormStyle? style;
  late List<GSSection> sections;
  late List<Widget> fields;

  /// Optional handle to read/write values and validate from outside the tree.
  final GSFormController? controller;

  /// `disabled` (default) validates on [isValid]; any other mode also validates a field as the user edits it.
  /// Fields already showing an error are always re-validated on change.
  final AutovalidateMode autovalidateMode;

  /// Called with the field tag and its new value whenever the user changes a field.
  final void Function(String tag, dynamic value)? onChanged;

  GSForm.singleSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.fields,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  }) {
    style ??=
        Theme.of(context).extension<GSFormStyle>() ??
        (GSFormUtils.checkIfDarkModeEnabled(context)
            ? GSFormStyle.singleSectionFormDefaultDarkStyle
            : GSFormStyle.singleSectionFormDefaultStyle);
    sections = [GSSection(style: style, sectionTitle: null, fields: fields)];
  }

  GSForm.multiSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.sections,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  }) {
    style ??=
        Theme.of(context).extension<GSFormStyle>() ??
        (GSFormUtils.checkIfDarkModeEnabled(context)
            ? GSFormStyle.multiSectionFormDefaultDarkStyle
            : GSFormStyle.multiSectionFormDefaultStyle);
    for (var element in sections) {
      element.style = style;
    }
  }

  Iterable<GSField> get _fields => sections.expand((s) => s.fields).whereType<GSField>();

  @override
  Widget build(BuildContext context) {
    return GSFormScope(
      controller: controller,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      child: Column(children: sections),
    );
  }

  /// Validates every field and, if [revealError], scrolls to the first invalid one.
  bool isValid({bool revealError = true}) {
    GSField? firstInvalid;
    for (final field in _fields) {
      if (!field.validate()) firstInvalid ??= field;
    }
    if (revealError) firstInvalid?.reveal();
    return firstInvalid == null;
  }

  Map<String, dynamic> onSubmit() => {for (final field in _fields) field.model?.tag ?? '': field.value};
}
