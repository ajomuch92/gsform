import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsform_plus/gsform_plus.dart';

/// Pumps a single-section form and returns it (re-read after rebuilds through the getter).
Future<GSForm Function()> pumpForm(
  WidgetTester tester,
  List<Widget> fields, {
  GSFormController? controller,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  void Function(String tag, dynamic value)? onChanged,
  ThemeData? theme,
}) async {
  late GSForm form;
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            form = GSForm.singleSection(
              context,
              fields: fields,
              controller: controller,
              autovalidateMode: autovalidateMode,
              onChanged: onChanged,
            );
            return SingleChildScrollView(child: form);
          },
        ),
      ),
    ),
  );
  return () => form;
}

void main() {
  group('GSMaskFormatter', () {
    final phone = GSMaskFormatter('(###) ###-####');

    test('applies literals lazily and skips invalid characters', () {
      expect(phone.apply('5551234567'), '(555) 123-4567');
      expect(phone.apply('555'), '(555');
      expect(phone.apply('55a5-12'), '(555) 12');
      expect(phone.apply('555123456789'), '(555) 123-4567');
      expect(GSMaskFormatter('AA-##').apply('ab12'), 'ab-12');
    });

    test('isComplete', () {
      expect(phone.isComplete('(555) 123-4567'), isTrue);
      expect(phone.isComplete('(555) 123'), isFalse);
    });
  });

  group('GSFormController', () {
    testWidgets('initialValues, values, setValue and reset', (tester) async {
      final controller = GSFormController(initialValues: {'name': 'Ana', 'card': '1234567812345678'});
      await pumpForm(tester, [
        GSField.text(tag: 'name'),
        GSField.bankCard(tag: 'card'),
        GSField.toggle(tag: 'terms', hint: 'Accept'),
      ], controller: controller);

      expect(controller.values, {'name': 'Ana', 'card': '1234567812345678', 'terms': false});
      expect(find.text('1234 5678 1234 5678'), findsOneWidget);

      controller.setValue('name', 'Luis');
      controller.setValue('terms', true);
      await tester.pump();
      expect(find.text('Luis'), findsOneWidget);
      expect(controller.getValue('terms'), isTrue);

      controller.setValue('name', '');
      expect(controller.isValid(), isTrue);
      controller.reset();
      await tester.pump();
      expect(controller.values, {'name': 'Ana', 'card': '1234567812345678', 'terms': false});
    });

    testWidgets('notifies listeners on user edits', (tester) async {
      final controller = GSFormController();
      await pumpForm(tester, [GSField.text(tag: 'a')], controller: controller);
      await tester.pump(); // mounting fields also notifies once, after the frame
      var notified = 0;
      controller.addListener(() => notified++);
      await tester.enterText(find.byType(TextField), 'x');
      expect(notified, 1);
    });

    testWidgets('disabled fields are skipped by validation', (tester) async {
      final controller = GSFormController();
      await pumpForm(tester, [GSField.text(tag: 'a', required: true)], controller: controller);
      expect(controller.isValid(), isFalse);
      controller.setEnabled('a', false);
      await tester.pump();
      expect(controller.isValid(), isTrue);
    });

    testWidgets('unknown tag throws', (tester) async {
      final controller = GSFormController();
      await pumpForm(tester, [GSField.text(tag: 'a')], controller: controller);
      expect(() => controller.setValue('nope', 1), throwsArgumentError);
    });
  });

  testWidgets('validator message is shown and cross-field validation works', (tester) async {
    final controller = GSFormController();
    final form = await pumpForm(tester, [
      GSField.password(tag: 'pass'),
      GSField.password(
        tag: 'confirm',
        errorMessage: 'generic',
        validator: (v) => v == controller.getValue('pass') ? null : 'Passwords differ',
      ),
    ], controller: controller);
    await tester.enterText(find.byType(TextField).first, 'secret');
    await tester.enterText(find.byType(TextField).last, 'other');
    expect(form().isValid(), isFalse);
    await tester.pump();
    expect(find.text('Passwords differ'), findsOneWidget);
    expect(find.text('generic'), findsNothing);
  });

  testWidgets('onChanged fires per field and per form; errors clear while typing', (tester) async {
    final fieldValues = <dynamic>[];
    final formEvents = <String>[];
    final form = await pumpForm(tester, [
      GSField.email(tag: 'mail', required: true, errorMessage: 'Bad email', onChanged: fieldValues.add),
    ], onChanged: (tag, value) => formEvents.add('$tag=$value'));

    expect(form().isValid(), isFalse);
    await tester.pump();
    expect(find.text('Bad email'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'a@b.co');
    await tester.pump();
    expect(fieldValues, ['a@b.co']);
    expect(formEvents, ['mail=a@b.co']);
    // A field showing an error is re-validated on change even with autovalidate disabled.
    expect(find.text('Bad email'), findsNothing);
  });

  testWidgets('autovalidate onUserInteraction validates while typing', (tester) async {
    await pumpForm(tester, [
      GSField.text(tag: 't', validator: (v) => (v as String).length < 3 ? 'Too short' : null),
    ], autovalidateMode: AutovalidateMode.onUserInteraction);
    await tester.enterText(find.byType(TextField), 'ab');
    await tester.pump();
    expect(find.text('Too short'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump();
    expect(find.text('Too short'), findsNothing);
  });

  testWidgets('pin code keeps digits only and needs every digit when required', (tester) async {
    final form = await pumpForm(tester, [GSField.pinCode(tag: 'pin', length: 4, required: true)]);
    await tester.enterText(find.byType(TextField), '1a2');
    expect(form().onSubmit()['pin'], '12');
    expect(form().isValid(), isFalse);
    await tester.enterText(find.byType(TextField), '1234');
    expect(form().isValid(), isTrue);
  });

  testWidgets('masked field formats input and validates completeness', (tester) async {
    final form = await pumpForm(tester, [GSField.masked(tag: 'phone', mask: '(###) ###-####', required: true)]);
    await tester.enterText(find.byType(TextField), '555123');
    await tester.pump();
    expect(find.text('(555) 123'), findsOneWidget);
    expect(form().isValid(), isFalse);
    await tester.enterText(find.byType(TextField), '5551234567');
    expect(form().onSubmit()['phone'], '(555) 123-4567');
    expect(form().isValid(), isTrue);
  });

  testWidgets('required toggle must be on', (tester) async {
    final form = await pumpForm(tester, [GSField.toggle(tag: 'terms', hint: 'I accept', required: true)]);
    expect(form().isValid(), isFalse);
    await tester.tap(find.text('I accept'));
    await tester.pump();
    expect(form().isValid(), isTrue);
    expect(form().onSubmit()['terms'], isTrue);
  });

  testWidgets('slider and range slider values', (tester) async {
    final controller = GSFormController();
    await pumpForm(tester, [
      GSField.slider(tag: 'age', min: 0, max: 100, value: 30),
      GSField.slider(tag: 'price', min: 0, max: 10, isRange: true),
    ], controller: controller);
    expect(controller.values, {'age': 30.0, 'price': const RangeValues(0, 10)});
    controller.setValue('age', 50);
    await tester.pump();
    expect(controller.getValue('age'), 50.0);
  });

  testWidgets('autocomplete value is the picked item', (tester) async {
    final form = await pumpForm(tester, [
      GSField.autocomplete(
        tag: 'city',
        required: true,
        items: [
          SpinnerDataModel(name: 'Guatemala', id: 1),
          SpinnerDataModel(name: 'Tegucigalpa', id: 2),
        ],
      ),
    ]);
    await tester.enterText(find.byType(TextField), 'tegu');
    await tester.pumpAndSettle();
    expect(form().isValid(), isFalse);
    await tester.tap(find.text('Tegucigalpa'));
    await tester.pumpAndSettle();
    expect((form().onSubmit()['city'] as SpinnerDataModel).id, 2);
    expect(form().isValid(), isTrue);
  });

  testWidgets('custom field', (tester) async {
    final form = await pumpForm(tester, [
      GSField.custom(
        tag: 'stars',
        required: true,
        builder: (context, value, onChanged) =>
            TextButton(onPressed: () => onChanged(((value as int?) ?? 0) + 1), child: Text('stars: ${value ?? 0}')),
      ),
    ]);
    expect(form().isValid(), isFalse);
    await tester.tap(find.text('stars: 0'));
    await tester.pump();
    expect(find.text('stars: 1'), findsOneWidget);
    expect(form().onSubmit()['stars'], 1);
    expect(form().isValid(), isTrue);
  });

  testWidgets('pre-selected checklist items are part of the value', (tester) async {
    final form = await pumpForm(tester, [
      GSField.checkList(
        tag: 'c',
        searchable: false,
        callBack: (_) {},
        items: [
          CheckDataModel(title: 'A', isSelected: true),
          CheckDataModel(title: 'B', isSelected: false),
        ],
      ),
    ]);
    expect((form().onSubmit()['c'] as List).map((e) => e.title), ['A']);
  });

  testWidgets('spinner honours its initial value', (tester) async {
    final two = SpinnerDataModel(name: 'Two', id: 2);
    final form = await pumpForm(tester, [
      GSField.spinner(
        tag: 's',
        value: two,
        items: [
          SpinnerDataModel(name: 'One', id: 1),
          two,
        ],
      ),
    ]);
    expect((form().onSubmit()['s'] as SpinnerDataModel).id, 2);
  });

  testWidgets('style comes from the theme extension and labels are translatable', (tester) async {
    final style = GSFormStyle(labels: GSFormLabels.es);
    final controller = GSFormController();
    final form = await pumpForm(
      tester,
      [GSField.dateRangePicker(tag: 'r', isPastAvailable: true)],
      controller: controller,
      theme: ThemeData(extensions: [style]),
    );
    expect(form().style, same(style));
    controller.setValue('r', DateTimeRange(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5)));
    await tester.pump();
    expect(find.textContaining('Desde:'), findsOneWidget);
    expect(find.textContaining('Hasta:'), findsOneWidget);
  });

  testWidgets('isValid scrolls to the first invalid field', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final form = await pumpForm(tester, [
      for (var i = 0; i < 12; i++) GSField.text(tag: 't$i', hint: 'hint $i'),
      GSField.text(tag: 'last', hint: 'last field', required: true),
    ]);
    expect(tester.getTopLeft(find.text('last field')).dy, greaterThan(400));
    expect(form().isValid(), isFalse);
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('last field')).dy, lessThan(400));
  });
}
