import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartupErrorWidget extends ConsumerWidget {
  const AppStartupErrorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
            child: AutoSizeText(
                'App startUp error has occurred, please re-run app')),
      ),
    );
  }
}
