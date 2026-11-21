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

  /// Stepper only: called with all values when the last step is submitted and valid.
  final ValueChanged<Map<String, dynamic>>? onComplete;

  /// Stepper only: called with the new step index.
  final ValueChanged<int>? onStepChanged;

  final bool _stepper;

  GSForm.singleSection(
    BuildContext context, {
    super.key,
    this.style,
    required this.fields,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  }) : onComplete = null,
       onStepChanged = null,
       _stepper = false {
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
  }) : onComplete = null,
       onStepChanged = null,
       _stepper = false {
    _applyMultiSectionStyle(context);
  }

  /// One section per step, with Back/Next buttons. Next validates only the current step (async validators included);
  /// on the last step it calls [onComplete] with every value. Steps keep their values while not shown.
  GSForm.stepper(
    BuildContext context, {
    super.key,
    this.style,
    required this.sections,
    required this.onComplete,
    this.onStepChanged,
    this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  }) : _stepper = true {
    _applyMultiSectionStyle(context);
  }

  void _applyMultiSectionStyle(BuildContext context) {
    style ??=
        Theme.of(context).extension<GSFormStyle>() ??
        (GSFormUtils.checkIfDarkModeEnabled(context)
            ? GSFormStyle.multiSectionFormDefaultDarkStyle
            : GSFormStyle.multiSectionFormDefaultStyle);
    for (var element in sections) {
      element.style = style;
    }
  }

  /// Fields currently in the form (built and not hidden by `visibleWhen`).
  Iterable<GSField> get _fields => sections.expand((s) => s.fields).whereType<GSField>().where((f) => f.isActive);

  @override
  Widget build(BuildContext context) => _GSFormHost(form: this);

  /// Validates every field and, if [revealError], scrolls to the first invalid one.
  bool isValid({bool revealError = true}) {
    GSField? firstInvalid;
    for (final field in _fields) {
      if (!field.validate()) firstInvalid ??= field;
    }
    if (revealError) firstInvalid?.reveal();
    return firstInvalid == null;
  }

  /// Like [isValid], but also runs `asyncValidator`s (in parallel) for fields whose sync checks pass.
  Future<bool> isValidAsync({bool revealError = true}) => _validateAll(_fields, revealError: revealError);

  Map<String, dynamic> onSubmit() => {for (final field in _fields) field.model?.tag ?? '': field.value};
}

Future<bool> _validateAll(Iterable<GSField> fields, {bool revealError = true}) async {
  final list = fields.toList();
  final results = await Future.wait(list.map((f) => f.validateAsync()));
  final firstInvalid = [
    for (var i = 0; i < list.length; i++)
      if (!results[i]) list[i],
  ].firstOrNull;
  if (revealError) firstInvalid?.reveal();
  return firstInvalid == null;
}

/// Keeps state across rebuilds of [GSForm]: a fallback controller (needed by `visibleWhen`) and the current step.
class _GSFormHost extends StatefulWidget {
  const _GSFormHost({required this.form});

  final GSForm form;

  @override
  State<_GSFormHost> createState() => _GSFormHostState();
}

class _GSFormHostState extends State<_GSFormHost> {
  GSFormController? _own;
  int _step = 0;
  bool _busy = false;

  GSForm get form => widget.form;

  GSFormController get _controller => form.controller ?? (_own ??= GSFormController());

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    setState(() => _busy = true);
    final stepFields = form.sections[_step].fields.whereType<GSField>().where((f) => f.isActive);
    final ok = await _validateAll(stepFields);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    if (_step == form.sections.length - 1) {
      form.onComplete?.call(_controller.values);
    } else {
      _goTo(_step + 1);
    }
  }

  void _goTo(int step) {
    setState(() => _step = step);
    form.onStepChanged?.call(step);
  }

  Widget _stepper() {
    final labels = form.style!.labels;
    final count = form.sections.length;
    final step = _step.clamp(0, count - 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: (step + 1) / count, semanticsLabel: '${step + 1} / $count'),
        const SizedBox(height: 12),
        // Offstage keeps the other steps mounted, so their values survive and stay in `values`.
        for (var i = 0; i < count; i++)
          Offstage(
            offstage: i != step,
            child: TickerMode(enabled: i == step, child: form.sections[i]),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (step > 0) OutlinedButton(onPressed: _busy ? null : () => _goTo(step - 1), child: Text(labels.back)),
            const Spacer(),
            FilledButton(onPressed: _busy ? null : _next, child: Text(step == count - 1 ? labels.submit : labels.next)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GSFormScope(
      controller: _controller,
      autovalidateMode: form.autovalidateMode,
      onChanged: form.onChanged,
      child: form._stepper ? _stepper() : Column(children: form.sections),
    );
  }
}
