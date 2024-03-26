import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/image_constant.dart';
import 'package:bytebuddy/constants/extension_constant.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/custom_pageview_scrollphysics.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/image_widget.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/info_widget.dart';
import 'package:bytebuddy/features/onboarding/presentation/widget/info_widget_transition.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  //mobile
  late PageController _pageController;
  late AnimationController _controller;
  final double bottomSheetHeight = 150;
  final double gapSize = 40.0;
  final double paddingSize = 50.0;
  bool initBound = true;
  double pageViewHalfPixel = 1.0;
  double rate = 0.0;

  //web
  late ScrollController _scrollController;
  bool hasScrollClient = false;
  @override
  void initState() {
    super.initState();
    //mobile
    _pageController = PageController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      // Animation duration
    );

    _pageController.addListener(() {
      _pageController.position.addListener(() {
        if (initBound) {
          _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
            lowerBound: _pageController.position.minScrollExtent,
            upperBound: _pageController.position.maxScrollExtent,

            // Animation duration
          );
          initBound = false;
          rate = 6.0 / _pageController.position.maxScrollExtent;
          pageViewHalfPixel = _pageController.position.maxScrollExtent / 2;
          setState(() {});
        }
        _controller.animateTo(_pageController.position.pixels);
      });
    });
    //web
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      debugPrint('has client ${_scrollController.hasClients.toString()}');
      debugPrint('pixel ${_scrollController.position.pixels.toString()}');
      debugPrint(
          'pixel ${_scrollController.position.maxScrollExtent.toString()}');
      debugPrint(
          'both ${_scrollController.hasClients && _scrollController.position.pixels > 500.0}');

      if (!hasScrollClient) {
        setState(() {});
        hasScrollClient = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const imageProvider = AssetImage(ImageConstant.intro);
    precacheImage(imageProvider, context, onError: (exception, stackTrace) {
      // Handle any errors that occur during image loading
      print('Error loading image: $exception');
    });
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          if (constraints.isMobile) {
            double height = (constraints.maxHeight - bottomSheetHeight) / 2;
            return Scaffold(
              backgroundColor: Pallete.secondaryColor,
              body: Container(
                padding: EdgeInsets.only(
                    bottom: bottomSheetHeight, top: 50, right: 50, left: 50),
                child: Stack(alignment: Alignment.topCenter, children: [
                  Positioned(
                    top: 50,
                    bottom: height,
                    left: 0.0,
                    right: 0.0,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        double animationValue = _controller.value * rate;
                        debugPrint(_controller.value.toString());
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(animationValue),
                          child: _controller.value < pageViewHalfPixel
                              ? ImageWidget(
                                  imageUrl: animationValue < 1.5
                                      ? ImageConstant.data
                                      : ImageConstant.support)
                              : ImageWidget(
                                  imageUrl: animationValue < 4.5
                                      ? ImageConstant.support
                                      : ImageConstant.settings),
                        );
                      },
                    ),
                  ),
                  PageView(
                    physics: const CustomPageViewScrollPhysics(),
                    controller: _pageController,
                    children: [
                      InfoWidget(
                        title: 'Cheap',
                        titleStyle: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        briefExplanation:
                            'Buy cheap mtn, airtel, glo and etisalat data plan',
                        briefExplanationStyle: context.bodySmall,
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      InfoWidget(
                        title: 'Support',
                        titleStyle: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        briefExplanation:
                            'Realtime chat support for questions, enquires etc',
                        briefExplanationStyle: context.bodySmall,
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      InfoWidget(
                        title: 'Low',
                        titleStyle: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        briefExplanation:
                            'Low data alert, set low data limit for remainder',
                        briefExplanationStyle: context.bodySmall,
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    ],
                  ),
                ]),
              ),
              bottomSheet: Container(
                color: Pallete.secondaryColor,
                height: bottomSheetHeight,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 40),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 3,
                            effect: const WormEffect(
                              activeDotColor: Pallete.primaryColor,
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
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              side: BorderSide(color: Pallete.primaryColor),
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => context.push('/auth/register'),
                        child: const Text(
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
              backgroundColor: Pallete.secondaryColor,
              appBar: PreferredSize(
                preferredSize: const Size(double.infinity, 100),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingSize, vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bytebuddy',
                              style: context.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Pallete.primaryColor,
                              ),
                            ),
                            Gap(gapSize),
                            InkWell(
                              onTap: () {
                                context.push("/auth/register");
                              },
                              child: Text(
                                'Register',
                                style: context.bodySmall?.copyWith(
                                  color: Pallete.accentColor,
                                ),
                              ),
                            ),
                            Gap(gapSize),
                            InkWell(
                              onTap: () {
                                context.push("/auth");
                              },
                              child: Text(
                                'Login',
                                style: context.bodySmall?.copyWith(
                                  color: Pallete.accentColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
              body: DynMouseScroll(builder: (context, controller, physics) {
                _scrollController = controller;
                return Scrollbar(
                  thickness: 10.0,
                  radius: const Radius.circular(5.0),
                  trackVisibility: true,
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: physics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: paddingSize),
                          alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                            color: Pallete.blueGreyColor,
                            image: DecorationImage(
                              image: AssetImage(ImageConstant
                                  .intro), // Replace with your image asset
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InfoWidgetTransition(
                            title: "Affordable Internet Enchantment!",
                            titleStyle: context.bodyLarge?.copyWith(
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                            briefExplanation:
                                "✨ Immerse yourself in the enchanting world of Bytebuddy, "
                                "where budget-friendly data plans weave seamlessly with wizardly support and"
                                " personalized enchantments. Explore the digital realm with affordable "
                                "magic at your fingertips—sign up now and let the enchantment begin! 🌌✨",
                            briefExplanationStyle: context.bodySmall?.copyWith(
                                color: Pallete.accentColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                wordSpacing: 2,
                                height: 2),
                            height: 500,
                            weight: maxWidth * 0.43,
                            textAlign: TextAlign.left,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(paddingSize),
                          child: AutoSizeText(
                            "Our Services",
                            textAlign: TextAlign.left,
                            style: context.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Pallete.accentColor),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(60),
                          alignment: Alignment.center,
                          color: Pallete.primaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: AnimatedBuilder(
                                    animation: _scrollController,
                                    builder: (context, child) {
                                      if (_scrollController.hasClients &&
                                          _scrollController.position.pixels >
                                              250) {
                                        return InfoWidgetTransition(
                                          title: "🌐 Cheap Data Delight:",
                                          titleStyle: context.bodyLarge
                                              ?.copyWith(
                                                  color:
                                                      Pallete.contrastTextColor,
                                                  fontWeight: FontWeight.bold),
                                          briefExplanation:
                                              "Embark on a digital journey without breaking "
                                              "the bank! Our pocket-friendly internet subscriptions "
                                              "ensure you stay seamlessly connected without compromising "
                                              "on speed or reliability. Dive into a world of affordable data "
                                              "plans that cater to your needs, bringing the power of the internet to your fingertips without burning a hole in your wallet.",
                                          briefExplanationStyle:
                                              context.bodyMedium?.copyWith(
                                                  color:
                                                      Pallete.contrastTextColor,
                                                  letterSpacing: 2,
                                                  wordSpacing: 2,
                                                  height: 2),
                                          height: 500,
                                          textAlign: TextAlign.left,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: ImageWidget(
                                imageUrl: ImageConstant.data,
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(60),
                          alignment: Alignment.center,
                          color: Pallete.secondaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                  child: ImageWidget(
                                imageUrl: ImageConstant.support,
                              )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: AnimatedBuilder(
                                    animation: _scrollController,
                                    builder: (context, child) {
                                      if (_scrollController.hasClients &&
                                          _scrollController.position.pixels >
                                              850.0) {
                                        return InfoWidgetTransition(
                                          title: "🤝 Customer Care Concierge:",
                                          titleStyle: context.bodyLarge
                                              ?.copyWith(
                                                  color: Pallete.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                          briefExplanation:
                                              "Say goodbye to frustrating support experiences! Our dedicated customer service "
                                              "team is here to make your life easier. Need assistance? We've got your back! "
                                              "From inquiries to troubleshooting, we're just a message or call away. "
                                              "Experience customer support that goes beyond expectations, "
                                              "ensuring your journey with us is as smooth as a buffering-free video stream",
                                          briefExplanationStyle:
                                              context.bodyMedium?.copyWith(
                                                  color: Pallete.accentColor,
                                                  letterSpacing: 2,
                                                  wordSpacing: 2,
                                                  height: 2),
                                          height: 500,
                                          textAlign: TextAlign.left,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(60),
                          alignment: Alignment.center,
                          color: Pallete.primaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60),
                                  child: AnimatedBuilder(
                                    animation: _scrollController,
                                    builder: (context, child) {
                                      if (_scrollController.hasClients &&
                                          _scrollController.position.pixels >
                                              1450.0) {
                                        return InfoWidgetTransition(
                                          title:
                                              "⚙️ Tailored Settings, Just for You:",
                                          titleStyle: context.bodyLarge
                                              ?.copyWith(
                                                  color:
                                                      Pallete.contrastTextColor,
                                                  fontWeight: FontWeight.bold),
                                          briefExplanation:
                                              "Customize your connectivity experience like never before! Take control with"
                                              " personalized settings that match your preferences. Whether it's adjusting data "
                                              "limits, optimizing speed, or configuring special features, our user-friendly interface empowers you to "
                                              "tailor your internet experience. Enjoy connectivity on your terms, with settings that reflect "
                                              "your unique digital lifestyle.",
                                          briefExplanationStyle:
                                              context.bodyMedium?.copyWith(
                                                  color:
                                                      Pallete.contrastTextColor,
                                                  letterSpacing: 2,
                                                  wordSpacing: 2,
                                                  height: 2),
                                          textAlign: TextAlign.left,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: ImageWidget(
                                imageUrl: ImageConstant.settings,
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(60),
                          alignment: Alignment.center,
                          color: Pallete.secondaryColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                  child: ImageWidget(
                                imageUrl: ImageConstant.app,
                                width: 350,
                                height: 350,
                              )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 60),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const ImageWidget(
                                          imageUrl: ImageConstant.byteBuddy,
                                          width: 100,
                                          height: 100,
                                        ),
                                        Gap(gapSize),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Coming soon on ',
                                                style: context.bodyMedium
                                                    ?.copyWith(
                                                        color: Pallete
                                                            .secondaryTextColor),
                                              ),
                                              TextSpan(
                                                text: 'Android',
                                                style: context.bodyMedium
                                                    ?.copyWith(
                                                  color: Pallete.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Pallete.tertiaryColor,
                          child: Padding(
                            padding: EdgeInsets.all(paddingSize),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bytebuddy',
                                  style: context.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(
                                            'https://twitter.com/ByteBuddy101'));
                                      },
                                      icon: Icon(FontAwesomeIcons.twitter),
                                    ),
                                    Gap(gapSize),
                                    IconButton(
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(
                                            'https://wa.me/2347043760387'));
                                      },
                                      icon: Icon(FontAwesomeIcons.whatsapp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
