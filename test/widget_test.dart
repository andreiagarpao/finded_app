import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finded_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FindEdApp());

    // Verify that our app loads
    expect(find.text('Find Your Perfect'), findsOneWidget);
  });
}