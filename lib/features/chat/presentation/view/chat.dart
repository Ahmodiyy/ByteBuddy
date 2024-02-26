import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
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
                  onPressed: () {},
                  child: const AutoSizeText('Chat us on whatsapp'))
            ],
          ),
        ),
      ),
    );
  }
}
//launchUrl(Uri.parse('https://wa.me/2347043760387'))
