import 'package:bytebuddy/env/Env.dart';
import 'package:bytebuddy/features/auth/presentation/view/login.dart';
import 'package:bytebuddy/features/auth/presentation/view/register.dart';
import 'package:bytebuddy/features/auth/presentation/view/reset_password.dart';
import 'package:bytebuddy/features/dashboard.dart';
import 'package:bytebuddy/features/topup/model/data_purchase_model.dart';
import 'package:bytebuddy/features/topup/presentation/view/check_out.dart';
import 'package:bytebuddy/features/topup/presentation/view/funding.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:bytebuddy/features/topup/presentation/view/transaction_history.dart';
import 'package:bytebuddy/features/topup/presentation/view/transaction_status.dart';
import 'package:bytebuddy/firebase_options.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bytebuddy/features/onboarding/presentation/view/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final User? user = FirebaseAuth.instance.currentUser;
  runApp(ProviderScope(child: MyApp(user: user)));
}

GoRouter _router(User? user) {
  debugPrint(
      'inside main user : ${user?.email}, verified : ${user?.emailVerified}');
  return GoRouter(
    initialLocation: user != null && user.emailVerified ? '/auth' : '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
          path: '/auth',
          builder: (context, state) => const Login(),
          routes: [
            GoRoute(
              path: 'register',
              builder: (context, state) => const Register(),
            ),
            GoRoute(
              path: 'resetPassword',
              builder: (context, state) => const ResetPassword(),
            ),
          ]),
      GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Dashboard(),
          routes: [
            GoRoute(
              path: 'transaction_history',
              builder: (context, state) => const TransactionHistory(),
            ),
            GoRoute(
              path: 'funding',
              builder: (context, state) => const Funding(),
            ),
            GoRoute(
              path: 'data',
              builder: (context, state) => const Data(),
            ),
            GoRoute(
              path: 'checkout',
              builder: (context, state) => const CheckOut(),
            ),
            GoRoute(
              path: 'transaction_status',
              builder: (context, state) => const TransactionStatus(),
            ),
          ]),
    ],
  );
}

class MyApp extends ConsumerWidget {
  final User? user;

  const MyApp({required this.user, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router(user),
      theme: ThemeData(
        scaffoldBackgroundColor: Pallete.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.secondaryColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black12,
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(color: Pallete.primaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              padding: MaterialStatePropertyAll(
                EdgeInsets.all(18),
              ),
              backgroundColor: MaterialStatePropertyAll(Pallete.primaryColor),
              foregroundColor: MaterialStatePropertyAll(Pallete.secondaryColor),
              textStyle: MaterialStatePropertyAll(
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.roboto(
            fontSize: 32.0,
            color: Pallete.textColor,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 24.0,
            color: Pallete.textColor,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 16.0,
            color: Pallete.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
