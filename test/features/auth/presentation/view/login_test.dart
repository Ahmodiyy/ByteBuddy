import 'package:bytebuddy/features/auth/presentation/view/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Widget Test', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ProviderScope(child: Login()),
        ),
      );
      // Act
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Welcome \nback!'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Don\'t have an account Sign up', findRichText: true),
          findsOneWidget);
    });

    testWidgets('Validation error shows when email is incorrect',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ProviderScope(child: Login()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'invalidemail');

      await tester.enterText(find.byType(TextFormField).at(1), 'password');

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
  });
}
