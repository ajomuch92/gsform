import 'package:flutter/material.dart';
import 'package:gsform_plus/gs_form/core/form_controller.dart';
import 'package:gsform_plus/gs_form/core/form_style.dart';
import 'package:gsform_plus/gs_form/enums/filed_type.dart';
import 'package:gsform_plus/gs_form/values/theme.dart';
import 'package:gsform_plus/gs_form/widget/field.dart';

// ignore: must_be_immutable
class GSSection extends StatelessWidget {
  late List<Widget> fields;
  GSFormStyle? style;
  String? sectionTitle;

  GSSection({super.key, required this.fields, this.style, required this.sectionTitle});

  /// Fields currently part of the form (see `visibleWhen`).
  List<Widget> visibleFields(GSFormController? controller) {
    if (controller == null) return fields;
    final values = controller.values;
    return [
      for (final f in fields)
        if (f is! GSField || f.model?.visibleWhen == null || f.model!.visibleWhen!(values)) f,
    ];
  }

  /// Lays fields out in rows of up to 12 weight units. Plain widgets take a full row.
  List<Widget> _rows(List<Widget> visible, bool compact) {
    final rows = <Widget>[];
    var current = <Widget>[];
    var sum = 0;
    void flush() {
      if (current.isNotEmpty) rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: current));
      current = [];
      sum = 0;
    }

    for (var i = 0; i < visible.length; i++) {
      final f = visible[i];
      if (f is! GSField) {
        flush();
        rows.add(Row(children: [Expanded(child: f)]));
        continue;
      }
      final model = f.model;
      final weight = ((compact ? model?.compactWeight : null) ?? model?.weight ?? 12).clamp(1, 12);
      final next = i + 1 < visible.length ? visible[i + 1] : null;
      if (next is GSField && next.model?.type != GSFieldTypeEnum.textPlain) {
        model?.nextFocusNode = next.model?.focusNode;
      }
      f.formStyle = style!;
      if (sum + weight > 12) flush();
      if (current.isNotEmpty) current.add(const SizedBox(width: 12));
      current.add(
        Expanded(
          flex: weight,
          child: f.layoutKey == null ? f : KeyedSubtree(key: f.layoutKey, child: f),
        ),
      );
      sum += weight;
    }
    flush();
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    style = style ?? GSFormStyle();
    final controller = GSFormScope.of(context)?.controller;
    final conditional = fields.any((f) => f is GSField && f.model?.visibleWhen != null);

    Widget layout() => LayoutBuilder(
      builder: (context, constraints) =>
          Column(children: _rows(visibleFields(controller), constraints.maxWidth < style!.compactBreakpoint)),
    );
    // Only sections with conditional fields need to rebuild on every value change.
    final body = conditional && controller != null
        ? ListenableBuilder(listenable: controller, builder: (_, _) => layout())
        : layout();

    return Column(
      children: [
        if (sectionTitle != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    sectionTitle!,
                    style: style?.sectionTitleStyle ?? GSFormTheme.textThemeStyle.displayLarge,
                  ),
                ),
              ],
            ),
          ),
        Card(
          color: style?.backgroundSectionColor,
          elevation: style?.sectionCardElevation,
          shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(style!.sectionRadius)),
          child: Padding(padding: EdgeInsets.all(style!.sectionCardPadding), child: body),
        ),
      ],
    );
  }
}
