import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/features/auth/presentation/widget/icon_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

final togglePasswordProvider = StateProvider<bool>((ref) {
  return true;
});

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final togglePassword = ref.watch(togglePasswordProvider);
    return Scaffold(
      backgroundColor: Pallete.scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Gap(20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AutoSizeText("Hi"),
                IconButton(
                  onPressed: () =>
                      context.push("/dashboard/transaction_history"),
                  icon: const Icon(FontAwesomeIcons.bell),
                ),
              ],
            ),
          ),
          Gap(20),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Pallete.greenColor,
                borderRadius: BorderRadius.circular(
                    15.0), // Adjust the corner radius as needed
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 3,
                                  child: AutoSizeText("Available Balance")),
                              InkWell(
                                onTap: () => ref
                                    .read(togglePasswordProvider.notifier)
                                    .update((state) => !state),
                                child: togglePassword
                                    ? const IconWidget(
                                        iconData: FontAwesomeIcons.eyeSlash)
                                    : const IconWidget(
                                        iconData: FontAwesomeIcons.eye),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () =>
                                context.push("/dashboard/transaction_history"),
                            child: AutoSizeText("Transaction History >"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        AutoSizeText("****"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: const Center(
                      child: InkWell(
                        child: Column(children: [
                          Icon(Icons.add),
                          AutoSizeText("Add money"),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Gap(20),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Pallete.whiteColor,
                borderRadius: BorderRadius.circular(
                    15.0), // Adjust the corner radius as needed
              ),
              child: Wrap(
                spacing: 8.0, // Adjust the spacing between items
                runSpacing: 8.0, // Adjust the spacing between lines
                children: List.generate(6, (index) {
                  return const GridItemWidget();
                }),
              ),
            ),
          ),
          Gap(20),
          Expanded(
            flex: 3,
            child: Column(),
          ),
        ]),
      ),
    );
  }
}

class GridItemWidget extends ConsumerWidget {
  const GridItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 100.0, // Set the width of each item as needed
      height: 100.0, // Set the height of each item as needed
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          'Item ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
