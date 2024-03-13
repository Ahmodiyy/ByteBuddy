import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Pallete.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AutoSizeText("Coming soon"),
              const Gap(10),
              ElevatedButton(
                  onPressed: () async {
                    await logout(ref, context, () {
                      context.go('/');
                    });
                  },
                  child: const AutoSizeText('Log out'))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout(
    WidgetRef ref, BuildContext context, VoidCallback onSuccess) async {
   onSuccess.call();
  await ref.read(authControllerLoginProvider.notifier).sign0ut();

}
