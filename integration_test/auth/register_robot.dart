import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RegisterRobot {
  final WidgetTester tester;

  RegisterRobot(this.tester);

  Future<void> enterEmail() async {
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).at(0), 'validemail@example.com');
  }

  Future<void> enterPassword() async {
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
  }

  Future<void> enterConfirmPassword() async {
    await tester.enterText(
        find.byType(TextFormField).at(2), 'differentpassword');
  }

  Future<void> clickSignUp() async {
    await tester.tap(find.text('Sign up'));
  }
}
