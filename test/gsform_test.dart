import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsform_plus/gs_form/core/constant.dart';
import 'package:gsform_plus/gs_form/model/fields_model/date_picker_model.dart';
import 'package:gsform_plus/gs_form/util/util.dart';
import 'package:gsform_plus/gsform_plus.dart';

/// Hosts a form and lets the test trigger a parent rebuild.
class _Host extends StatefulWidget {
  const _Host(this.fields, this.onForm);
  final List<Widget> Function() fields;
  final void Function(GSForm form, VoidCallback rebuild) onForm;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  @override
  Widget build(BuildContext context) {
    final form = GSForm.singleSection(context, fields: widget.fields());
    widget.onForm(form, () => setState(() {}));
    return SingleChildScrollView(child: form);
  }
}

Future<(GSForm Function(), VoidCallback)> _pump(WidgetTester tester, List<Widget> Function() fields) async {
  late GSForm form;
  late VoidCallback rebuild;
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: _Host(fields, (f, r) => (form = f, rebuild = r)))));
  return (() => form, rebuild);
}

void main() {
  test('formatThousands', () {
    expect(GSFormUtils.formatThousands(''), '');
    expect(GSFormUtils.formatThousands('1234567'), '1,234,567');
    expect(GSFormUtils.formatThousands('1,234a5'), '12,345');
    expect(GSFormUtils.formatThousands('000123'), '123');
    expect(GSFormUtils.formatThousands('0'), '0');
  });

  test('email regex', () {
    final r = RegExp(GSConstant.emailRegEx);
    expect(r.hasMatch('a.b+c@my-domain.co.uk'), isTrue);
    expect(r.hasMatch('user@example.com'), isTrue);
    expect(r.hasMatch('user@example'), isFalse);
    expect(r.hasMatch('user@example.com!!'), isFalse);
  });

  test('datePicker forwards availableFrom (was overwritten by availableTo)', () {
    final from = GSDate(year: 2020, month: 1, day: 1);
    final to = GSDate(year: 2030, month: 1, day: 1);
    final model = GSField.datePicker(tag: 'd', availableFrom: from, availableTo: to).model as GSDatePickerModel;
    expect(model.availableFrom, same(from));
    expect(model.availableTo, same(to));
  });

  testWidgets('validateRegEx is applied and values are collected', (tester) async {
    final (form, _) = await _pump(tester, () => [GSField.text(tag: 'code', validateRegEx: RegExp(r'^\d{3}$'))]);
    await tester.enterText(find.byType(TextField), 'abc');
    expect(form().isValid(), isFalse);
    await tester.enterText(find.byType(TextField), '123');
    expect(form().isValid(), isTrue);
    expect(form().onSubmit(), {'code': '123'});
  });

  testWidgets('price field survives clearing the text', (tester) async {
    final (form, _) = await _pump(tester, () => [GSField.price(tag: 'p')]);
    await tester.enterText(find.byType(TextField), '12345');
    await tester.pump();
    expect(find.text('12,345'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(form().onSubmit(), {'p': ''});
  });

  testWidgets('email keeps typed text across parent rebuilds', (tester) async {
    final (form, rebuild) = await _pump(tester, () => [GSField.email(tag: 'e', value: 'old@x.com')]);
    await tester.enterText(find.byType(TextField), 'new@x.com');
    rebuild();
    await tester.pump();
    expect(form().onSubmit(), {'e': 'new@x.com'});
  });

  testWidgets('empty time field does not crash on parent rebuild', (tester) async {
    final (form, rebuild) = await _pump(tester, () => [GSField.time(tag: 't', hint: 'pick')]);
    rebuild();
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(form().onSubmit(), {'t': null});
  });

  testWidgets('required spinner with hint is invalid until a real item is picked', (tester) async {
    final (form, _) = await _pump(
      tester,
      () => [
        GSField.spinner(
          tag: 's',
          required: true,
          hint: 'Choose',
          items: [
            SpinnerDataModel(name: 'One', id: 1),
            SpinnerDataModel(name: 'Two', id: 2),
          ],
        ),
      ],
    );
    expect(form().isValid(), isFalse);
    await tester.tap(find.text('Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two').last);
    await tester.pumpAndSettle();
    expect(form().isValid(), isTrue);
    expect((form().onSubmit()['s'] as SpinnerDataModel).id, 2);
  });

  testWidgets('GSField works outside a GSSection', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: GSField.text(tag: 'x')),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
  });
}
