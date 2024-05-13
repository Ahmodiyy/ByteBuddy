import 'package:bytebuddy/features/onboarding/presentation/view/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bytebuddy/main.dart';

import 'auth/login_robot.dart';
import 'auth/register_robot.dart';
import 'onboarding/onboarding_robot.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("whole app", (WidgetTester tester) async {
    // Arrange
    await tester.binding.setSurfaceSize(const Size(500, 800));
    await tester.pumpWidget(MyApp(FirebaseAuth.instance.currentUser));

    OnboardingRobot onboardingRobot = OnboardingRobot(tester);
    onboardingRobot.swipe();
    onboardingRobot.clickGetStarted();

    RegisterRobot registerRobot = RegisterRobot(tester);
    registerRobot.enterEmail();
    registerRobot.enterPassword();
    registerRobot.enterConfirmPassword();
    registerRobot.clickSignUp();

    LoginRobot loginRobot = LoginRobot(tester);
    loginRobot.enterEmail();
    loginRobot.enterPassword();
    loginRobot.clickSignIn();
  });
}
