import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/screen/auth/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static String tag = '/onboarding-screen';
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntroductionScreen(
        controlsPadding: EdgeInsets.symmetric(vertical: 20),
        globalBackgroundColor: CustomColor.MAIN,
        pages: [
          PageViewModel(
            title: "Welcome to Bottle Union",
            body: "Instead of having to buy an entire share, invest any amount you want.",
            image: SizedBox(
              height: 80,
              child: Image.asset('assets/images/ic_logo_bu_white.png'),
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white,),
              bodyTextStyle: TextStyle(fontSize: 18, color: Colors.white,),
              // bodyPadding: EdgeInsets.all(10),
              imagePadding: EdgeInsets.all(10),
              bodyAlignment: Alignment.center,
            ),
          ),
          PageViewModel(
            title: "Welcome to Bottle Union",
            body: "Instead of having to buy an entire share, invest any amount you want.",
            image: SizedBox(
              height: 80,
              child: Image.asset('assets/images/ic_logo_bu_white.png'),
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white,),
              bodyTextStyle: TextStyle(fontSize: 18, color: Colors.white,),
              // bodyPadding: EdgeInsets.all(10),
              imagePadding: EdgeInsets.all(10),
              bodyAlignment: Alignment.center,
            ),
          ),
          PageViewModel(
            title: "Welcome to Bottle Union",
            body: "Instead of having to buy an entire share, invest any amount you want.",
            image: SizedBox(
              height: 80,
              child: Image.asset('assets/images/ic_logo_bu_white.png'),
            ),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white,),
              bodyTextStyle: TextStyle(fontSize: 18, color: Colors.white,),
              // bodyPadding: EdgeInsets.all(10),
              imagePadding: EdgeInsets.all(10),
              bodyAlignment: Alignment.center,
            ),
          ),
        ],
        onDone: () => Get.offAndToNamed(StartScreen.tag),
        dotsDecorator: DotsDecorator(
          color: Colors.white,
          activeColor: Colors.amberAccent,
        ),
        showBackButton: false,
        showSkipButton: true,
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        next: const Icon(Icons.arrow_forward, color: Colors.white,),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
