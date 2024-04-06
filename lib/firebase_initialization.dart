import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'app_startup_error_widget.dart';
import 'features/topup/presentation/widget/shimmer_widget.dart';
import 'firebase_options.dart';

final firebaseInitializationProvider = StateProvider<bool>((ref) {
  return false;
});

class FirebaseInitialization extends ConsumerStatefulWidget {
  const FirebaseInitialization({super.key});

  @override
  ConsumerState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<FirebaseInitialization> {
  Future<void> initializeFirebase() async {
    try {
      bool _buildComplete = false;
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final User? user = FirebaseAuth.instance.currentUser;

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        setState(() {
          _buildComplete = true;
        });
      });
      //
    } catch (e, st) {
      debugPrint('ERROR INITIALIZING FIREBASE ${e.toString()}');
      runApp(const AppStartupErrorWidget());
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('INSIDE BUILD METHOD');
    final initState = ref.watch(firebaseInitializationProvider);
    // if (initState == true) {
    //   context.go('/auth');
    // }
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.rectangular(
                  width: 20,
                  height: 20,
                ),
                ShimmerWidget.rectangular(
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Pallete.secondaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.isMobile) {
                  return const Column(children: [
                    ShimmerWidget.rectangular(
                      width: double.infinity,
                      height: 180,
                    ),
                    Gap(20),
                    ShimmerWidget.rectangular(
                      width: double.infinity,
                      height: 180,
                    ),
                    Gap(20),
                  ]);
                }
                return const Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ShimmerWidget.rectangular(
                            width: double.infinity,
                            height: 180,
                          ),
                        ),
                        Gap(20),
                        Expanded(
                          flex: 3,
                          child: ShimmerWidget.rectangular(
                            width: double.infinity,
                            height: 180,
                          ),
                        ),
                        Gap(20),
                      ],
                    ),
                    Gap(40),
                    // Row(
                    //   children: [
                    //     const Expanded(
                    //         flex: 2, child: ShortTransactionHistory()),
                    //     Expanded(flex: 3, child: Container()),
                    //   ],
                    // ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
