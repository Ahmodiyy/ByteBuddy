import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Pallete.scaffoldColor,
      body: InkWell(
        child: AutoSizeText("message us on whatsapp"),
      ),
    );
  }
}
