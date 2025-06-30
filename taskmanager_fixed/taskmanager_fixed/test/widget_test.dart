import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taskmanager_fixed/main.dart';

void main() {
  testWidgets('App loads and shows welcome text', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const TaskManagerApp());

    // Wait for frames to settle (useful if there's async code in build)
    await tester.pumpAndSettle();

    // Check for welcome text (ensure your HomeScreen has this)
    expect(find.text('Welcome to Task Manager'), findsOneWidget);
  });
}
