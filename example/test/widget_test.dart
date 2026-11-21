import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:formtest/features_page.dart';

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('features page renders, validates, fills and resets', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: FeaturesPage()));

    expect(find.text('Ana'), findsOneWidget);

    await tapText(tester, 'Submit');
    expect(find.text('Fix the highlighted fields'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // let the snack bar go away
    await tester.pumpAndSettle();

    await tapText(tester, 'Fill some');
    expect(find.text('(555) 123-4567'), findsOneWidget);

    await tapText(tester, 'Reset');
    expect(find.text('(555) 123-4567'), findsNothing);
  });
}
