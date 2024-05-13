import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OnboardingRobot {
  final WidgetTester tester;

  OnboardingRobot(this.tester);

  Future<void> swipe() async {
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
  }

  Future<void> clickGetStarted() async {
    //Act
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get started'));
  }

  Future<void> clickLogin() async {
    //Act
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
  }
}
