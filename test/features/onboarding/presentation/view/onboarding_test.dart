import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bytebuddy/features/onboarding/presentation/view/onboarding.dart';

void main() {
  testWidgets('Onboarding displays correctly on mobile',
      (WidgetTester tester) async {
    // Arrange
    await tester.binding.setSurfaceSize(const Size(500, 800));
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderScope(child: OnboardingScreen()),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Cheap'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Scroll behavior works correctly on mobile',
      (WidgetTester tester) async {
    // Arrange
    await tester.binding.setSurfaceSize(const Size(500, 800));
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderScope(child: OnboardingScreen()),
      ),
    );

    // Act
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-200, 0));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Act
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-200, 0));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Low'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
