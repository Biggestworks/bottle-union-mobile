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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Image.asset('assets/images/ic_logo_white.png', scale: 1.5,),
        ),
      ),
    );
  }
}
