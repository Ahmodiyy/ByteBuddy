import 'package:bytebuddy/constants/extension_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.isMobile) {
          return Scaffold(
            body: Container(child: Text("LOGIN")),
          );
        }
        return Scaffold(
          body: Container(child: Text("LOGIN")),
        );
      },
    );
  }
}
