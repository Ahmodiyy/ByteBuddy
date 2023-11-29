import 'package:ByteBuddy/constants/ImageAssetConstant.dart';
import 'package:ByteBuddy/features/onboarding/presentation/widget/OnboardingImageWidget.dart';
import 'package:ByteBuddy/features/onboarding/presentation/widget/OnboardingInfoWidget.dart';
import 'package:ByteBuddy/themes/Pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _controller;
  final double bottomSheetHeight = 150;
  bool initBound = false;
  double pageViewHalfPixel = 1.0;

  double lowerBound = 0;
  double upperBound = 1;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: lowerBound,
      upperBound: upperBound,
      // Animation duration
    );

    pageController.addListener(() {
      pageController.position.addListener(() {
        debugPrint('status $initBound');
        if (!initBound) {
          lowerBound = pageController.position.minScrollExtent;
          upperBound = pageController.position.maxScrollExtent;
          _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
            lowerBound: lowerBound,
            upperBound: upperBound,
            // Animation duration
          );
          initBound = true;
        }
        debugPrint('status $initBound');

        pageViewHalfPixel = pageController.position.maxScrollExtent / 2;

        // debugPrint('lowerbound  $lowerBound');
        //debugPrint('upperbound $upperBound');
        // debugPrint(' current ${pageController.position.pixels.toString()}');
        _controller.animateTo(pageController.position.pixels);

        //_controller.forward();
        //pageViewHalfPixel = pageController.position.maxScrollExtent / 2;
        // setState(() {
        //   currentOffset = pageController.position.pixels;
        //   debugPrint(pageViewHalfPixel.toString());
        //   double rateAnimeValue = 3 / pageViewHalfPixel;
        //   currentOffset < pageViewHalfPixel
        //       ? animValue = currentOffset * rateAnimeValue
        //       : animValue =
        //           (currentOffset - pageViewHalfPixel) * rateAnimeValue;
        // });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
              bottom: bottomSheetHeight, top: 20, right: 20, left: 20),
          child: Stack(children: [
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  double animationValue = _controller.value * 0.0094;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(animationValue),
                    child: _controller.value < pageViewHalfPixel
                        ? OnboardingImageWidget(
                            imageUrl: animationValue < 1.5
                                ? ImageAssetConstant.data
                                : ImageAssetConstant.alert)
                        : OnboardingImageWidget(
                            imageUrl: animationValue > 1.5
                                ? ImageAssetConstant.alert
                                : ImageAssetConstant.support),
                  );
                },
                child: Container()),
            PageView(
              controller: pageController,
              children: const [
                OnboardingInfoWidget(
                  title: 'Cheap',
                  briefExplanation:
                      'Buy cheap mtn, airtel, glo and etisalat data plan',
                ),
                OnboardingInfoWidget(
                  title: 'Low',
                  briefExplanation:
                      'Low data alert, set low data limit for remainder',
                ),
                OnboardingInfoWidget(
                  title: 'Support',
                  briefExplanation:
                      'Realtime chat support for questions, enquires etc',
                ),
              ],
            ),
          ]),
        ),
        bottomSheet: Container(
          color: Pallete.backgroundColor,
          height: bottomSheetHeight,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      effect: const WormEffect(
                        activeDotColor: Pallete.greenColor,
                        dotColor: Colors.black12,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => context.push('/crypto'),
                  child: const Text(
                    'Get started',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
