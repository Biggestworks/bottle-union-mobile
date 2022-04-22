 import 'package:eight_barrels/helper/color_helper.dart';
import 'package:eight_barrels/provider/splash/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<SplashProvider>(context, listen: false).fnAuthentication();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.MAIN,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: SizedBox(
            height: 80,
            child: Image.asset('assets/images/ic_logo_bu_white.png',),
          ),
        ),
      ),
    );
  }
}
