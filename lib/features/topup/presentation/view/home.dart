import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/icon_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:bytebuddy/util/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
        backgroundColor: Pallete.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(balanceStreamProvider.future),
            color: Pallete.primaryColor,
            backgroundColor: Pallete.secondaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.isMobile) {
                    return Column(children: [
                      const DepositWidget(),
                      const Gap(20),
                      GridItemWidget(),
                      const Gap(20),
                    ]);
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(flex: 2, child: DepositWidget()),
                          const Gap(20),
                          Expanded(flex: 3, child: GridItemWidget()),
                          const Gap(20),
                        ],
                      ),
                      const Gap(40),
                      BarChartSample8(),
                    ],
                  );
                },
              ),
            ),
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
        color: Pallete.primaryColor,
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
                          Flexible(
                            child: AutoSizeText(
                              "Available Balance",
                              maxLines: 1,
                              style: context.bodyMedium
                                  ?.copyWith(color: Pallete.secondaryColor),
                            ),
                          ),
                          togglePassword
                              ? const IconWidget(
                                  iconData: FontAwesomeIcons.eyeSlash,
                                  color: Pallete.secondaryColor,
                                  size: 15,
                                )
                              : const IconWidget(
                                  iconData: FontAwesomeIcons.eye,
                                  color: Pallete.secondaryColor,
                                  size: 15,
                                ),
                        ],
                      )),
                ),
                const Gap(10),
                Flexible(
                  child: InkWell(
                    onTap: () => context.push("/dashboard/transaction_history"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            "Transaction History",
                            maxLines: 1,
                            style: context.bodyMedium
                                ?.copyWith(color: Pallete.secondaryColor),
                          ),
                        ),
                        const IconWidget(
                          iconData: FontAwesomeIcons.greaterThan,
                          color: Pallete.secondaryColor,
                          size: 15,
                        )
                      ],
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
                    final formattedPrice =
                        UtilityFunctions.formatCurrency(data);
                    return Flexible(
                      child: AutoSizeText(
                        togglePassword ? "****" : formattedPrice,
                        style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Pallete.secondaryColor),
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Pallete.errorBackgroundColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: AutoSizeText(
                          "Please check your internet connection and refresh.",
                          //error.toString(),
                          style: context.bodySmall
                              ?.copyWith(color: Pallete.secondaryColor),
                        ),
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(
                    color: Pallete.secondaryColor,
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
                          color: Pallete.secondaryColor,
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the corner radius as needed
                        ),
                        child: const Center(
                          child: IconWidget(
                            iconData: FontAwesomeIcons.plus,
                            color: Pallete.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const Gap(5),
                    Flexible(
                      flex: 1,
                      child: AutoSizeText(
                        "Add Money",
                        maxLines: 1,
                        style: context.bodySmall
                            ?.copyWith(color: Pallete.secondaryColor),
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
        color: Pallete.secondaryColor,
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
            onTap: () => index == 0
                ? context.push("/dashboard/${svgs[index].text.toLowerCase()}")
                : null,
            child: SizedBox(
              height: 50.0,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: index == 0
                        ? CircleAvatar(
                            backgroundColor: Pallete.backgroundColor,
                            child: SvgPicture.asset(svgs[index].svgUrl,
                                width: 25, height: 25),
                          )
                        : Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundColor: Pallete.backgroundColor,
                                child: SvgPicture.asset(svgs[index].svgUrl,
                                    width: 25, height: 25),
                              ),
                              Positioned(
                                  top: 0,
                                  right: -25,
                                  child: Container(
                                    width: 35,
                                    height: 17.5,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0.5, horizontal: 1),
                                    decoration: const BoxDecoration(
                                      color: Pallete.secondaryErrorColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: const Center(
                                      child: AutoSizeText(
                                        'soon',
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 0.001,
                                            color: Pallete.contrastTextColor),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        svgs[index].text,
                        style: context.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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




class BarChartSample8 extends StatefulWidget {
  BarChartSample8({super.key});

  final Color barBackgroundColor = Pallete.textColor;
  final Color barColor = Pallete.primaryColor;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.secondaryColor,
        borderRadius:
        BorderRadius.circular(15.0), // Adjust the corner radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.graphic_eq),
                const Gap(20),
                Text(
                  'Sales forecasting chart',
                  style: TextStyle(
                    color: widget.barColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Gap(20),
            SizedBox(
              height: 250,
              child: BarChart(
                randomData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 300.0,
      minY: 0.0,
      backgroundColor: Pallete.secondaryColor,
      barTouchData: BarTouchData(
        enabled: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
            (i) => makeGroupData(
          i,
          Random().nextInt(290).toDouble() + 10,
        ),
      ),
      gridData: const FlGridData(show: true),
    );
  }
  BarChartGroupData makeGroupData(
      int x,
      double y,
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x >= 4 ? Colors.transparent : widget.barColor,
          borderRadius: BorderRadius.zero,
          borderDashArray: x >= 4 ? [4, 4] : null,
          width: 22,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Pallete.secondaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: text,
    );
  }


}
