import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.scaffoldColor,
      body: AutoSizeText("coming up"),
    );
  }
}
