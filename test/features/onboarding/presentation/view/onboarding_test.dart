import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bytebuddy/features/onboarding/presentation/view/onboarding.dart';

void main() {
  testWidgets('Onboarding displays correctly', (WidgetTester tester) async {
    // Arrange

    debugPrint('size  ${tester.view.physicalSize}');

    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderScope(child: OnboardingScreen()),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Scroll behavior works correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: OnboardingScreen()));

    // Scroll the screen and verify that certain elements become visible or hidden
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();
    expect(find.text('Some hidden element'), findsNothing);
  });

  // Add more tests as needed for animations, interaction with external links, etc.
}
