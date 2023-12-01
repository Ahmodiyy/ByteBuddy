import 'package:bytebuddy/constants/image_constant.dart';
import 'package:bytebuddy/constants/extension_constant.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/custom_pageview_scrollphysics.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/image_widget.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/info_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';

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
  final double gapSize = 20.0;
  final double paddingSize = 40.0;

  bool initBound = true;
  double pageViewHalfPixel = 1.0;
  double rate = 0.0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      // Animation duration
    );

    pageController.addListener(() {
      pageController.position.addListener(() {
        if (initBound) {
          _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
            lowerBound: pageController.position.minScrollExtent,
            upperBound: pageController.position.maxScrollExtent,

            // Animation duration
          );

          CurvedAnimation(parent: _controller, curve: Curves.easeIn);
          initBound = false;
          rate = 6.0 / pageController.position.maxScrollExtent;
          pageViewHalfPixel = pageController.position.maxScrollExtent / 2;
          setState(() {});
        }
        _controller.animateTo(pageController.position.pixels);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.isMobile) {
            return Scaffold(
              body: Container(
                padding: EdgeInsets.only(
                    bottom: bottomSheetHeight, top: 20, right: 20, left: 20),
                child: Stack(alignment: Alignment.topCenter, children: [
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        double animationValue = _controller.value * rate;
                        debugPrint(_controller.value.toString());
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(animationValue),
                          child: _controller.value < pageViewHalfPixel
                              ? OnboardingImageWidget(
                                  imageUrl: animationValue < 1.5
                                      ? ImageAssetConstant.data
                                      : ImageAssetConstant.support)
                              : OnboardingImageWidget(
                                  imageUrl: animationValue < 4.5
                                      ? ImageAssetConstant.support
                                      : ImageAssetConstant.alert),
                        );
                      },
                      child: Container()),
                  PageView(
                    physics: const CustomPageViewScrollPhysics(),
                    controller: pageController,
                    children: const [
                      OnboardingInfoWidget(
                        title: 'Cheap',
                        briefExplanation:
                            'Buy cheap mtn, airtel, glo and etisalat data plan',
                      ),
                      OnboardingInfoWidget(
                        title: 'Support',
                        briefExplanation:
                            'Realtime chat support for questions, enquires etc',
                      ),
                      OnboardingInfoWidget(
                        title: 'Low',
                        briefExplanation:
                            'Low data alert, set low data limit for remainder',
                      ),
                    ],
                  ),
                ]),
              ),
              bottomSheet: Container(
                color: Pallete.whiteColor,
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
                        onPressed: () => context.push('/auth/register'),
                        child: Text(
                          'Get started',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, 50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingSize),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ByteBuddy",
                          style: context.bodyMedium?.copyWith(
                              color: Pallete.greenColor,
                              fontWeight: FontWeight.w400)),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Home',
                              style: context.bodyMedium
                                  ?.copyWith(color: Pallete.greenColor),
                            ),
                          ),
                          Gap(gapSize),
                          InkWell(
                            onTap: () {
                              context.go("/auth/register");
                            },
                            child: Text(
                              'Register',
                              style: context.bodyMedium
                                  ?.copyWith(color: Pallete.deepPurple),
                            ),
                          ),
                          Gap(gapSize),
                          InkWell(
                            onTap: () {
                              context.go("/auth");
                            },
                            child: Text(
                              'Login',
                              style: context.bodyMedium
                                  ?.copyWith(color: Pallete.deepPurple),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            body: Container(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
