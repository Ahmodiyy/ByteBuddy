import 'package:bytebuddy/features/auth/presentation/login.dart';
import 'package:bytebuddy/features/auth/presentation/register.dart';
import 'package:bytebuddy/features/auth/presentation/reset_password.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bytebuddy/features/onboarding/presentation/view/onboarding.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const Login(), routes: [
      GoRoute(
        path: 'register',
        builder: (context, state) => const Register(),
      ),
      GoRoute(
        path: 'resetPassword',
        builder: (context, state) => const ResetPassword(),
      ),
    ]),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black12,
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  side: BorderSide(color: Pallete.greenColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
              padding: MaterialStatePropertyAll(
                EdgeInsets.all(18),
              ),
              backgroundColor: MaterialStatePropertyAll(Pallete.greenColor),
              foregroundColor: MaterialStatePropertyAll(Pallete.whiteColor),
              textStyle: MaterialStatePropertyAll(
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.roboto(
            textStyle:
                const TextStyle(fontSize: 48.0, color: Pallete.greenColor),
          ),
          bodyMedium: GoogleFonts.roboto(
            textStyle:
                const TextStyle(fontSize: 22.0, color: Pallete.deepPurple),
          ),
          bodySmall: GoogleFonts.roboto(
            textStyle:
                const TextStyle(fontSize: 16.0, color: Pallete.lightBlack),
          ),
        ),
        scaffoldBackgroundColor: Pallete.whiteColor,
      ),
    );
  }
}

/**
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    amountController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 237, 237),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "projectTitle",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount(₦)',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final ref = generateRef();
                  final amount = int.parse(amountController.text);
                  try {
                    return await FlutterPaystackPlus.openPaystackPopup(
                        publicKey: "",
                        context: context,
                        secretKey: "",
                        currency: 'NGN',
                        customerEmail: emailController.text,
                        amount: (amount * 100).toString(),
                        reference: ref,
                        onClosed: () {
                          debugPrint(
                              'Could\'nnnnnnnnnnnnnnnnnnnnnnnnnnnnnt finish payment');
                        },
                        onSuccess: () {
                          debugPrint(
                              'Payment succeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeessful');
                        });
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[400]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pay${amountController.text.isEmpty ? '' : ' ₦${amountController.text}'} with Paystack',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
**/
