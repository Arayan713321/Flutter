// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:digital_diary_ts/main.dart';

void main() {
  testWidgets('App launches and shows login or home', (WidgetTester tester) async {
    // Build the app with mock login state.
    await tester.pumpWidget(const MyApp(isLoggedIn: false, hasPin: false));

    // Check for text from the PIN setup screen.
    expect(find.textContaining('PIN'), findsOneWidget);
  });
}
