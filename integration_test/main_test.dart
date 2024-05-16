import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bytebuddy/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login_robot.dart';
import 'auth/register_robot.dart';
import 'onboarding/onboarding_robot.dart';
import 'package:bytebuddy/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("app test", (WidgetTester tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    User? user = FirebaseAuth.instance.currentUser;
    await tester.pumpWidget(ProviderScope(child: MyApp(user)));

    if (user == null) {
      OnboardingRobot onboardingRobot = OnboardingRobot(tester);
      await onboardingRobot.swipe();
      await onboardingRobot.clickGetStarted();

      RegisterRobot registerRobot = RegisterRobot(tester);
      await registerRobot.enterEmail();
      await registerRobot.enterPassword();
      await registerRobot.enterConfirmPassword();
      await registerRobot.clickSignUp();
    }

    LoginRobot loginRobot = LoginRobot(tester);
    await loginRobot.enterEmail();
    await loginRobot.enterPassword();
    await loginRobot.clickSignIn();
  });
}
