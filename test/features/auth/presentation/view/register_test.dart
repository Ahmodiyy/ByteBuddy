import 'package:bytebuddy/features/auth/presentation/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('Register Widget Test', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ProviderScope(child: Register()),
        ),
      );
      // Act
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Create an \naccount'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Already have an account Sign in', findRichText: true),
          findsOneWidget);
    });

    testWidgets('Validation error shows when passwords do not match',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ProviderScope(child: Register()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(TextFormField).at(0), 'validemail@example.com');

      await tester.enterText(find.byType(TextFormField).at(1), 'password');

      await tester.enterText(
          find.byType(TextFormField).at(2), 'differentpassword');

      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Password does not match'), findsOneWidget);
    });
  });
}
