import 'package:bytebuddy/features/auth/presentation/view/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reset password widget test', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ProviderScope(child: ResetPassword()),
        ),
      );
      // Act
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Forgot \nPassword?'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(
          find.text('*We will send you a message to reset your password',
              findRichText: true),
          findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
      expect(find.text('Go back!', findRichText: true), findsOneWidget);
    });
  });
}
