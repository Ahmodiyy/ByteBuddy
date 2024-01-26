import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckOut extends ConsumerWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(child: Column()),
    ));
  }
}
