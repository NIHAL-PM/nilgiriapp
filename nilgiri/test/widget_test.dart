// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:nilgiri/main.dart';

void main() {
  testWidgets('shows the Nilgiri splash and attribution', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(launcher: (Uri uri) async => true));

    expect(find.text('NILGIRI COLLEGE'), findsOneWidget);
    expect(find.text('ARTS & SCIENCE'), findsOneWidget);
    expect(find.text('co-developed with Nihal PM'), findsOneWidget);
    expect(find.text('Open college portal'), findsOneWidget);
  });
}
