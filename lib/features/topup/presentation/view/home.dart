import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/icon_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
            ),
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
        ),
        backgroundColor: Pallete.scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              const DepositWidget(),
              const Gap(20),
              GridItemWidget(),
              const Gap(20),
              Column(),
            ]),
          ),
        ),
      ),
    );
  }
}

class DepositWidget extends ConsumerWidget {
  const DepositWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final togglePassword = ref.watch(togglePasswordProvider);
    final balanceState = ref.watch(balanceStreamProvider);

    return Container(
      height: 180,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Pallete.greenColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                      onTap: () => ref
                          .read(togglePasswordProvider.notifier)
                          .update((state) => !state),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "Available Balance ",
                              maxLines: 1,
                              style: context.bodySmall
                                  ?.copyWith(color: Pallete.lightWhite),
                            ),
                          ),
                          togglePassword
                              ? const IconWidget(
                                  iconData: FontAwesomeIcons.eyeSlash,
                                  color: Pallete.lightWhite,
                                )
                              : const IconWidget(
                                  iconData: FontAwesomeIcons.eye,
                                  color: Pallete.lightWhite,
                                ),
                        ],
                      )),
                ),
                const Gap(20),
                Flexible(
                  child: InkWell(
                    onTap: () => context.push("/dashboard/transaction_history"),
                    child: AutoSizeText(
                      "Transaction History >",
                      maxLines: 1,
                      style: context.bodySmall
                          ?.copyWith(color: Pallete.lightWhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                balanceState.when(
                  data: (data) {
                    var formatter = NumberFormat.currency(symbol: '₦');
                    var balanceInNaira = formatter.format(data);
                    return Flexible(
                      child: AutoSizeText(
                        togglePassword ? "****" : balanceInNaira,
                        style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Pallete.whiteColor),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Flexible(
                      child: AutoSizeText(
                        error.toString(),
                        style: context.bodyMedium
                            ?.copyWith(color: Pallete.whiteColor),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: InkWell(
                onTap: () => context.push("/dashboard/funding"),
                child: Column(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Pallete.whiteColor,
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the corner radius as needed
                        ),
                        child: const Center(
                          child: IconWidget(
                            iconData: FontAwesomeIcons.plus,
                            color: Pallete.greenColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const Gap(5),
                    Flexible(
                      flex: 1,
                      child: AutoSizeText(
                        "Add money",
                        maxLines: 1,
                        style: context.bodySmall
                            ?.copyWith(color: Pallete.lightWhite),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  GridItemWidget({super.key});
  final List<TopUpSvgAndText> svgs = [
    TopUpSvgAndText(
      SvgConstant.data,
      "Data",
    ),
    TopUpSvgAndText(
      SvgConstant.airtime,
      "Airtime",
    ),
    TopUpSvgAndText(
      SvgConstant.pin,
      "Pin",
    ),
    TopUpSvgAndText(
      SvgConstant.tv,
      "TV",
    ),
    TopUpSvgAndText(
      SvgConstant.electric,
      "Electric",
    ),
    TopUpSvgAndText(
      SvgConstant.printing,
      "Printing",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the corner radius as needed
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            mainAxisExtent: 65),

        itemCount: svgs.length, // Total number of items (rows * columns)
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () =>
                context.push("/dashboard/${svgs[index].text.toLowerCase()}"),
            child: SizedBox(
              height: 50.0,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                        backgroundColor: Pallete.lightGreen,
                        child: SvgPicture.asset(svgs[index].svgUrl,
                            width: 25, height: 25)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        svgs[index].text,
                        style: context.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopUpSvgAndText {
  String svgUrl;
  String text;
  TopUpSvgAndText(this.svgUrl, this.text);
}
