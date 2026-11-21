import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gsform_plus/gsform_plus.dart';

Future<void> pumpApp(WidgetTester tester, Widget Function(BuildContext context) builder, {Size? size}) async {
  if (size != null) {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: Builder(builder: builder))),
    ),
  );
  await tester.pump(); // let post-frame visibility updates settle
}

void main() {
  group('visibleWhen', () {
    testWidgets('shows a field only when its condition holds; hidden fields are not validated or submitted', (
      tester,
    ) async {
      late GSForm form;
      await pumpApp(tester, (context) {
        return form = GSForm.singleSection(
          context,
          fields: [
            GSField.toggle(tag: 'company', hint: 'I am a company'),
            GSField.text(
              tag: 'companyName',
              hint: 'Company name',
              required: true,
              visibleWhen: (values) => values['company'] == true,
            ),
          ],
        );
      });

      expect(find.text('Company name'), findsNothing);
      expect(form.isValid(), isTrue);
      expect(form.onSubmit(), {'company': false});

      await tester.tap(find.text('I am a company'));
      await tester.pumpAndSettle();
      expect(find.text('Company name'), findsOneWidget);
      expect(form.isValid(), isFalse);

      await tester.enterText(find.byType(TextField), 'ACME');
      expect(form.onSubmit(), {'company': true, 'companyName': 'ACME'});
    });

    testWidgets('works with an explicit controller too', (tester) async {
      final controller = GSFormController(initialValues: {'kind': true});
      await pumpApp(tester, (context) {
        return GSForm.singleSection(
          context,
          controller: controller,
          fields: [
            GSField.toggle(tag: 'kind', hint: 'Show extra'),
            GSField.text(tag: 'extra', hint: 'Extra', visibleWhen: (v) => v['kind'] == true),
          ],
        );
      });
      expect(find.text('Extra'), findsOneWidget);
      controller.setValue('kind', false);
      await tester.pumpAndSettle();
      expect(find.text('Extra'), findsNothing);
      expect(controller.values.keys, ['kind']);
    });
  });

  group('asyncValidator', () {
    testWidgets('runs on isValidAsync after sync checks, not on isValid', (tester) async {
      final checked = <dynamic>[];
      final completer = Completer<String?>();
      late GSForm form;
      await pumpApp(tester, (context) {
        return form = GSForm.singleSection(
          context,
          fields: [
            GSField.text(
              tag: 'user',
              required: true,
              asyncValidator: (v) {
                checked.add(v);
                return completer.future;
              },
            ),
          ],
        );
      });

      // Sync failure: the async check never runs.
      expect(await form.isValidAsync(), isFalse);
      expect(checked, isEmpty);

      await tester.enterText(find.byType(TextField), 'ana');
      expect(form.isValid(), isTrue);
      expect(checked, isEmpty);

      final result = form.isValidAsync();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete('Username taken');
      expect(await result, isFalse);
      await tester.pump();
      expect(checked, ['ana']);
      expect(find.text('Username taken'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('controller.isValidAsync', (tester) async {
      final controller = GSFormController();
      await pumpApp(tester, (context) {
        return GSForm.singleSection(
          context,
          controller: controller,
          fields: [GSField.text(tag: 'code', asyncValidator: (v) async => v == 'ok' ? null : 'Invalid code')],
        );
      });
      controller.setValue('code', 'nope');
      expect(await controller.isValidAsync(), isFalse);
      controller.setValue('code', 'ok');
      expect(await controller.isValidAsync(), isTrue);
    });
  });

  testWidgets('stepper validates each step, keeps values and completes with all of them', (tester) async {
    Map<String, dynamic>? result;
    final steps = <int>[];
    await pumpApp(tester, (context) {
      return GSForm.stepper(
        context,
        onComplete: (values) => result = values,
        onStepChanged: steps.add,
        sections: [
          GSSection(sectionTitle: 'Account', fields: [GSField.text(tag: 'name', hint: 'Name', required: true)]),
          GSSection(sectionTitle: 'Contact', fields: [GSField.email(tag: 'email', hint: 'Email')]),
        ],
      );
    });

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Back'), findsNothing);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(steps, isEmpty); // required name is missing

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Ana');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(steps, [1]);
    expect(find.text('Submit'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget); // value kept
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'a@b.co');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(result, {'name': 'Ana', 'email': 'a@b.co'});
  });

  group('layout', () {
    Future<double> rowGap(WidgetTester tester, double width) async {
      await pumpApp(tester, (context) {
        return GSForm.singleSection(
          context,
          fields: [
            GSField.text(tag: 'a', hint: 'A', weight: 6, compactWeight: 12),
            GSField.text(tag: 'b', hint: 'B', weight: 6, compactWeight: 12),
          ],
        );
      }, size: Size(width, 800));
      return tester.getTopLeft(find.text('B')).dy - tester.getTopLeft(find.text('A')).dy;
    }

    testWidgets('compactWeight applies below the breakpoint and moved fields keep their state', (tester) async {
      expect(await rowGap(tester, 800), 0); // same row
      await tester.enterText(find.widgetWithText(TextField, 'B'), 'typed');
      expect(await rowGap(tester, 400), greaterThan(0)); // stacked
      expect(find.text('typed'), findsOneWidget);
    });

    testWidgets('a plain widget after a field and overflowing weights get their own rows', (tester) async {
      await pumpApp(tester, (context) {
        return GSForm.singleSection(
          context,
          fields: [
            GSField.text(tag: 'a', hint: 'A', weight: 6),
            const Text('plain'),
            GSField.text(tag: 'b', hint: 'B', weight: 6),
            GSField.text(tag: 'c', hint: 'C', weight: 12),
          ],
        );
      }, size: const Size(800, 800));
      expect(tester.takeException(), isNull);
      double y(String t) => tester.getTopLeft(find.text(t)).dy;
      expect(y('plain'), greaterThan(y('A')));
      expect(y('B'), greaterThan(y('plain')));
      expect(y('C'), greaterThan(y('B')));
    });
  });
}
